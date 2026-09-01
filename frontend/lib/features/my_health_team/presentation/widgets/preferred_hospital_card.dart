import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/hospital.dart';

class PreferredHospitalCard extends StatelessWidget {
  final Hospital hospital;

  const PreferredHospitalCard({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/hospital-detail', extra: hospital),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 220, // Increased width slightly for better fit
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue.shade100, width: 1.5),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    hospital.imageUrl,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 110,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.business, color: Colors.grey, size: 40),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (hospital.logoUrl.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Image.network(
                                  hospital.logoUrl,
                                  height: 12,
                                  errorBuilder: (context, e, s) => const Icon(Icons.health_and_safety, size: 12, color: Colors.blue),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                hospital.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          hospital.address,
                          style: TextStyle(fontSize: 8, color: Colors.grey.shade600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _infoItem(Icons.king_bed_outlined, "${hospital.beds} Beds"),
                            _infoItem(Icons.location_on_outlined, hospital.distance),
                          ],
                        ),
                        const SizedBox(height: 4),
                        _infoItem(Icons.account_balance_outlined, hospital.type),
                      ],
                    ),
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
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 8,
              top: 8,
              child: InkWell(
                onTap: () {
                  // Handle remove
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 14),
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.black),
        const SizedBox(width: 2),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
