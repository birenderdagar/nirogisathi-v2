import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00456A);

    final List<Map<String, String>> faqs = [
      {
        "question": "How do I book an appointment?",
        "answer": "You can book an appointment directly from the 'User Dashboard' under the 'Quick Actions' section by clicking 'Book Appointment'."
      },
      {
        "question": "How can I access my medical records?",
        "answer": "Your medical records are securely stored in 'My Digital Health Locker'. You can find it on your home screen or via the profile drawer."
      },
      {
        "question": "Can I cancel my subscription?",
        "answer": "Yes, you can manage and cancel your subscription from the 'My Subscription' page in your profile settings."
      },
      {
        "question": "Is my personal data secure?",
        "answer": "Absolutely. We use end-to-end encryption and follow strict HIPAA-compliant protocols to ensure your health data remains private and secure."
      },
      {
        "question": "How do I contact customer support?",
        "answer": "You can reach us through the 'Contact Us' page in the profile drawer. We offer chat, email, and phone support from 10 AM to 7 PM."
      },
      {
        "question": "What is the role of a Health Assistant?",
        "answer": "A Health Assistant is a dedicated professional assigned to help you manage your daily health tasks, vitals checkups, and coordination with doctors."
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("FAQs"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: primaryColor,
            child: const Column(
              children: [
                Icon(Icons.help_center_outlined, size: 60, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  "How can we help you today?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Search our frequently asked questions below",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: ExpansionTile(
                    shape: const Border(),
                    leading: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.question_mark_rounded, size: 18, color: primaryColor),
                    ),
                    title: Text(
                      faqs[index]["question"]!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          faqs[index]["answer"]!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
