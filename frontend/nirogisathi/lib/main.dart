import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'app/di/injection.dart';
import 'app/router/app_router.dart';
import 'firebase_options.dart';
import 'features/Splash/presentation/provider/splash_provider.dart';
import 'features/auth/presentation/provider/auth_provider.dart';
import 'features/location/presentation/provider/location_provider.dart';
import 'features/cart/presentation/providers/cart_provider.dart';
import 'features/my_health_team/presentation/providers/health_team_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Dependency Injection
  await init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // ✅ Providing Global Providers at the root to prevent "disposed" errors
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: getIt<SplashProvider>()),
        ChangeNotifierProvider.value(value: getIt<AuthProvider>()),
        ChangeNotifierProvider.value(value: getIt<LocationProvider>()),
        ChangeNotifierProvider.value(value: getIt<CartProvider>()),
        ChangeNotifierProvider.value(value: getIt<HealthTeamProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
