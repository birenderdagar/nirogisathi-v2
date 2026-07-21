import 'package:shared_preferences/shared_preferences.dart';

abstract class SplashLocalDataSource {
  Future<bool> isFirstTime();
  Future<String?> getAuthToken();
  Future<void> cacheFirstTime(bool value);
}

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  final SharedPreferences sharedPreferences;

  SplashLocalDataSourceImpl({required this.sharedPreferences});

  static const firstTimeKey = 'FIRST_TIME';
  static const tokenKey = 'TOKEN';

  @override
  Future<bool> isFirstTime() async {
    return sharedPreferences.getBool(firstTimeKey) ?? true;
  }

  @override
  Future<String?> getAuthToken() async {
    return sharedPreferences.getString(tokenKey);
  }

  @override
  Future<void> cacheFirstTime(bool value) async {
    await sharedPreferences.setBool(firstTimeKey, value);
  }
}