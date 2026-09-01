import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nirogisathi/app/di/injection.dart';
import 'package:nirogisathi/features/home/data/datasources/user_subscription_remote_datasource.dart';
import 'package:nirogisathi/features/home/domain/entities/user_subscription.dart';

class HealthAssistantCard extends StatefulWidget {
  const HealthAssistantCard({super.key});

  @override
  State<HealthAssistantCard> createState() => _HealthAssistantCardState();
}

class _HealthAssistantCardState extends State<HealthAssistantCard> {
  late Future<UserSubscriptionStatus> _future;

  @override
  void initState() {
    super.initState();
    _future = getIt<UserSubscriptionRemoteDataSource>().fetchMySubscription();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserSubscriptionStatus>(
      future: _future,
      builder: (context, snapshot) {
        final status = snapshot.data;
        final isUnlocked = status?.hasActiveSubscription == true;
        final assistant = status?.healthAssistant;

        final name = assistant?.name ?? 'Health Assistant';
        final empId = assistant?.employeeId;
        final phone = (assistant?.mobile ?? '').replaceAll(RegExp(r'[^0-9]'), '');
        final rating = assistant?.rating ?? '4.8/5';
        final photoUrl = assistant?.photoUrl;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                              ? NetworkImage(photoUrl)
                              : const AssetImage('assets/images/health_assistant.jpg')
                                  as ImageProvider,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isUnlocked ? name : 'Personal Health Assistant',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const Text(
                                'Your Personal Health Assistant',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              if (isUnlocked && empId != null && empId.isNotEmpty)
                                Text(
                                  'Emp ID: $empId',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const Icon(Icons.star, color: Colors.orange, size: 18),
                            Text(
                              rating,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: isUnlocked && phone.isNotEmpty
                                ? () => _launchCaller(phone)
                                : null,
                            icon: const Icon(Icons.call, size: 18),
                            label: const Text('Call me'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00456A),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: isUnlocked && phone.isNotEmpty
                                ? () => _launchWhatsApp(phone)
                                : null,
                            icon: const Icon(Icons.message, size: 18),
                            label: const Text('WhatsApp'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green,
                              side: const BorderSide(color: Colors.green),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isUnlocked)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Colors.white.withValues(alpha: 0.6),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.lock_person, color: Color(0xFF00456A), size: 30),
                                const SizedBox(height: 5),
                                const Text(
                                  'please subscribe to unlock this feature, after that this section will unlock',
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
                                    onPressed: () => context.push('/subscription-plan/basic'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF00456A),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 40),
                                    ),
                                    child: const Text(
                                      'Subscribe',
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
      },
    );
  }

  void _launchCaller(String number) async {
    final cleaned = number.length == 10 ? number : number.replaceFirst(RegExp(r'^91'), '');
    final Uri url = Uri.parse('tel:+91$cleaned');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (e) {
      debugPrint('Error launching dialer: $e');
    }
  }

  void _launchWhatsApp(String number) async {
    final cleaned = number.length >= 10 ? number.substring(number.length - 10) : number;
    final Uri whatsappUrl = Uri.parse('whatsapp://send?phone=+91$cleaned');
    final Uri httpsUrl = Uri.parse('https://wa.me/91$cleaned');

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl);
      } else if (await canLaunchUrl(httpsUrl)) {
        await launchUrl(httpsUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching WhatsApp: $e');
    }
  }
}
