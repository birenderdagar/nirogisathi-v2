import 'package:flutter/material.dart';
import '../../../domain/entities/transaction_entity.dart';
import 'visit_item.dart';

class OthersTab extends StatelessWidget {
  final List<TransactionEntity> transactions;

  const OthersTab({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final others = transactions.where((e) => e.category == "visit").toList();

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: others.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return VisitItem(transaction: others[index]);
      },
    );
  }
}
