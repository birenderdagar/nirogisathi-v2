import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/signup_success_dialog.dart';
import '../provider/auth_provider.dart';
import '../../../../app/di/injection.dart';

class SignupPasswordPage extends StatefulWidget {
  final String name;
  final String mobile;
  final String email;
  final String otp;

  const SignupPasswordPage({
    super.key,
    required this.name,
    required this.mobile,
    required this.email,
    required this.otp,
  });

  @override
  State<SignupPasswordPage> createState() => _SignupPasswordPageState();
}

class _SignupPasswordPageState extends State<SignupPasswordPage> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  bool _obscurePin = true;
  bool _obscureConfirm = true;
  bool _agreed = false;

  void _createAccount(AuthProvider provider) async {
    final pin = _pinController.text.trim();
    final confirm = _confirmPinController.text.trim();

    if (pin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("MPIN must be exactly 4 digits")),
      );
      return;
    }

    if (pin != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("MPIN does not match")),
      );
      return;
    }

    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please accept Terms & Privacy Policy"),
        ),
      );
      return;
    }

    // Call the signUp method in AuthProvider
    await provider.signUp(
      name: widget.name,
      mobile: widget.mobile,
      email: widget.email,
      mpin: pin,
    );

    if (provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage!)),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return SignupSuccessDialog(name: widget.name);
        },
      );
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isValid =
        _pinController.text.length == 4 &&
            _confirmPinController.text.length == 4;

    return ChangeNotifierProvider(
      create: (_) => getIt<AuthProvider>(),
      child: Consumer<AuthProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () => context.pop(),
                            icon: const Icon(Icons.arrow_back),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Hi ${widget.name}",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Create your 4-digit MPIN",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 30),
                          TextField(
                            controller: _pinController,
                            obscureText: _obscurePin,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            maxLength: 4,
                            textAlign: TextAlign.center,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(
                              fontSize: 24,
                              letterSpacing: 12,
                            ),
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "••••",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePin
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePin = !_obscurePin;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _confirmPinController,
                            obscureText: _obscureConfirm,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            maxLength: 4,
                            textAlign: TextAlign.center,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(
                              fontSize: 24,
                              letterSpacing: 12,
                            ),
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "••••",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirm = !_obscureConfirm;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Checkbox(
                                value: _agreed,
                                activeColor: const Color(0xFF00456A),
                                onChanged: (v) {
                                  setState(() {
                                    _agreed = v ?? false;
                                  });
                                },
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: "I agree to ",
                                    style: const TextStyle(color: Colors.black, fontSize: 14),
                                    children: [
                                      TextSpan(
                                        text: "Terms",
                                        style: const TextStyle(
                                          color: Color(0xFF00456A),
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            context.push('/terms');
                                          },
                                      ),
                                      const TextSpan(text: " & "),
                                      TextSpan(
                                        text: "Privacy Policy",
                                        style: const TextStyle(
                                          color: Color(0xFF00456A),
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            context.push('/privacy');
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: InkWell(
                              onTap: () => context.go('/login'),
                              child: const Text(
                                "Already have an account? Log in",
                                style: TextStyle(
                                  color: Color(0xFF00456A),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          AuthButton(
                            text: "Create Account",
                            onPressed: (isValid && _agreed && !provider.isLoading)
                                ? () => _createAccount(provider)
                                : null,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  if (provider.isLoading)
                    const ColoredBox(
                      color: Colors.black26,
                      child: Center(
                        child: CircularProgressIndicator(color: Color(0xFF00456A)),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
