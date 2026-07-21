import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';

class SignupSuccessDialog extends StatefulWidget {
  final String name;

  const SignupSuccessDialog({super.key, required this.name});

  @override
  State<SignupSuccessDialog> createState() => _SignupSuccessDialogState();
}

class _SignupSuccessDialogState extends State<SignupSuccessDialog> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 4));

    _confettiController.play();

    /// 🔁 Auto navigate after 3 sec
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [

          /// 🎊 Confetti
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            numberOfParticles: 25,
            maxBlastForce: 20,
            minBlastForce: 8,
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// 🎬 Lottie Animation
                SizedBox(
                  height: 120,
                  child: Lottie.asset('assets/animations/success.json'),
                ),

                const SizedBox(height: 10),

                /// 🔹 Title
                const Text(
                  "Congratulations 🎉",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                /// 🔹 Subtitle
                Text(
                  "Welcome ${widget.name}!\nYour account has been created successfully.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 20),

                /// 🔹 Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("Continue"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}