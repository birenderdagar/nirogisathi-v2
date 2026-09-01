import 'package:dio/dio.dart';
import '../storage/local_storage_service.dart';
import '../constants/api_constants.dart';

class ApiClient {
  final Dio dio;
  final LocalStorageService localStorage;

  ApiClient(this.localStorage)
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Fetch token from local storage
          final token = localStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Global error handling can be added here
          return handler.next(e);
        },
      ),
    );

    // ✅ Add logging for easier debugging of Laravel link
    dio.interceptors.add(LogInterceptor(
      responseBody: true, 
      requestBody: true,
      requestHeader: true,
      responseHeader: false,
    ));
  }

  // Helper methods for common operations
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await dio.delete(path);
  }
}
