import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart'
as firebase;

import '../../../../../app/di/injection.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_endpoints.dart';

class FirebaseAuthDataSource {

  final firebase.FirebaseAuth auth;

  FirebaseAuthDataSource(this.auth);

  final Dio dio = getIt<ApiClient>().dio;

  /*
  |--------------------------------------------------------------------------
  | CURRENT USER
  |--------------------------------------------------------------------------
  */
  firebase.User? get currentUser =>
      auth.currentUser;

  /*
  |--------------------------------------------------------------------------
  | AUTH CHANGES
  |--------------------------------------------------------------------------
  */
  Stream<firebase.User?> authStateChanges() =>
      auth.authStateChanges();

  /*
  |--------------------------------------------------------------------------
  | LOGIN
  |--------------------------------------------------------------------------
  */
  Future<firebase.UserCredential> login(

      String email,
      String password,

      ) async {

    return await auth
        .signInWithEmailAndPassword(

      email: email,

      password: password,

    );
  }

  /*
  |--------------------------------------------------------------------------
  | SIGNUP
  |--------------------------------------------------------------------------
  */
  Future<firebase.UserCredential> signup({

    required String name,

    required String mobile,

    required String email,

    required String password,

    required String mpin,

  }) async {

    /*
    |--------------------------------------------------------------------------
    | FIREBASE SIGNUP
    |--------------------------------------------------------------------------
    */
    final credential =
    await auth
        .createUserWithEmailAndPassword(

      email: email,

      password: password,

    );

    /*
    |--------------------------------------------------------------------------
    | SAVE USER TO LARAVEL BACKEND
    |--------------------------------------------------------------------------
    */
    await dio.post(

      ApiEndpoints.createUser,

      data: {

        "name": name,

        "mobile": mobile,

        "email": email,

        "mpin": mpin,

        "role": "user",

        "status": "active",

      },

    );

    return credential;
  }

  /*
  |--------------------------------------------------------------------------
  | LOGOUT
  |--------------------------------------------------------------------------
  */
  Future<void> logout() async {

    await auth.signOut();
  }

  /*
  |--------------------------------------------------------------------------
  | GET TOKEN
  |--------------------------------------------------------------------------
  */
  Future<String?> getToken() async {

    return await auth.currentUser
        ?.getIdToken();
  }
}