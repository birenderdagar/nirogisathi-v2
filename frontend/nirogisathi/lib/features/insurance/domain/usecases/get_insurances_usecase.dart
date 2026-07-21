import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/insurance_entity.dart';
import '../repositories/insurance_repository.dart';

class GetInsurancesUseCase {
  final InsuranceRepository repository;

  GetInsurancesUseCase(this.repository);

  Future<Either<Failure, List<InsuranceEntity>>> call() async {
    return await repository.getInsurances();
  }
}
