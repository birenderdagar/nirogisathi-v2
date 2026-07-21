import 'package:flutter/material.dart';

class HomeBanners extends StatelessWidget {
  const HomeBanners({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: PageView(
        children: [
          _buildBanner(
            "PATIENTS ARE OUR\nPRIORITY",
            "Book Now",
            "https://img.freepik.com/free-photo/doctors-day-cute-young-female-doctor-white-lab-coat-with-stethoscope-smiling-confidently_144627-46338.jpg",
          ),
          _buildBanner(
            "BEST CONSULTATION\nWITH SPECIALISTS",
            "Find Doctor",
            "https://img.freepik.com/free-photo/smiling-doctor-with-stethoscope-holding-clipboard_23-2148168407.jpg",
          ),
          _buildBanner(
            "LATEST TECHNOLOGY\nIN DIAGNOSTICS",
            "Book Test",
            "https://img.freepik.com/free-photo/scientists-working-together-lab_23-2148812480.jpg",
          ),
          _buildBanner(
            "CARING FOR YOUR\nLITTLE ONES",
            "Pediatrician",
            "https://img.freepik.com/free-photo/doctor-examining-little-girl-hospital_23-2148352219.jpg",
          ),
          _buildBanner(
            "24/7 SUPPORT\nFOR ELDERLY CARE",
            "Learn More",
            "https://img.freepik.com/free-photo/nurse-helping-senior-woman-walk_23-2148232777.jpg",
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(String title, String buttonText, String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFE3F2FD),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            width: 180,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.blue.shade100),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFE3F2FD),
                  const Color(0xFFE3F2FD).withOpacity(0.8),
                  const Color(0xFFE3F2FD).withOpacity(0.0),
                ],
                stops: const [0.0, 0.5, 0.9],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF00456A),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00456A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
