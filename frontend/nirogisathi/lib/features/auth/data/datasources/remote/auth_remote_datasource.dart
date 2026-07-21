import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/constants/api_constants.dart';

abstract class AuthRemoteDataSource {
  Future<dynamic> loginWithOtp(String phone);
  Future<dynamic> verifyOtp(String mobile, String otp);
  Future<dynamic> loginWithMpin(String mobile, String mpin);
  Future<dynamic> register({required String name, required String mobile, required String email, required String mpin});
  Future<dynamic> getUserProfile();
  Future<dynamic> updateProfile(Map<String, dynamic> data);
  Future<dynamic> debugGetAllUsers();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<dynamic> updateProfile(Map<String, dynamic> data) async {
    dynamic requestData;
    
    // Ensure user_id is included as an integer if it's in UID format
    // Many Laravel backends expect 'user_id' for identification in the body
    final Map<String, dynamic> body = Map.from(data);
    if (!body.containsKey('user_id')) {
      final uid = apiClient.localStorage.getUid();
      if (uid != null) {
        // Try to parse as int, otherwise send as is
        body['user_id'] = int.tryParse(uid) ?? uid;
      }
    }

    // Check if we have a file path in profile_image
    final String? imagePath = body['profile_image'];
    
    if (imagePath != null && !imagePath.startsWith('http') && File(imagePath).existsSync()) {
      debugPrint("🌐 [NETWORK] Converting to multipart/form-data for image upload. Path: $imagePath");
      // Use FormData for file uploads
      final Map<String, dynamic> formDataMap = Map.from(body);
      
      // ✅ Create separate instances for each key to avoid "MultipartFile has already been finalized" error
      formDataMap['profile_image'] = await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      );
      
      formDataMap['photo'] = await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      );
      
      requestData = FormData.fromMap(formDataMap);
    } else {
      requestData = body;
    }

    final response = await apiClient.post(ApiConstants.profileUpdate, data: requestData);
    debugPrint("🌐 [NETWORK] Profile update response: ${response.data}");
    return response.data;
  }

  @override
  Future<dynamic> debugGetAllUsers() async {
    debugPrint("🌐 [NETWORK] GET Request to /users (Debug)");
    try {
      final response = await apiClient.get('/users'); // Assuming /api/users exists
      return response.data;
    } catch (e) {
      debugPrint("🌐 [NETWORK] /users fetch failed (Normal if route doesn't exist)");
      return null;
    }
  }

  @override
  Future<dynamic> loginWithOtp(String phone) async {
    final response = await apiClient.post(
      ApiConstants.login,
      data: {"phone": phone},
    );
    return response.data;
  }

  @override
  Future<dynamic> verifyOtp(String mobile, String otp) async {
    final response = await apiClient.post(
      ApiConstants.verifyOtp,
      data: {
        "mobile": mobile,
        "otp": otp,
      },
    );
    return response.data;
  }

  @override
  Future<dynamic> register({required String name, required String mobile, required String email, required String mpin}) async {
    final response = await apiClient.post(
      ApiConstants.register,
      data: {
        "name": name,
        "mobile": mobile,
        "phone": mobile,
        "email": email,
        "mpin": mpin,
        "role": "user", // ✅ Adding role field
        "status": "active", // ✅ Adding status field
        "is_profile_complete": 0, // ✅ Initial state
      },
    );
    return response.data;
  }

  @override
  Future<dynamic> loginWithMpin(String mobile, String mpin) async {
    final response = await apiClient.post(
      ApiConstants.login,
      data: {
        "mobile": mobile,
        "mpin": mpin,
      },
    );
    return response.data;
  }

  @override
  Future<dynamic> getUserProfile() async {
    debugPrint("🌐 [NETWORK] GET Request to: ${ApiConstants.baseUrl}${ApiConstants.profile}");
    try {
      final response = await apiClient.get(ApiConstants.profile);
      debugPrint("🌐 [NETWORK] Response Status: ${response.statusCode}");
      debugPrint("🌐 [NETWORK] Response Body: ${response.data}");
      return response.data;
    } catch (e) {
      debugPrint("🌐 [NETWORK] GET Error: $e");
      rethrow;
    }
  }
}
