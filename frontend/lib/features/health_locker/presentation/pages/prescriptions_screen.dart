import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/health_locker_items.dart';
import '../providers/health_locker_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/health_locker_form_helpers.dart';

class PrescriptionsScreen extends StatefulWidget {
  const PrescriptionsScreen({super.key});

  @override
  State<PrescriptionsScreen> createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends State<PrescriptionsScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locker = context.watch<HealthLockerProvider>();
    final items = locker.prescriptions;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HealthLockerAppBar(
        title: 'Prescriptions',
        actionLabel: 'Add',
        onActionPressed: () => context.push('/health-locker/add-prescription'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),
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
                onChanged: locker.setPrescriptionQuery,
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
          const SizedBox(height: 20),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text(
                      'No prescriptions yet.\nTap Add to create one.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return InkWell(
                        onTap: () => context.push(
                          '/health-locker/prescription-detail',
                          extra: item,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        child: _PrescriptionCard(item: item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _PrescriptionCard extends StatelessWidget {
  final PrescriptionRecord item;

  const _PrescriptionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    const remarkColor = Color(0xFF2E6B8A);
    final parts = HealthLockerDateParts.from(item.date, item.createdAt);
    final thumb = item.imagePaths.isNotEmpty ? item.imagePaths.first : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 55,
            child: Column(
              children: [
                Text(parts.day, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.1)),
                Text(parts.month, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(4)),
                  child: const Text('NEW', style: TextStyle(color: Color(0xFF4CAF50), fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.purpose.isEmpty ? 'Prescription' : item.purpose,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: 'Remarks: ',
                    style: const TextStyle(color: remarkColor, fontSize: 14, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: item.remarks.isEmpty ? '—' : item.remarks,
                        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: healthLockerThumb(thumb),
          ),
        ],
      ),
    );
  }
}
