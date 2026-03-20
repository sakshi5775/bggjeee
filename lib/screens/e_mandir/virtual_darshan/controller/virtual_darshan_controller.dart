import 'dart:async';
import 'dart:math';
import 'package:astrobharataiuser/app_manager/myButton.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/god_category_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/god_data.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/god_image_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/puja_item_category_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/coin_action_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/special_bhog_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/mandir_items_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/service/god_category_service.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/service/puja_item_category_service.dart';

import 'package:astrobharataiuser/screens/e_mandir/devotional_library/service/devotional_music_service.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/widgets/falling_flower_widget.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/analytics_service.dart';

import '../../../../data_model/e_mandir_dataModels/e_mandir_home_model.dart';

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

class VirtualDarshanController extends BaseController
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

  final RxList<GodCategoryModel> filterdGodCategories =
      <GodCategoryModel>[].obs;
  final RxBool isLoadingCategories = true.obs;
  final RxString errorMessage = ''.obs;

  // Per-category images (shown in the vertical reel)
  final RxList<GodImageModel> categoryImages = <GodImageModel>[].obs;
  final RxBool isLoadingCategoryImages = false.obs;
  final RxInt currentCategoryIndex = 0.obs;

  /// god category search controller in header widget
  final Rx<TextEditingController> searchC = TextEditingController().obs;

  // Getter for current category name
  String get currentGodName {
    if (godCategories.isEmpty) {
      if (fallbackGodsList.isNotEmpty &&
          currentCategoryIndex.value < fallbackGodsList.length) {
        return fallbackGodsList[currentCategoryIndex.value].name;
      }
      return 'Unknown';
    }
    if (currentCategoryIndex.value < godCategories.length) {
      return godCategories[currentCategoryIndex.value].godName;
    }
    return 'Unknown';
  }

  // Getter for current category thumbnail
  String get currentGodImage {
    if (godCategories.isEmpty) {
      if (fallbackGodsList.isNotEmpty &&
          currentCategoryIndex.value < fallbackGodsList.length) {
        return fallbackGodsList[currentCategoryIndex.value].profileImage;
      }
      return '';
    }
    if (currentCategoryIndex.value < godCategories.length) {
      return godCategories[currentCategoryIndex.value].godImage;
    }
    return '';
  }

  /// Get image URL at [index] within the current category's images.
  String getGodImageAt(int index) {
    if (categoryImages.isNotEmpty && index < categoryImages.length) {
      return categoryImages[index].imageUrl;
    }
    // Fallback
    if (godCategories.isEmpty && index < fallbackGodsList.length) {
      return fallbackGodsList[index].profileImage;
    }
    return '';
  }

  /// Check if a URL points to a video file.
  static bool isVideoUrl(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.webm') ||
        lower.endsWith('.avi') ||
        lower.endsWith('.mkv');
  }

  /// Total count of images for the current category (vertical reel items).
  int get godsCount {
    if (categoryImages.isNotEmpty) return categoryImages.length;
    if (godCategories.isEmpty) return fallbackGodsList.length;
    return 0;
  }

  /// Total number of categories (for horizontal swipe).
  int get categoriesCount =>
      godCategories.isEmpty ? fallbackGodsList.length : godCategories.length;

  final currentGodIndex = 0.obs;
  final ScrollController scrollController = ScrollController();
  final PageController horizontalPageController = PageController();
  final PageController verticalPageController = PageController();
  late AnimationController aartiController;
  late AnimationController thaliTransitionController;
  late Animation<double> thaliTransitionAnimation;

  // Dhup animation controllers
  late AnimationController dhupTransitionController;
  late Animation<double> dhupTransitionAnimation;
  late AnimationController dhupCircleController;
  final RxBool isDhupActive = false.obs;
  final RxString selectedDhupImage = ''.obs;

  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioPlayer shankhPlayer = AudioPlayer();
  Timer? flowerTimer;
  final List<String> flowerAssets = [
    AppConstant.eMandirFlower1,
    AppConstant.eMandirFlower2,
    AppConstant.eMandirFlower3,
  ];
  final List<FallingFlowerState> activeFlowers = [];
  final RxBool isAartiActive = false.obs;

  // Selection State
  final selectedOfferingIcon = AppConstant.eMandirLadduIcon.obs;
  final selectedFlowerAsset = AppConstant.eMandirFlower1.obs;
  final selectedInstrumentAsset = AppConstant.eMandirSankhIcon.obs;

  // Pooja Item Categories API
  final PujaItemCategoryService _pujaItemCategoryService =
      PujaItemCategoryService();
  final RxList<PujaItemCategory> pujaItemCategories = <PujaItemCategory>[].obs;
  final RxBool isLoadingPujaCategories = true.obs;
  final Rx<PujaItemCategoryDetail?> selectedCategoryDetail =
      Rx<PujaItemCategoryDetail?>(null);
  final RxBool isLoadingCategoryItems = false.obs;
  final RxInt selectedCategoryIndex = 0.obs;

  // Specific image for the Thali icon on the main screen (from thali's first item)
  final RxString thaliItemImage = ''.obs;

  // Coin Actions
  final RxList<CoinAction> coinActions = <CoinAction>[].obs;

  // Special Bhog Data
  final Rxn<SpecialBhogResponse> specialBhogData = Rxn<SpecialBhogResponse>();

  // Mandir Items Selection State
  final RxString selectedLeftBellImage = AppConstant.leftGhantaImage.obs;
  final RxString selectedRightBellImage = AppConstant.rightGhantaImage.obs;
  final RxString selectedMandirArchImage = AppConstant.mandirHeaderImage.obs;

  // Mandir Items Data
  final Rxn<MandirItemsData> mandirItemsData = Rxn<MandirItemsData>();

  // Offering Bottom Sheet Tab Controller
  TabController? offeringTabController;

  // Get offering tab names from API
  List<String> get offeringTabs =>
      pujaItemCategories.map((c) => c.name).toList();

  void filterSearch(String query) {
    if (query.isEmpty) {
      // If the search bar is empty, show all categories
      filterdGodCategories.assignAll(godCategories);
    } else {
      // Filter the list based on the query
      filterdGodCategories.assignAll(
        godCategories.where((category) {
          // IMPORTANT: Replace '.name' with the actual property you want to search by in your model
          return category.godName.toLowerCase().contains(query.toLowerCase());
        }).toList(),
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Listen to changes in the text field automatically
    searchC.value.addListener(() {
      filterSearch(searchC.value.text);
    });
    aartiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    thaliTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    thaliTransitionAnimation = CurvedAnimation(
      parent: thaliTransitionController,
      curve: Curves.easeInOut,
    );
    // Dhup animation
    dhupTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    dhupTransitionAnimation = CurvedAnimation(
      parent: dhupTransitionController,
      curve: Curves.easeInOut,
    );
    dhupCircleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    shankhPlayer.setReleaseMode(ReleaseMode.stop);
    dailyCheckIn();
    getAllPunyaWallet();
    // Fetch god categories from API
    _loadGodCategories();
    // Sync main container when user scrolls the header thumbnail list (so second visit / swipe header still updates content)
    // Header thumbnails now manage their own ScrollController to avoid
    // "ScrollController attached to multiple scroll views" crashes.
    // Fetch puja item categories from API
    _loadPujaItemCategories();
    // Fetch coin actions
    // Fetch coin actions
    fetchCoinActions();
    // Fetch mandir items
    fetchMandirItemsData();
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

        // Pre-fetch the Thali category specifically to get its first item's image
        try {
          final thaliIndex = response.items.indexWhere(
            (c) =>
                c.slug.toLowerCase().contains('thali') ||
                c.name.toLowerCase().contains('thali'),
          );
          if (thaliIndex != -1) {
            final thaliRes = await _pujaItemCategoryService.getCategoryById(
              response.items[thaliIndex].id,
            );
            if (thaliRes != null &&
                thaliRes.success &&
                thaliRes.category != null) {
              if (thaliRes.category!.items.isNotEmpty) {
                final firstImage = thaliRes.category!.items.first.image ?? '';
                thaliItemImage.value = firstImage;
                selectedThaliImage.value = firstImage;
              } else {
                thaliItemImage.value = response.items[thaliIndex].image ?? '';
                selectedThaliImage.value = thaliItemImage.value;
              }
            }
          }
        } catch (e) {
          print('Error fetching explicit thali category item: $e');
        }

        // Pre-fetch flowers category to select first flower by default
        try {
          final flowersIndex = response.items.indexWhere(
            (c) =>
                c.slug.toLowerCase().contains('flowers') ||
                c.name.toLowerCase().contains('flowers'),
          );
          if (flowersIndex != -1) {
            final flowersRes = await _pujaItemCategoryService.getCategoryById(
              response.items[flowersIndex].id,
            );
            if (flowersRes != null &&
                flowersRes.success &&
                flowersRes.category != null &&
                flowersRes.category!.items.isNotEmpty) {
              final firstFlower = flowersRes.category!.items.first.image ?? '';
              if (firstFlower.isNotEmpty) {
                selectedFlowerAsset.value = firstFlower;
                flowerAssets.clear();
                flowerAssets.add(firstFlower);
              }
            }
          }
        } catch (e) {
          print('Error pre-fetching flowers category: $e');
        }

        // Pre-fetch dhup category to select first dhup item by default
        try {
          final dhupIndex = response.items.indexWhere(
            (c) =>
                c.slug.toLowerCase().contains('dhup') ||
                c.name.toLowerCase().contains('dhup'),
          );
          if (dhupIndex != -1) {
            final dhupRes = await _pujaItemCategoryService.getCategoryById(
              response.items[dhupIndex].id,
            );
            if (dhupRes != null &&
                dhupRes.success &&
                dhupRes.category != null &&
                dhupRes.category!.items.isNotEmpty) {
              selectedDhupImage.value =
                  dhupRes.category!.items.first.image ?? '';
            }
          }
        } catch (e) {
          print('Error pre-fetching dhup category: $e');
        }

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
        filterdGodCategories.assignAll(godCategories);
        // Auto-select first category and load its images
        currentCategoryIndex.value = 0;
        selectedGodID.value = godCategories.first.id.toString();
        await loadGodCategoryImages(godCategories.first.id);
        await fetchSpecialBhogData(godCategories.first.id);
        // Fetch aarti audio for the first god category
        fetchAartiAudio();
      } else {
        errorMessage.value =
            response?.message ?? 'Failed to load god categories';
      }
    } catch (e) {
      errorMessage.value = 'Error loading god categories: $e';
    } finally {
      isLoadingCategories.value = false;
    }
  }

  /// Fetch images for a specific god category and update the vertical reel.
  Future<void> loadGodCategoryImages(String categoryId) async {
    isLoadingCategoryImages.value = true;
    try {
      final response = await _godCategoryService.getGodCategoryImages(
        categoryId,
      );
      if (response != null && response.success && response.items.isNotEmpty) {
        categoryImages.value = response.items;
      } else {
        categoryImages.clear();
      }
    } catch (e) {
      print('Error loading god category images: $e');
      categoryImages.clear();
    } finally {
      isLoadingCategoryImages.value = false;
    }
  }

  /// Approximate width of each header thumbnail (circle + margin) for scroll sync.
  static const double _headerItemWidth = 50.0;
  bool _skipNextHeaderScrollSync = false;

  /// Sync selected category from header list scroll position so main container updates when user scrolls header (e.g. on second visit).
  void _onHeaderScrollSync() {
    if (_skipNextHeaderScrollSync || !scrollController.hasClients || categoriesCount == 0) return;
    final offset = scrollController.offset;
    final index = (offset / _headerItemWidth).round().clamp(0, categoriesCount - 1);
    if (index != currentCategoryIndex.value) {
      swipeToCategory(index);
    }
  }

  /// Called when user swipes horizontally to change category.
  void swipeToCategory(int newIndex) {
    if (newIndex < 0 || newIndex >= categoriesCount) return;
    if (newIndex == currentCategoryIndex.value) return;

    currentCategoryIndex.value = newIndex;
    currentGodIndex.value = 0;

    // Reset vertical page to first image after this frame so only one PageView is attached
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (verticalPageController.hasClients) {
        try {
          verticalPageController.jumpToPage(0);
        } catch (_) {}
      }
    });

    // Scroll the thumbnail list to the new category (skip header sync during animation to avoid feedback loop)
    if (scrollController.hasClients) {
      _skipNextHeaderScrollSync = true;
      scrollController.animateTo(
        newIndex * 60.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      Future.delayed(const Duration(milliseconds: 350), () {
        _skipNextHeaderScrollSync = false;
      });
    }

    // Load images for the new category
    if (godCategories.isNotEmpty && newIndex < godCategories.length) {
      selectedGodID.value = godCategories[newIndex].id.toString();
      loadGodCategoryImages(godCategories[newIndex].id);
      // Re-fetch aarti audio for the new god category
      fetchAartiAudio();
      fetchSpecialBhogData(godCategories[newIndex].id);
    }
  }

  Future<void> dailyCheckIn() async {
    try {
      setLoadingState(true);

      final success = await _pujaItemCategoryService.dailyCheckIn();

      if (success) {
        getAllPunyaWallet();
      }
    } catch (e) {
      print("Error fetching punya wallet: $e");
    } finally {
      setLoadingState(false);
    }
  }

  Future<void> useCoinItem(PujaItem item, context) async {
    try {
      setLoadingState(true);
      final success = await _pujaItemCategoryService.useItem(item.id);
      if (success) {
        getAllPunyaWallet();
        handleOfferingSelection(item);

        // Log Analytics
        AnalyticsService().logVirtualDarshanAction(
          actionType: 'offering',
          itemName: item.name,
        );

        // If flower/garland was selected, start a brief flower rain animation
        final slug = currentCategorySlug;
        if (slug == 'flowers' || slug == 'garland') {
          // Start flower rain burst (1 second animation)
          startItemRainBurst(context);
        }
      } else {
        showErrorMessage(
          message: "Insufficient coins to perform this offering",
        );
        showHowToEarnPunyaDialog(context);
      }
    } catch (e) {
      showErrorMessage(message: e.toString());
      print("Error fetching punya wallet: $e");
    } finally {
      setLoadingState(false);
    }
  }

  final Rxn<EMandirHomeDataModel> punyaWallet = Rxn<EMandirHomeDataModel>();
  Future<void> getAllPunyaWallet() async {
    try {
      setLoadingState(true);
      final response = await _pujaItemCategoryService.punyaWallet();
      if (response != null) {
        punyaWallet.value = response;
      }
    } catch (e) {
      print("Error fetching punya wallet: $e");
    } finally {
      setLoadingState(false);
    }
  }

  Future<void> fetchCoinActions() async {
    try {
      final response = await _pujaItemCategoryService.getCoinActions();
      if (response != null && response.success) {
        coinActions.value = response.coinActions;
      }
    } catch (e) {
      print("Error fetching coin actions: $e");
    }
  }

  Future<void> fetchSpecialBhogData(String id) async {
    try {
      final response = await _pujaItemCategoryService.getSpecialBhog(id);
      if (response != null && response.success) {
        specialBhogData.value = response;
      }
    } catch (e) {
      print("Error fetching special bhog: $e");
    }
  }

  Future<void> fetchMandirItemsData() async {
    try {
      final response = await _pujaItemCategoryService.getMandirItems();
      if (response != null && response.success && response.data != null) {
        mandirItemsData.value = response.data;
        selectedMandirArchImage.value =
            mandirItemsData.value?.upperMandirFront.first.image ?? '';

        selectedLeftBellImage.value =
            mandirItemsData.value?.bells.first.leftBell ?? '';
        selectedRightBellImage.value =
            mandirItemsData.value?.bells.first.rightBell ?? '';
      }
    } catch (e) {
      print("Error fetching mandir items: $e");
    }
  }

  Future<void> offerSpecialBhog(BhogItem bhog, BuildContext context) async {
    try {
      setLoadingState(true);
      final success = await _pujaItemCategoryService.useItem(bhog.id);
      if (success) {
        getAllPunyaWallet();
        startItemRainBurst(context, imageUrl: bhog.thumbnail);
        
        // Log Analytics
        AnalyticsService().logVirtualDarshanAction(
          actionType: 'special_bhog',
          itemName: bhog.bhogName,
        );

        showSuccessMessage(message: "${bhog.bhogName} offered successfully!");
      } else {
        showHowToEarnPunyaDialog(context);
      }
    } catch (e) {
      showErrorMessage(message: e.toString());
      print("Error offering special bhog: $e");
    } finally {
      setLoadingState(false);
    }
  }

  void applyBellSelection(BellItem bell) {
    selectedLeftBellImage.value = bell.leftBell;
    selectedRightBellImage.value = bell.rightBell;
  }

  void applyArchSelection(UpperMandirFrontItem arch) {
    selectedMandirArchImage.value = arch.image;
  }

  Future<void> earnCoin(String actionKey) async {
    try {
      final success = await _pujaItemCategoryService.earnWalletCoin(actionKey);
      if (success) {
        // Find how many coins were earned
        final action = coinActions.firstWhereOrNull(
          (a) => a.actionKey == actionKey,
        );
        if (action != null) {
          showSuccessMessage(message: "Punya Earned +${action.coins}");
        }
        getAllPunyaWallet();
      }
    } catch (e) {
      print("Error earning coin: $e");
    }
  }

  void showHowToEarnPunyaDialog(BuildContext context) {
    if (coinActions.isEmpty) return;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "How to Earn Punya",
                style: AppTypography.h3.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              ...coinActions.map((action) {
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16.r,
                        backgroundColor: Colors.white,
                        backgroundImage: const AssetImage(
                          AppConstant.eMandirOmmIcon,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              action.actionName,
                              style: AppTypography.body1.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "${action.description} +${action.coins} Coins",
                              style: AppTypography.body2.copyWith(
                                color: Colors.grey.shade700,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(height: 12.h),
              MyButton(title: "Got it", onPress: () => Get.back()),
            ],
          ),
        ),
      ),
    );
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
    thaliTransitionController.dispose();
    dhupTransitionController.dispose();
    dhupCircleController.dispose();
    offeringTabController?.dispose();
    scrollController.dispose();
    horizontalPageController.dispose();
    verticalPageController.dispose();
    audioPlayer.dispose();
    shankhPlayer.dispose();
    super.onClose();
  }

  void toggleAarti(BuildContext context) {
    if (aartiController.isAnimating || thaliTransitionController.value > 0.0) {
      // Stop Aarti and move thali down
      aartiController.reset();
      thaliTransitionController.reverse();
      audioPlayer.stop();
      stopFlowerRain();
      isAartiActive.value = false;
    } else {
      // When starting aarti thali, stop dhoop if it is running (mutual exclusion)
      if (isDhupActive.value) {
        dhupCircleController.reset();
        dhupTransitionController.reverse();
        isDhupActive.value = false;
      }
      // Move thali up
      thaliTransitionController.forward().then((_) {
        // Start Aarti rotation once thali is in the center
        if (isAartiActive.value) {
          aartiController.repeat();
        }
      });
      audioPlayer.stop();
      audioPlayer.setReleaseMode(ReleaseMode.loop);
      final audioUrl = aartiAudioUrl.value.isNotEmpty
          ? aartiAudioUrl.value
          : AppConstant.aartiMp3;
      audioPlayer.play(UrlSource(audioUrl)).catchError((e) {});
      startFlowerRain(context);
      isAartiActive.value = true;
    }
  }

  void startItemRainBurst(BuildContext context, {String? imageUrl}) {
    if (!Get.isRegistered<VirtualDarshanController>()) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final random = Random();

    // Get the image path: custom one, or selected flower
    final imagePath = imageUrl ?? selectedFlowerAsset.value;

    // Create 20-30 flowers for the burst effect
    final itemCount = random.nextInt(11) + 20;

    for (int i = 0; i < itemCount; i++) {
      // Stagger items across time for a natural rain effect
      Future.delayed(Duration(milliseconds: random.nextInt(500)), () {
        if (!context.mounted) return;

        // Spread items across the full screen width randomly
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
        late FallingFlowerState itemState;

        entry = OverlayEntry(
          builder: (_) {
            return FallingFlowerWidget(
              key: ValueKey(entry.hashCode),
              flowerState: itemState,
            );
          },
        );

        itemState = FallingFlowerState(
          animationController: animationController,
          fallAnimation: fallAnimation,
          rotationAnimation: rotationAnimation,
          fixedX: fixedX,
          size: size,
          imagePath: imagePath,
          screenHeight: screenHeight,
          entry: entry,
        );

        animationController.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            entry.remove();
            activeFlowers.remove(itemState);
            animationController.dispose();
          }
        });

        animationController.forward();
        activeFlowers.add(itemState);
        Overlay.of(context).insert(entry);
      });
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

  void playShankh() {
    if (shankhPlayer.state == PlayerState.playing) {
      shankhPlayer.stop();
    } else {
      shankhPlayer.stop();
      shankhPlayer.setReleaseMode(ReleaseMode.stop);
      shankhPlayer
          .play(UrlSource(AppConstant.shankhMp3))
          .then((_) {
            // Log Analytics
            AnalyticsService().logVirtualDarshanAction(
              actionType: 'instrument',
              itemName: 'Shankh',
            );

            // Earn coin when shankh plays
            earnCoin('shankh_blow');
          })
          .catchError((e) {
            print("SHANKH AUDIO ERROR: $e");
          });
    }
  }

  /// Perform dhup animation: transition up → one full circle → transition back down.
  void performDhupAnimation() {
    if (isDhupActive.value) return;
    // When starting dhoop, stop aarti thali if it is running (mutual exclusion)
    if (aartiController.isAnimating || thaliTransitionController.value > 0.0) {
      aartiController.reset();
      thaliTransitionController.reverse();
      audioPlayer.stop();
      stopFlowerRain();
      isAartiActive.value = false;
    }
    isDhupActive.value = true;

    // Step 1: Move dhup from dock to circle position
    dhupTransitionController.forward().then((_) {
      // Step 2: Do one full circle
      dhupCircleController.reset();
      dhupCircleController.forward().then((_) {
        // Step 3: Move dhup back to dock
        dhupTransitionController.reverse().then((_) {
          isDhupActive.value = false;
          dhupCircleController.reset();
        });
      });
    });
  }

  RxString selectedThaliImage = ''.obs;

  void handleOfferingSelection(PujaItem item) {
    // Determine the type based on selected category
    final categoryDetail = selectedCategoryDetail.value;
    final categorySlug = categoryDetail?.slug ?? '';

    if (categorySlug == 'flowers' || categorySlug == 'garland') {
      if (item.image != null && item.image!.isNotEmpty) {
        selectedOfferingIcon.value = item.image!;
        selectedFlowerAsset.value = item.image!;
        flowerAssets.clear();
        flowerAssets.add(item.image!);
      }
      // startFlowerRain will be called from view with context after selection
    } else if (categorySlug == 'sound') {
      // Play sound but do NOT update offering icon
      playShankh();
      if (item.image != null && item.image!.isNotEmpty) {
        selectedInstrumentAsset.value = item.image!;
      }
    } else if (categorySlug == 'thali') {
      // Thali: do NOT update offering icon
      selectedThaliImage.value = item.image ?? '';
    } else if (categorySlug == 'dhup') {
      // Dhup: update icon and trigger one-circle animation
      if (item.image != null && item.image!.isNotEmpty) {
        selectedDhupImage.value = item.image!;
        selectedOfferingIcon.value = item.image!;
      }
      performDhupAnimation();
    } else {
      // Other categories: update the offering icon
      if (item.image != null && item.image!.isNotEmpty) {
        selectedOfferingIcon.value = item.image!;
      }
    }
  }

  /// Get current category slug for view logic
  String get currentCategorySlug => selectedCategoryDetail.value?.slug ?? '';

  void onHorizontalPageChanged(int index) {
    // Now used for category changes via swipe
    swipeToCategory(index);
  }

  RxString selectedGodID = "".obs;

  /// Dynamic aarti audio URL fetched from API
  RxString aartiAudioUrl = "".obs;

  /// Fetch aarti audio URL for the currently selected god category
  Future<void> fetchAartiAudio() async {
    if (selectedGodID.value.isEmpty) return;
    try {
      final service = DevotionalMusicService();
      final response = await service.getTracks(
        selectedGodID.value,
        'aarti',
        page: 1,
        limit: 1,
      );
      if (response != null &&
          response.data != null &&
          response.data!.items.isNotEmpty) {
        aartiAudioUrl.value = response.data!.items.first.audioUrl;
      } else {
        aartiAudioUrl.value = '';
      }
    } catch (e) {
      aartiAudioUrl.value = '';
    }
  }

  /// Navigate to a specific category by tapping its thumbnail.
  void navigateToGod(int index, String id) {
    selectedGodID.value = id;
    swipeToCategory(index);
    fetchSpecialBhogData(id);
  }

  void navigateToDevotionalLibrary() {
    UserMainController.pushInCurrentTab(AppRoutes.devotionalLibrary);
  }

  /// Stops all active animations and audio when navigating away from the Virtual Darshan tab.
  void stopAllAnimationsForTabSwitch() {
    if (isAartiActive.value) {
      aartiController.reset();
      thaliTransitionController.reverse();
      audioPlayer.stop();
      stopFlowerRain();
      isAartiActive.value = false;
    }

    // Clear any loose flowers that were raining
    activeFlowers.clear();
    flowerTimer?.cancel();
    flowerTimer = null;

    try {
      audioPlayer.pause();
      shankhPlayer.stop();
    } catch (_) {}
  }
}
