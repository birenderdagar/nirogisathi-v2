import 'package:flutter_test/flutter_test.dart';
import 'package:nirogisathi/features/home/data/datasources/home_remote_data_source.dart';
import 'package:nirogisathi/features/home/data/models/home_model.dart';
import 'package:nirogisathi/features/home/data/repositories/home_repository_impl.dart';

// Fake Remote DataSource
class FakeHomeRemoteDataSource implements HomeRemoteDataSource {
  @override
  Future<HomeModel> getHomeFromApi() async {
    return HomeModel(title: "Test Title");
  }
}

void main() {
  late HomeRepositoryImpl repository;
  late FakeHomeRemoteDataSource fakeRemoteDataSource;

  setUp(() {
    fakeRemoteDataSource = FakeHomeRemoteDataSource();
    repository = HomeRepositoryImpl(fakeRemoteDataSource);
  });

  test('should return HomeEntity on success', () async {
    final result = await repository.getHomeData();

    result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (data) {
        expect(data.title, "Test Title");
      },
    );
  });
}