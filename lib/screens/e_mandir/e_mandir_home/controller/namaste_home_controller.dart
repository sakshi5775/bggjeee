import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/data_model/festival_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/service/e_mandir_home_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../data_model/e_mandir_dataModels/e_mandir_home_model.dart';

class NamasteHomeController extends BaseController
    with GetTickerProviderStateMixin {
  final selectedIndex = 0.obs;
  final PageController darshanController = PageController();
  final currentDarshanIndex = 0.obs;
  final AudioPlayer shankhPlayer = AudioPlayer();
  final isShankhPlaying = false.obs;
  final volume = 1.0.obs; // Volume range: 0.0 to 1.0
  final showVolumeSlider = false.obs;

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

  final EMandirHomeService _eMandirHomeService = EMandirHomeService();

  // Festivals
  final RxList<FestivalModel> festivals = <FestivalModel>[].obs;
  final RxBool isLoadingFestivals = true.obs;

  @override
  void onInit() {
    super.onInit();
    // _playShankhOnInit();
    _initializeFullscreenAnimation();
    getAllPunyaWallet();
    _loadFestivals();
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

  final Rxn<EMandirHomeDataModel> punyaWallet = Rxn<EMandirHomeDataModel>();

  Future<void> getAllPunyaWallet() async {
    try {
      setLoadingState(true);

      final response = await _eMandirHomeService.punyaWallet();

      if (response != null) {
        punyaWallet.value = response;
        print("Punya wallet: ${punyaWallet.value}");
      }
    } catch (e) {
      print("Error fetching punya wallet: $e");
    } finally {
      setLoadingState(false);
    }
  }

  Future<void> _loadFestivals() async {
    isLoadingFestivals.value = true;
    try {
      final response = await _eMandirHomeService.getFestivals();
      if (response != null && response.success && response.items.isNotEmpty) {
        festivals.value = response.items;
      }
    } catch (e) {
      print('Error loading festivals: $e');
    } finally {
      isLoadingFestivals.value = false;
    }
  }

  // Future<void> dailyCheckIn() async {
  //   try {
  //     setLoadingState(true);

  //     final success = await _eMandirHomeService.dailyCheckIn();

  //     if (success) {
  //       getAllPunyaWallet();
  //     }
  //   } catch (e) {
  //     print("Error fetching punya wallet: $e");
  //   } finally {
  //     setLoadingState(false);
  //   }
  // }

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

  void stopShankh() {
    try {
      if (shankhPlayer.state == PlayerState.playing) {
        shankhPlayer.stop();
      }
      isShankhPlaying.value = false;
    } catch (e) {
      print("Error stopping shankh player: $e");
    }
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
    stopShankh();
    Get.toNamed(AppRoutes.virtualDarshan);
  }

  void navigateToDevotionalLibrary() {
    stopShankh();
    Get.toNamed(AppRoutes.devotionalLibrary);
  }

  void navigateToPunyaMudra() {
    stopShankh();
    Get.toNamed(
      AppRoutes.punyaMudra,
      arguments: {'punyaWallet': punyaWallet.value},
    );
  }

  void navigateQuickAction(int index) {
    stopShankh();
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

