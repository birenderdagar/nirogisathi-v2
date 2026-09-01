import 'dart:convert';
import '../../../../core/storage/local_storage_service.dart';
import '../models/user_model.dart';
import '../../domain/entities/user.dart';

class SessionLocalDataSource {
  final LocalStorageService storage;

  SessionLocalDataSource(this.storage);

  static const String _keyUser = "cached_user";

  Future<void> cacheUid(String uid) async {
    await storage.saveUid(uid);
  }

  String? getUid() {
    return storage.getUid();
  }

  /// ✅ Cache full user model
  Future<void> saveUser(UserModel user) async {
    await storage.prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  /// ✅ Retrieve cached user
  User? getUser() {
    final data = storage.prefs.getString(_keyUser);
    if (data == null) return null;
    try {
       return UserModel.fromJson(jsonDecode(data)).toEntity();
    } catch (e) {
       return null;
    }
  }

  Future<void> clearSession() async {
    await storage.clear();
    await storage.prefs.remove(_keyUser);
  }
}
