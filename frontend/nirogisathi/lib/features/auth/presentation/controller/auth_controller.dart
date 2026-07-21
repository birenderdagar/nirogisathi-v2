import 'package:flutter/material.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../../../core/services/biometric_service.dart';

class AuthController extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final AuthRepository repository;
  final BiometricService biometricService;

  AuthController({
    required this.loginUseCase,
    required this.repository,
    required this.biometricService,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  User? _user;
  User? get user => _user;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
  // 🔹 SEND OTP
  Future<dynamic> sendOtp(String mobile) async {
    _setLoading(true);
    _setError(null);

    final result = await repository.loginWithOtp(mobile);

    _setLoading(false);

    return result.fold(
      (failure) {
        _setError(failure.message);
        return {'status': false, 'message': failure.message};
      },
      (response) => response,
    );
  }

  // 🔹 VERIFY OTP
  Future<dynamic> verifyOtp(String mobile, String otp) async {
    _setLoading(true);
    _setError(null);

    final result = await repository.verifyOtp(mobile, otp);

    _setLoading(false);

    return result.fold(
      (failure) {
        _setError(failure.message);
        return {'status': false, 'message': failure.message};
      },
      (response) => response,
    );
  }

  /// ✅ Login with Mobile and MPIN
  Future<void> login(String mobile, String mpin) async {
    _setLoading(true);
    _setError(null);

    final result = await repository.loginWithMobile(mobile, mpin);

    result.fold(
      (failure) => _setError(failure.message),
      (user) {
        _user = user;
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  /// ✅ Sign Up
  Future<void> signUp({
    required String name,
    required String mobile,
    required String email,
    required String mpin,
  }) async {
    _setLoading(true);
    _setError(null);

    final result = await repository.signUp(
      name: name,
      mobile: mobile,
      email: email,
      mpin: mpin,
    );

    result.fold(
      (failure) => _setError(failure.message),
      (_) {
        // Handle post-signup logic if needed
      },
    );

    _setLoading(false);
  }

  /// ✅ Biometric Authentication
  Future<void> loginWithBiometric() async {
    _setLoading(true);
    _setError(null);

    final isAuthed = await biometricService.authenticate();

    if (!isAuthed) {
      _setError("Biometric authentication failed or cancelled");
      _setLoading(false);
      return;
    }

    final result = await repository.getUser();

    result.fold(
      (failure) => _setError(failure.message),
      (user) {
        if (user == null) {
          _setError("No session found. Please login with MPIN first.");
        } else {
          _user = user;
          notifyListeners();
        }
      },
    );

    _setLoading(false);
  }

  /// ✅ Logout
  Future<void> logout() async {
    _setLoading(true);
    await repository.logout();
    _user = null;
    _setLoading(false);
  }

  /// ✅ Clear Error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// 🛠️ DIAGNOSTIC: Cross-check backend connection
  Future<void> debugCheckBackend() async {
    debugPrint("🛠️ [DIAGNOSTIC] Starting backend cross-check...");
    
    // 1. Try to get current user session
    final result = await repository.getUser();
    result.fold(
      (failure) => debugPrint("🛠️ [DIAGNOSTIC] Session Check Failed: ${failure.message}"),
      (user) {
        if (user != null) {
          debugPrint("🛠️ [DIAGNOSTIC] Session Success: ${user.name} (${user.role})");
        } else {
          debugPrint("🛠️ [DIAGNOSTIC] No active local session.");
        }
      },
    );

    // 2. Try to fetch all users (if route /users exists)
    debugPrint("🛠️ [DIAGNOSTIC] Attempting to fetch all backend users for verification...");
    final allUsers = await repository.remoteDataSource.debugGetAllUsers();
    if (allUsers != null) {
      debugPrint("🛠️ [DIAGNOSTIC] All Users Data: $allUsers");
    } else {
      debugPrint("🛠️ [DIAGNOSTIC] Could not fetch user list (Route might be protected or non-existent).");
    }
  }
}
