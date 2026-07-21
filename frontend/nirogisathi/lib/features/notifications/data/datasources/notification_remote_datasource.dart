import '../../domain/entities/notification_entity.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      NotificationModel(
        id: "1",
        title: "Appointment Confirmed",
        message: "Your appointment with Dr. Vidhi is confirmed for tomorrow at 10:30 AM.",
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        type: NotificationType.appointment,
      ),
      NotificationModel(
        id: "2",
        title: "Order Shipped",
        message: "Your pharmacy order #1024 has been shipped and will arrive in 40 mins.",
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: true,
        type: NotificationType.order,
      ),
      NotificationModel(
        id: "3",
        title: "New Health Tip",
        message: "Stay hydrated! Drink at least 8 glasses of water today to keep your energy up.",
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        type: NotificationType.general,
      ),
    ];
  }
}
