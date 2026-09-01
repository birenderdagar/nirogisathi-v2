import '../../domain/entities/user.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/constants/api_constants.dart';

class UserModel {
  final String uid;
  final String name;
  final String mobile;
  final String email;
  final String mpin;
  final String? photo;
  final String? dob;
  final String? gender;
  final String? bloodGroup;
  final String? weight;
  final String? height;
  final bool isProfileComplete;
  final String role;

  const UserModel({
    required this.uid,
    required this.name,
    required this.mobile,
    required this.email,
    required this.mpin,
    this.photo,
    this.dob,
    this.gender,
    this.bloodGroup,
    this.weight,
    this.height,
    required this.isProfileComplete,
    required this.role,
  });

  /// 🔄 Backend/Firestore → Model
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse bool from various types (bool, int, string)
    bool parseBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) return value == "1" || value.toLowerCase() == "true";
      return false;
    }

    return UserModel(
      uid: (json['uid'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? json['full_name'] ?? '').toString(),
      mobile: (json['mobile'] ?? json['phone'] ?? json['mobile_number'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      mpin: (json['mpin'] ?? '').toString(),
      photo: json['photo_url'] as String? ?? json['photo'] as String? ?? json['profile_image'] as String? ?? json['profile_photo_url'] as String?,
      dob: json['dob'] as String? ?? json['date_of_birth'] as String?,
      gender: json['gender'] as String?,
      bloodGroup: json['blood_group'] as String? ?? json['bloodGroup'] as String? ?? json['blood_type'] as String?,
      weight: (json['weight'] ?? json['body_weight'] ?? '').toString(),
      height: (json['height'] ?? json['body_height'] ?? '').toString(),
      isProfileComplete: parseBool(json['isProfileComplete'] ?? json['is_profile_complete'] ?? json['profile_completed']),
      role: json['role'] as String? ?? 'user',
    );
  }

  /// 🔄 Model → Backend
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'mobile': mobile,
      'email': email,
      'mpin': mpin,
      'photo': photo,
      'dob': dob,
      'gender': gender,
      'blood_group': bloodGroup,
      'weight': weight,
      'height': height,
      'isProfileComplete': isProfileComplete,
      'role': role,
    };
  }

  /// 🔥 Model → Entity
  User toEntity() {
    // Construct full photo URL if it's a relative path from Laravel storage
    String? fullPhotoUrl = photo;
    
    if (fullPhotoUrl != null && fullPhotoUrl.isNotEmpty) {
      if (fullPhotoUrl.startsWith('http')) {
        // Already a full URL (Prioritized from photo_url)
      } else if (fullPhotoUrl.startsWith('/') || 
                 fullPhotoUrl.contains('data/user/0') || 
                 fullPhotoUrl.contains('cache')) {
        // ✅ It's a local file path, keep it as is for FileImage to use
      } else {
        // Derive storage base URL from ApiConstants.baseUrl
        final String baseUrl = ApiConstants.baseUrl.split('/api').first;
        // Handle leading slash in relative path
        final String cleanPath = fullPhotoUrl.startsWith('/') ? fullPhotoUrl.substring(1) : fullPhotoUrl;
        fullPhotoUrl = "$baseUrl/storage/$cleanPath";
      }
    }

    return User(
      id: uid,
      name: name,
      mobile: mobile,
      email: email,
      photoUrl: fullPhotoUrl,
      dob: dob,
      gender: gender,
      bloodGroup: bloodGroup,
      weight: weight,
      height: height,
      isProfileComplete: isProfileComplete,
      role: _mapRole(role),
    );
  }

  UserRole _mapRole(String role) {
    switch (role) {
      case 'doctor':
        return UserRole.doctor;
      case 'healthAssistant':
      case 'assistant':
        return UserRole.healthAssistant;
      case 'admin':
        return UserRole.admin;
      case 'user':
      default:
        return UserRole.user;
    }
  }
}
