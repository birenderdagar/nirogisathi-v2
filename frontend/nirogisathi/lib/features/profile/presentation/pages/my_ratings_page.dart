import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class MyRatingsPage extends StatefulWidget {
  const MyRatingsPage({super.key});

  @override
  State<MyRatingsPage> createState() => _MyRatingsPageState();
}

class _MyRatingsPageState extends State<MyRatingsPage> {
  int _rating = 0;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String _getFunnyMessage() {
    switch (_rating) {
      case 1:
        return "Ouch! Did we accidentally step on your toe? 😭\nTell us what we did wrong!";
      case 2:
        return "We're like a cold cup of tea. Disappointing, but drinkable? ☕\nWe'll try to heat things up!";
      case 3:
        return "Perfectly average. Like a sandwich with no mayo. 🥪\nNot bad, but not exactly a party.";
      case 4:
        return "Almost legendary! Like a unicorn with a slightly crooked horn. 🦄\nWe're so close to perfection!";
      case 5:
        return "You love us! We're blushing... stop it! 😍\n(Actually, don't stop, we love the attention).";
      default:
        return "Tap a star to judge us! \nDon't be shy, we can take it (maybe).";
    }
  }

  String _getEmoji() {
    switch (_rating) {
      case 1: return "😫";
      case 2: return "😐";
      case 3: return "😏";
      case 4: return "😎";
      case 5: return "🥳";
      default: return "🤔";
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF00456A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Judge Us!"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Text(
                      _getEmoji(),
                      key: ValueKey<String>(_getEmoji()),
                      style: const TextStyle(fontSize: 100),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "How was your experience?",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 80,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _getFunnyMessage(),
                        key: ValueKey<String>(_getFunnyMessage()),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                          size: 45,
                          color: index < _rating ? Colors.amber : Colors.grey.shade300,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = index + 1;
                            if (_rating == 5) {
                              _confettiController.play();
                            }
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 50),
                  if (_rating > 0)
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_rating == 5 ? "Yay! We're printing this and putting it on the fridge! 📝" : "Feedback received! We're going to hide in the corner and think about what we did. 🏃💨"),
                            backgroundColor: primaryColor,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text("Submit Judgment", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
