import 'package:flutter/material.dart';
import '../widgets/auth_button.dart';
import 'package:go_router/go_router.dart';

class AuthSelectionPage extends StatelessWidget {
  const AuthSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const Spacer(),

                        /// 🔹 Logo
                        Center(
                          child: Image.asset(
                            'assets/images/Nirogi_logo.png',
                            height: 120,
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// 🔹 App Name / Tagline
                        const Text(
                          "Welcome to Nirogi Sathi",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "We cares for you and your family.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),

                        const Spacer(),

                        /// 🔹 Login Button
                        AuthButton(
                          text: "Login",
                          onPressed: () {
                            context.push('/login');
                          },
                        ),

                        const SizedBox(height: 16),

                        /// 🔹 Signup Button
                        AuthButton(
                          text: "Sign Up",
                          onPressed: () {
                            context.push('/signup-name');
                          },
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}