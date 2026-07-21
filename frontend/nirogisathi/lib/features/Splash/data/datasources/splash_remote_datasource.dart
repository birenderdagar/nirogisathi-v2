import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class SplashRemoteDataSource {
  Future<bool> validateToken(String token);
}

class SplashRemoteDataSourceImpl implements SplashRemoteDataSource {
  final http.Client client;

  SplashRemoteDataSourceImpl({required this.client});

  @override
  Future<bool> validateToken(String token) async {
    try {
      final response = await client.get(
        Uri.parse('https://api.example.com/validate'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['valid'] == true;
      }

      return false; // ✅ ensures non-200 always returns something
    } catch (e) {
      return false; // ✅ ensures network error also returns bool
    }
  }
}