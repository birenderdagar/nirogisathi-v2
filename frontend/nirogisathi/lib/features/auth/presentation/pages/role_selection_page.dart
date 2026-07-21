import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/di/injection.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/utils/time_greeting.dart';
import '../../../Splash/presentation/provider/splash_provider.dart';
import '../widgets/role_card.dart';
import '../../domain/repositories/auth_repository.dart'; // ✅ Corrected path

class RoleSelectionPage extends StatelessWidget {
  final String userName;

  const RoleSelectionPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final greeting = getGreeting();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            final splash = getIt<SplashProvider>();
            // If the current state is already a chosen role, we can just refresh to go back there
            // Or if we have a user object, we are definitely logged in
            if (splash.user != null) {
              splash.refresh(isFreshLogin: false);
            } else {
              // Check if we were already in an authenticated state before coming here
              // This is a bit of a hack, but safer than always logging out
              await getIt<AuthRepository>().logout();
              splash.refresh();
            }
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF00456A),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                Text(
                  "$greeting, $userName 👋",
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),

                const SizedBox(height: 12),

                const Text(
                  "How would you like to continue today?",
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),

                const SizedBox(height: 40),

                // User / Patient Tab
                RoleCard(
                  title: "User / Patient",
                  emoji: "👤",
                  onTap: () {
                    getIt<SplashProvider>().setAuthenticatedRole(UserRole.user, userName);
                  },
                ),

                const SizedBox(height: 16),

                // Health Assistant Tab
                RoleCard(
                  title: "Health Assistant",
                  emoji: "🧑‍⚕️",
                  onTap: () => _showAssistantDialog(context),
                ),

                const SizedBox(height: 16),

                // Doctor Tab
                RoleCard(
                  title: "Doctor / Professional",
                  emoji: "👨‍⚕️",
                  onTap: () => _showDoctorDialog(context),
                ),
                
                const SizedBox(height: 40),
                
                Center(
                  child: TextButton(
                    onPressed: () async {
                      // ✅ Same logic for the Switch Account link
                      await getIt<AuthRepository>().logout();
                      getIt<SplashProvider>().refresh();
                    },
                    child: const Text("Not you? Switch Account", style: TextStyle(color: Colors.white70)),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAssistantDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Assistant Verification"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter Employee ID (Use HA0000)",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final id = controller.text.trim();
              if (id == "HA0000") {
                Navigator.pop(context);
                getIt<SplashProvider>().setAuthenticatedRole(UserRole.healthAssistant, userName);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid Employee ID. Try HA0000")));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00456A)),
            child: const Text("Verify & Login", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  void _showDoctorDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Doctor Verification"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter Professional ID (Use DR0000)",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final id = controller.text.trim();
              if (id == "DR0000") {
                Navigator.pop(context);
                getIt<SplashProvider>().setAuthenticatedRole(UserRole.doctor, userName);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid Professional ID. Try DR0000")));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00456A)),
            child: const Text("Verify & Login", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
