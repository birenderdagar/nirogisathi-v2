import 'package:flutter/material.dart';
import 'subscription_detail_page.dart';

class SubscriptionPackPage extends StatelessWidget {
  const SubscriptionPackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SubscriptionDetailPage(initialSlug: 'basic');
  }
}
