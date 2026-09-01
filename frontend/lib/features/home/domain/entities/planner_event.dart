import 'package:equatable/equatable.dart';

enum PlannerEventType { appointment, event, schedule }

class PlannerEvent extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final PlannerEventType type;
  final bool reminderEnabled;

  const PlannerEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.type,
    this.reminderEnabled = false,
  });

  PlannerEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? time,
    PlannerEventType? type,
    bool? reminderEnabled,
  }) {
    return PlannerEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      type: type ?? this.type,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    );
  }

  factory PlannerEvent.fromJson(Map<String, dynamic> json) {
    return PlannerEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String? ?? '',
      type: PlannerEventType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PlannerEventType.event,
      ),
      reminderEnabled: json['reminderEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
        'time': time,
        'type': type.name,
        'reminderEnabled': reminderEnabled,
      };

  @override
  List<Object?> get props =>
      [id, title, description, date, time, type, reminderEnabled];
}
