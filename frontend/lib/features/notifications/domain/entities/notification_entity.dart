import 'package:equatable/equatable.dart';

enum NotificationType { appointment, order, promo, general }

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final NotificationType type;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.type,
  });

  @override
  List<Object?> get props => [id, title, message, timestamp, isRead, type];
}
