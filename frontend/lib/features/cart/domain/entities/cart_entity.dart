import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String id;
  final String productName;
  final String productInfo;
  final int quantity;
  final double price;
  final String imageUrl;

  const CartItemEntity({
    required this.id,
    required this.productName,
    required this.productInfo,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, productName, productInfo, quantity, price, imageUrl];
}
