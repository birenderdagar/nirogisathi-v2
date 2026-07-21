import 'package:flutter/material.dart';
import 'package:nirogisathi/features/orders/domain/entities/order_entity.dart';
import 'package:nirogisathi/features/orders/presentation/providers/order_provider.dart';

class OrderStatusTabs extends StatelessWidget {
  final OrderProvider provider;

  const OrderStatusTabs({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTabItem("TO RECEIVE", OrderStatus.toReceive),
          _buildTabItem("COMPLETED", OrderStatus.completed),
          _buildTabItem("CANCELLED", OrderStatus.cancelled),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, OrderStatus status) {
    final isSelected = provider.currentStatus == status;
    const Color primaryBlue = Color(0xFF00456A);

    return GestureDetector(
      onTap: () => provider.fetchOrders(status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
