import 'package:flutter/material.dart';

class OtherServicesList extends StatelessWidget {
  const OtherServicesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Other Services", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            TextButton(onPressed: () {}, child: const Text("See All")),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildServiceItem("Medical Equipment", Icons.medical_services_outlined),
              _buildServiceItem("Hospital visit", Icons.apartment_outlined),
              _buildServiceItem("Dressing", Icons.healing_outlined),
              _buildServiceItem("Ambulance", Icons.local_shipping_outlined), // ✅ Changed to available icon
            ],
          ),
        )
      ],
    );
  }

  Widget _buildServiceItem(String label, IconData icon) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5),
              ],
            ),
            child: Icon(icon, color: const Color(0xFF00456A), size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
