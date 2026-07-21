import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF00456A);

    // Dummy Data
    final List<NotificationEntity> notifications = [
      NotificationEntity(
        id: "1",
        title: "Appointment Confirmed",
        message: "Your appointment with Dr. Vidhi is confirmed for tomorrow at 10:30 AM.",
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        type: NotificationType.appointment,
      ),
      NotificationEntity(
        id: "2",
        title: "Order Shipped",
        message: "Your pharmacy order #1024 has been shipped and will arrive in 40 mins.",
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: true,
        type: NotificationType.order,
      ),
      NotificationEntity(
        id: "3",
        title: "New Health Tip",
        message: "Stay hydrated! Drink at least 8 glasses of water today to keep your energy up.",
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        type: NotificationType.general,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            leading: CircleAvatar(
              backgroundColor: _getIconColor(item.type).withOpacity(0.1),
              child: Icon(_getIcon(item.type), color: _getIconColor(item.type), size: 20),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (!item.isRead)
                  const CircleAvatar(radius: 4, backgroundColor: Colors.orange),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  item.message,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('hh:mm a, dd MMM').format(item.timestamp),
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.appointment: return Icons.calendar_today;
      case NotificationType.order: return Icons.local_shipping_outlined;
      default: return Icons.notifications_none;
    }
  }

  Color _getIconColor(NotificationType type) {
    switch (type) {
      case NotificationType.appointment: return Colors.blue;
      case NotificationType.order: return Colors.green;
      default: return const Color(0xFF00456A);
    }
  }
}
