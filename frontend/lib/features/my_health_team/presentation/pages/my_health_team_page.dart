import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_team_provider.dart';
import '../widgets/health_professional_card.dart';

class MyHealthTeamPage extends StatefulWidget {
  const MyHealthTeamPage({super.key});

  @override
  State<MyHealthTeamPage> createState() => _MyHealthTeamPageState();
}

class _MyHealthTeamPageState extends State<MyHealthTeamPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthTeamProvider>().fetchHealthTeam();
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00456A);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "My Health Team",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_outlined, color: Colors.white),
            onPressed: () {
              // Navigate to add member
            },
          ),
        ],
      ),
      body: Consumer<HealthTeamProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: primaryColor));
          }

          if (provider.error != null) {
            return Center(child: Text("Error: ${provider.error}"));
          }

          if (provider.team.isEmpty) {
            return const Center(child: Text("No health professionals in your team yet."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.team.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final member = provider.team[index];
              return HealthProfessionalCard(member: member);
            },
          );
        },
      ),
    );
  }
}
