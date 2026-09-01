import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/repositories/splash_repository.dart';
import '../datasources/splash_local_datasource.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashLocalDataSource localDataSource;

  SplashRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, bool>> isOnboardingDone() async {
    try {
      final isFirstTime = await localDataSource.isFirstTime();
      return Right(!isFirstTime);
    } on SocketException {
      return const Left(NetworkFailure());
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final token = await localDataSource.getAuthToken();
      final isLoggedIn = token != null && token.isNotEmpty;
      return Right(isLoggedIn);
    } on SocketException {
      return const Left(NetworkFailure());
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}