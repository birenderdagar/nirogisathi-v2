import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/health_locker_items.dart';
import '../providers/health_locker_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/health_locker_form_helpers.dart';

class DiagnosticsScreen extends StatefulWidget {
  const DiagnosticsScreen({super.key});

  @override
  State<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends State<DiagnosticsScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locker = context.watch<HealthLockerProvider>();
    final items = locker.diagnostics;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HealthLockerAppBar(
        title: 'X-Ray / Diagnostic',
        actionLabel: 'Add',
        onActionPressed: () => context.push('/health-locker/add-diagnostic'),
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
                onChanged: locker.setDiagnosticQuery,
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
                ? const Center(child: Text('No diagnostic reports yet.\nTap Add to create one.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final parts = HealthLockerDateParts.from(item.date, item.createdAt);
                      return InkWell(
                        onTap: () => context.push('/health-locker/diagnostic-detail', extra: item),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 55,
                                child: Column(children: [
                                  Text(parts.day, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                                  Text(parts.month, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                ]),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    Text(item.reportType.isEmpty ? 'Diagnostic' : item.reportType, style: const TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: healthLockerThumb(item.imagePaths.isEmpty ? null : item.imagePaths.first),
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
