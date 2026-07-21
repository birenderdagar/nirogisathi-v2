import 'package:flutter/material.dart';

class ClientSayList extends StatelessWidget {
  const ClientSayList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('"What our Client\'s say"', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildClientCard("Anjali", "https://img.freepik.com/free-photo/young-beautiful-woman-pink-warm-sweater-natural-look-smiling-portrait-isolated-long-hair_285396-896.jpg"),
              _buildClientCard("Rohan", "https://img.freepik.com/free-photo/handsome-young-man-with-new-haircut_273609-12136.jpg"),
              _buildClientCard("Sneha", "https://img.freepik.com/free-photo/smiley-woman-posing-medium-shot_23-2148903511.jpg"),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildClientCard(String name, String imageUrl) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          ClipOval(
            child: Image.network(
              imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 70,
                height: 70,
                color: Colors.grey.shade200,
                child: const Icon(Icons.person, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
