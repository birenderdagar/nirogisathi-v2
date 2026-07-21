import 'package:equatable/equatable.dart';

enum PlannerEventType { appointment, event, schedule }

class PlannerEvent extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final PlannerEventType type;

  const PlannerEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.type,
  });

  @override
  List<Object?> get props => [id, title, description, date, time, type];
}
