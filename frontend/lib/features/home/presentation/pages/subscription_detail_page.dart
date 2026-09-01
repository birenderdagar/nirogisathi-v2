import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nirogisathi/app/di/injection.dart';
import '../../data/datasources/home_content_remote_datasource.dart';
import '../../domain/entities/home_content.dart';
import '../../domain/entities/user_subscription.dart';

/// Swipeable subscription detail — loads all active plans and pages between them.
class SubscriptionDetailPage extends StatefulWidget {
  final String? initialSlug;

  const SubscriptionDetailPage({
    super.key,
    this.initialSlug,
  });

  @override
  State<SubscriptionDetailPage> createState() => _SubscriptionDetailPageState();
}

class _SubscriptionDetailPageState extends State<SubscriptionDetailPage> {
  late Future<List<SubscriptionPlanItem>> _future;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _future = _loadPlans();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  Future<List<SubscriptionPlanItem>> _loadPlans() async {
    final plans = await getIt<HomeContentRemoteDataSource>().fetchSubscriptions();
    if (plans.isEmpty) {
      throw Exception('No subscription plans available');
    }

    var index = 0;
    final slug = widget.initialSlug?.trim().toLowerCase();
    if (slug != null && slug.isNotEmpty) {
      final found = plans.indexWhere((p) => p.slug.toLowerCase() == slug);
      if (found >= 0) index = found;
    }

    _pageController = PageController(initialPage: index);
    return plans;
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00456A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 18),
            ),
          ),
        ),
        title: const Text(
          'Subscription plan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<SubscriptionPlanItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not load plans.\n${snapshot.error ?? ''}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final plans = snapshot.data!;
          final controller = _pageController!;

          return PageView.builder(
            controller: controller,
            itemCount: plans.length,
            itemBuilder: (context, index) {
              return _PlanPageContent(
                plan: plans[index],
                currentIndex: index,
                totalPlans: plans.length,
                onDotTap: (i) => controller.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOut,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _PlanPageContent extends StatelessWidget {
  final SubscriptionPlanItem plan;
  final int currentIndex;
  final int totalPlans;
  final ValueChanged<int>? onDotTap;

  const _PlanPageContent({
    required this.plan,
    required this.currentIndex,
    required this.totalPlans,
    this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00456A);
    const Color accentColor = Color(0xFF3FCFFB);
    final iconData = plan.icon == 'vintage'
        ? Icons.filter_vintage
        : Icons.auto_awesome;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(iconData, color: Colors.white, size: 40),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        plan.billingLabel,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalPlans, (index) {
              final active = index == currentIndex;
              return GestureDetector(
                onTap: onDotTap == null ? null : () => onDotTap!(index),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? accentColor : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                for (var i = 0; i < plan.featureSections.length; i++) ...[
                  if (i > 0) const SizedBox(height: 25),
                  _buildFeatureCard(plan.featureSections[i]),
                ],
              ],
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  context.push(
                    '/payment',
                    extra: SubscriptionPaymentExtra(
                      amount: plan.price > 0 ? plan.price : 0,
                      subscriptionId: plan.id > 0 ? plan.id : null,
                      planSlug: plan.slug,
                      planName: plan.name,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  plan.payButtonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(SubscriptionFeatureSection section) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Column(
            children: [
              for (final item in section.items) _buildFeatureItem(item),
            ],
          ),
        ),
        Positioned(
          top: -12,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Text(
                section.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00456A),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(SubscriptionFeatureItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.isLocked ? Icons.lock : Icons.check,
            size: 18,
            color: item.isLocked ? Colors.black : Colors.green,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.text,
              style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
