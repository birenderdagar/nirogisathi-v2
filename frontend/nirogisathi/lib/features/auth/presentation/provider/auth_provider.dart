import 'package:flutter/foundation.dart';

import '../../../../core/services/biometric_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final AuthRepository repository;
  final BiometricService biometricService;

  AuthProvider(
      this.loginUseCase,
      this.repository,
      this.biometricService,
      );

  bool isLoading = false;
  String? errorMessage;
  User? user;

  /// ✅ MPIN LOGIN
  Future<void> login(String mobile, String mpin) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await loginUseCase(mobile, mpin);

    result.fold(
          (failure) {
        errorMessage = failure.message;
      },
          (u) {
        user = u;
      },
    );

    isLoading = false;
    notifyListeners();
  }

  /// ✅ SIGN UP
  Future<void> signUp({
    required String name,
    required String mobile,
    required String email,
    required String mpin,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await repository.signUp(
      name: name,
      mobile: mobile,
      email: email,
      mpin: mpin,
    );

    result.fold(
          (failure) {
        errorMessage = failure.message;
      },
          (_) {
        // After successful signup
      },
    );

    isLoading = false;
    notifyListeners();
  }

  /// ✅ COMPLETE PROFILE
  Future<void> completeProfile(String uid, Map<String, dynamic> data) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await repository.completeProfile(uid: uid, profileData: data);

    result.fold(
          (failure) => errorMessage = failure.message,
          (_) {
        // Profile updated
      },
    );

    isLoading = false;
    notifyListeners();
  }

  /// 🔐 BIOMETRIC LOGIN
  Future<void> loginWithBiometric() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final success = await biometricService.authenticate();

    if (!success) {
      errorMessage = "Biometric authentication cancelled";
      isLoading = false;
      notifyListeners();
      return;
    }

    final result = await repository.getUser();

    result.fold(
          (failure) {
        errorMessage = failure.message;
      },
          (u) {
        if (u == null) {
          errorMessage = "No active session found. Please login with MPIN once to enable biometrics.";
        } else {
          user = u;
        }
      },
    );

    isLoading = false;
    notifyListeners();
  }
}
