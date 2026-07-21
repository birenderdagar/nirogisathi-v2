import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserFirestoreDataSource {
  final FirebaseFirestore firestore;

  UserFirestoreDataSource(this.firestore);

  /// 🔍 Get user by mobile (login flow)
  Future<UserModel?> getUserByMobile(String mobile) async {
    final result = await firestore
        .collection('users')
        .where('mobile', isEqualTo: mobile)
        .limit(1)
        .get();

    if (result.docs.isEmpty) return null;

    return UserModel.fromJson(result.docs.first.data());
  }

  /// 👤 Get user by UID (session restore / splash flow)
  Future<UserModel?> getUserByUid(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();

    if (!doc.exists || doc.data() == null) return null;

    return UserModel.fromJson(doc.data()!);
  }

  /// 🧾 Create new user profile
  Future<void> createUser(UserModel user) async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .set(user.toJson());
  }
}