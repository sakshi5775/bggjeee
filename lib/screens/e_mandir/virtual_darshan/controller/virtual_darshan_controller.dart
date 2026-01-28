import 'dart:async';
import 'dart:math';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/god_category_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/god_data.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/puja_item_category_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/service/god_category_service.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/service/puja_item_category_service.dart';
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
  final GodCategoryService _godCategoryService = GodCategoryService();

  // Fallback static data (used if API fails)
  final List<GodData> fallbackGodsList = [
    GodData(
      name: "Shri Ganesh",
      profileImage: AppConstant.eMandirGanesha,
      galleryImages: [
        AppConstant.eMandirGanesha,
        AppConstant.eMandirShriGanesh,
        AppConstant.eMandirGodIcon,
      ],
    ),
    GodData(
      name: "Tirupati Balaji",
      profileImage: AppConstant.eMandirTirupatiBalaji,
      galleryImages: [
        AppConstant.eMandirTirupatiBalaji,
        AppConstant.eMandirMeenakshiTemple,
        AppConstant.eMandirGoldenTemple,
      ],
    ),
  ];

  // API data
  final RxList<GodCategoryModel> godCategories = <GodCategoryModel>[].obs;
  final RxBool isLoadingCategories = true.obs;
  final RxString errorMessage = ''.obs;

  // Getter for current god name
  String get currentGodName {
    if (godCategories.isEmpty) {
      if (fallbackGodsList.isNotEmpty &&
          currentGodIndex.value < fallbackGodsList.length) {
        return fallbackGodsList[currentGodIndex.value].name;
      }
      return 'Unknown';
    }
    if (currentGodIndex.value < godCategories.length) {
      return godCategories[currentGodIndex.value].godName;
    }
    return 'Unknown';
  }

  // Getter for current god image
  String get currentGodImage {
    if (godCategories.isEmpty) {
      if (fallbackGodsList.isNotEmpty &&
          currentGodIndex.value < fallbackGodsList.length) {
        return fallbackGodsList[currentGodIndex.value].profileImage;
      }
      return '';
    }
    if (currentGodIndex.value < godCategories.length) {
      return godCategories[currentGodIndex.value].godImage;
    }
    return '';
  }

  // Get god image at index
  String getGodImageAt(int index) {
    if (godCategories.isEmpty) {
      if (index < fallbackGodsList.length) {
        return fallbackGodsList[index].profileImage;
      }
      return '';
    }
    if (index < godCategories.length) {
      return godCategories[index].godImage;
    }
    return '';
  }

  // Get total count of gods
  int get godsCount {
    if (godCategories.isEmpty) {
      return fallbackGodsList.length;
    }
    return godCategories.length;
  }

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

  // Puja Item Categories API
  final PujaItemCategoryService _pujaItemCategoryService =
      PujaItemCategoryService();
  final RxList<PujaItemCategory> pujaItemCategories = <PujaItemCategory>[].obs;
  final RxBool isLoadingPujaCategories = true.obs;
  final Rx<PujaItemCategoryDetail?> selectedCategoryDetail =
      Rx<PujaItemCategoryDetail?>(null);
  final RxBool isLoadingCategoryItems = false.obs;
  final RxInt selectedCategoryIndex = 0.obs;

  // Offering Bottom Sheet Tab Controller
  TabController? offeringTabController;

  // Get offering tab names from API
  List<String> get offeringTabs =>
      pujaItemCategories.map((c) => c.name).toList();

  @override
  void onInit() {
    super.onInit();
    aartiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    shankhPlayer.setReleaseMode(ReleaseMode.stop);

    // Fetch god categories from API
    _loadGodCategories();
    // Fetch puja item categories from API
    _loadPujaItemCategories();
  }

  Future<void> _loadPujaItemCategories() async {
    isLoadingPujaCategories.value = true;
    try {
      final response = await _pujaItemCategoryService.getCategories();
      if (response != null && response.success && response.items.isNotEmpty) {
        pujaItemCategories.value = response.items;
        // Initialize tab controller after getting categories
        offeringTabController = TabController(
          length: response.items.length,
          vsync: this,
        );
        offeringTabController!.addListener(_onTabChanged);
        // Load first category items by default
        if (pujaItemCategories.isNotEmpty) {
          await loadCategoryItems(pujaItemCategories.first.id);
        }
      }
    } catch (e) {
      print('Error loading puja item categories: $e');
    } finally {
      isLoadingPujaCategories.value = false;
    }
  }

  void _onTabChanged() {
    if (offeringTabController != null) {
      final index = offeringTabController!.index;
      // Only load if it's a different category to avoid duplicate calls
      if (index >= 0 &&
          index < pujaItemCategories.length &&
          selectedCategoryIndex.value != index) {
        selectedCategoryIndex.value = index;
        loadCategoryItems(pujaItemCategories[index].id);
      }
    }
  }

  Future<void> loadCategoryItems(String categoryId) async {
    isLoadingCategoryItems.value = true;
    try {
      final response = await _pujaItemCategoryService.getCategoryById(
        categoryId,
      );
      if (response != null && response.success && response.category != null) {
        selectedCategoryDetail.value = response.category;
      }
    } catch (e) {
      print('Error loading category items: $e');
    } finally {
      isLoadingCategoryItems.value = false;
    }
  }

  Future<void> _loadGodCategories() async {
    isLoadingCategories.value = true;
    errorMessage.value = '';

    try {
      final response = await _godCategoryService.getGodCategories();
      if (response != null && response.success && response.items.isNotEmpty) {
        godCategories.value = response.items;
      } else {
        // Keep empty list - will use fallback
        errorMessage.value =
            response?.message ?? 'Failed to load god categories';
      }
    } catch (e) {
      errorMessage.value = 'Error loading god categories: $e';
    } finally {
      isLoadingCategories.value = false;
    }
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
    offeringTabController?.dispose();
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
      audioPlayer.play(UrlSource(AppConstant.aartiMp3)).catchError((e) {
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
        final fallAnimation = Tween<double>(begin: -0.15, end: 1.1).animate(
          CurvedAnimation(parent: animationController, curve: Curves.linear),
        );

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

  /// Start a quick burst of flower rain when a flower is selected
  void startFlowerRainBurst(BuildContext context) {
    final overlay = Overlay.of(context);
    final random = Random();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Get the selected flower image (either network URL or asset paths)
    final imagePath = selectedFlowerAsset.value;

    // Create 20-30 flowers for the burst effect
    final flowerCount = random.nextInt(11) + 20;

    for (int i = 0; i < flowerCount; i++) {
      // Stagger flowers across time for a natural rain effect
      Future.delayed(Duration(milliseconds: random.nextInt(500)), () {
        if (!context.mounted) return;

        // Spread flowers across the full screen width randomly
        final fixedX = random.nextDouble() * (screenWidth - 40);
        final size = 25.0 + random.nextDouble() * 30;
        // SLOWER animation: 2.5-4 seconds for gentle falling
        final duration = Duration(milliseconds: 2500 + random.nextInt(1500));

        final animationController = AnimationController(
          vsync: this,
          duration: duration,
        );

        // Start from above the screen (negative values), fall to below screen
        final fallAnimation = Tween<double>(begin: -0.1, end: 1.15).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.easeInQuad,
          ),
        );

        // Gentler rotation
        final rotationAnimation = Tween<double>(
          begin: 0,
          end: (random.nextBool() ? 1 : -1) * pi * 0.5,
        ).animate(animationController);

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

        overlay.insert(entry);
        activeFlowers.add(flowerState);

        animationController.forward();

        // Remove flower when animation completes
        animationController.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            entry.remove();
            animationController.dispose();
            activeFlowers.remove(flowerState);
          }
        });
      });
    }
  }

  void playShankh() {
    if (shankhPlayer.state == PlayerState.playing) {
      shankhPlayer.stop();
    } else {
      shankhPlayer.stop();
      shankhPlayer.setReleaseMode(ReleaseMode.stop);
      shankhPlayer.play(UrlSource(AppConstant.shankhMp3)).catchError((e) {
        print("SHANKH AUDIO ERROR: $e");
      });
    }
  }

  void handleOfferingSelection(PujaItem item) {
    Get.back(); // Close bottom sheet

    // Use item image if available, otherwise keep current icon
    if (item.image != null && item.image!.isNotEmpty) {
      selectedOfferingIcon.value = item.image!;
    }

    // Determine the type based on selected category
    final categoryDetail = selectedCategoryDetail.value;
    final categorySlug = categoryDetail?.slug ?? '';

    if (categorySlug == 'flowers' || categorySlug == 'garland') {
      if (item.image != null && item.image!.isNotEmpty) {
        selectedFlowerAsset.value = item.image!;
        flowerAssets.clear();
        flowerAssets.add(item.image!);
      }
      // startFlowerRain will be called from view with context after selection
    } else if (categorySlug == 'sound') {
      playShankh();
      if (item.image != null && item.image!.isNotEmpty) {
        selectedInstrumentAsset.value = item.image!;
      }
    }
    // For thali and other categories, just update the icon
  }

  /// Get current category slug for view logic
  String get currentCategorySlug => selectedCategoryDetail.value?.slug ?? '';

  void onHorizontalPageChanged(int index) {
    if (godsCount == 0) return;
    currentGodIndex.value = index % godsCount;
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
    if (godsCount == 0) return;
    currentGodIndex.value = index;
    // Animate the vertical PageView to the selected god index
    if (verticalPageController.hasClients) {
      verticalPageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void navigateToDevotionalLibrary() {
    Get.toNamed('/devotional-library');
  }
}
