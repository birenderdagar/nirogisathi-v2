import 'package:flutter/material.dart';

class CurrentUpdatesCard extends StatelessWidget {
  const CurrentUpdatesCard({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00456A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Current Updates",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryColor),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(child: _buildUpdateItem("20", "Healthcare\nGivers", Colors.blue.shade50, Colors.blue.shade700)),
            const SizedBox(width: 8),
            Expanded(child: _buildUpdateItem("200", "Clients\nServed", Colors.green.shade50, Colors.green.shade700)),
            const SizedBox(width: 8),
            Expanded(child: _buildUpdateItem("35", "Doctors\nOnboard", Colors.teal.shade50, Colors.teal.shade700)),
            const SizedBox(width: 8),
            Expanded(child: _buildUpdateItem("5", "Hospitals\nOnboard", Colors.orange.shade50, Colors.orange.shade700)),
          ],
        )
      ],
    );
  }

  Widget _buildUpdateItem(String value, String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      height: 90,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor, fontSize: 9, fontWeight: FontWeight.w500, height: 1.2),
          ),
        ],
      ),
    );
  }
}
