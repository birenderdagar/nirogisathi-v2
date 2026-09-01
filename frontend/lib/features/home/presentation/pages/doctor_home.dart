import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/di/injection.dart';
import '../../../Splash/presentation/provider/splash_provider.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../location/presentation/provider/location_provider.dart';
import '../widgets/location_ribbon.dart';

class DoctorHome extends StatelessWidget {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<LocationProvider>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Doctor Dashboard"),
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
            const LocationRibbon(), // ✅ Added Location Ribbon
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome, Doctor",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: "Appointments",
                            value: "12",
                            color: Colors.blue.shade700,
                            icon: Icons.calendar_today,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildStatCard(
                            title: "Pending Reviews",
                            value: "05",
                            color: Colors.orange.shade700,
                            icon: Icons.assignment_late_outlined,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    _buildSectionTitle("Patient List"),
                    _buildActivityItem("Birender Dagar", "General Checkup", "10:00 AM"),
                    _buildActivityItem("Amit Sharma", "Follow-up", "11:30 AM"),
                    _buildActivityItem("Priya Verma", "Lab Results", "12:15 PM"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value, required Color color, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String name, String type, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(type),
        trailing: Text(time, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
