import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/order_entity.dart';
import 'order_tracking_screen.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF00456A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Status Banner
            _buildStatusBanner(),

            // 2. Customer & Address Section
            _buildAddressSection(primaryBlue),

            const Divider(thickness: 8, color: Color(0xFFF5F5F5)),

            // 3. Delivery Status Ribbon
            _buildDeliveryRibbon(context, primaryBlue),

            const Divider(thickness: 8, color: Color(0xFFF5F5F5)),

            // 4. Items in Order
            _buildItemsSection(primaryBlue),

            const Divider(thickness: 8, color: Color(0xFFF5F5F5)),

            // 5. Order Total Summary
            _buildTotalSection(primaryBlue),

            const Divider(thickness: 8, color: Color(0xFFF5F5F5)),

            // 6. Order Timings
            _buildOrderInfoSection(primaryBlue),

            const SizedBox(height: 100), // Space for bottom button
          ],
        ),
      ),
      bottomSheet: _buildBottomButton(primaryBlue),
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: const Color(0xFFFFFBE6), // Light yellow background for notice
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order ${order.id} delivered! ✨",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please ensure that the safety sticker is untouched.",
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.medication, size: 60, color: Color(0xFF00456A)),
        ],
      ),
    );
  }

  Widget _buildAddressSection(Color themeColor) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Birender Dagar",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  "H.No.616, Vpo Malikpur, New Delhi-73",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.location_on, color: themeColor, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryRibbon(BuildContext context, Color themeColor) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderTrackingScreen(orderId: order.id)),
        );
      },
      leading: const Icon(Icons.inventory_2_outlined, color: Colors.grey, size: 20),
      title: Text(
        order.estimatedArrival,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 14, color: themeColor),
    );
  }

  Widget _buildItemsSection(Color themeColor) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Items in order",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "${order.quantity} Item",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.network(order.imageUrl, fit: BoxFit.contain),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.productName,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(order.productInfo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(width: 8),
                        Text("|  ₹${order.price} /-", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: themeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text("x${order.quantity}", style: TextStyle(color: themeColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        const Spacer(),
                        Text("₹${order.price} /-", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildActionButton(Icons.assignment_outlined, "Instructions for Use", themeColor),
          const SizedBox(height: 12),
          _buildActionButton(Icons.description_outlined, "Download Invoice", themeColor),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color themeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: themeColor.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: themeColor),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: themeColor, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTotalSection(Color themeColor) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Order Total", style: TextStyle(fontSize: 16, color: Colors.black87)),
          Row(
            children: [
              Text(
                "₹${order.price} /-",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: themeColor),
              ),
              const SizedBox(width: 8),
              Icon(Icons.keyboard_arrow_down, color: themeColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfoSection(Color themeColor) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInfoRow("Order ID", order.id, themeColor, isCopyable: true),
          _buildInfoRow("Order Time", "16.07.2022, 19:43", themeColor),
          _buildInfoRow("Payment Time", "16.07.2022, 19:47", themeColor),
          _buildInfoRow("Ship Time", "16.07.2022, 20:47", themeColor),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color themeColor, {bool isCopyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 14)),
          Row(
            children: [
              Text(value, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500)),
              if (isCopyable) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                  },
                  child: Text("Copy", style: TextStyle(color: themeColor, fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(Color themeColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: themeColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            "BUY AGAIN",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
