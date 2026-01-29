import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../../core/routes/app_routes.dart';

class NamasteHomeController extends GetxController
    with GetTickerProviderStateMixin {
  final selectedIndex = 0.obs;
  final PageController darshanController = PageController();
  final currentDarshanIndex = 0.obs;
  final AudioPlayer shankhPlayer = AudioPlayer();
  final isShankhPlaying = false.obs;
  final volume = 1.0.obs; // Volume range: 0.0 to 1.0
  final showVolumeSlider = false.obs;
  bool _hasNavigatedAway = false; // Track if we've navigated away

  // Animation for fullscreen button
  late AnimationController fullscreenAnimationController;
  late Animation<double> fullscreenScaleAnimation;
  late Animation<double> fullscreenPulseAnimation;

  final List<String> darshanImages = [
    AppConstant.eMandirLiveDarshan,
    AppConstant.eMandirLiveDarshan,
    AppConstant.eMandirLiveDarshan,
    AppConstant.eMandirLiveDarshan,
  ];

  @override
  void onInit() {
    super.onInit();
    _playShankhOnInit();
    _initializeFullscreenAnimation();
  }

  void _initializeFullscreenAnimation() {
    // Scale animation for bounce effect
    fullscreenAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Scale animation (bounce effect)
    fullscreenScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.15,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 0.3,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.15,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 0.7,
      ),
    ]).animate(fullscreenAnimationController);

    // Pulse animation for outer ring
    fullscreenPulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: fullscreenAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation and repeat it
    fullscreenAnimationController.repeat();
  }

  @override
  void onReady() {
    super.onReady();
    // Resume audio if we've navigated away and come back
    // This will be called when the route becomes active again
    if (_hasNavigatedAway) {
      Future.delayed(const Duration(milliseconds: 300), () {
        resumeAudioIfNeeded();
        _hasNavigatedAway = false; // Reset flag
      });
    }
  }

  void resumeAudioIfNeeded() {
    // Only resume if audio is not playing, we've navigated away, and player is not disposed
    if (!isShankhPlaying.value && _hasNavigatedAway) {
      try {
        // Check if player is still valid (not disposed)
        if (shankhPlayer.state != PlayerState.disposed) {
          shankhPlayer.setReleaseMode(ReleaseMode.loop);
          shankhPlayer.setVolume(volume.value);
          shankhPlayer.play(UrlSource(AppConstant.shankhMp3)).catchError((e) {
            print("SHANKH AUDIO ERROR on resume: $e");
          });
          isShankhPlaying.value = true;
          _hasNavigatedAway = false; // Reset flag after resuming
        }
      } catch (e) {
        print("Error resuming shankh audio: $e");
      }
    }
  }

  @override
  void onClose() {
    // Stop and dispose animation controller
    fullscreenAnimationController.dispose();

    // Stop and dispose audio player first
    try {
      shankhPlayer.stop();
    } catch (e) {
      print("Error stopping shankh player: $e");
    }

    try {
      shankhPlayer.dispose();
    } catch (e) {
      print("Error disposing shankh player: $e");
    }

    // Dispose page controller
    darshanController.dispose();

    // GetX will automatically delete the controller when using Get.put with permanent: false
    super.onClose();
  }

  void _playShankhOnInit() {
    try {
      shankhPlayer.setReleaseMode(ReleaseMode.loop);
      shankhPlayer.setVolume(volume.value);
      shankhPlayer.play(UrlSource(AppConstant.shankhMp3)).catchError((e) {
        print("SHANKH AUDIO ERROR: $e");
      });
      isShankhPlaying.value = true;
    } catch (e) {
      print("Error playing shankh on init: $e");
    }
  }

  void toggleShankh() {
    if (shankhPlayer.state == PlayerState.playing) {
      shankhPlayer.stop();
      isShankhPlaying.value = false;
    } else {
      shankhPlayer.setReleaseMode(ReleaseMode.loop);
      shankhPlayer.setVolume(volume.value);
      shankhPlayer.play(UrlSource(AppConstant.shankhMp3)).catchError((e) {
        print("SHANKH AUDIO ERROR: $e");
      });
      isShankhPlaying.value = true;
    }
  }

  void toggleVolumeSlider() {
    showVolumeSlider.value = !showVolumeSlider.value;
  }

  void setVolume(double newVolume) {
    volume.value = newVolume.clamp(0.0, 1.0);
    shankhPlayer.setVolume(volume.value);
  }

  void increaseVolume() {
    final newVolume = (volume.value + 0.1).clamp(0.0, 1.0);
    setVolume(newVolume);
  }

  void decreaseVolume() {
    final newVolume = (volume.value - 0.1).clamp(0.0, 1.0);
    setVolume(newVolume);
  }

  void muteUnmute() {
    if (volume.value > 0.0) {
      setVolume(0.0);
    } else {
      setVolume(1.0);
    }
  }

  void onDarshanPageChanged(int index) {
    currentDarshanIndex.value = index;
  }

  void navigateToVirtualDarshan() {
    // Only stop audio, don't dispose - we'll restart when coming back
    shankhPlayer.stop();
    isShankhPlaying.value = false;
    _hasNavigatedAway = true; // Mark that we're navigating away
    Get.toNamed(AppRoutes.virtualDarshan);
  }

  void navigateToDevotionalLibrary() {
    // Only stop audio, don't dispose - we'll restart when coming back
    shankhPlayer.stop();
    isShankhPlaying.value = false;
    _hasNavigatedAway = true; // Mark that we're navigating away
    Get.toNamed(AppRoutes.devotionalLibrary);
  }

  void navigateToPunyaMudra() {
    // Only stop audio, don't dispose - we'll restart when coming back
    shankhPlayer.stop();
    isShankhPlaying.value = false;
    _hasNavigatedAway = true; // Mark that we're navigating away
    Get.toNamed(AppRoutes.punyaMudra);
  }

  void navigateQuickAction(int index) {
    shankhPlayer.stop();
    isShankhPlaying.value = false;
    _hasNavigatedAway = true;
    switch (index) {
      case 0:
        Get.toNamed(AppRoutes.comingSoon);
        break;
      case 1:
        Get.toNamed(AppRoutes.bookPuja);
        break;
      case 2:
        Get.toNamed(AppRoutes.comingSoon);
        break;
      case 3:
        Get.toNamed(AppRoutes.comingSoon);
        break;
      case 4:
        Get.toNamed(AppRoutes.myBookings);
        break;
      default:
    }
  }
}
