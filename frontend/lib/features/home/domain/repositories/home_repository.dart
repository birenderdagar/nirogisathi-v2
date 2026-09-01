import 'package:dartz/dartz.dart';
import 'package:nirogisathi/core/errors/failures.dart';

import '../entities/home_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeEntity>> getHomeData();
}