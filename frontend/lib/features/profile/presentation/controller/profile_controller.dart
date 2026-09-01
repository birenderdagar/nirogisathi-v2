import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/profile_service.dart';

class ProfileController extends ChangeNotifier {

  final ProfileService service = ProfileService();

  bool loading = false;

  Map<String, dynamic>? profile;

  /*
  |--------------------------------------------------------------------------
  | LOAD PROFILE
  |--------------------------------------------------------------------------
  */
  Future<void> loadProfile(int userId) async {

    try {

      loading = true;

      notifyListeners();

      final response = await service.getProfile(
        userId: userId,
      );

      profile = response.data['data'];

    } catch (e) {

      debugPrint(
        "❌ LOAD PROFILE ERROR: $e",
      );

    } finally {

      loading = false;

      notifyListeners();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | UPDATE PROFILE
  |--------------------------------------------------------------------------
  */
  Future<bool> updateProfile({

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

    try {

      loading = true;

      notifyListeners();

      /*
      |--------------------------------------------------------------------------
      | FORMAT DOB FOR MYSQL
      | Converts:
      | 01-01-1982
      | TO
      | 1982-01-01
      |--------------------------------------------------------------------------
      */

      String formattedDob = "";

      if (dob.isNotEmpty) {

        try {

          formattedDob = DateFormat(
            'yyyy-MM-dd',
          ).format(

            DateFormat(
              'dd-MM-yyyy',
            ).parse(dob),

          );

        } catch (e) {

          formattedDob = dob;
        }
      }

      final response = await service.updateProfile(

        userId: userId,

        name: name,

        mobile: mobile,

        email: email,

        dob: formattedDob,

        gender: gender,

        bloodGroup: bloodGroup,

        weight: weight,

        height: height,

        address: address,

        photo: photo,

      );

      debugPrint(
        "✅ PROFILE UPDATED: ${response.data}",
      );

      return true;

    } catch (e) {

      debugPrint(
        "❌ UPDATE PROFILE ERROR: $e",
      );

      return false;

    } finally {

      loading = false;

      notifyListeners();
    }
  }
}