import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_app_bar.dart';

class MedicinesScreen extends StatelessWidget {
  const MedicinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00456A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HealthLockerAppBar(
        title: "Medicines",
        actionLabel: "Add",
        onActionPressed: () => context.push('/health-locker/add-medicine'),
        secondaryAction: GestureDetector(
          onTap: () => context.push('/cart'),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Badge(
              label: Text("9+"),
              child: Icon(Icons.shopping_basket_outlined, color: Colors.red, size: 24),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade400, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search.......",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  suffixIcon: Icon(Icons.search, color: Colors.grey, size: 28),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Medicine List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                _buildMedicineItem(
                  context,
                  date: "01",
                  month: "NOV",
                  name: "Supradyn",
                  dose: "1 dose",
                  doctor: "Dr. Ankush Jian",
                  timing: "after meal at night",
                  imageUrl: "https://via.placeholder.com/100x120",
                ),
                _buildMedicineItem(
                  context,
                  date: "01",
                  month: "NOV",
                  name: "Multivitamin",
                  dose: "3 dose",
                  doctor: "Dr. Ankush Jian",
                  timing: "after meal",
                  imageUrl: "https://via.placeholder.com/100x120",
                ),
                _buildMedicineItem(
                  context,
                  date: "01",
                  month: "NOV",
                  name: "Maxvitamin-G",
                  dose: "2 dose",
                  doctor: "Dr. Ankush Jian",
                  timing: "before meal in morning",
                  imageUrl: "https://via.placeholder.com/100x120",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineItem(
    BuildContext context, {
    required String date,
    required String month,
    required String name,
    required String dose,
    required String doctor,
    required String timing,
    required String imageUrl,
  }) {
    const Color primaryColor = Color(0xFF00456A);

    return InkWell(
      onTap: () => context.push('/health-locker/medicine-detail'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Section
            Column(
              children: [
                Text(
                  date,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  month,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "NEW",
                    style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            // Info Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    dose,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    doctor,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    timing,
                    style: const TextStyle(
                      fontSize: 14,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Image and Reorder Button
            Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(imageUrl, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text(
                      "Reorder",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
