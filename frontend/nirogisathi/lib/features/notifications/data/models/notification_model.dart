import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.timestamp,
    required super.isRead,
    required super.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      type: _mapType(json['type'] as String),
    );
  }

  static NotificationType _mapType(String type) {
    switch (type.toLowerCase()) {
      case 'appointment': return NotificationType.appointment;
      case 'order': return NotificationType.order;
      case 'promo': return NotificationType.promo;
      default: return NotificationType.general;
    }
  }
}
