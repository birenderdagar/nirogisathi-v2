import 'package:equatable/equatable.dart';

class HealthProfessional extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final String imageUrl;
  final String rating;
  final String hospitalName;
  final bool isAvailable;

  const HealthProfessional({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.rating,
    required this.hospitalName,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [id, name, specialty, imageUrl, rating, hospitalName, isAvailable];
}
