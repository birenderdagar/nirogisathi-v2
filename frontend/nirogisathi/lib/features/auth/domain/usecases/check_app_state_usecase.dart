import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/enums/app_state.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart' as domain;
import '../repositories/auth_repository.dart';

class CheckAppStateUseCase {
  final AuthRepository repository;

  const CheckAppStateUseCase(this.repository);

  Future<Either<Failure, AppState>> call({bool isFreshLogin = false}) async {
    final result = await repository.getUser();

    return result.fold(
      (failure) => const Right(Unauthenticated()),
      (domain.User? user) async {
        if (user == null) {
          return const Right(Unauthenticated());
        }

        // 1. If we just freshly logged in with MPIN, go to role selection
        if (isFreshLogin) {
          return Right(RoleSelectionRequired(user.name));
        }

        // 2. IMPORTANT: If we are already in a dashboard session, don't force MPIN again
        // This handles cases like profile updates or background refreshes.
        // We detect this by seeing if the user is already authenticated with a specific role
        // but since UseCase is stateless, we can't easily know without current state.
        
        // Actually, the simplest fix for your requirement (Compulsory MPIN on startup)
        // is to keep MpinRequired as default, BUT allow the Provider to bypass it
        // when explicitly refreshing data.

        // Always require MPIN login every time the app starts from splash
        return Right(MpinRequired(user.mobile));
      },
    );
  }

  /// Use this to check permissions and determine final home after role selection
  Future<Either<Failure, AppState>> checkPermissionsAndProceed(domain.User user) async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || 
        permission == LocationPermission.deniedForever) {
      return Right(LocationPermissionRequired(user.role));
    }

    return Right(AuthenticatedWithRole(user.role, user.name));
  }
}
