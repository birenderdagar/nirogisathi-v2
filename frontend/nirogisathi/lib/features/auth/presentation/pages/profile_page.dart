import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection.dart';
import '../../../Splash/presentation/provider/splash_provider.dart';
import '../../data/datasources/session_local_datasource.dart';
import '../provider/auth_provider.dart';
import '../widgets/auth_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  String? selectedGender;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _completeProfile(AuthProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    // Get the current user UID from the session
    final uid = getIt<SessionLocalDataSource>().getUid();
    
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Session error. Please login again.")),
      );
      context.go('/login');
      return;
    }

    final data = {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'gender': selectedGender,
    };

    await provider.completeProfile(uid, data);

    if (provider.errorMessage == null) {
      // Refresh the splash provider to trigger router redirect to home
      await getIt<SplashProvider>().refresh();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AuthProvider>(),
      child: Consumer<AuthProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Complete Profile"),
              backgroundColor: const Color(0xFF00456A),
              foregroundColor: Colors.white,
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Almost there!",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Please provide a few more details to get started.",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: "Full Name",
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => v!.isEmpty ? "Enter your name" : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => v!.isEmpty ? "Enter your email" : null,
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: selectedGender,
                          decoration: const InputDecoration(
                            labelText: "Gender",
                            border: OutlineInputBorder(),
                          ),
                          items: ["Male", "Female", "Other"]
                              .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                              .toList(),
                          onChanged: (v) => setState(() => selectedGender = v),
                          validator: (v) => v == null ? "Select gender" : null,
                        ),
                        const Spacer(),
                        AuthButton(
                          text: "Finish Setup",
                          onPressed: provider.isLoading
                              ? null
                              : () => _completeProfile(provider),
                        ),
                      ],
                    ),
                  ),
                ),
                if (provider.isLoading)
                  const ColoredBox(
                    color: Colors.black26,
                    child: Center(
                      child: CircularProgressIndicator(color: Color(0xFF00456A)),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
