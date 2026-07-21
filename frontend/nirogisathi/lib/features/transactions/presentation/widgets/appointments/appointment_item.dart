import 'package:flutter/material.dart';
import '../../../domain/entities/transaction_entity.dart';

class AppointmentItem extends StatelessWidget {
  final TransactionEntity transaction;

  const AppointmentItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildBadge(
                icon: Icons.access_time,
                text: "placed on ${transaction.placedTime ?? '--:--'}",
                color: Colors.red.shade50,
                textColor: Colors.red.shade400,
              ),
              const SizedBox(width: 8),
              _buildBadge(
                text: transaction.statusTime ?? "pending",
                color: _getStatusBgColor(),
                textColor: _getStatusTextColor(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.person_outline, transaction.doctorName ?? "N/A"),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.phone_outlined, transaction.phoneNumber ?? "N/A"),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.location_on_outlined, transaction.location ?? "N/A"),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF26A69A)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "View Details",
                style: TextStyle(color: Color(0xFF26A69A), fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({IconData? icon, required String text, required Color color, required Color textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Color _getStatusBgColor() {
    switch (transaction.status) {
      case TransactionStatus.confirmed: return Colors.green.shade50;
      case TransactionStatus.missed: return Colors.red.shade50;
      default: return Colors.red.shade50;
    }
  }

  Color _getStatusTextColor() {
    switch (transaction.status) {
      case TransactionStatus.confirmed: return Colors.green.shade400;
      case TransactionStatus.missed: return Colors.red.shade400;
      default: return Colors.red.shade400;
    }
  }
}
