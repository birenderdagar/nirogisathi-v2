import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/health_team_provider.dart';
import '../widgets/preferred_doctor_card.dart';
import '../widgets/popular_doctor_card.dart';
import '../widgets/feature_doctor_card.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthTeamProvider>().fetchDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00456A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Doctors",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
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

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "My Prefered Doctors",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 180,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.preferredDoctors.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 15),
                    itemBuilder: (context, index) {
                      return PreferredDoctorCard(doctor: provider.preferredDoctors[index]);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () => context.push('/add-preferred-doctor'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90E2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      elevation: 0,
                    ),
                    child: const Text("Add prefered Doctor", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Find Other Doctor", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search.....",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: const Icon(Icons.close),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                _sectionHeader("Browse by category", onTap: () {
                  context.push('/doctor-categories');
                }),
                const SizedBox(height: 15),
                SizedBox(
                  height: 100,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    children: [
                      _categoryCard(
                        Icons.medical_services_outlined, 
                        [Colors.blue, Colors.blue.shade300],
                        "General",
                        onTap: () => context.push('/all-doctors', extra: {'title': 'General', 'category': 'general'}),
                      ),
                      _categoryCard(
                        Icons.favorite_border, 
                        [Colors.green, Colors.green.shade300],
                        "Cardiology",
                        onTap: () => context.push('/all-doctors', extra: {'title': 'Cardiology', 'category': 'cardiology'}),
                      ),
                      _categoryCard(
                        Icons.remove_red_eye_outlined, 
                        [Colors.orange, Colors.orange.shade300],
                        "Eye Care",
                        onTap: () => context.push('/all-doctors', extra: {'title': 'Eye Care', 'category': 'eyecare'}),
                      ),
                      _categoryCard(
                        Icons.accessibility_new, 
                        [Colors.red, Colors.red.shade300],
                        "Ortho",
                        onTap: () => context.push('/all-doctors', extra: {'title': 'Ortho', 'category': 'ortho'}),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                _sectionHeader("Popular Doctor", onTap: () {
                  context.push('/all-doctors', extra: {'title': 'Popular Doctors'});
                }),
                const SizedBox(height: 15),
                SizedBox(
                  height: 260,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.popularDoctors.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 15),
                    itemBuilder: (context, index) {
                      return PopularDoctorCard(doctor: provider.popularDoctors[index]);
                    },
                  ),
                ),
                const SizedBox(height: 25),
                _sectionHeader("Feature Doctor", onTap: () {
                  context.push('/all-doctors', extra: {'title': 'Feature Doctors'});
                }),
                const SizedBox(height: 15),
                SizedBox(
                  height: 180,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.featureDoctors.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 15),
                    itemBuilder: (context, index) {
                      return FeatureDoctorCard(doctor: provider.featureDoctors[index]);
                    },
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionHeader(String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: onTap,
            child: Text("See all >", style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(IconData icon, List<Color> colors, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 40),
      ),
    );
  }
}
