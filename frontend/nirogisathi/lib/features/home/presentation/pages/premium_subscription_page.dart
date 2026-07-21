import 'package:flutter/material.dart';

class PremiumSubscriptionPage extends StatelessWidget {
  const PremiumSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00456A);
    const Color accentColor = Color(0xFF3FCFFB);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 18),
            ),
          ),
        ),
        title: const Text(
          "My Subscription",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Logo and Plan Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: const BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.filter_vintage, color: Colors.white, size: 40),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Premium",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "4500/- per Month",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: accentColor, shape: BoxShape.circle),
                ),
              ],
            ),
            const SizedBox(height: 35),
            
            // Feature Border-Label Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildFeatureCard(
                    title: "Routine Screening",
                    children: [
                      _buildFeatureItem(Icons.check, Colors.green, "3 timed in a year (may be very according to need."),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildFeatureCard(
                    title: "Digital Health Locker",
                    children: [
                      _buildFeatureItem(Icons.check, Colors.green, "Digital health locker helps to manage all health records and to create health history that will helps doctors to find your disease or health history and diagnose the patient easy and quickly."),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildFeatureCard(
                    title: "Gov./Private Hospital Support",
                    children: [
                      _buildFeatureItem(Icons.check, Colors.green, "We have a support system and large network in Govt. & private hospitals/labs to give a hassle free service to our clients ."),
                      _buildFeatureItem(Icons.check, Colors.green, "We provide discounts on all private lab tests and hospital charges ."),
                      _buildFeatureItem(Icons.check, Colors.green, "We helps in hectic process of registratin queue, medicine queue and other clerical work in govt ."),
                      _buildFeatureItem(Icons.check, Colors.green, "Hospitals as well as to book a appointment, medicines and helps to find an expert doctor for any particular disease in private sectors ."),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildFeatureCard(
                    title: "Monitoring after Doctor consultation and reminders",
                    children: [
                      _buildFeatureItem(Icons.check, Colors.green, "After any treatment or doctor consultation we strongly belive to monitor the patient for improment or any side effect of medicines.we set reminders for further tests andmedicines. We provide both physical and emotional support. In addition to helping patients with personal care.We makes a real difference in people's lives by providing essential care and support during their time of need."),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildFeatureCard(
                    title: "Costomize Health tips,costomize diet plans",
                    children: [
                      _buildFeatureItem(Icons.check, Colors.green, "once in a month."),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildFeatureCard(
                    title: "Personal Yoga Trainer",
                    children: [
                      _buildFeatureItem(Icons.check, Colors.green, "four season in a month."),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildFeatureCard(
                    title: "Personal Health Coach",
                    children: [
                      _buildFeatureItem(Icons.check, Colors.green, "four season in a month."),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildFeatureCard(
                    title: "Physiotherapy Seasons",
                    children: [
                      _buildFeatureItem(Icons.check, Colors.green, "two season in a month."),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // Bottom Pay Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Processing Payment...")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Pay 4500/-",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({required String title, required List<Widget> children}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400, width: 1.2),
          ),
          child: Column(
            children: children,
          ),
        ),
        Positioned(
          top: -12,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00456A),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, Color iconColor, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
