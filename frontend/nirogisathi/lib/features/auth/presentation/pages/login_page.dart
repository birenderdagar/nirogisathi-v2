import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection.dart';
import 'package:nirogisathi/features/Splash/presentation/provider/splash_provider.dart';
import '../provider/auth_provider.dart';
import 'package:nirogisathi/features/auth/presentation/controller/auth_controller.dart';
import '../../domain/entities/user.dart';
import 'otp_screen.dart';
import '../widgets/auth_button.dart';

class LoginPage extends StatefulWidget {
  final String? initialMobile;
  
  const LoginPage({super.key, this.initialMobile});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController mobileController;
  final mpinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    mobileController = TextEditingController(text: widget.initialMobile);
    
    // 🛠️ Run diagnostic on startup to cross-check backend
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<AuthController>().debugCheckBackend();
    });
  }

  @override
  void dispose() {
    mobileController.dispose();
    mpinController.dispose();
    super.dispose();
  }

  void _login(AuthController controller) async {
    if (!_formKey.currentState!.validate()) return;

    await controller.login(
      mobileController.text.trim(),
      mpinController.text.trim(),
    );

    if (controller.user != null) {
      _handleLoginSuccess(controller.user!);
    }
  }

  void _handleLoginSuccess(User user) {
    debugPrint("🚀 [UI] Login successful. Forcing Role Selection for ${user.name}...");
    
    // 1. Update State (This triggers the Router's refreshListenable)
    getIt<SplashProvider>().forceRoleSelection(user.name, user: user);
    
    // 2. Clear snackbars and show success
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Login successful! Welcome back."),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );

    // 3. Manual navigation as a safety fallback
    if (mounted) {
       context.go('/role-selection');
    }
  }

  void _sendOtp(BuildContext context, AuthController controller) async {
    if (mobileController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid 10-digit mobile number")),
      );
      return;
    }

    var res = await controller.sendOtp(
      mobileController.text.trim(),
    );

    // ✅ Flexible status check
    final bool isSuccess = res['status'] == true || 
                           res['status'] == 'true' || 
                           res['status'] == 1 ||
                           res['success'] == true ||
                           res['message']?.toString().toLowerCase().contains('ok') == true;

    if (isSuccess) {
      if (!context.mounted) return;
      context.push('/verify-otp', extra: mobileController.text.trim());
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'] ?? "Failed to send OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => getIt<AuthController>(),
        child: Consumer<AuthController>(
          builder: (context, controller, _) {
            // ✅ Only handle errors here. Navigation is handled in the button callbacks.
            if (controller.errorMessage != null && controller.errorMessage!.isNotEmpty) {
               WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(controller.errorMessage!)),
                  );
                  controller.clearError();
               });
            }

        return Scaffold(
          body: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 🔙 Back Button
                        IconButton(
                          onPressed: () => context.go('/auth'),
                          icon: const Icon(Icons.arrow_back),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// Mobile
                        TextFormField(
                          controller: mobileController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: const InputDecoration(
                            labelText: 'Mobile Number',
                            border: OutlineInputBorder(),
                            counterText: '',
                          ),
                          validator: (value) {
                            if (value == null || value.length != 10) {
                              return 'Enter valid 10-digit mobile number';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        /// MPIN
                        TextFormField(
                          controller: mpinController,
                          obscureText: true,
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'MPIN',
                            border: OutlineInputBorder(),
                            counterText: '',
                          ),
                          validator: (value) {
                            if (value == null || value.length != 4) {
                              return 'Enter 4-digit MPIN';
                            }
                            return null;
                          },
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => context.push('/forgot-mpin'),
                            child: const Text(
                              'Forgot MPIN?',
                              style: TextStyle(color: Color(0xFF00456A)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// Login Button
                        AuthButton(
                          text: 'Login',
                          onPressed: controller.isLoading
                              ? null
                              : () => _login(controller),
                        ),

                        const SizedBox(height: 15),

                        /// Send OTP Button
                        Center(
                          child: TextButton(
                            onPressed: () => _sendOtp(context, controller),
                            child: const Text(
                              'Login with OTP',
                              style: TextStyle(
                                color: Color(0xFF00456A),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// Biometrics
                        Center(
                          child: Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.fingerprint, size: 40, color: Color(0xFF00456A)),
                                onPressed: controller.isLoading
                                    ? null
                                    : () async {
                                        await controller.loginWithBiometric();
                                        if (controller.user != null) {
                                          _handleLoginSuccess(controller.user!);
                                        }
                                      },
                              ),
                              const Text('Use Biometrics'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        /// Signup
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Text("Don't have an account? "),
                                GestureDetector(
                                  onTap: () => context.push('/signup-name'),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Color(0xFF00456A),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              if (controller.isLoading)
                const ColoredBox(
                  color: Colors.black26,
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF00456A)),
                  ),
                ),
            ],
          ),
        );
      },
    ));
  }
}
