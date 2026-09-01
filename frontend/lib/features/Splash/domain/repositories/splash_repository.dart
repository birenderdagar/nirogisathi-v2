import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class SplashRepository {
  Future<Either<Failure, bool>> isOnboardingDone();
  Future<Either<Failure, bool>> isLoggedIn();
}