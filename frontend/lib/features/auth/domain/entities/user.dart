import '../../../../core/enums/user_role.dart';

class User {
  final String id;
  final String name;
  final String mobile;
  final String? email;
  final String? photoUrl;
  final String? dob;
  final String? gender;
  final String? bloodGroup;
  final String? weight;
  final String? height;
  final bool isProfileComplete;
  final UserRole role;

  const User({
    required this.id,
    required this.name,
    required this.mobile,
    this.email,
    this.photoUrl,
    this.dob,
    this.gender,
    this.bloodGroup,
    this.weight,
    this.height,
    required this.isProfileComplete,
    required this.role,
  });

  double get profileCompletion {
    int totalFields = 8; // Name, Email, Photo, DOB, Gender, BloodGroup, Weight, Height
    int filledFields = 0;

    if (name.isNotEmpty) filledFields++;
    if (email != null && email!.isNotEmpty) filledFields++;
    if (photoUrl != null && photoUrl!.isNotEmpty) filledFields++;
    if (dob != null && dob!.isNotEmpty && dob != 'N/A') filledFields++;
    if (gender != null && gender!.isNotEmpty) filledFields++;
    if (bloodGroup != null && bloodGroup!.isNotEmpty) filledFields++;
    if (weight != null && weight!.isNotEmpty && weight != 'N/A') filledFields++;
    if (height != null && height!.isNotEmpty && height != 'N/A') filledFields++;

    return filledFields / totalFields;
  }
}
