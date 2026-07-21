import 'package:equatable/equatable.dart';

enum OrderStatus { toReceive, completed, cancelled }

class OrderEntity extends Equatable {
  final String id;
  final String productName;
  final String productInfo; // e.g., 48pcs
  final int quantity;
  final double price;
  final String imageUrl;
  final OrderStatus status;
  final String estimatedArrival;

  const OrderEntity({
    required this.id,
    required this.productName,
    required this.productInfo,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    required this.status,
    required this.estimatedArrival,
  });

  @override
  List<Object?> get props => [id, productName, productInfo, quantity, price, imageUrl, status, estimatedArrival];
}
