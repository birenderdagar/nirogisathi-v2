import 'package:flutter/material.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../common/transaction_card.dart';
import 'invoice_button.dart';

class PaymentItem extends StatelessWidget {
  final TransactionEntity transaction;

  const PaymentItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TransactionCard(transaction: transaction),
        if (transaction.status == TransactionStatus.success)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: InvoiceButton(onPressed: () {}),
            ),
          ),
      ],
    );
  }
}
