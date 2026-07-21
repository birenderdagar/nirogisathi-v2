import '../../domain/entities/cart_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.productName,
    required super.productInfo,
    required super.quantity,
    required super.price,
    required super.imageUrl,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      productName: json['productName'] as String,
      productInfo: json['productInfo'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'productInfo': productInfo,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
