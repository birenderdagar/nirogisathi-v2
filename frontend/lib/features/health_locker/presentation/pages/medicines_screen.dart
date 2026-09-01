import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nirogisathi/features/cart/domain/entities/cart_entity.dart';
import 'package:nirogisathi/features/cart/presentation/providers/cart_provider.dart';
import '../../domain/entities/health_locker_items.dart';
import '../providers/health_locker_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/health_locker_form_helpers.dart';

class MedicinesScreen extends StatefulWidget {
  const MedicinesScreen({super.key});

  @override
  State<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends State<MedicinesScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _reorder(MedicineRecord medicine) {
    context.read<CartProvider>().addItem(
          CartItemEntity(
            id: 'med-${medicine.id}',
            productName: medicine.name,
            productInfo: medicine.dose.isEmpty ? '1 pack' : medicine.dose,
            quantity: 1,
            price: 0,
            imageUrl: medicine.imagePaths.isNotEmpty
                ? medicine.imagePaths.first
                : 'https://cdn-icons-png.flaticon.com/512/822/822143.png',
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medicine.name} added to cart'),
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () => context.push('/cart'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF00456A);
    final locker = context.watch<HealthLockerProvider>();
    final cartCount = context.watch<CartProvider>().itemCount;
    final items = locker.medicines;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HealthLockerAppBar(
        title: 'Medicines',
        actionLabel: 'Add',
        onActionPressed: () => context.push('/health-locker/add-medicine'),
        secondaryAction: GestureDetector(
          onTap: () => context.push('/cart'),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_basket_outlined, color: Colors.red, size: 24),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade400, width: 1.2),
              ),
              child: TextField(
                controller: _search,
                onChanged: locker.setMedicineQuery,
                decoration: const InputDecoration(
                  hintText: 'Search.......',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  suffixIcon: Icon(Icons.search, color: Colors.grey, size: 28),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('No medicines yet.\nTap Add to create one.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final medicine = items[index];
                      final parts = HealthLockerDateParts.from(medicine.date, medicine.createdAt);
                      return InkWell(
                        onTap: () => context.push('/health-locker/medicine-detail', extra: medicine),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(parts.day, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                  Text(parts.month, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(medicine.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    Text(medicine.dose.isEmpty ? '—' : medicine.dose, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                                    Text(medicine.doctorName.isEmpty ? '—' : medicine.doctorName, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                                    const SizedBox(height: 8),
                                    Text(
                                      medicine.instructions.isEmpty ? medicine.purpose : medicine.instructions,
                                      style: const TextStyle(fontSize: 14, color: primaryColor, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: healthLockerThumb(
                                      medicine.imagePaths.isEmpty ? null : medicine.imagePaths.first,
                                      width: 70,
                                      height: 70,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 30,
                                    child: ElevatedButton(
                                      onPressed: () => _reorder(medicine),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                      ),
                                      child: const Text('Reorder', style: TextStyle(fontSize: 12, color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
