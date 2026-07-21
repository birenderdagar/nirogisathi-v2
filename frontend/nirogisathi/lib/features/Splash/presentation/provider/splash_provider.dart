import 'package:flutter/foundation.dart';

import '../../../../core/enums/app_state.dart';
import '../../../../core/enums/user_role.dart';
import '../../../auth/domain/entities/user.dart' as domain;
import '../../../auth/domain/usecases/check_app_state_usecase.dart';

class SplashProvider extends ChangeNotifier {
  final CheckAppStateUseCase useCase;

  SplashProvider(this.useCase);

  AppState _state = const AppLoading();
  
  AppState get state {
    // ✅ If the video hasn't finished, always report AppLoading to keep the splash screen visible
    if (!_videoFinished && _isInitialized) return const AppLoading();
    return _state;
  }

  domain.User? _user;
  domain.User? get user => _user;

  bool _isInitialized = false;
  bool _videoFinished = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;
    await _fetchState();
  }

  /// ✅ Forces a state refresh (used after login/logout/back)
  Future<void> refresh({bool isFreshLogin = false}) async {
    await _fetchState(isFreshLogin: isFreshLogin);
    notifyListeners();
  }

  /// ✅ Manually set to Role Selection state
  void forceRoleSelection(String name, {domain.User? user}) {
    debugPrint("🌊 [SPLASH] Forcing Role Selection state for $name");
    _state = RoleSelectionRequired(name);
    if (user != null) _user = user;
    notifyListeners();
    
    // Ensure we have the full user object for profile syncing
    _syncUserOnly();
  }

  /// ✅ Manually set to Authenticated (Bypass for persistent login issues)
  void forceAuthenticated(UserRole role, [String name = "User", domain.User? user]) {
    debugPrint("🌊 [SPLASH] Forcing Authenticated state for $name");
    _state = AuthenticatedWithRole(role, name);
    if (user != null) _user = user;
    notifyListeners();

    // Trigger a background sync to fill in the full user object (photo, email, etc.)
    _syncUserOnly();
  }

  Future<void> _syncUserOnly() async {
    debugPrint("🌊 [SPLASH] Background sync for full user details...");
    final userResult = await useCase.repository.getUser();
    userResult.fold((_) => debugPrint("🌊 [SPLASH] User details sync failed"), (u) {
      if (u != null) {
        debugPrint("🌊 [SPLASH] User details synced: ${u.name}, Photo: ${u.photoUrl}");
        _user = u;
        notifyListeners();
      }
    });
  }

  /// ✅ Manually set the authenticated role after selection
  void setAuthenticatedRole(UserRole role, [String name = "User", domain.User? user]) {
    _state = AuthenticatedWithRole(role, name);
    if (user != null) _user = user;
    notifyListeners();
    
    // Ensure we have full details when entering dashboard
    if (_user == null) {
      _syncUserOnly();
    }
  }

  /// ✅ Go back to Role Selection (Switch Role)
  void goToRoleSelection() {
    debugPrint("🌊 [SPLASH] goToRoleSelection called. Current state: $_state");
    
    // We try to get the name from either the user object or the current state
    String name = _user?.name ?? "User";
    
    if (_user == null && _state is AuthenticatedWithRole) {
      name = (_state as AuthenticatedWithRole).userName;
    } else if (_user == null && _state is RoleSelectionRequired) {
      name = (_state as RoleSelectionRequired).userName;
    }
    
    debugPrint("🌊 [SPLASH] Switching to Role Selection for $name");
    _state = RoleSelectionRequired(name);
    notifyListeners();
  }

  Future<void> _fetchState({bool isFreshLogin = false}) async {
    debugPrint("🌊 [SPLASH] Fetching state... (isFreshLogin: $isFreshLogin)");
    
    // Save current role to restore after refresh (prevents logout on profile update)
    UserRole? currentRole;
    if (_state is AuthenticatedWithRole) {
      currentRole = (_state as AuthenticatedWithRole).role;
    }

    // Also fetch the full user object for global access
    final userResult = await useCase.repository.getUser();
    userResult.fold((_) => _user = null, (u) {
      _user = u;
      if (u != null) {
        debugPrint("🌊 [SPLASH] User data loaded: ${u.name}, Height: ${u.height}, Weight: ${u.weight}");
      }
    });

    final result = await useCase(isFreshLogin: isFreshLogin);

    result.fold(
      (failure) {
        debugPrint("🌊 [SPLASH] State fetch failed: ${failure.message}");
        _state = const Unauthenticated();
      },
      (appState) {
        // ✅ Fix: If we were already in a dashboard session, keep that role
        if (currentRole != null && appState is MpinRequired && !isFreshLogin) {
          debugPrint("🌊 [SPLASH] Session active. Bypassing MPIN requirement after refresh.");
          _state = AuthenticatedWithRole(_user?.role ?? currentRole, _user?.name ?? "User");
        } else {
          _state = appState;
        }
        debugPrint("🌊 [SPLASH] New State set: $_state");
      },
    );

    // Only notify if the video is already finished.
    // If not, the setVideoFinished() call will notify listeners later.
    if (_videoFinished) {
      debugPrint("🌊 [SPLASH] Notifying listeners (Video already finished)");
      notifyListeners();
    }
  }

  void setVideoFinished() {
    debugPrint("🌊 [SPLASH] Video finished event received");
    _videoFinished = true;
    
    // Once the video is finished, we can finally notify the router about the state
    notifyListeners();
  }
}
