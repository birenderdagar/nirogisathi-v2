import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/location_provider.dart';
import '../../../../app/di/injection.dart';
import '../../../Splash/presentation/provider/splash_provider.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Use the global provider instead of creating a new one that gets disposed
    return Consumer<LocationProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 📍 Attractive Animated Icon
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF00456A).withOpacity(0.1),
                        ),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Pulsing effect
                              Container(
                                height: 120 + (20 * _animationController.value),
                                width: 120 + (20 * _animationController.value),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF00456A).withOpacity(0.15),
                                ),
                              ),
                              const Icon(
                                Icons.location_on_rounded,
                                size: 90,
                                color: Color(0xFF00456A),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 40),
                  
                  const Text(
                    "Enable Location",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00456A),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  const Text(
                    "To provide you with the best services and accurate data, we need to access your device's location.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  if (provider.isLoading)
                    const CircularProgressIndicator(color: Color(0xFF00456A))
                  else ...[
                    // 🔘 Allow Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () async {
                          await provider.fetchCurrentLocation();
                          // Use isFreshLogin: true to bypass MPIN check and go to dashboard
                          getIt<SplashProvider>().refresh(isFreshLogin: true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00456A),
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: const Color(0xFF00456A).withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "ALLOW ACCESS",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // 🔘 Skip Button
                    TextButton(
                      onPressed: () {
                        // Use isFreshLogin: true to bypass MPIN check even if skipped
                        getIt<SplashProvider>().refresh(isFreshLogin: true);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF00456A),
                      ),
                      child: const Text(
                        "Maybe Later",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  
                  if (provider.errorMessage != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.withOpacity(0.2)),
                      ),
                      child: Text(
                        provider.errorMessage!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
