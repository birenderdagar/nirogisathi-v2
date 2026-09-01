import 'package:flutter/material.dart';
import 'subscription_detail_page.dart';

class StandardSubscriptionPage extends StatelessWidget {
  const StandardSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SubscriptionDetailPage(initialSlug: 'standard');
  }
}
