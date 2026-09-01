import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/health_professional.dart';
import '../repositories/health_team_repository.dart';

class GetMyHealthTeamUseCase {
  final HealthTeamRepository repository;

  GetMyHealthTeamUseCase(this.repository);

  Future<Either<Failure, List<HealthProfessional>>> call() async {
    return await repository.getMyHealthTeam();
  }
}
