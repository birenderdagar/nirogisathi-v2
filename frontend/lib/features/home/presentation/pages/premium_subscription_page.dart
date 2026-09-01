import 'package:flutter/material.dart';
import 'subscription_detail_page.dart';

class PremiumSubscriptionPage extends StatelessWidget {
  const PremiumSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SubscriptionDetailPage(initialSlug: 'premium');
  }
}
