import '../../domain/entities/health_professional.dart';

class HealthProfessionalModel extends HealthProfessional {
  const HealthProfessionalModel({
    required super.id,
    required super.name,
    required super.specialty,
    required super.imageUrl,
    required super.rating,
    required super.hospitalName,
    required super.isAvailable,
  });

  factory HealthProfessionalModel.fromJson(Map<String, dynamic> json) {
    return HealthProfessionalModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: json['rating']?.toString() ?? '0.0',
      hospitalName: json['hospitalName'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'imageUrl': imageUrl,
      'rating': rating,
      'hospitalName': hospitalName,
      'isAvailable': isAvailable,
    };
  }
}
