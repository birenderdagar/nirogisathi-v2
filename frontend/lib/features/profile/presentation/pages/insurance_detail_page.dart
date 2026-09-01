import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../insurance/domain/entities/insurance_entity.dart';

class InsuranceDetailPage extends StatelessWidget {
  final InsuranceEntity insurance;

  const InsuranceDetailPage({super.key, required this.insurance});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF00456A);
    final expiryStr = DateFormat('dd MMM yyyy').format(insurance.expiryDate);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Insurance Details"),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: primaryBlue,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Icons.security, size: 40, color: primaryBlue),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    insurance.planName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    insurance.providerName,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow("Policy Number", insurance.policyNumber, Icons.numbers),
                  _buildDetailRow("Coverage Amount", "₹${insurance.coverageAmount}", Icons.currency_rupee),
                  _buildDetailRow("Expiry Date", expiryStr, Icons.calendar_today),
                  _buildDetailRow("Status", insurance.status.name.toUpperCase(), Icons.info_outline),
                  
                  const SizedBox(height: 32),
                  const Text(
                    "Key Benefits",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...insurance.benefits.map((benefit) => _buildBenefitItem(benefit)),
                  
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Download Policy PDF",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String benefit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 18),
          const SizedBox(width: 12),
          Text(
            benefit,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
