import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_button.dart';

class SignupOtpPage extends StatefulWidget {
  final String name;
  final String mobile;
  final String email;

  const SignupOtpPage({
    super.key,
    required this.name,
    required this.mobile,
    required this.email,
  });

  @override
  State<SignupOtpPage> createState() => _SignupOtpPageState();
}

class _SignupOtpPageState extends State<SignupOtpPage> {
  final TextEditingController _otpController = TextEditingController();

  int _secondsRemaining = 30;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = 30;
    _canResend = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _verifyOtp() {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid 6-digit OTP")),
      );
      return;
    }
    context.push('/signup-password', extra: {
      'name': widget.name,
      'mobile': widget.mobile,
      'email': widget.email,
      'otp': otp,
    });
  }

  void _resendOtp() {
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP resent successfully")),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOtpValid = _otpController.text.length == 6;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(height: 20),
              const Text(
                "Verify OTP",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "OTP sent to +91 ${widget.mobile}",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                maxLength: 6,
                textAlign: TextAlign.center,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(
                  fontSize: 24,
                  letterSpacing: 6,
                ),
                decoration: InputDecoration(
                  hintText: "------",
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: _canResend
                    ? TextButton(
                  onPressed: _resendOtp,
                  child: const Text(
                    "Resend OTP",
                    style: TextStyle(color: Color(0xFF00456A)),
                  ),
                )
                    : Text(
                  "Resend OTP in $_secondsRemaining sec",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              const Spacer(),
              AuthButton(
                text: "Verify",
                onPressed: isOtpValid ? _verifyOtp : null,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
