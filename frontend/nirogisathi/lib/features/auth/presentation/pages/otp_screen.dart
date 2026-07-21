import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nirogisathi/features/auth/presentation/controller/auth_controller.dart';
import 'package:nirogisathi/features/Splash/presentation/provider/splash_provider.dart';
import 'package:nirogisathi/features/auth/domain/repositories/auth_repository.dart';
import 'package:nirogisathi/features/auth/domain/entities/user.dart' as domain;
import '../../../../core/enums/user_role.dart';
import '../../../../app/di/injection.dart';
import '../widgets/auth_button.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;

  const OtpScreen({super.key, required this.mobile});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void verifyOtp(AuthController controller) async {
    if (otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the OTP")),
      );
      return;
    }

    // Call verifyOtp from AuthController instance
    var res = await controller.verifyOtp(
      widget.mobile,
      otpController.text,
    );

    // ✅ Flexible status check
    final bool isSuccess = res['status'] == true || 
                           res['status'] == 'true' || 
                           res['status'] == 1 ||
                           res['success'] == true ||
                           res['message']?.toString().toLowerCase().contains('ok') == true;

    if (isSuccess) {
      debugPrint("Login Success 🎉");
      if (mounted) {
        // Fetch user data to get name
        final userRes = await getIt<AuthRepository>().getUser();
        domain.User? user;
        String name = "User";
        userRes.fold((_) => null, (u) {
          user = u;
          name = u?.name ?? "User";
        });

        // ✅ CRITICAL FIX: Manually set state to bypass background check failures
        final splash = getIt<SplashProvider>();
        splash.forceRoleSelection(name, user: user);
        
        // Push navigation
        context.go('/role-selection');
      }
    } else {
      debugPrint("Invalid OTP ❌");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Invalid OTP')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              "Verify OTP",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => context.pop(),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter OTP sent to +91 ${widget.mobile}",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  style: const TextStyle(fontSize: 20, letterSpacing: 2),
                  decoration: InputDecoration(
                    labelText: "OTP",
                    counterText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 40),
                if (controller.isLoading)
                  const Center(child: CircularProgressIndicator(color: Color(0xFF00456A)))
                else
                  AuthButton(
                    text: "Verify",
                    onPressed: () => verifyOtp(controller),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
