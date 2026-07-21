import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Terms of Service",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Welcome to Nirogi Sathi. By using our application, you agree to the following terms...",
            ),
            SizedBox(height: 16),
            Text(
              "1. Acceptance of Terms\n"
              "By accessing or using the app, you agree to be bound by these Terms of Service.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "2. Use of the App\n"
              "You must provide accurate information when creating an account.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // Add more dummy text as needed
          ],
        ),
      ),
    );
  }
}
