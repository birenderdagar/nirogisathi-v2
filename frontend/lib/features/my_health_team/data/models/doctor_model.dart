import '../../domain/entities/doctor.dart';

class DoctorModel extends Doctor {
  const DoctorModel({
    required super.id,
    required super.name,
    required super.specialty,
    required super.hospitalName,
    required super.imageUrl,
    required super.rating,
    super.hourlyRate,
    super.isPreferred,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      hospitalName: json['hospitalName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: json['rating']?.toString() ?? '0.0',
      hourlyRate: json['hourlyRate']?.toString() ?? '0',
      isPreferred: json['isPreferred'] ?? false,
    );
  }
}
