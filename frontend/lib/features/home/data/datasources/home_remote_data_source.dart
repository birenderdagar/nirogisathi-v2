
import '../models/home_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeModel> getHomeFromApi();
}