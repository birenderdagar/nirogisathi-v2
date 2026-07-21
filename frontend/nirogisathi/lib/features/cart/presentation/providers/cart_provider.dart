import 'package:flutter/foundation.dart';
import '../../domain/entities/cart_entity.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemEntity> _items = [
    const CartItemEntity(
      id: "1",
      productName: "Gaviscon Dual Kautabletten",
      productInfo: "48 ST | 150ml",
      quantity: 1,
      price: 18.45,
      imageUrl: "https://cdn-icons-png.flaticon.com/512/822/822143.png",
    ),
    const CartItemEntity(
      id: "2",
      productName: "Paracetamol 500mg",
      productInfo: "20 Tablets",
      quantity: 2,
      price: 9.75,
      imageUrl: "https://cdn-icons-png.flaticon.com/512/822/822143.png",
    ),
  ];

  List<CartItemEntity> get items => List.unmodifiable(_items);

  double get totalPrice => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void incrementQuantity(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = _items[index];
      _items[index] = CartItemEntity(
        id: item.id,
        productName: item.productName,
        productInfo: item.productInfo,
        quantity: item.quantity + 1,
        price: item.price,
        imageUrl: item.imageUrl,
      );
      notifyListeners();
    }
  }

  void decrementQuantity(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = _items[index];
      if (item.quantity > 1) {
        _items[index] = CartItemEntity(
          id: item.id,
          productName: item.productName,
          productInfo: item.productInfo,
          quantity: item.quantity - 1,
          price: item.price,
          imageUrl: item.imageUrl,
        );
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
