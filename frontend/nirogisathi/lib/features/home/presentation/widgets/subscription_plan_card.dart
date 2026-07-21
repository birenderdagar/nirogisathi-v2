import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubscriptionPlanCard extends StatelessWidget {
  const SubscriptionPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Our Subscription Plan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            TextButton(
              onPressed: () => context.push('/subscription-pack'), 
              child: const Text("See All")
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildPlanItem(
                context, 
                "Basic", 
                "₹150.00", 
                Colors.orange, 
                '/subscription-pack'
              )
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildPlanItem(
                context, 
                "Standard", 
                "₹1500.00", 
                Colors.red, 
                '/standard-subscription'
              )
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildPlanItem(
                context, 
                "Premium", 
                "₹4500.00", 
                Colors.amber, 
                '/premium-subscription'
              )
            ),
          ],
        )
      ],
    );
  }

  Widget _buildPlanItem(BuildContext context, String name, String price, Color color, String route) {
    return GestureDetector(
      onTap: () => context.push(route),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ✅ Prevent taking unnecessary space
          children: [
            Image.asset(
              "assets/images/Nirogi_logo.png",
              height: 24,
              width: 24,
              errorBuilder: (context, error, stackTrace) => CircleAvatar(
                radius: 12, 
                backgroundColor: color.withOpacity(0.1), 
                child: Icon(Icons.circle_outlined, color: color, size: 12)
              ),
            ),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
              child: Text(
                price, 
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)
              ),
            )
          ],
        ),
      ),
    );
  }
}
