import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nirogisathi/features/cart/domain/entities/cart_entity.dart';
import 'package:nirogisathi/features/cart/presentation/providers/cart_provider.dart';
import '../../domain/entities/health_locker_items.dart';
import '../providers/health_locker_provider.dart';
import '../widgets/custom_app_bar.dart';

class MedicineDetailScreen extends StatelessWidget {
  final MedicineRecord item;
  const MedicineDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF00456A);
    final live = context.watch<HealthLockerProvider>().medicineById(item.id) ?? item;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HealthLockerAppBar(title: 'Medicine'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.grey.shade300)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(live.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                  IconButton(onPressed: () => context.push('/health-locker/add-medicine', extra: live), icon: const Icon(Icons.edit_outlined, color: primaryColor)),
                  IconButton(
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete medicine?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                          ],
                        ),
                      );
                      if (ok != true || !context.mounted) return;
                      await context.read<HealthLockerProvider>().deleteMedicine(live.id);
                      if (context.mounted) context.pop();
                    },
                    icon: const Icon(Icons.delete_outline, color: primaryColor),
                  ),
                ],
              ),
              _row('Dose', live.dose),
              _row('Doctor', live.doctorName),
              _row('Purpose', live.purpose),
              _row('Instructions', live.instructions),
              _row('Remarks', live.remarks),
              _row('Date', live.date),
              _row('Time', live.time),
              if (live.imagePaths.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  children: live.imagePaths
                      .map((p) => ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(File(p), width: 90, height: 110, fit: BoxFit.cover)))
                      .toList(),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CartProvider>().addItem(
                          CartItemEntity(
                            id: 'med-${live.id}',
                            productName: live.name,
                            productInfo: live.dose.isEmpty ? '1 pack' : live.dose,
                            quantity: 1,
                            price: 0,
                            imageUrl: live.imagePaths.isNotEmpty
                                ? live.imagePaths.first
                                : 'https://cdn-icons-png.flaticon.com/512/822/822143.png',
                          ),
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${live.name} added to cart'),
                        action: SnackBarAction(label: 'VIEW CART', onPressed: () => context.push('/cart')),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
                  child: const Text('Reorder'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600))),
          Expanded(child: Text(value.isEmpty ? '—' : value)),
        ],
      ),
    );
  }
}
