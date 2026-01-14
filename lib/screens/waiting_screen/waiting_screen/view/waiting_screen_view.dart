import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/waiting_screen/waiting_screen/controller/waiting_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class WaitingScreenView extends BasePage<WaitingScreenController> {
  const WaitingScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const _SplashVideoPlayer(),
    );
  }
}

class _SplashVideoPlayer extends StatefulWidget {
  const _SplashVideoPlayer();

  @override
  State<_SplashVideoPlayer> createState() => _SplashVideoPlayerState();
}

class _SplashVideoPlayerState extends State<_SplashVideoPlayer> {
  VideoPlayerController? _controller;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    // Try to load video in background, but don't wait for it
    _loadVideoInBackground();
  }

  void _loadVideoInBackground() {
    // Load video asynchronously without blocking
    // Use a small delay to ensure assets are fully loaded
    Future.delayed(const Duration(milliseconds: 100), () async {
      try {
        final controller = VideoPlayerController.asset('assets/app/splash_video.mp4');
        
        // Initialize with timeout to prevent hanging
        await controller.initialize().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            controller.dispose();
            throw Exception('Video initialization timeout');
          },
        );
        
        if (!mounted) {
          controller.dispose();
          return;
        }
        
        if (controller.value.isInitialized) {
          // Play video once (no looping) so full video plays
          controller.setLooping(false);
          controller.setVolume(0.0);
          
          // Notify controller about video duration so it can wait for full playback
          final duration = controller.value.duration;
          if (duration.inMilliseconds > 0) {
            controller.play().then((_) {
              // Notify the controller about video duration
              Get.find<WaitingScreenController>().setVideoDuration(duration);
            });
          }
          
          // Add listener to detect when video ends
          controller.addListener(_videoListener);
          
          if (mounted) {
            setState(() {
              _controller = controller;
              _videoReady = true;
            });
          } else {
            controller.dispose();
          }
        } else {
          controller.dispose();
        }
      } catch (e) {
        // Silently fail - gradient background is already showing
        // Video file might not be included in build or path is incorrect
        debugPrint('Video not available, using gradient background: $e');
      }
    });
  }

  void _videoListener() {
    if (_controller == null) return;
    
    // Check if video has ended
    if (_controller!.value.position >= _controller!.value.duration &&
        _controller!.value.duration.inMilliseconds > 0) {
      debugPrint('Video playback completed');
      // Video has finished playing
      _controller!.removeListener(_videoListener);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show video if ready, otherwise show gradient immediately
    return _videoReady && _controller != null && _controller!.value.isInitialized
        ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            ),
          )
        : Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF3D0C11), Color(0xFF5D1C21)],
              ),
            ),
          );
  }
}
