import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/health_locker_items.dart';
import '../providers/health_locker_provider.dart';
import '../widgets/custom_app_bar.dart';

class PrescriptionDetailScreen extends StatelessWidget {
  final PrescriptionRecord item;

  const PrescriptionDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF00456A);
    final live = context.watch<HealthLockerProvider>().prescriptionById(item.id) ?? item;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HealthLockerAppBar(title: 'Prescription'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.grey.shade300, width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      live.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _action(Icons.edit_outlined, primaryColor, () {
                    context.push('/health-locker/add-prescription', extra: live);
                  }),
                  const SizedBox(width: 10),
                  _action(Icons.delete_outline, primaryColor, () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete prescription?'),
                        content: const Text('This cannot be undone.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                        ],
                      ),
                    );
                    if (ok != true || !context.mounted) return;
                    await context.read<HealthLockerProvider>().deletePrescription(live.id);
                    if (!context.mounted) return;
                    context.pop();
                  }),
                ],
              ),
              const SizedBox(height: 25),
              const Text('Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _row('Purpose', live.purpose),
              _row('Remarks', live.remarks),
              _row('Clinical notes', live.clinicalNotes),
              _row('Date', live.date),
              _row('Time', live.time),
              if (live.imagePaths.isNotEmpty) ...[
                const SizedBox(height: 25),
                const Text('Photos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: live.imagePaths
                      .map(
                        (p) => ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(File(p), width: 90, height: 110, fit: BoxFit.cover),
                        ),
                      )
                      .toList(),
                ),
              ],
              if (live.investigation.isNotEmpty) ...[
                const SizedBox(height: 25),
                const Text('Investigation advised', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('• ${live.investigation}'),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _action(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value.isEmpty ? '—' : value)),
        ],
      ),
    );
  }
}
