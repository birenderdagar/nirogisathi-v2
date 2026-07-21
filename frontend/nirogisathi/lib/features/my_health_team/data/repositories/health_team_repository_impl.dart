import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/health_professional.dart';
import '../../domain/entities/hospital.dart';
import '../../domain/entities/doctor.dart';
import '../../domain/repositories/health_team_repository.dart';
import '../datasources/health_team_remote_datasource.dart';

class HealthTeamRepositoryImpl implements HealthTeamRepository {
  final HealthTeamRemoteDataSource remoteDataSource;

  HealthTeamRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<HealthProfessional>>> getMyHealthTeam() async {
    try {
      final remoteData = await remoteDataSource.getMyHealthTeam();
      return Right(remoteData);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch health team: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addMember(String professionalId) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> removeMember(String professionalId) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<Hospital>>> getPreferredHospitals() async {
    try {
      final remoteData = await remoteDataSource.getPreferredHospitals();
      return Right(remoteData);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch preferred hospitals: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Hospital>>> getOtherHospitals() async {
    try {
      final remoteData = await remoteDataSource.getOtherHospitals();
      return Right(remoteData);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch other hospitals: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Doctor>>> getPreferredDoctors() async {
    try {
      final remoteData = await remoteDataSource.getPreferredDoctors();
      return Right(remoteData);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch preferred doctors: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Doctor>>> getPopularDoctors() async {
    try {
      final remoteData = await remoteDataSource.getPopularDoctors();
      return Right(remoteData);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch popular doctors: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Doctor>>> getFeatureDoctors() async {
    try {
      final remoteData = await remoteDataSource.getFeatureDoctors();
      return Right(remoteData);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch feature doctors: $e'));
    }
  }
}
