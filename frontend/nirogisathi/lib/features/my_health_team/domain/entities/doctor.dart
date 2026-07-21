import 'package:equatable/equatable.dart';

class Doctor extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final String hospitalName;
  final String imageUrl;
  final String rating;
  final String hourlyRate;
  final bool isPreferred;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospitalName,
    required this.imageUrl,
    required this.rating,
    this.hourlyRate = '0',
    this.isPreferred = false,
  });

  @override
  List<Object?> get props => [id, name, specialty, hospitalName, imageUrl, rating, hourlyRate, isPreferred];
}
