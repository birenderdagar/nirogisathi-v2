import 'package:flutter/material.dart';
import '../../../../app/di/injection.dart';
import '../../../Splash/presentation/provider/splash_provider.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../widgets/location_ribbon.dart';

class AssistantHome extends StatelessWidget {
  const AssistantHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assistant Dashboard"),
        backgroundColor: const Color(0xFF00456A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: "Switch Role",
            icon: const Icon(Icons.swap_horiz_rounded),
            onPressed: () {
              getIt<SplashProvider>().goToRoleSelection();
            },
          ),
          IconButton(
            tooltip: "Logout",
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await getIt<AuthRepository>().logout();
              getIt<SplashProvider>().refresh();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const LocationRibbon(), // Uses global Provider from main.dart
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Assistant Tasks",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  
                  // Task Summary
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00456A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _TaskStat(label: "Pending", value: "08"),
                        _TaskStat(label: "Completed", value: "24"),
                        _TaskStat(label: "Urgent", value: "03"),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  const Text(
                    "Assigned Patients",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  
                  _buildPatientTile("Rahul Kapoor", "Room 302", "Vitals Check"),
                  _buildPatientTile("Suman Lata", "Room 105", "Medication"),
                  _buildPatientTile("Vikram Singh", "Emergency", "ECG Required"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientTile(String name, String location, String task) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF00456A).withOpacity(0.1),
          child: const Icon(Icons.person, color: Color(0xFF00456A)),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location, style: const TextStyle(fontSize: 13)),
            Text(task, style: TextStyle(color: Colors.red.shade400, fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }
}

class _TaskStat extends StatelessWidget {
  final String label;
  final String value;
  const _TaskStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
