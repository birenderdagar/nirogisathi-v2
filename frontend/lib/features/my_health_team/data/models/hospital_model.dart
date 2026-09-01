import '../../domain/entities/hospital.dart';

class HospitalModel extends Hospital {
  const HospitalModel({
    required super.id,
    required super.name,
    required super.address,
    required super.imageUrl,
    required super.beds,
    required super.type,
    required super.distance,
    required super.logoUrl,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      beds: json['beds'] ?? '',
      type: json['type'] ?? '',
      distance: json['distance'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'imageUrl': imageUrl,
      'beds': beds,
      'type': type,
      'distance': distance,
      'logoUrl': logoUrl,
    };
  }
}
