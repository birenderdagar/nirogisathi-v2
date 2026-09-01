import 'package:flutter/material.dart';

class OffersBanner extends StatelessWidget {
  const OffersBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Offer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 140, // ✅ Increased height to prevent overflow
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF00456A), Color(0xFF007991)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                bottom: -10,
                child: Opacity(
                  opacity: 0.5,
                  child: Image.network(
                    "https://cdn-icons-png.flaticon.com/512/3306/3306613.png",
                    height: 120, // ✅ Slightly increased image size
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "ON MEDICAL\nTREATMENT",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF00456A),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        minimumSize: const Size(80, 32), // ✅ Adjusted minimum size
                      ),
                      child: const Text("CLAIM NOW", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
