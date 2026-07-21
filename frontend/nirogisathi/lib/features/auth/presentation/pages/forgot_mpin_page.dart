import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_button.dart';

class ForgotMpinPage extends StatefulWidget {
  const ForgotMpinPage({super.key});

  @override
  State<ForgotMpinPage> createState() => _ForgotMpinPageState();
}

class _ForgotMpinPageState extends State<ForgotMpinPage> {
  final PageController _pageController = PageController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    } else {
      _resetMpin();
    }
  }

  void _resetMpin() {
    final pin = _newPinController.text.trim();
    final confirm = _confirmPinController.text.trim();

    if (pin != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("MPINs do not match")),
      );
      return;
    }

    if (pin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter 4-digit MPIN")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("MPIN reset successfully!")),
    );
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot MPIN"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentPage > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              setState(() {
                _currentPage--;
              });
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildMobileStep(),
          _buildOtpStep(),
          _buildNewPinStep(),
        ],
      ),
    );
  }

  Widget _buildMobileStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Enter your mobile number to reset MPIN",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            decoration: const InputDecoration(
              labelText: "Mobile Number",
              border: OutlineInputBorder(),
              prefixText: "+91 ",
            ),
          ),
          const Spacer(),
          AuthButton(
            text: "Send OTP",
            onPressed: () {
              if (_mobileController.text.length == 10) {
                _nextPage();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOtpStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter the 6-digit OTP sent to +91 ${_mobileController.text}",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, letterSpacing: 8),
            decoration: const InputDecoration(
              hintText: "------",
              border: OutlineInputBorder(),
            ),
          ),
          const Spacer(),
          AuthButton(
            text: "Verify OTP",
            onPressed: () {
              if (_otpController.text.length == 6) {
                _nextPage();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNewPinStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Create your new 4-digit MPIN",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _newPinController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, letterSpacing: 12),
            decoration: const InputDecoration(
              hintText: "••••",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Confirm new MPIN",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _confirmPinController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, letterSpacing: 12),
            decoration: const InputDecoration(
              hintText: "••••",
              border: OutlineInputBorder(),
            ),
          ),
          const Spacer(),
          AuthButton(
            text: "Reset MPIN",
            onPressed: _resetMpin,
          ),
        ],
      ),
    );
  }
}
