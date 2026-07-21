import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences prefs;

  LocalStorageService(this.prefs);

  static const String _keyUid = "uid";
  static const String _keyToken = "auth_token";

  /// Save user session UID
  Future<void> saveUid(String uid) async {
    await prefs.setString(_keyUid, uid);
  }

  /// Get saved UID (session restore)
  String? getUid() {
    return prefs.getString(_keyUid);
  }

  /// Save Auth Token from Laravel
  Future<void> saveToken(String token) async {
    await prefs.setString(_keyToken, token);
  }

  /// Get Auth Token
  String? getToken() {
    return prefs.getString(_keyToken);
  }

  /// Clear session (logout)
  Future<void> clear() async {
    await prefs.remove(_keyUid);
    await prefs.remove(_keyToken);
  }
}
