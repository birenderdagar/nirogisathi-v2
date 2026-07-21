import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart'; // ✅ Added GoRouter
import '../../../../app/di/injection.dart';
import '../../../insurance/domain/entities/insurance_entity.dart';
import '../../../insurance/presentation/providers/insurance_provider.dart';
import 'insurance_detail_page.dart';

class MyInsurancePage extends StatefulWidget {
  const MyInsurancePage({super.key});

  @override
  State<MyInsurancePage> createState() => _MyInsurancePageState();
}

class _MyInsurancePageState extends State<MyInsurancePage> {
  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF00456A);

    return ChangeNotifierProvider(
      create: (_) => getIt<InsuranceProvider>()..fetchInsurances(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text("My Insurances"),
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Consumer<InsuranceProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator(color: primaryBlue));
            }

            if (provider.insurances.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.insurances.length,
              itemBuilder: (context, index) {
                return _buildInsuranceCard(context, provider.insurances[index], primaryBlue);
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // ✅ Fixed: Navigate to Add Insurance page
            context.push('/add-insurance');
          },
          backgroundColor: primaryBlue,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Add Insurance", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildInsuranceCard(BuildContext context, InsuranceEntity insurance, Color themeColor) {
    final expiryStr = DateFormat('dd MMM yyyy').format(insurance.expiryDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InsuranceDetailPage(insurance: insurance),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: themeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      insurance.providerName,
                      style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  _buildStatusBadge(insurance.status),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                insurance.planName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Policy No: ${insurance.policyNumber}",
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Coverage Amount", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text("₹${insurance.coverageAmount}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("Expiry Date", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(expiryStr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(InsuranceStatus status) {
    Color color = status == InsuranceStatus.active ? Colors.green : Colors.orange;
    return Row(
      children: [
        Icon(Icons.circle, size: 8, color: color),
        const SizedBox(width: 4),
        Text(status.name.toUpperCase(), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.security_outlined, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text("No insurance records found", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
