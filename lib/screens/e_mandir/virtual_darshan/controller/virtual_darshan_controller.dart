import 'dart:async';
import 'dart:math';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/god_data.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/offering_item.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/widgets/falling_flower_widget.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Falling Flower State class to hold animation data
class FallingFlowerState {
  final AnimationController animationController;
  final Animation<double> fallAnimation;
  final Animation<double> rotationAnimation;
  final double fixedX;
  final double size;
  final String imagePath;
  final double screenHeight;
  final OverlayEntry entry;

  FallingFlowerState({
    required this.animationController,
    required this.fallAnimation,
    required this.rotationAnimation,
    required this.fixedX,
    required this.size,
    required this.imagePath,
    required this.screenHeight,
    required this.entry,
  });

  double get topPosition => fallAnimation.value * screenHeight;
  double get rotationAngle => rotationAnimation.value;
  double get opacity {
    final progress = fallAnimation.value;
    if (progress > 0.85) {
      return (1.0 - progress) / 0.15;
    }
    return 1.0;
  }
}

class VirtualDarshanController extends GetxController
    with GetTickerProviderStateMixin {
  final List<GodData> godsList = [
    GodData(
      name: "Shri Ganesh",
      profileImage: AppConstant.eMandirGanesha,
      galleryImages: [
        AppConstant.eMandirGanesha,
        AppConstant.eMandirShriGanesh,
        AppConstant.eMandirGodIcon,
        AppConstant.eMandirGanesha,
        AppConstant.eMandirShriGanesh,
      ],
    ),
    GodData(
      name: "Tirupati Balaji",
      profileImage: AppConstant.eMandirTirupatiBalaji,
      galleryImages: [
        AppConstant.eMandirTirupatiBalaji,
        AppConstant.eMandirMeenakshiTemple,
        AppConstant.eMandirGoldenTemple,
        AppConstant.eMandirTirupatiBalaji,
        AppConstant.eMandirMeenakshiTemple,
      ],
    ),
    GodData(
      name: "Golden Temple",
      profileImage: AppConstant.eMandirGoldenTemple,
      galleryImages: [
        AppConstant.eMandirGoldenTemple,
        AppConstant.eMandirTirupatiBalaji,
        AppConstant.eMandirGoldenTemple,
        AppConstant.eMandirTirupatiBalaji,
        AppConstant.eMandirGoldenTemple,
      ],
    ),
    GodData(
      name: "Meenakshi Amman",
      profileImage: AppConstant.eMandirMeenakshiTemple,
      galleryImages: [
        AppConstant.eMandirMeenakshiTemple,
        AppConstant.eMandirGoldenTemple,
        AppConstant.eMandirMeenakshiTemple,
        AppConstant.eMandirGoldenTemple,
        AppConstant.eMandirMeenakshiTemple,
      ],
    ),
    GodData(
      name: "Shri Ganesh",
      profileImage: AppConstant.eMandirGanesha,
      galleryImages: [
        AppConstant.eMandirGanesha,
        AppConstant.eMandirShriGanesh,
        AppConstant.eMandirGodIcon,
        AppConstant.eMandirGanesha,
        AppConstant.eMandirShriGanesh,
      ],
    ),
    GodData(
      name: "Tirupati Balaji",
      profileImage: AppConstant.eMandirTirupatiBalaji,
      galleryImages: [
        AppConstant.eMandirTirupatiBalaji,
        AppConstant.eMandirMeenakshiTemple,
        AppConstant.eMandirGoldenTemple,
        AppConstant.eMandirTirupatiBalaji,
        AppConstant.eMandirMeenakshiTemple,
      ],
    ),
    GodData(
      name: "Golden Temple",
      profileImage: AppConstant.eMandirGoldenTemple,
      galleryImages: [
        AppConstant.eMandirGoldenTemple,
        AppConstant.eMandirTirupatiBalaji,
        AppConstant.eMandirGoldenTemple,
        AppConstant.eMandirTirupatiBalaji,
        AppConstant.eMandirGoldenTemple,
      ],
    ),
    GodData(
      name: "Meenakshi Amman",
      profileImage: AppConstant.eMandirMeenakshiTemple,
      galleryImages: [
        AppConstant.eMandirMeenakshiTemple,
        AppConstant.eMandirGoldenTemple,
        AppConstant.eMandirMeenakshiTemple,
        AppConstant.eMandirGoldenTemple,
        AppConstant.eMandirMeenakshiTemple,
      ],
    ),
  ];

  final currentGodIndex = 0.obs;
  final ScrollController scrollController = ScrollController();
  final PageController horizontalPageController = PageController();
  final PageController verticalPageController = PageController();
  late AnimationController aartiController;
  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioPlayer shankhPlayer = AudioPlayer();
  Timer? flowerTimer;
  final List<String> flowerAssets = [
    AppConstant.eMandirFlower1,
    AppConstant.eMandirFlower2,
    AppConstant.eMandirFlower3,
  ];
  final List<FallingFlowerState> activeFlowers = [];

  // Selection State
  final selectedOfferingIcon = AppConstant.eMandirLadduIcon.obs;
  final selectedFlowerAsset = AppConstant.eMandirFlower1.obs;
  final selectedInstrumentAsset = AppConstant.eMandirSankhIcon.obs;

  // Offering Bottom Sheet Tab Controller
  late TabController offeringTabController;
  final offeringTabs = [
    "Flower",
    "Instruments",
    "Decoration",
    "Thali",
    "Dhoop-Deep",
  ];

  @override
  void onInit() {
    super.onInit();
    aartiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    offeringTabController = TabController(
      length: offeringTabs.length,
      vsync: this,
    );
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    shankhPlayer.setReleaseMode(ReleaseMode.stop);
  }

  @override
  void onClose() {
    flowerTimer?.cancel();
    // Dispose all active flowers
    for (var flower in activeFlowers) {
      flower.entry.remove();
      flower.animationController.dispose();
    }
    activeFlowers.clear();
    aartiController.dispose();
    offeringTabController.dispose();
    scrollController.dispose();
    horizontalPageController.dispose();
    verticalPageController.dispose();
    audioPlayer.dispose();
    shankhPlayer.dispose();
    super.onClose();
  }

  void toggleAarti(BuildContext context) {
    if (aartiController.isAnimating) {
      aartiController.reset();
      audioPlayer.stop();
      stopFlowerRain();
    } else {
      aartiController.repeat();
      audioPlayer.stop();
      audioPlayer.setReleaseMode(ReleaseMode.loop);
      audioPlayer.play(AssetSource('audio/aarti.mp3')).catchError((e) {
        print("AUDIO ERROR: $e");
      });
      startFlowerRain(context);
    }
  }

  void startFlowerRain(BuildContext context) {
    final overlay = Overlay.of(context);
    final random = Random();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final centerX = screenWidth / 2;

    flowerTimer?.cancel();

    flowerTimer = Timer.periodic(const Duration(milliseconds: 260), (_) {
      if (!Get.isRegistered<VirtualDarshanController>()) return;

      try {
        double startX;

        if (random.nextDouble() < 0.3) {
          startX = centerX - 25 + random.nextDouble() * 50;
        } else {
          startX = random.nextDouble() * (screenWidth - 40);
        }

        if (flowerAssets.isEmpty) {
          print("Error: No flower assets to spawn!");
          return;
        }

        final imagePath = flowerAssets[random.nextInt(flowerAssets.length)];
        final fixedX = startX;
        final size = 28 + random.nextDouble() * 20;
        final duration = Duration(milliseconds: 14000 + random.nextInt(4000));

        // Create animation controller for this flower
        final animationController = AnimationController(
          vsync: this,
          duration: duration,
        );

        // Create fall animation
        final fallAnimation = Tween<double>(
          begin: -0.15,
          end: 1.1,
        ).animate(CurvedAnimation(
          parent: animationController,
          curve: Curves.linear,
        ));

        // Create rotation animation
        final rotationAnimation = Tween<double>(
          begin: 0,
          end: (random.nextBool() ? 1 : -1) * pi,
        ).animate(animationController);

        // Create overlay entry
        late OverlayEntry entry;
        late FallingFlowerState flowerState;
        
        entry = OverlayEntry(
          builder: (_) {
            return FallingFlowerWidget(
              key: ValueKey(entry.hashCode),
              flowerState: flowerState,
            );
          },
        );
        
        // Create flower state with the entry reference
        flowerState = FallingFlowerState(
          animationController: animationController,
          fallAnimation: fallAnimation,
          rotationAnimation: rotationAnimation,
          fixedX: fixedX,
          size: size,
          imagePath: imagePath,
          screenHeight: screenHeight,
          entry: entry,
        );

        // Add status listener to remove flower when animation completes
        animationController.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            entry.remove();
            activeFlowers.remove(flowerState);
            animationController.dispose();
          }
        });

        // Start animation
        animationController.forward();

        // Add to active flowers list
        activeFlowers.add(flowerState);

        // Insert overlay entry
        overlay.insert(entry);
      } catch (e) {
        print("FLOWER RAIN ERROR: $e");
      }
    });
  }

  void stopFlowerRain() {
    flowerTimer?.cancel();
    flowerTimer = null;
    // Remove all active flowers
    for (var flower in activeFlowers) {
      flower.entry.remove();
      flower.animationController.dispose();
    }
    activeFlowers.clear();
  }

  void playShankh() {
    if (shankhPlayer.state == PlayerState.playing) {
      shankhPlayer.stop();
    } else {
      shankhPlayer.stop();
      shankhPlayer.setReleaseMode(ReleaseMode.stop);
      shankhPlayer.play(AssetSource('audio/shankh.mp3')).catchError((e) {
        print("SHANKH AUDIO ERROR: $e");
      });
    }
  }

  void handleOfferingSelection(OfferingItem item) {
    Get.back(); // Close bottom sheet

    selectedOfferingIcon.value = item.imagePath;

    if (item.type == "Flower") {
      bool isRaining = flowerTimer != null;
      bool isSameFlower = selectedFlowerAsset.value == item.imagePath;

      if (isRaining && isSameFlower) {
        stopFlowerRain();
      } else {
        selectedFlowerAsset.value = item.imagePath;
        flowerAssets.clear();
        flowerAssets.add(item.imagePath);

        if (flowerTimer != null) {
          stopFlowerRain();
        }
        // startFlowerRain will be called from view with context after selection
      }
    } else if (item.type == "Instrument") {
      if (item.name.contains("Sankh")) {
        playShankh();
      }
      selectedInstrumentAsset.value = item.imagePath;
    }
  }

  void onHorizontalPageChanged(int index) {
    currentGodIndex.value = index % godsList.length;
    if (scrollController.hasClients) {
      scrollController.animateTo(
        currentGodIndex.value * 60.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    // Reset vertical page to first image when god changes
    if (verticalPageController.hasClients) {
      verticalPageController.jumpToPage(0);
    }
  }

  void navigateToGod(int index) {
    final currentPage = horizontalPageController.page?.round() ?? 0;
    final currentMod = currentPage % godsList.length;
    final difference = index - currentMod;
    horizontalPageController.jumpToPage(currentPage + difference);
    // Reset vertical page to first image when god changes
    if (verticalPageController.hasClients) {
      verticalPageController.jumpToPage(0);
    }
  }

  void navigateToDevotionalLibrary() {
    Get.toNamed('/devotional-library');
  }
}
