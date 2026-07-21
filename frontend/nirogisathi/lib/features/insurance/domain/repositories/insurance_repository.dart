import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/insurance_entity.dart';

abstract class InsuranceRepository {
  Future<Either<Failure, List<InsuranceEntity>>> getInsurances();
}
