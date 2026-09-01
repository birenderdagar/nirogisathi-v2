import 'package:flutter/material.dart';
import '../../../domain/entities/transaction_entity.dart';
import 'payment_item.dart';

class PaymentsTab extends StatelessWidget {
  final List<TransactionEntity> transactions;

  const PaymentsTab({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // Correct category is "payment"
    final payments = transactions.where((e) => e.category == "payment").toList();

    if (payments.isEmpty) {
      return const Center(child: Text("No payments found"));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: payments.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return PaymentItem(transaction: payments[index]);
      },
    );
  }
}
