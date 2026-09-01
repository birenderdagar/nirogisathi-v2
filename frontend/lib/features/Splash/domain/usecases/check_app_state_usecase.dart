

import 'package:dartz/dartz.dart';

import '../../../../core/enums/app_state.dart';
import '../../../../core/errors/failures.dart';

import '../../../auth/domain/entities/user.dart';
import '../../../auth/domain/repositories/auth_repository.dart';


class CheckAppStateUseCase {
  final AuthRepository repository;

  const CheckAppStateUseCase(this.repository);

  Future<Either<Failure, AppState>> call() async {
    final result = await repository.getUser();

    return result.map((User? user) {
      /// 🔓 Not logged in
      if (user == null) {
        return const Unauthenticated();
      }

      /// 🔐 Fully authenticated
      return AuthenticatedWithRole(user.role);
    });
  }
}