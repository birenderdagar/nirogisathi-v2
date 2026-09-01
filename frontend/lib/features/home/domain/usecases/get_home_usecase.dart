import 'package:dartz/dartz.dart';
import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';
import '../../../../core/errors/failures.dart';

class GetHomeDataUseCase {
  final HomeRepository repository;

  GetHomeDataUseCase(this.repository);

  Future<Either<Failure, HomeEntity>> call() async {
    return await repository.getHomeData();
  }
}