import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/health_professional.dart';
import '../entities/hospital.dart';
import '../entities/doctor.dart';

abstract class HealthTeamRepository {
  Future<Either<Failure, List<HealthProfessional>>> getMyHealthTeam();
  Future<Either<Failure, void>> addMember(String professionalId);
  Future<Either<Failure, void>> removeMember(String professionalId);

  Future<Either<Failure, List<Hospital>>> getPreferredHospitals();
  Future<Either<Failure, List<Hospital>>> getOtherHospitals();

  Future<Either<Failure, List<Doctor>>> getPreferredDoctors();
  Future<Either<Failure, List<Doctor>>> getPopularDoctors();
  Future<Either<Failure, List<Doctor>>> getFeatureDoctors();
}
