import 'package:flutter/material.dart';
import '../../../domain/entities/transaction_entity.dart';
import 'appointment_item.dart';

class AppointmentsTab extends StatelessWidget {
  final List<TransactionEntity> transactions;

  const AppointmentsTab({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final appointments = transactions.where((e) => e.category == "appointment").toList();

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return AppointmentItem(transaction: appointments[index]);
      },
    );
  }
}
