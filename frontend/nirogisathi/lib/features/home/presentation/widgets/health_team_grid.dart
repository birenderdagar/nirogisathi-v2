import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HealthTeamGrid extends StatelessWidget {
  const HealthTeamGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("My Health Team", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            TextButton(
              onPressed: () => context.push('/my-health-team'),
              child: const Text("View All", style: TextStyle(color: Color(0xFF00456A))),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            _buildTeamItem(context, "Hospitals", Icons.local_hospital, Colors.green.shade100, Colors.green, route: '/hospitals'),
            _buildTeamItem(context, "Doctors", Icons.person, Colors.blue.shade100, Colors.blue, route: '/doctors'),
            _buildTeamItem(context, "Laboratory", Icons.science, Colors.purple.shade100, Colors.purple),
            _buildTeamItem(context, "Nursing", Icons.medical_services, Colors.teal.shade100, Colors.teal),
            _buildTeamItem(context, "Health Coaches", Icons.fitness_center, Colors.orange.shade100, Colors.orange),
            _buildTeamItem(context, "Pharmacy", Icons.local_pharmacy, Colors.cyan.shade100, Colors.cyan),
          ],
        )
      ],
    );
  }

  Widget _buildTeamItem(BuildContext context, String label, IconData icon, Color bgColor, Color iconColor, {String? route}) {
    return InkWell(
      onTap: () => context.push(route ?? '/my-health-team'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // ✅ Prevent overflow in tight constraints
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
