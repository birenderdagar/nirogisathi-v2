import 'package:flutter/foundation.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/get_orders_usecase.dart';

class OrderProvider extends ChangeNotifier {
  final GetOrdersUseCase getOrdersUseCase;

  OrderProvider(this.getOrdersUseCase);

  List<OrderEntity> _orders = [];
  List<OrderEntity> get orders => _orders;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  OrderStatus _currentStatus = OrderStatus.toReceive;
  OrderStatus get currentStatus => _currentStatus;

  Future<void> fetchOrders(OrderStatus status) async {
    _isLoading = true;
    _currentStatus = status;
    notifyListeners();

    final result = await getOrdersUseCase(status);

    result.fold(
      (failure) {
        _orders = [];
        _isLoading = false;
        notifyListeners();
      },
      (list) {
        _orders = list;
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
