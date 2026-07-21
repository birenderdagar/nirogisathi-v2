import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HealthAssistantCard extends StatefulWidget {
  final bool isSubscribed;

  const HealthAssistantCard({
    super.key,
    this.isSubscribed = false,
  });

  @override
  State<HealthAssistantCard> createState() => _HealthAssistantCardState();
}

class _HealthAssistantCardState extends State<HealthAssistantCard> {
  bool _localUnlocked = false;

  @override
  Widget build(BuildContext context) {
    const String phoneNumber = "9311951176";
    final bool isUnlocked = widget.isSubscribed || _localUnlocked;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Main Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("assets/images/health_assistant.jpg"),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Anjali Ray", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text("Your Personal Health Assistant", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text("Emp ID: HA0044", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const Column(
                      children: [
                         Icon(Icons.star, color: Colors.orange, size: 18),
                         Text("4.8/5", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isUnlocked ? () => _launchCaller(phoneNumber) : null,
                        icon: const Icon(Icons.call, size: 18),
                        label: const Text("Call me"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00456A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isUnlocked ? () => _launchWhatsApp(phoneNumber) : null,
                        icon: const Icon(Icons.message, size: 18),
                        label: const Text("WhatsApp"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          // Lock Overlay
          if (!isUnlocked)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.white.withOpacity(0.6),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock_person, color: Color(0xFF00456A), size: 30),
                            const SizedBox(height: 5),
                            const Text(
                              "please subscribe to unlock this feature, after that this section will unlock",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF00456A),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 35,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _localUnlocked = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00456A),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                ),
                                child: const Text(
                                  "OK",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _launchCaller(String number) async {
    final Uri url = Uri.parse('tel:+91$number');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (e) {
      debugPrint("Error launching dialer: $e");
    }
  }

  void _launchWhatsApp(String number) async {
    // Try native scheme first, then fallback to web link
    final Uri whatsappUrl = Uri.parse("whatsapp://send?phone=+91$number");
    final Uri httpsUrl = Uri.parse("https://wa.me/91$number");

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl);
      } else {
        // Fallback to web URL
        if (await canLaunchUrl(httpsUrl)) {
          await launchUrl(httpsUrl, mode: LaunchMode.externalApplication);
        } else {
          debugPrint("Could not launch WhatsApp");
        }
      }
    } catch (e) {
      debugPrint("Error launching WhatsApp: $e");
    }
  }
}
