import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nirogisathi/app/di/injection.dart';
import 'package:nirogisathi/features/home/data/datasources/user_subscription_remote_datasource.dart';
import 'package:nirogisathi/features/home/domain/entities/user_subscription.dart';

class MySubscriptionPage extends StatefulWidget {
  const MySubscriptionPage({super.key});

  @override
  State<MySubscriptionPage> createState() => _MySubscriptionPageState();
}

class _MySubscriptionPageState extends State<MySubscriptionPage> {
  late Future<UserSubscriptionStatus> _future;

  @override
  void initState() {
    super.initState();
    _future = getIt<UserSubscriptionRemoteDataSource>().fetchMySubscription();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00456A);
    const Color secondaryColor = Color(0xFFF5A623);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('My Subscription'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/user-home');
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/subscription-plan/basic'),
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Browse plans',
          ),
        ],
      ),
      body: FutureBuilder<UserSubscriptionStatus>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final status = snapshot.data;
          final sub = status?.subscription;
          final hasActive = status?.hasActiveSubscription == true && sub != null;

          if (!hasActive) {
            return _EmptySubscription(
              onBrowse: () => context.push('/subscription-plan/basic'),
            );
          }

          final features = sub.features;

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          sub.planName.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        sub.priceDisplay ?? '₹${sub.price.toStringAsFixed(0)}/-',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        sub.billingLabel ?? 'Active plan',
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      if (sub.endsAt != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Valid till ${_formatDate(sub.endsAt!)}',
                          style: const TextStyle(color: Colors.white60, fontSize: 13),
                        ),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "What's included in your plan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (features.isEmpty)
                        const Text('Plan features will appear here.')
                      else
                        for (final section in features) ...[
                          _buildFeatureItem(
                            icon: Icons.check_circle_outline,
                            title: section['title']?.toString() ?? 'Feature',
                            description: _sectionDescription(section),
                          ),
                          const SizedBox(height: 16),
                        ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () => context.push('/subscription-plan/${sub.planSlug}'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            shadowColor: primaryColor.withValues(alpha: 0.4),
                          ),
                          child: const Text(
                            'Upgrade plan',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _sectionDescription(Map<String, dynamic> section) {
    final items = section['items'];
    if (items is! List || items.isEmpty) return '';
    final lines = <String>[];
    for (final item in items) {
      if (item is Map) {
        final locked = item['is_locked'] == true;
        final text = item['text']?.toString() ?? '';
        if (text.isEmpty) continue;
        lines.add(locked ? '🔒 $text' : text);
      } else if (item is String) {
        lines.add(item);
      }
    }
    return lines.join('\n');
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF00456A).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF00456A), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySubscription extends StatelessWidget {
  final VoidCallback onBrowse;

  const _EmptySubscription({required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.subscriptions_outlined, size: 64, color: Color(0xFF00456A)),
            const SizedBox(height: 16),
            const Text(
              'No active subscription',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Subscribe to a plan to unlock Personal Health Assistant and other benefits.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onBrowse,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00456A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Browse plans'),
            ),
          ],
        ),
      ),
    );
  }
}
