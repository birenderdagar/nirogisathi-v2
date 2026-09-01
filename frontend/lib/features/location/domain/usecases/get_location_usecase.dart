import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class GetLocationUseCase {
  final LocationRepository repository;

  GetLocationUseCase(this.repository);

  Future<Either<Failure, LocationEntity>> call() async {
    return await repository.getCurrentLocation();
  }
}
