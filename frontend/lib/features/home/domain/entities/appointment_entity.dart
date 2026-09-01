import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final DateTime date;
  final String time;

  const AppointmentEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.time,
  });

  @override
  List<Object?> get props => [id, title, subtitle, date, time];
}
