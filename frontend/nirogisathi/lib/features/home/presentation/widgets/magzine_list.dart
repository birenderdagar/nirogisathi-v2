import 'package:flutter/material.dart';

class MagzineList extends StatelessWidget {
  const MagzineList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Nirogi Sathi Magzine", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildMagzineItem("Jan 24", "https://img.freepik.com/free-vector/modern-medical-magazine-cover-template_23-2148503848.jpg")),
            const SizedBox(width: 10),
            Expanded(child: _buildMagzineItem("Feb 24", "https://img.freepik.com/free-vector/flat-medical-magazine-cover-template_23-2148503847.jpg")),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Coming\nsoon", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey)),
                    SizedBox(height: 4),
                    Text("March 24", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildMagzineItem(String month, String imageUrl) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 120,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(month, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
