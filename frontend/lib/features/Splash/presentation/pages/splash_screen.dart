import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../app/di/injection.dart';
import '../provider/splash_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    
    // Start fetching auth state early
    getIt<SplashProvider>().init();

    _controller = VideoPlayerController.asset(
      'assets/videos/nirogi_splash.mp4',
    )..initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      _controller.setVolume(0.06);
      _controller.play();
    });

    _controller.addListener(_videoListener);
  }

  void _videoListener() {
    if (_controller.value.isInitialized &&
        _controller.value.position >= _controller.value.duration) {
      _controller.removeListener(_videoListener);
      // Notify provider that video is done
      getIt<SplashProvider>().setVideoFinished();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF00456A),
        child: _controller.value.isInitialized
            ? Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        )
            : const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }
}
