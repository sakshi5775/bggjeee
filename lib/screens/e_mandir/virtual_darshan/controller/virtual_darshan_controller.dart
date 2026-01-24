import 'dart:async';
import 'dart:math';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/controller/falling_flower_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/god_data.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/offering_item.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/widgets/falling_flower_widget.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  late AnimationController aartiController;
  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioPlayer shankhPlayer = AudioPlayer();
  Timer? flowerTimer;
  final List<String> flowerAssets = [
    AppConstant.eMandirFlower1,
    AppConstant.eMandirFlower2,
    AppConstant.eMandirFlower3,
  ];

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
    aartiController.dispose();
    offeringTabController.dispose();
    scrollController.dispose();
    horizontalPageController.dispose();
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

        late OverlayEntry entry;
        final imagePath = flowerAssets[random.nextInt(flowerAssets.length)];
        entry = OverlayEntry(
          builder: (_) {
            final flowerController = Get.put(
              FallingFlowerController(
                startX: startX,
                entry: entry,
                imagePath: imagePath,
                screenHeight: screenHeight,
              ),
              tag:
                  'flower_${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(10000)}',
            );
            return FallingFlowerWidget(
              key: ValueKey(flowerController.hashCode),
            );
          },
        );

        overlay.insert(entry);
      } catch (e) {
        print("FLOWER RAIN ERROR: $e");
      }
    });
  }

  void stopFlowerRain() {
    flowerTimer?.cancel();
    flowerTimer = null;
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
  }

  void navigateToGod(int index) {
    final currentPage = horizontalPageController.page?.round() ?? 0;
    final currentMod = currentPage % godsList.length;
    final difference = index - currentMod;
    horizontalPageController.jumpToPage(currentPage + difference);
  }

  void navigateToDevotionalLibrary() {
    Get.toNamed('/devotional-library');
  }
}
