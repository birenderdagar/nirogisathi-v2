import 'package:flutter/material.dart';

class InvoiceButton extends StatelessWidget {
  final VoidCallback onPressed;

  const InvoiceButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.download_outlined, size: 14),
      label: const Text("Invoice", style: TextStyle(fontSize: 12)),
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF00456A),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
