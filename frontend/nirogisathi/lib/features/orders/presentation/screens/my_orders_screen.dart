import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/di/injection.dart';
import '../providers/order_provider.dart';
import '../../domain/entities/order_entity.dart';
import '../widgets/order_card.dart';
import '../widgets/order_status_tabs.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<OrderProvider>()..fetchOrders(OrderStatus.toReceive),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: const Color(0xFF00456A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "My Orders",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Consumer<OrderProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                // ✅ Modular Status Tabs Widget
                OrderStatusTabs(provider: provider),
                
                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator(color: Color(0xFF00456A)))
                      : provider.orders.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: provider.orders.length,
                              itemBuilder: (context, index) {
                                // ✅ Modular Order Card Widget
                                return OrderCard(order: provider.orders[index]);
                              },
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            "No orders found",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
