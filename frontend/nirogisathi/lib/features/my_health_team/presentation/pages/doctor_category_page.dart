import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DoctorCategoryPage extends StatelessWidget {
  const DoctorCategoryPage({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      "name": "Dentist",
      "subName": "(Dental)",
      "icon": Icons.medical_services_outlined,
      "colors": [Color(0xFF6A82FB), Color(0xFF4A68D6)],
    },
    {
      "name": "Cardiologist",
      "subName": "(Heart Disease)",
      "icon": Icons.monitor_heart_outlined,
      "colors": [Color(0xFF00D2FF), Color(0xFF3A7BD5)],
    },
    {
      "name": "Optometrist",
      "subName": "(regular Eye care)",
      "icon": Icons.visibility_outlined,
      "colors": [Color(0xFFF2994A), Color(0xFFF2C94C)],
    },
    {
      "name": "Gastroenterologist",
      "subName": "(digestive organs)",
      "icon": Icons.accessibility_new_outlined,
      "colors": [Color(0xFFFF5F6D), Color(0xFFFFC371)],
    },
    {
      "name": "Dentist",
      "subName": "(Dental)",
      "icon": Icons.medical_services_outlined,
      "colors": [Color(0xFF6A82FB), Color(0xFF4A68D6)],
    },
    {
      "name": "Cardiologist",
      "subName": "(Heart Disease)",
      "icon": Icons.monitor_heart_outlined,
      "colors": [Color(0xFF00D2FF), Color(0xFF3A7BD5)],
    },
    {
      "name": "Optometrist",
      "subName": "(regular Eye care)",
      "icon": Icons.visibility_outlined,
      "colors": [Color(0xFFF2994A), Color(0xFFF2C94C)],
    },
    {
      "name": "Gastroenterologist",
      "subName": "(digestive organs)",
      "icon": Icons.accessibility_new_outlined,
      "colors": [Color(0xFFFF5F6D), Color(0xFFFFC371)],
    },
    {
      "name": "Dentist",
      "subName": "(Dental)",
      "icon": Icons.medical_services_outlined,
      "colors": [Color(0xFF6A82FB), Color(0xFF4A68D6)],
    },
    {
      "name": "Cardiologist",
      "subName": "(Heart Disease)",
      "icon": Icons.monitor_heart_outlined,
      "colors": [Color(0xFF00D2FF), Color(0xFF3A7BD5)],
    },
    {
      "name": "Optometrist",
      "subName": "(regular Eye care)",
      "icon": Icons.visibility_outlined,
      "colors": [Color(0xFFF2994A), Color(0xFFF2C94C)],
    },
    {
      "name": "Gastroenterologist",
      "subName": "(digestive organs)",
      "icon": Icons.accessibility_new_outlined,
      "colors": [Color(0xFFFF5F6D), Color(0xFFFFC371)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Doctor Category",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 25,
          childAspectRatio: 0.65,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              context.push('/all-doctors', extra: {
                'title': category['name'],
                'category': category['name'].toString().toLowerCase(),
              });
            },
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: category['colors'],
                      ),
                    ),
                    child: Icon(
                      category['icon'],
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category['name'],
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  category['subName'],
                  style: const TextStyle(
                    fontSize: 7.5,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
