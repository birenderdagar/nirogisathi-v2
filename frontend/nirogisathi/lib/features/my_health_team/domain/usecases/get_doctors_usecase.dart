import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/doctor.dart';
import '../repositories/health_team_repository.dart';

class GetDoctorsUseCase {
  final HealthTeamRepository repository;

  GetDoctorsUseCase(this.repository);

  Future<Either<Failure, Map<String, List<Doctor>>>> call() async {
    final preferred = await repository.getPreferredDoctors();
    final popular = await repository.getPopularDoctors();
    final feature = await repository.getFeatureDoctors();

    return preferred.fold(
      (Failure l) => Left<Failure, Map<String, List<Doctor>>>(l),
      (List<Doctor> prefList) => popular.fold(
        (Failure l) => Left<Failure, Map<String, List<Doctor>>>(l),
        (List<Doctor> popList) => feature.fold(
          (Failure l) => Left<Failure, Map<String, List<Doctor>>>(l),
          (List<Doctor> featList) => Right<Failure, Map<String, List<Doctor>>>({
            'preferred': prefList,
            'popular': popList,
            'feature': featList,
          }),
        ),
      ),
    );
  }
}
