import 'package:flutter/material.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../common/transaction_card.dart';

class VisitItem extends StatelessWidget {
  final TransactionEntity transaction;

  const VisitItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return TransactionCard(transaction: transaction);
  }
}
