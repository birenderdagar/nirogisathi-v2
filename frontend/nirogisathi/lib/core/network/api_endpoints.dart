class ApiEndpoints {

  /*
  |--------------------------------------------------------------------------
  | BASE URL
  |--------------------------------------------------------------------------
  */
  static const String baseUrl =
      "http://192.168.1.86:8000/api/";

  /*
  |--------------------------------------------------------------------------
  | AUTH
  |--------------------------------------------------------------------------
  */
  static const String login =
      "login";

  static const String logout =
      "logout";

  static const String verifyOtp =
      "user-verifyotp";

  /*
  |--------------------------------------------------------------------------
  | USER APIs
  |--------------------------------------------------------------------------
  */

  /// CREATE USER AFTER FIREBASE SIGNUP
  static const String createUser =
      "users/create";

  /// GET USER PROFILE
  static const String getProfile =
      "users/profile";

  /// UPDATE USER PROFILE
  static const String updateProfile =
      "users/update-profile";

  /*
  |--------------------------------------------------------------------------
  | LOCATION
  |--------------------------------------------------------------------------
  */
  static const String updateLocation =
      "location/update";
}