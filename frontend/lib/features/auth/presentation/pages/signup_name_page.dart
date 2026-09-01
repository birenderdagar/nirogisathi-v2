import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_button.dart';

class SignupNamePage extends StatefulWidget {
  const SignupNamePage({super.key});

  @override
  State<SignupNamePage> createState() => _SignupNamePageState();
}

class _SignupNamePageState extends State<SignupNamePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your name")),
      );
      return;
    }

    context.push('/signup-details', extra: name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Hi 👋",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "What’s your name?",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: "Enter your full name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: AuthButton(
                text: "Continue",
                onPressed: _nameController.text.trim().isEmpty ? null : _onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
