import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.productName,
    required super.productInfo,
    required super.quantity,
    required super.price,
    required super.imageUrl,
    required super.status,
    required super.estimatedArrival,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      productName: json['productName'] as String,
      productInfo: json['productInfo'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      status: _mapStatus(json['status'] as String),
      estimatedArrival: json['estimatedArrival'] as String,
    );
  }

  static OrderStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'toreceive': return OrderStatus.toReceive;
      case 'completed': return OrderStatus.completed;
      case 'cancelled': return OrderStatus.cancelled;
      default: return OrderStatus.toReceive;
    }
  }
}
