import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nirogisathi/app/di/injection.dart';
import 'package:nirogisathi/core/network/api_client.dart';

import '../../../core/network/api_endpoints.dart';

class ProfileService {

  final Dio dio = getIt<ApiClient>().dio;

  /*
  |--------------------------------------------------------------------------
  | GET PROFILE
  |--------------------------------------------------------------------------
  */
  Future<Response> getProfile({

    required int userId,

  }) async {

    return await dio.post(

      ApiEndpoints.getProfile,

      data: {

        "user_id": userId,

      },

    );
  }

  /*
  |--------------------------------------------------------------------------
  | UPDATE PROFILE
  |--------------------------------------------------------------------------
  */
  Future<Response> updateProfile({

    required int userId,

    required String name,

    required String mobile,

    required String email,

    required String dob,

    required String gender,

    required String bloodGroup,

    required String weight,

    required String height,

    required String address,

    File? photo,

  }) async {

    FormData formData = FormData.fromMap({

      "user_id": userId,

      "name": name,

      "mobile": mobile,

      "email": email,

      "dob": dob,

      "gender": gender,

      "blood_group": bloodGroup,

      "weight": weight,

      "height": height,

      "address": address,

    });

    /*
    |--------------------------------------------------------------------------
    | PHOTO
    |--------------------------------------------------------------------------
    */
    if (photo != null) {

      formData.files.add(

        MapEntry(

          "photo",

          await MultipartFile.fromFile(
            photo.path,
          ),

        ),

      );
    }

    return await dio.post(

      ApiEndpoints.updateProfile,

      data: formData,

    );
  }
}