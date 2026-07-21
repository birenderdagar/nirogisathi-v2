import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/insurance_entity.dart';
import '../../domain/repositories/insurance_repository.dart';
import '../datasources/insurance_remote_datasource.dart';

class InsuranceRepositoryImpl implements InsuranceRepository {
  final InsuranceRemoteDataSource remoteDataSource;

  InsuranceRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<InsuranceEntity>>> getInsurances() async {
    try {
      final insurances = await remoteDataSource.getInsurances();
      return Right(insurances);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
