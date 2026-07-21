import 'package:flutter/foundation.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_notifications_usecase.dart';

class NotificationProvider extends ChangeNotifier {
  final GetNotificationsUseCase getNotificationsUseCase;

  NotificationProvider(this.getNotificationsUseCase);

  List<NotificationEntity> _notifications = [];
  List<NotificationEntity> get notifications => _notifications;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();

    final result = await getNotificationsUseCase();

    result.fold(
      (failure) {
        _isLoading = false;
        notifyListeners();
      },
      (list) {
        _notifications = list;
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
