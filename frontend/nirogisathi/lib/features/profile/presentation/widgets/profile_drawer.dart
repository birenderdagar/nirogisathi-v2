import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nirogisathi/app/di/injection.dart';
import 'package:nirogisathi/core/enums/app_state.dart';
import 'package:nirogisathi/features/Splash/presentation/provider/splash_provider.dart';
import 'package:nirogisathi/core/utils/age_calculator.dart';
import 'package:nirogisathi/features/auth/domain/repositories/auth_repository.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Consumer<SplashProvider>(
            builder: (context, splash, _) => _buildDrawerHeader(splash),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.edit_note, "Edit Profile", onTap: () => context.push('/edit-profile')),
                _buildDrawerItem(Icons.receipt_long_outlined, "My transactions", onTap: () => context.push('/past-transactions')),
                _buildDrawerItem(Icons.shopping_bag_outlined, "My orders", onTap: () => context.push('/orders')),
                _buildDrawerItem(Icons.subscriptions_outlined, "My subscription", onTap: () => context.push('/subscription')),
                _buildDrawerItem(Icons.security_outlined, "My Insurances", onTap: () => context.push('/insurance')),
                _buildDrawerItem(Icons.location_on_outlined, "Location", onTap: () => context.push('/location-permission')),
                
                // 🔔 Notifications with On/Off Toggle
                ListTile(
                  leading: const Icon(Icons.notifications_outlined, color: Colors.black54),
                  title: const Text("Notifications", style: TextStyle(fontSize: 14)),
                  trailing: Switch(
                    value: _notificationsEnabled,
                    activeColor: const Color(0xFF00456A),
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                ),

                _buildDrawerItem(Icons.help_outline, "FAQ", onTap: () => context.push('/faq')),
                _buildDrawerItem(Icons.headset_mic_outlined, "Contact us", onTap: () => context.push('/contact')),
                _buildDrawerItem(Icons.star_outline, "My Ratings", onTap: () => context.push('/ratings')),
                _buildDrawerItem(Icons.privacy_tip_outlined, "Privacy Policy", onTap: () => context.push('/privacy')),
                _buildDrawerItem(Icons.lock_reset, "Reset Pin", onTap: () => context.push('/forgot-mpin')),
                _buildDrawerItem(Icons.swap_horiz_rounded, "Switch Role", onTap: () {
                  Navigator.pop(context);
                  getIt<SplashProvider>().goToRoleSelection();
                }),
                const Divider(),
                _buildDrawerItem(Icons.logout, "Log Out", textColor: Colors.red, iconColor: Colors.red, onTap: () async {
                  await getIt<AuthRepository>().logout();
                  getIt<SplashProvider>().refresh();
                }),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "App Version 7.1",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(SplashProvider splash) {
    final user = splash.user;
    String name = user?.name ?? "User";
    if (name == "User" && splash.state is RoleSelectionRequired) {
      name = (splash.state as RoleSelectionRequired).userName;
    } else if (name == "User" && splash.state is AuthenticatedWithRole) {
      name = (splash.state as AuthenticatedWithRole).userName;
    }
    final mobile = user?.mobile ?? "";
    final photoUrl = user?.photoUrl;
    final completion = user?.profileCompletion ?? 0.0;
    final percentage = (completion * 100).toInt();

    ImageProvider? imageProvider;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      if (photoUrl.startsWith('http')) {
        imageProvider = NetworkImage(photoUrl);
      } else if (photoUrl.startsWith('/') || photoUrl.contains('data/user')) {
        imageProvider = FileImage(File(photoUrl));
      }
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      color: const Color(0xFF00456A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                backgroundImage: imageProvider,
                child: imageProvider == null
                    ? const Icon(Icons.person, size: 45, color: Color(0xFF00456A))
                    : null,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      mobile,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text("$percentage%", style: const TextStyle(color: Colors.white, fontSize: 12)),
                        const SizedBox(width: 5),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: completion,
                            backgroundColor: Colors.white24,
                            color: percentage < 40 ? Colors.red : (percentage < 80 ? Colors.orange : Colors.green),
                            minHeight: 4,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      percentage == 100 ? "Profile completed" : "Complete your profile",
                      style: const TextStyle(color: Colors.white60, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeaderStat("${calculateAge(user?.dob)} Age"),
              _buildHeaderStat("${user?.weight ?? 'N/A'} Kg"),
              _buildHeaderStat("${user?.height ?? 'N/A'} Cm"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {required VoidCallback onTap, Color? textColor, Color? iconColor}) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.black54),
      title: Text(
        title,
        style: TextStyle(color: textColor ?? Colors.black87, fontSize: 14),
      ),
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}
