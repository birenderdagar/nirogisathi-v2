import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:nirogisathi/core/errors/exceptions.dart';
import 'package:nirogisathi/core/errors/failures.dart';
import 'package:nirogisathi/features/home/domain/entities/home_entity.dart';
import 'package:nirogisathi/features/home/domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, HomeEntity>> getHomeData() async {
    try {
      final model = await remoteDataSource.getHomeFromApi();
      return Right(model.toEntity());
    } on ServerException catch (e, stackTrace) {
      log('ServerException: ${e.message}', stackTrace: stackTrace);
      return Left(ServerFailure(e.message));
    } on NetworkException catch (_, stackTrace) {
      log('NetworkException occurred', stackTrace: stackTrace);
      return Left(NetworkFailure('No internet connection'));
    } catch (e, stackTrace) {
      log('Unknown Error: $e', stackTrace: stackTrace);
      return Left(UnknownFailure('Something went wrong'));
    }
  }
}