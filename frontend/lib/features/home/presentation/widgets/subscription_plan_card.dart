import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nirogisathi/app/di/injection.dart';
import '../../data/datasources/home_content_remote_datasource.dart';
import '../../domain/entities/home_content.dart';

class SubscriptionPlanCard extends StatefulWidget {
  const SubscriptionPlanCard({super.key});

  @override
  State<SubscriptionPlanCard> createState() => _SubscriptionPlanCardState();
}

class _SubscriptionPlanCardState extends State<SubscriptionPlanCard> {
  late Future<List<SubscriptionPlanItem>> _future;

  static const List<SubscriptionPlanItem> _fallback = [
    SubscriptionPlanItem(
      id: -1,
      name: 'Basic',
      slug: 'basic',
      priceDisplay: '₹150.00',
      billingLabel: '150/- per Month',
      payButtonText: 'Pay 150/-',
      icon: 'awesome',
      price: 150,
      accentColor: 0xFFF97316,
      appRoute: '/subscription-plan/basic',
    ),
    SubscriptionPlanItem(
      id: -2,
      name: 'Standard',
      slug: 'standard',
      priceDisplay: '₹1500.00',
      billingLabel: '1500/- per Month',
      payButtonText: 'Pay 1500/-',
      icon: 'vintage',
      price: 1500,
      accentColor: 0xFFEF4444,
      appRoute: '/subscription-plan/standard',
    ),
    SubscriptionPlanItem(
      id: -3,
      name: 'Premium',
      slug: 'premium',
      priceDisplay: '₹4500.00',
      billingLabel: '4500/- per Month',
      payButtonText: 'Pay 4500/-',
      icon: 'vintage',
      price: 4500,
      accentColor: 0xFFF59E0B,
      appRoute: '/subscription-plan/premium',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<SubscriptionPlanItem>> _load() async {
    try {
      final items = await getIt<HomeContentRemoteDataSource>().fetchSubscriptions();
      if (items.isEmpty) return _fallback;
      return items;
    } catch (e) {
      debugPrint('SubscriptionPlanCard API failed: $e');
      return _fallback;
    }
  }

  void _openPlan(BuildContext context, SubscriptionPlanItem plan) {
    final slug = plan.slug.trim().isEmpty ? 'basic' : plan.slug.trim();
    context.push('/subscription-plan/$slug');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Our Subscription Plan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextButton(
              onPressed: () => context.push('/subscription-plan/basic'),
              child: const Text('See All'),
            ),
          ],
        ),
        FutureBuilder<List<SubscriptionPlanItem>>(
          future: _future,
          builder: (context, snapshot) {
            final plans = snapshot.data ?? _fallback;
            return SizedBox(
              height: 118,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: plans.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 110,
                    child: _buildPlanItem(context, plans[index]),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPlanItem(BuildContext context, SubscriptionPlanItem plan) {
    final color = Color(plan.accentColor);

    return GestureDetector(
      onTap: () => _openPlan(context, plan),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Nirogi_logo.png',
              height: 24,
              width: 24,
              errorBuilder: (context, error, stackTrace) => CircleAvatar(
                radius: 12,
                backgroundColor: color.withValues(alpha: 0.1),
                child: Icon(Icons.circle_outlined, color: color, size: 12),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              plan.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                plan.priceDisplay,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
