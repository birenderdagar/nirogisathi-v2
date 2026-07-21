import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart' as domain;
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  Future<Either<Failure, domain.User>> call(
      String mobile,
      String mpin,
      ) {
    return repository.loginWithMobile(mobile, mpin);
  }
}
