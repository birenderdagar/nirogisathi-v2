import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/hospital.dart';
import '../repositories/health_team_repository.dart';

class GetHospitalsUseCase {
  final HealthTeamRepository repository;

  GetHospitalsUseCase(this.repository);

  Future<Either<Failure, Map<String, List<Hospital>>>> call() async {
    final preferredResult = await repository.getPreferredHospitals();
    final othersResult = await repository.getOtherHospitals();

    return preferredResult.fold(
      (Failure l) => Left<Failure, Map<String, List<Hospital>>>(l),
      (List<Hospital> preferred) => othersResult.fold(
        (Failure l) => Left<Failure, Map<String, List<Hospital>>>(l),
        (List<Hospital> others) => Right<Failure, Map<String, List<Hospital>>>({
          'preferred': preferred,
          'others': others,
        }),
      ),
    );
  }
}
