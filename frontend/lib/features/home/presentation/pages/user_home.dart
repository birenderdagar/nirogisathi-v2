import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nirogisathi/core/utils/time_greeting.dart';
import 'package:nirogisathi/core/enums/app_state.dart';
import 'package:nirogisathi/features/Splash/presentation/provider/splash_provider.dart';
import '../widgets/location_ribbon.dart';
import 'package:nirogisathi/features/profile/presentation/widgets/profile_drawer.dart';

// Import widgets
import '../widgets/my_calendar.dart';
import '../widgets/home_banners.dart';
import '../widgets/health_assistant_card.dart';
import '../widgets/subscription_plan_card.dart';
import '../widgets/current_updates_card.dart';
import '../widgets/digital_health_locker.dart';
import '../widgets/health_team_grid.dart';
import '../widgets/other_services_list.dart';
import '../widgets/offers_banner.dart';
import '../widgets/join_community_list.dart';
import '../widgets/client_say_list.dart';
import '../widgets/magzine_list.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    final greeting = getGreeting();
    
    return Scaffold(
      drawer: const ProfileDrawer(),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
            Consumer<SplashProvider>(
              builder: (context, splash, _) {
                String name = splash.user?.name ?? "User";
                if (name == "User" && splash.state is RoleSelectionRequired) {
                  name = (splash.state as RoleSelectionRequired).userName;
                } else if (name == "User" && splash.state is AuthenticatedWithRole) {
                  name = (splash.state as AuthenticatedWithRole).userName;
                }
                return Text(
                  name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                );
              }
            ),
          ],
        ),
        backgroundColor: const Color(0xFF00456A),
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Consumer<SplashProvider>(
              builder: (context, splash, _) {
                final photoUrl = splash.user?.photoUrl;
                
                ImageProvider? imageProvider;
                if (photoUrl != null && photoUrl.isNotEmpty) {
                  if (photoUrl.startsWith('http')) {
                    imageProvider = NetworkImage(photoUrl);
                  } else if (photoUrl.startsWith('/') || photoUrl.contains('data/user')) {
                    imageProvider = FileImage(File(photoUrl));
                  }
                }

                return CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white24,
                  backgroundImage: imageProvider,
                  child: imageProvider == null
                      ? const Icon(Icons.person, size: 20, color: Colors.white)
                      : null,
                );
              },
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            tooltip: "My Cart",
            icon: const Badge(
              label: Text("2"),
              child: Icon(Icons.shopping_cart_outlined),
            ),
            onPressed: () => context.push('/cart'),
          ),
          IconButton(
            tooltip: "Notifications",
            icon: const Badge(
              child: Icon(Icons.notifications_none_rounded),
            ),
            onPressed: () => context.push('/notifications'),
          ),
        ],
      ),
      body: Column(
        children: [
          const LocationRibbon(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MyCalendar(),
                  const SizedBox(height: 10),
                  const HomeBanners(),
                  const SizedBox(height: 20),
                  const HealthAssistantCard(),
                  const SizedBox(height: 20),
                  const SubscriptionPlanCard(),
                  const SizedBox(height: 20),
                  const CurrentUpdatesCard(),
                  const SizedBox(height: 20),
                  const DigitalHealthLocker(),
                  const SizedBox(height: 20),
                  const HealthTeamGrid(),
                  const SizedBox(height: 20),
                  const OtherServicesList(),
                  const SizedBox(height: 20),
                  const OffersBanner(),
                  const SizedBox(height: 20),
                  const JoinCommunityList(),
                  const SizedBox(height: 20),
                  const ClientSayList(),
                  const SizedBox(height: 20),
                  const MagzineList(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
