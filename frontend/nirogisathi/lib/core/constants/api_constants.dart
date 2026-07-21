class ApiConstants {

  /*
  |--------------------------------------------------------------------------
  | BASE URL
  |--------------------------------------------------------------------------
  */

  // 🌐 Production Server
  // static const String baseUrl =
  //     "https://nirogisathi.cloud/api/";

  // 💻 Local Laravel Server
  static const String baseUrl =
      "http://192.168.1.86:8000/api/";

  /*
  |--------------------------------------------------------------------------
  | AUTH APIs
  |--------------------------------------------------------------------------
  */

  /// LOGIN WITH MPIN
  static const String login =
      "login";

  /// LOGOUT
  static const String logout =
      "logout";

  /// VERIFY OTP
  static const String verifyOtp =
      "user-verifyotp";

  /*
  |--------------------------------------------------------------------------
  | USER APIs
  |--------------------------------------------------------------------------
  */

  /// CREATE USER
  static const String register =
      "users/create";

  /// GET USER PROFILE
  static const String profile =
      "user";

  /// UPDATE USER PROFILE
  static const String profileUpdate =
      "users/update-profile";

  /// GET ALL USERS
  static const String users =
      "users";

  /// GET SINGLE USER
  static const String singleUser =
      "users/";

  /*
  |--------------------------------------------------------------------------
  | HEALTH TEAM APIs
  |--------------------------------------------------------------------------
  */

  /// MY HEALTH TEAM
  static const String myHealthTeam =
      "health-team/my-team";

  /// HOSPITALS
  static const String hospitals =
      "hospitals";

  /// DOCTORS
  static const String doctors =
      "doctors";

  /*
  |--------------------------------------------------------------------------
  | LOCATION APIs
  |--------------------------------------------------------------------------
  */

  /// UPDATE LOCATION
  static const String updateLocation =
      "location/update";

  /*
  |--------------------------------------------------------------------------
  | IMAGE URL
  |--------------------------------------------------------------------------
  */

  static const String storageUrl =
      "http://192.168.1.86:8000/storage/";

}