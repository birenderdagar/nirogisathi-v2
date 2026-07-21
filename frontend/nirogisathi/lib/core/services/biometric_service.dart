import 'package:local_auth/local_auth.dart';
import 'app_logger.dart';

class BiometricService {
  final LocalAuthentication auth;

  BiometricService(this.auth);

  /// Check availability
  Future<bool> _isAvailable() async {
    try {
      final supported = await auth.isDeviceSupported();
      final canCheck = await auth.canCheckBiometrics;
      return supported && canCheck;
    } catch (e, stackTrace) {
      AppLogger.error('Biometric availability failed', e, stackTrace);
      return false;
    }
  }

  /// Authenticate user
  Future<bool> authenticate() async {
    try {
      final available = await _isAvailable();

      if (!available) {
        AppLogger.error('Biometrics not available');
        return false;
      }

      return await auth.authenticate(
        localizedReason: 'Authenticate to login',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Biometric auth failed', e, stackTrace);
      return false;
    }
  }
}