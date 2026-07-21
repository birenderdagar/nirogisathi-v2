import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';

import '../../domain/entities/user.dart'
as domain;

import '../../domain/repositories/auth_repository.dart';

import '../datasources/user_firestore_datasource.dart';

import '../datasources/session_local_datasource.dart';

import '../datasources/remote/auth_remote_datasource.dart';

import '../models/user_model.dart';

class AuthRepositoryImpl
    implements AuthRepository {

  /*
  |--------------------------------------------------------------------------
  | DATASOURCES
  |--------------------------------------------------------------------------
  */

  final UserFirestoreDataSource
  firestore;

  final SessionLocalDataSource
  session;

  @override
  final AuthRemoteDataSource
  remoteDataSource;

  /*
  |--------------------------------------------------------------------------
  | CONSTRUCTOR
  |--------------------------------------------------------------------------
  */

  const AuthRepositoryImpl(

      this.firestore,

      this.session,

      this.remoteDataSource,

      );

  /*
  |--------------------------------------------------------------------------
  | LOGIN WITH OTP
  |--------------------------------------------------------------------------
  */

  @override
  Future<Either<Failure, dynamic>>
  loginWithOtp(
      String phone,
      ) async {

    try {

      final response =
      await remoteDataSource
          .loginWithOtp(phone);

      return Right(response);

    } catch (e) {

      return Left(

        ServerFailure(
          e.toString(),
        ),

      );
    }
  }

  /*
  |--------------------------------------------------------------------------
  | VERIFY OTP
  |--------------------------------------------------------------------------
  */

  @override
  Future<Either<Failure, dynamic>>
  verifyOtp(
      String mobile,
      String otp,
      ) async {

    try {

      debugPrint(
        "🔍 [OTP] Verifying for $mobile...",
      );

      final response =
      await remoteDataSource
          .verifyOtp(
        mobile,
        otp,
      );

      debugPrint(
        "🔍 [OTP] Response: $response",
      );

      final bool isSuccess =

          response['success'] == true ||

              response['status'] == true ||

              response['message']
                  ?.toString()
                  .toLowerCase()
                  .contains('ok') ==
                  true;

      if (isSuccess) {

        String? token =

            response['token'] ??

                response['access_token'] ??

                response['plainTextToken'];

        if (token != null) {

          await session.storage
              .saveToken(
            token.toString(),
          );
        } else {
           await session.storage.saveToken("valid_session_placeholder");
        }

        dynamic userData =

            response['user'] ??

                response['data'];

        if (userData == null) {

          final allUsers =
          await remoteDataSource
              .debugGetAllUsers();

          if (allUsers != null &&
              allUsers is List) {

            userData =
                allUsers.firstWhere(

                      (u) =>

                  u['mobile']
                      ?.toString() ==
                      mobile ||

                      u['phone']
                          ?.toString() ==
                          mobile,

                  orElse: () => null,

                );
          }
        }

        if (userData != null) {

          final uid = (

              userData['id'] ??

                  userData['uid'] ??

                  ''

          ).toString();

          await session.cacheUid(uid);
          
          // Save user data locally
          final userModel = UserModel.fromJson(userData as Map<String, dynamic>);
          await session.saveUser(userModel);
        }

        return Right(response);
      }

      return Right(response);

    } catch (e) {

      return Left(

        ServerFailure(
          e.toString(),
        ),

      );
    }
  }

  /*
  |--------------------------------------------------------------------------
  | LOGIN WITH MPIN
  |--------------------------------------------------------------------------
  */

  @override
  Future<Either<Failure, domain.User>>
  loginWithMobile(
    String mobile,
    String mpin,
  ) async {

    try {

      debugPrint(
        "🚀 [LOGIN] Starting verification for: $mobile",
      );

      final loginResponse =
      await remoteDataSource
          .loginWithMpin(
        mobile,
        mpin,
      );

      debugPrint(
        "🔍 [LOGIN] API Response: $loginResponse",
      );

      final bool pinVerified =

          loginResponse['status'] == true ||

              loginResponse['success'] == true ||

              loginResponse['message']
                  ?.toString()
                  .toLowerCase()
                  .contains('ok') ==
                  true;

      if (!pinVerified) {

        return Left(

          ServerFailure(

            loginResponse['message']
                ?? "Incorrect MPIN",

          ),

        );
      }

      // Check if user data is already in the login response
      dynamic foundUserData = loginResponse['data'] ?? loginResponse['user'];

      if (foundUserData == null) {
        debugPrint("⚠️ [LOGIN] No user data in login response. Searching in user list...");
        final allUsers =
        await remoteDataSource
            .debugGetAllUsers();

        if (allUsers != null &&
            allUsers is List) {

          foundUserData =
              allUsers.firstWhere(

                    (u) =>

                u['mobile']
                    ?.toString() ==
                    mobile ||

                    u['phone']
                        ?.toString() ==
                        mobile,

                orElse: () => null,

              );
        }
      }

      final String? token =

          loginResponse['token'] ??

              loginResponse['access_token'] ??
              
              loginResponse['plainTextToken'];

      if (token != null) {

        await session.storage
            .saveToken(
          token.toString(),
        );
      } else {
        await session.storage.saveToken("valid_session_placeholder");
      }

      if (foundUserData == null) {
        return Left(
          ServerFailure("User profile not found"),
        );
      }

      final String uid = (

          foundUserData['id'] ??

              foundUserData['uid'] ??

              'temp_id'

      ).toString();

      await session.cacheUid(uid);

      final userModel =
      UserModel.fromJson({

        ...foundUserData
        as Map<String, dynamic>,

        'mobile': mobile,

        'mpin': mpin,

      });

      // ✅ Save user profile locally for instant session restore
      await session.saveUser(userModel);

      return Right(
        userModel.toEntity(),
      );

    } catch (e) {

      return Left(

        ServerFailure(
          e.toString(),
        ),

      );
    }
  }

  /*
  |--------------------------------------------------------------------------
  | SIGNUP
  |--------------------------------------------------------------------------
  */

  @override
  Future<Either<Failure, Unit>>
  signUp({

    required String name,

    required String mobile,

    required String email,

    required String mpin,

  }) async {

    try {

      /*
      |--------------------------------------------------------------------------
      | CHECK FIREBASE USER
      |--------------------------------------------------------------------------
      */

      final existingUser =
      await firestore
          .getUserByMobile(
        mobile,
      );

      if (existingUser != null) {

        return const Left(

          ServerFailure(
            "User already exists",
          ),

        );
      }

      /*
      |--------------------------------------------------------------------------
      | SAVE TO FIREBASE
      |--------------------------------------------------------------------------
      */

      final uid = const Uuid().v4();

      final userModel = UserModel(

        uid: uid,

        name: name,

        mobile: mobile,

        email: email,

        mpin: mpin,

        role: "user",

        isProfileComplete: false,

      );

      await firestore.createUser(
        userModel,
      );

      await session.cacheUid(uid);
      await session.saveUser(userModel);

      /*
      |--------------------------------------------------------------------------
      | SAVE TO LARAVEL BACKEND
      |--------------------------------------------------------------------------
      */

      debugPrint(
        "🌐 [SIGNUP] Registering on backend...",
      );

      final backendResponse =
      await remoteDataSource
          .register(

        name: name,

        mobile: mobile,

        email: email,

        mpin: mpin,

      );

      debugPrint(
        "🌐 [SIGNUP] Backend Response: $backendResponse",
      );

      /*
      |--------------------------------------------------------------------------
      | CHECK RESPONSE
      |--------------------------------------------------------------------------
      */

      final bool isSuccess =

          backendResponse['success']
              == true ||

              backendResponse['status']
                  == true;

      /*
      |--------------------------------------------------------------------------
      | FAILED
      |--------------------------------------------------------------------------
      */

      if (!isSuccess) {

        return Left(

          ServerFailure(

            backendResponse['message']
                ?? "Signup failed",

          ),

        );
      }

      /*
      |--------------------------------------------------------------------------
      | SAVE BACKEND USER ID
      |--------------------------------------------------------------------------
      */

      final backendUserId =

      backendResponse['user_id']
          ?.toString();

      if (backendUserId != null) {

        await session.cacheUid(
          backendUserId,
        );
      }

      debugPrint(
        "✅ [SIGNUP] Success",
      );

      return const Right(unit);

    } catch (e) {

      debugPrint(
        "❌ [SIGNUP] Error: $e",
      );

      return Left(

        ServerFailure(
          e.toString(),
        ),

      );
    }
  }

  /*
  |--------------------------------------------------------------------------
  | COMPLETE PROFILE
  |--------------------------------------------------------------------------
  */

  @override
  Future<Either<Failure, Unit>>
  completeProfile({

    required String uid,

    required Map<String, dynamic>
    profileData,

  }) async {

    try {

      final response =
      await remoteDataSource
          .updateProfile(
        profileData,
      );

      final bool isSuccess =

          response['success'] ==
              true ||

              response['status'] ==
                  true;

      if (isSuccess) {
        // ✅ Try to get fresh user data from the update response if available
        // Check for 'data', 'user' or just the map itself if it has an 'id'
        dynamic userData;
        if (response is Map) {
          userData = response['data'] ?? response['user'] ?? (response.containsKey('id') ? response : null);
        }

        if (userData != null && userData is Map) {
          debugPrint("👤 [AUTH REPO] Updating local cache with fresh data from response");
          final userModel = UserModel.fromJson(userData as Map<String, dynamic>);
          await session.saveUser(userModel);
        } else {
          // Fallback: Manually update local cache with the new profile data immediately
          final existingUser = session.getUser();
          if (existingUser != null) {
            debugPrint("👤 [AUTH REPO] Manually updating local cache (response was empty)");
            final updatedModel = UserModel(
              uid: existingUser.id,
              name: profileData['name'] ?? existingUser.name,
              mobile: existingUser.mobile,
              email: profileData['email'] ?? existingUser.email ?? '',
              mpin: '', // MPIN not usually in profile update
              photo: profileData['profile_image'] ?? existingUser.photoUrl,
              dob: profileData['dob'] ?? existingUser.dob,
              gender: profileData['gender'] ?? existingUser.gender,
              bloodGroup: profileData['blood_group'] ?? existingUser.bloodGroup,
              weight: profileData['weight'] ?? existingUser.weight,
              height: profileData['height'] ?? existingUser.height,
              isProfileComplete: true,
              role: existingUser.role.name,
            );
            await session.saveUser(updatedModel);
          }
        }

        // Trigger a background refresh to be 100% sure final paths are synced
        getUser();

        return const Right(unit);
      }

      return Left(

        ServerFailure(

          response['message'] ??
              "Profile update failed",

        ),

      );

    } catch (e) {

      return Left(

        ServerFailure(
          e.toString(),
        ),

      );
    }
  }

  /*
  |--------------------------------------------------------------------------
  | GET USER
  |--------------------------------------------------------------------------
  */

  @override
  Future<Either<Failure, domain.User?>>
  getUser() async {

    try {

      final token =
      session.storage.getToken();

      final uid = session.getUid();

      if (token == null && uid == null) {

        return const Right(null);
      }

      // 1. Try fresh data if token exists (Ensures UI stays in sync with DB)
      if (token != null) {
        try {
          final response =
          await remoteDataSource
              .getUserProfile();

          final root =

          (response is Map &&
              response.containsKey(
                'data',
              ))

              ? response['data']

              : (response is Map && response.containsKey('user'))
                  ? response['user']
                  : response;

          final userData =

          root is Map

              ? (

              root['user'] ??

                  root['profile'] ??

                  root

          )

              : null;

          if (userData != null &&
              userData is Map) {

            final userModel =
            UserModel.fromJson(

              userData
              as Map<String, dynamic>,

            );

            // Update cache
            await session.saveUser(userModel);

            return Right(
              userModel.toEntity(),
            );
          }
        } catch (e) {
          debugPrint("❌ [AUTH REPO] Server profile fetch FAILED — showing cached data which may be STALE. Backend edits will NOT appear until this succeeds: $e");
        }
      }

      // 2. Fallback to cached user (Fastest/Offline)
      final cachedUser = session.getUser();
      if (cachedUser != null) {
         return Right(cachedUser);
      }
      
      // 3. Fallback: If no cache but we have a UID, try searching in list
      if (uid != null) {
        final response = await remoteDataSource.debugGetAllUsers();
        dynamic usersList;
        if (response is List) {
          usersList = response;
        } else if (response is Map && response['data'] is List) {
          usersList = response['data'];
        }

        if (usersList != null && usersList is List) {
           final found = usersList.firstWhere(
             (u) => (u['id'] ?? u['uid']).toString() == uid,
             orElse: () => null,
           );
           if (found != null) {
             final userModel = UserModel.fromJson(found as Map<String, dynamic>);
             await session.saveUser(userModel);
             return Right(userModel.toEntity());
           }
        }
      }

      return const Right(null);

    } catch (e) {

      return Left(

        ServerFailure(
          e.toString(),
        ),

      );
    }
  }

  /*
  |--------------------------------------------------------------------------
  | LOGOUT
  |--------------------------------------------------------------------------
  */

  @override
  Future<Either<Failure, Unit>>
  logout() async {

    try {

      await session.clearSession();

      return const Right(unit);

    } catch (e) {

      return Left(

        ServerFailure(
          e.toString(),
        ),

      );
    }
  }
}
