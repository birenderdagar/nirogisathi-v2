import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/health_team_provider.dart';
import '../widgets/preferred_hospital_card.dart';
import '../widgets/other_hospital_card.dart';

class HospitalsPage extends StatefulWidget {
  const HospitalsPage({super.key});

  @override
  State<HospitalsPage> createState() => _HospitalsPageState();
}

class _HospitalsPageState extends State<HospitalsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthTeamProvider>().fetchHospitals();
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00456A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Hospital",
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: Colors.white, 
            fontSize: 20,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<HealthTeamProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: primaryColor));
          }

          if (provider.error != null) {
            return Center(child: Text("Error: ${provider.error}"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "My Prefered Hospitals",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),
                // Increased height to 300 to prevent bottom overflow
                SizedBox(
                  height: 300,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.preferredHospitals.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 15),
                    itemBuilder: (context, index) {
                      return PreferredHospitalCard(
                        hospital: provider.preferredHospitals[index],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: ElevatedButton(
                    onPressed: () => context.push('/add-preferred-hospital'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90E2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Add prefered Hospital",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                const Text(
                  "Other Hospitals",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.otherHospitals.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    return OtherHospitalCard(
                      hospital: provider.otherHospitals[index],
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
