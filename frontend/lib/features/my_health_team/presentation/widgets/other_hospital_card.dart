import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/hospital.dart';

class OtherHospitalCard extends StatelessWidget {
  final Hospital hospital;

  const OtherHospitalCard({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/hospital-detail', extra: hospital),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue.shade100, width: 1.5),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      hospital.imageUrl,
                      width: 100,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 100,
                        height: 80,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.business, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (hospital.logoUrl.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Image.network(hospital.logoUrl, height: 12),
                              )
                            else
                               const Text("HEART NEURO", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.blue)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hospital.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hospital.address,
                          style: TextStyle(fontSize: 8, color: Colors.grey.shade600),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                             Expanded(child: Text(hospital.type, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500))),
                             _infoItem(Icons.king_bed_outlined, "${hospital.beds} Beds"),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _infoItem(Icons.location_on_outlined, hospital.distance),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF9C27B0), // Purple color from image
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(13)),
              ),
              child: const Text(
                "View Details",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.black),
        const SizedBox(width: 2),
        Text(
          text,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
