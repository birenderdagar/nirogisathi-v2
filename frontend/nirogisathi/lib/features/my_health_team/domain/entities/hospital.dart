import 'package:equatable/equatable.dart';

class Hospital extends Equatable {
  final String id;
  final String name;
  final String address;
  final String imageUrl;
  final String beds;
  final String type; // e.g., Superspeciality Hospital
  final String distance;
  final String logoUrl;

  const Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.beds,
    required this.type,
    required this.distance,
    required this.logoUrl,
  });

  @override
  List<Object?> get props => [id, name, address, imageUrl, beds, type, distance, logoUrl];
}
