import 'package:flutter/material.dart';
import 'package:nirogisathi/app/di/injection.dart';
import '../../data/datasources/home_content_remote_datasource.dart';
import '../../domain/entities/home_content.dart';

class CurrentUpdatesCard extends StatefulWidget {
  const CurrentUpdatesCard({super.key});

  @override
  State<CurrentUpdatesCard> createState() => _CurrentUpdatesCardState();
}

class _CurrentUpdatesCardState extends State<CurrentUpdatesCard> {
  late Future<List<CurrentUpdateItem>> _future;

  static const List<CurrentUpdateItem> _fallback = [
    CurrentUpdateItem(
      id: -1,
      value: '20',
      label: 'Healthcare\nGivers',
      bgColor: 0xFFEFF6FF,
      textColor: 0xFF1D4ED8,
    ),
    CurrentUpdateItem(
      id: -2,
      value: '200',
      label: 'Clients\nServed',
      bgColor: 0xFFECFDF5,
      textColor: 0xFF15803D,
    ),
    CurrentUpdateItem(
      id: -3,
      value: '35',
      label: 'Doctors\nOnboard',
      bgColor: 0xFFF0FDFA,
      textColor: 0xFF0F766E,
    ),
    CurrentUpdateItem(
      id: -4,
      value: '5',
      label: 'Hospitals\nOnboard',
      bgColor: 0xFFFFF7ED,
      textColor: 0xFFC2410C,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<CurrentUpdateItem>> _load() async {
    try {
      final items = await getIt<HomeContentRemoteDataSource>().fetchCurrentUpdates();
      if (items.isEmpty) return _fallback;
      return items;
    } catch (e) {
      debugPrint('CurrentUpdatesCard API failed: $e');
      return _fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00456A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Current Updates',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryColor),
        ),
        const SizedBox(height: 15),
        FutureBuilder<List<CurrentUpdateItem>>(
          future: _future,
          builder: (context, snapshot) {
            final items = snapshot.data ?? _fallback;
            return Row(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(child: _buildUpdateItem(items[i])),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildUpdateItem(CurrentUpdateItem item) {
    final bgColor = Color(item.bgColor);
    final textColor = Color(item.textColor);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      height: 90,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.value,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 9,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
