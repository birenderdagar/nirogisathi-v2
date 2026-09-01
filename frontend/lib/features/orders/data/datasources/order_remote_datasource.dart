import '../models/order_model.dart';
import '../../domain/entities/order_entity.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders(OrderStatus status);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  @override
  Future<List<OrderModel>> getOrders(OrderStatus status) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (status == OrderStatus.toReceive) {
      return [
        const OrderModel(
          id: "ORD001",
          productName: "Gaviscon Dual Kautabletten 48 ST",
          productInfo: "48pcs",
          quantity: 1,
          price: 18.45,
          imageUrl: "https://cdn-icons-png.flaticon.com/512/822/822143.png",
          status: OrderStatus.toReceive,
          estimatedArrival: "40-50 min",
        )
      ];
    } else if (status == OrderStatus.completed) {
      return [
        const OrderModel(
          id: "M2Z4-VVY2",
          productName: "Nurofen Junior Fiebersaft Erbeer 40...",
          productInfo: "150ml",
          quantity: 1,
          price: 11.80,
          imageUrl: "https://cdn-icons-png.flaticon.com/512/822/822143.png",
          status: OrderStatus.completed,
          estimatedArrival: "Delivered on 16.07.2022, 20:53",
        ),
        const OrderModel(
          id: "VSLR-29BA",
          productName: "Paracetamol-Ratiopharm 500mg Ta...",
          productInfo: "10pcs",
          quantity: 5,
          price: 9.75,
          imageUrl: "https://cdn-icons-png.flaticon.com/512/822/822143.png",
          status: OrderStatus.completed,
          estimatedArrival: "Delivered on 29.06.2022, 15:18",
        ),
        const OrderModel(
          id: "VC6J-2DHX",
          productName: "Kamillosan Konzentrat 30 ML",
          productInfo: "100ml",
          quantity: 2,
          price: 13.94,
          imageUrl: "https://cdn-icons-png.flaticon.com/512/822/822143.png",
          status: OrderStatus.completed,
          estimatedArrival: "Delivered on 28.06.2022, 12:57",
        ),
      ];
    } else if (status == OrderStatus.cancelled) {
      return [
        const OrderModel(
          id: "CNCL-9912",
          productName: "Aspirin Complex 20 ST",
          productInfo: "20pcs",
          quantity: 1,
          price: 12.50,
          imageUrl: "https://cdn-icons-png.flaticon.com/512/822/822143.png",
          status: OrderStatus.cancelled,
          estimatedArrival: "Cancelled on 10.07.2022",
        ),
      ];
    }
    return [];
  }
}
