import 'dart:async';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/enums/user_role.dart';
import 'package:astrobharataiuser/core/services/auth_service.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/screens/wallet/controller/wallet_controller.dart';
import 'package:astrobharataiuser/data_model/live_stream_model.dart';
import 'package:astrobharataiuser/data_model/daily_quote_model.dart';
import 'package:astrobharataiuser/data_model/blog_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/live_stream_service.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/banner_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/daily_quote_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/dashboard_search_service.dart';
import 'package:astrobharataiuser/services/global_free_service_manager.dart';
import 'package:astrobharataiuser/screens/blogs/service/blog_service.dart';
import 'package:astrobharataiuser/screens/ai_chat/services/ai_chat_service.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/screens/courses/services/courses_service.dart';
import 'package:astrobharataiuser/screens/courses/services/webinar_service.dart';
import 'package:astrobharataiuser/data_model/course_model.dart';
import 'package:astrobharataiuser/data_model/webinar_model.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/data_model/banner_model.dart';
import 'package:astrobharataiuser/data_model/puja_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/puja_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/youtube_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:video_player/video_player.dart';

import '../../../data_model/astrologer_model.dart';
import '../../../data_model/user_profile_model.dart';
import '../service/user_profile_service.dart';

class UserDashboardController extends BaseController
    with GetTickerProviderStateMixin {
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userPhone = ''.obs;
  final Rx<UserRole> userRole = UserRole.user.obs;
  final RxBool showConsultationBanner = true.obs;

  // Live streams
  final LiveStreamService _liveStreamService = LiveStreamService();
  final AstrologerService _astrologerService = AstrologerService();

  final RxList<LiveStreamModel> liveStreams = <LiveStreamModel>[].obs;
  final RxBool isLoadingLiveStreams = false.obs;

  // Cache for astrologer profile pictures and names
  final RxMap<String, String?> astrologerProfilePictures =
      <String, String?>{}.obs;
  final RxMap<String, String?> astrologerNames = <String, String?>{}.obs;

  // Daily quote
  final DailyQuoteService _dailyQuoteService = DailyQuoteService();
  final Rx<DailyQuoteData?> dailyQuote = Rx<DailyQuoteData?>(null);
  final RxBool isLoadingDailyQuote = false.obs;

  // Fallback quotes when API doesn't return data
  static final List<DailyQuoteData> _fallbackQuotes = [
    DailyQuoteData(
      quoteDate: '',
      sanskrit: SanskritQuote(
        text:
            'उद्यमेन हि सिद्ध्यन्ति कार्याणि न मनोरथैः।\nन हि सुप्तस्य सिंहस्य प्रविशन्ति मुखे मृगाः॥',
        transliteration:
            'Udyamena hi siddhyanti karyani na manorathaih.\nNa hi suptasya simhasya pravishanti mukhe mrigah.',
        meaning:
            'Success comes by effort, not by wishes. A sleeping lion does not get food.',
        source: 'Traditional Sanskrit Quote',
        category: 'Motivation',
      ),
      availableTranslations: [],
      isFallback: true,
    ),
    DailyQuoteData(
      quoteDate: '',
      sanskrit: SanskritQuote(
        text:
            'विद्या ददाति विनयं विनयाद् याति पात्रताम्।\nपात्रत्वात् धनमाप्नोति धनात् धर्मं ततः सुखम्॥',
        transliteration:
            'Vidya dadati vinayam vinayad yati patratam.\nPatratvat dhanamapnoti dhanat dharmam tatah sukham.',
        meaning:
            'Knowledge gives humility, humility gives worthiness, worthiness brings wealth, wealth leads to righteousness, and righteousness brings happiness.',
        source: 'Traditional Sanskrit Quote',
        category: 'Education',
      ),
      availableTranslations: [],
      isFallback: true,
    ),
    DailyQuoteData(
      quoteDate: '',
      sanskrit: SanskritQuote(
        text: 'न हि ज्ञानेन सदृशं पवित्रमिह विद्यते।',
        transliteration: 'Na hi jnanena sadrisham pavitramiha vidyate.',
        meaning: 'Nothing in this world is as pure as true knowledge.',
        source: 'Bhagavad Gita',
        category: 'Knowledge',
      ),
      availableTranslations: [],
      isFallback: true,
    ),
    DailyQuoteData(
      quoteDate: '',
      sanskrit: SanskritQuote(
        text:
            'सर्वे भवन्तु सुखिनः सर्वे सन्तु निरामयाः।\nसर्वे भद्राणि पश्यन्तु मा कश्चिद् दुःखभाग्भवेत्॥',
        transliteration:
            'Sarve bhavantu sukhinah sarve santu niraamayah.\nSarve bhadrani pashyantu ma kashchid duhkhabhagbhavet.',
        meaning:
            'May all be happy, healthy, see goodness, and may no one suffer.',
        source: 'Traditional Sanskrit Prayer',
        category: 'Blessing',
      ),
      availableTranslations: [],
      isFallback: true,
    ),
    DailyQuoteData(
      quoteDate: '',
      sanskrit: SanskritQuote(
        text: 'यत्र नार्यस्तु पूज्यन्ते रमन्ते तत्र देवताः।',
        transliteration: 'Yatra naryastu pujyante ramante tatra devatah.',
        meaning: 'Where women are respected, divinity resides.',
        source: 'Manusmriti',
        category: 'Respect',
      ),
      availableTranslations: [],
      isFallback: true,
    ),
  ];

  // AI Astrologers Personas
  final AiChatService _aiChatService = AiChatService();
  final RxList<PersonaModel> aiAstrologersPersonas = <PersonaModel>[].obs;
  final RxBool isLoadingAiAstrologers = false.obs;

  // Vedic Kundli Astrologers
  final RxList<AstrologerModel> vedicAstrologers = <AstrologerModel>[].obs;
  final RxBool isLoadingVedicAstrologers = false.obs;

  // Kids Specialist Astrologers
  final RxList<AstrologerModel> kidsSpecialistAstrologers =
      <AstrologerModel>[].obs;
  final RxBool isLoadingKidsSpecialistAstrologers = false.obs;

  // Celebrity Astrologers
  final RxList<AstrologerModel> celebrityAstrologers = <AstrologerModel>[].obs;
  final RxBool isLoadingCelebrityAstrologers = false.obs;

  // Courses
  final CoursesService _coursesService = CoursesService();
  final RxList<CourseModel> courses = <CourseModel>[].obs;
  final RxBool isLoadingCourses = false.obs;

  // Live Webinar for enrolled courses
  final WebinarService _webinarService = WebinarService();
  final Rx<WebinarModel?> liveWebinarForEnrolledCourse = Rx<WebinarModel?>(
    null,
  );
  final RxBool hasLiveWebinarForEnrolledCourse = false.obs;

  // Blogs
  final BlogService _blogService = BlogService();
  final RxList<Blog> blogs = <Blog>[].obs;
  final RxBool isLoadingBlogs = false.obs;

  // Ecommerce Categories for Astro Remedy Section
  final EcommerceService _ecommerceService = EcommerceService();
  final RxList<CategoryModel> remedyCategories = <CategoryModel>[].obs;
  final RxBool isLoadingRemedyCategories = false.obs;

  // Digital Mart tab: all product categories
  final RxList<CategoryModel> digitalMartCategories = <CategoryModel>[].obs;
  final RxBool isLoadingDigitalMartCategories = false.obs;

  // Search functionality
  final DashboardSearchService _searchService = DashboardSearchService();
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  // Free services - now handled globally by GlobalFreeServiceManager
  final RxBool isListening = false.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();
  bool _sttInitialized = false;

  // Header search overlay (tap search icon → opens overlay; same app-wide search as dashboard bar)
  final TextEditingController headerSearchController = TextEditingController();
  final FocusNode headerSearchFocusNode = FocusNode();
  final RxBool isHeaderSearchOpen = false.obs;

  // Typewriter animation for search bar
  final RxString animatedSearchText = ''.obs;
  final List<String> _searchPrompts = [
    'Get your palm reading.',
    'Get face reading.',
    'Want to make kundli.',
    'Check your horoscope.',
    'Get tarot reading.',
    'Talk to live astrologer.',
  ];
  int _currentPromptIndex = 0;
  bool _isAnimating = false;
  bool _shouldAnimate = true;
  final ScrollController scrollController = ScrollController();

  final RxBool isExpanded = false.obs;

  // Header slider tabs (Home = default active)
  // Header slider tabs (Home = default active)
  final RxInt selectedSliderIndex = 0.obs;

  // Slider Tabs
  List<String> get sliderTabs => [
    'Home',
    DateTime.now().year.toString(),
    'Astrologers',
    'AI Astrologers',
    'Digital Mart',
    'Digital Mandir',
    'Digital Learning',
    'Video',
    'Panchang',
    'Horoscope',
  ];

  // Book Pooja Carousel
  final Rx<PageController> bookPoojaPageController = PageController().obs;
  final RxInt bookPoojaCurrentPage = 0.obs;
  Timer? _bookPoojaTimer;

  // Puja Service
  final PujaService _pujaService = PujaService();

  // Dynamic data for pooja cards
  final RxList<PujaModel> pujas = <PujaModel>[].obs;
  final RxBool isLoadingPujas = false.obs;

  // YouTube videos
  final YouTubeService _youtubeService = YouTubeService();
  final RxList<YouTubeVideo> youtubeVideos = <YouTubeVideo>[].obs;
  final RxBool isLoadingYoutubeVideos = false.obs;

  // Ads Carousel (dynamic from API)
  final BannerService _bannerService = BannerService();
  final RxList<BannerItem> adsBanners = <BannerItem>[].obs;
  final RxList<BannerItem> offerBanners = <BannerItem>[].obs;
  final RxList<BannerItem> generalBanners = <BannerItem>[].obs;
  final RxBool isLoadingBanners = false.obs;
  final Rx<PageController> adsPageController = PageController().obs;
  final RxInt adsCurrentPage = 0.obs;
  Timer? _adsTimer;

  void toggleView() {
    // Only preserve scroll position if controller is properly attached
    double? offset;
    if (scrollController.hasClients && scrollController.positions.length == 1) {
      offset = scrollController.offset;
    }

    isExpanded.toggle();

    // Restore scroll position AFTER layout rebuild (only if we saved it)
    if (offset != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients &&
            scrollController.positions.length == 1) {
          try {
            scrollController.jumpTo(offset!);
          } catch (e) {
            // Ignore errors if controller is no longer valid
            if (kDebugMode) {
              print('Error restoring scroll position: $e');
            }
          }
        }
      });
    }
  }

  int visibleItemCount(int total) {
    if (isExpanded.value) return total;
    return total >= 4 ? 4 : total;
  }

  String get viewText => isExpanded.value ? 'View Less' : 'View All';

  AuthService get _authService => Get.find<AuthService>();
  bool get _isGuest => LoginGuard.isGuest;

  late AnimationController liveVideoIconController;
  late Animation<double> liveVideoIconOpacity;
  late Animation<double> liveVideoIconScale;

  @override
  void onInit() {
    super.onInit();
    liveVideoIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    liveVideoIconOpacity = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: liveVideoIconController, curve: Curves.easeInOut),
    );

    liveVideoIconScale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: liveVideoIconController, curve: Curves.easeInOut),
    );
    final requireAuth = !_isGuest;
    _loadUserData();
    if (requireAuth) {
      loadUserProfile();
      checkForLiveWebinarFromEnrolledCourses();
    }
    _initializeSTT();
    refreshDashboard();
    // Start global free service manager after dashboard loads
    if (requireAuth) {
      _startGlobalFreeServiceManager();
    }
    // Start animation after a short delay to ensure UI is ready
    Future.delayed(const Duration(milliseconds: 2000), () {
      _startTypewriterAnimation();
    });
    // Initialize wallet controller if not already registered (only for logged-in users)
    if (requireAuth && !Get.isRegistered<WalletController>()) {
      Get.put(WalletController());
    }
    // Load pujas from API
    loadPujas();
    // Load YouTube videos
    loadYouTubeVideos();
    // Ads carousel auto-slide is started in loadBanners() when banners are loaded
  }

  /// Load pujas from API
  /// By default, loads all pujas without filters (as per API requirement)
  Future<void> loadPujas({
    bool? featured,
    bool? popular,
    String? search,
    String? templeId,
  }) async {
    await runWithLoading(
      () async {
        isLoadingPujas.value = true;
        final response = await _pujaService.getPujas(
          page: 1,
          limit: 10,
          featured: featured,
          popular: popular,
          search: search,
          templeId: templeId,
        );

        if (response != null &&
            response.success == true &&
            response.data?.items != null) {
          pujas.value = response.data!.items!
              .where(
                (puja) =>
                    puja.status == null ||
                    puja.status!.isEmpty ||
                    puja.status!.toLowerCase() == 'active',
              )
              .toList();

          if (pujas.isNotEmpty) {
            _startBookPoojaAutoSlide();
          }
        }
      },
      showBusy: false,
      silent401ForGuest: true,
    ).whenComplete(() => isLoadingPujas.value = false);
  }

  /// Start Book Pooja carousel auto-slide
  void _startBookPoojaAutoSlide() {
    if (pujas.isEmpty || pujas.length <= 1) return;

    _stopBookPoojaAutoSlide();

    // Delay so PageView is built and attached (e.g. when section is in view)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (pujas.isEmpty || pujas.length <= 1) return;

        _bookPoojaTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
          final pageController = bookPoojaPageController.value;
          if (!pageController.hasClients || pageController.positions.isEmpty) {
            return;
          }
          final count = pujas.length;
          if (count <= 1) return;
          final next = (bookPoojaCurrentPage.value + 1) % count;
          bookPoojaCurrentPage.value = next;
          try {
            pageController.animateToPage(
              next,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          } catch (e) {
            _stopBookPoojaAutoSlide();
          }
        });
      });
    });
  }

  /// Stop Book Pooja carousel auto-slide
  void _stopBookPoojaAutoSlide() {
    _bookPoojaTimer?.cancel();
    _bookPoojaTimer = null;
  }

  /// Load home screen banners from API
  Future<void> loadBanners() async {
    await runWithLoading(
      () async {
        isLoadingBanners.value = true;
        // 1. Home Screen Banners (apphomescreen)
        var list = await _bannerService.getBannersByCategory('apphomescreen');
        if (list.isEmpty) {
          list = await _bannerService.getBannersByCategory('home');
          if (list.isEmpty) {
            list = await _bannerService.getHomeBanners();
          }
        }
        adsBanners.assignAll(list);

        // 2. Offer Banners (appoffers) - Visible all over app (stored here for access)
        var offers = await _bannerService.getBannersByCategory('appoffers');
        if (offers.isEmpty) {
          offers = await _bannerService.getBannersByCategory('offers');
        }
        offerBanners.assignAll(offers);

        // 3. General Banners (appgeneral) - For Horoscope, 2026, etc.
        var generals = await _bannerService.getBannersByCategory('appgeneral');
        if (generals.isEmpty) {
          generals = await _bannerService.getBannersByCategory('general');
        }
        generalBanners.assignAll(generals);
      },
      showBusy: false,
      silent401ForGuest: true,
    ).whenComplete(() => isLoadingBanners.value = false);
  }

  /// Stop Ads carousel auto-slide
  void _stopAdsAutoSlide() {
    _adsTimer?.cancel();
    _adsTimer = null;
  }

  /// Start the global free service manager (only after dashboard loads)
  void _startGlobalFreeServiceManager() {
    // Wait for dashboard to fully load, then start the global service
    Future.delayed(const Duration(seconds: 1), () {
      if (Get.isRegistered<GlobalFreeServiceManager>()) {
        final manager = Get.find<GlobalFreeServiceManager>();
        manager.start();
      }
    });
  }

  @override
  void onClose() {
    _shouldAnimate = false;
    _isAnimating = false;
    headerSearchController.dispose();
    headerSearchFocusNode.dispose();
    _speechToText.stop();
    _stopBookPoojaAutoSlide();
    _stopAdsAutoSlide();
    bookPoojaPageController.value.dispose();
    adsPageController.value.dispose();
    liveVideoIconController.dispose();
    super.onClose();
  }

  Future<void> loadLiveStreams() async {
    await runWithLoading(
      () async {
        isLoadingLiveStreams.value = true;
        final response = await _liveStreamService.getLiveStreams(limit: 20);
        if (response != null) {
          liveStreams.value = response.streams
              .where((stream) => stream.status == 'LIVE')
              .toList();
          await _loadAstrologerDetails(liveStreams);
        }
      },
      showBusy: false,
      silent401ForGuest: true,
    ).whenComplete(() => isLoadingLiveStreams.value = false);
  }

  final RxList<AstrologerModel> allAstrologer = <AstrologerModel>[].obs;

  Future<void> _loadAstrologerDetails(List<LiveStreamModel> streams) async {
    final response = await _astrologerService.getAstrologers(limit: 100);
    if (response != null) {
      for (final astrologer in response.astrologers) {
        final name = astrologer.displayName.isNotEmpty
            ? astrologer.displayName
            : astrologer.name;
        astrologerProfilePictures[astrologer.astrologerId] =
            astrologer.profilePicture;
        astrologerProfilePictures[astrologer.id] = astrologer.profilePicture;
        astrologerNames[astrologer.astrologerId] = name;
        astrologerNames[astrologer.id] = name;
        if (!allAstrologer.contains(astrologer)) {
          allAstrologer.add(astrologer);
        }
      }
    }
  }

  String? getProfilePictureForAstrologer(String astrologerId) {
    return astrologerProfilePictures[astrologerId];
  }

  String? getAstrologerName(String astrologerId) {
    return astrologerNames[astrologerId];
  }

  void _loadUserData() {
    final userData = UserData().getLoginData.user;
    if (userData != null) {
      userName.value = userData.username ?? 'User';
      userEmail.value = userData.email ?? '';
      userPhone.value = userData.phone ?? '';
      userRole.value = UserRole.fromString(userData.userType ?? 'USER');
    }
  }

  Future<void> logout() async {
    final result =
        await Get.dialog<String?>(
          AlertDialog(
            title: const AutoTranslateText('Sign out'),
            content: const AutoTranslateText(
              'Choose how you would like to logout.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: null),
                child: const AutoTranslateText('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(result: 'all'),
                child: const AutoTranslateText('Logout all devices'),
              ),
              TextButton(
                onPressed: () => Get.back(result: 'single'),
                child: const AutoTranslateText('Logout'),
              ),
            ],
          ),
        ) ??
        null;

    if (result == null) return;

    final logoutAll = result == 'all';
    await _authService.logout(logoutFromAllDevices: logoutAll);
  }

  /// Load daily quote
  Future<void> loadDailyQuote({bool requireAuth = true}) async {
    await runWithLoading(
          () async {
            isLoadingDailyQuote.value = true;
            final response = await _dailyQuoteService.getDailyQuote(
              useAuthHeader: requireAuth,
            );
            if (response != null &&
                response.success == true &&
                response.data != null) {
              dailyQuote.value = response.data;
            } else {
              _useFallbackQuote();
            }
          },
          showBusy: false,
          silent401ForGuest: true,
        )
        .catchError((_) {
          _useFallbackQuote();
          return null;
        })
        .whenComplete(() => isLoadingDailyQuote.value = false);
  }

  void _useFallbackQuote() {
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    final quote = _fallbackQuotes[dayOfYear % _fallbackQuotes.length];
    dailyQuote.value = quote;
  }

  final Rxn<UserProfileModel> userProfile = Rxn<UserProfileModel>();
  Future<void> loadUserProfile() async {
    await runWithLoading(() async {
      final response = await UserProfileService().getProfile(
        UserData().getLoginData.user?.userId ?? '',
      );
      if (response != null) {
        userProfile.value = response;
      }
    }, showBusy: false);
  }

  /// Load blogs for dashboard (limit to 5 for preview)
  // Load AI Astrologers Personas
  Future<void> loadAiAstrologers() async {
    await runWithLoading(
      () async {
        isLoadingAiAstrologers.value = true;
        final response = await _aiChatService.getPersonas(
          page: 1,
          limit: 10,
          sortBy: 'rating',
        );

        if (response != null && response.personas.isNotEmpty) {
          aiAstrologersPersonas.value = response.personas;
        }
      },
      showBusy: false,
      silent401ForGuest: true,
    ).whenComplete(() => isLoadingAiAstrologers.value = false);
  }

  // Load Vedic Kundli Astrologers
  Future<void> loadVedicAstrologers() async {
    await runWithLoading(
      () async {
        isLoadingVedicAstrologers.value = true;
        final response = await _astrologerService.getAstrologers(
          page: 1,
          limit: 5,
          specialization: 'VEDIC',
          sortBy: 'rating',
        );

        if (response != null && response.astrologers.isNotEmpty) {
          vedicAstrologers.value = response.astrologers;
        }
      },
      showBusy: false,
      silent401ForGuest: true,
    ).whenComplete(() => isLoadingVedicAstrologers.value = false);
  }

  // Load Kids Specialist Astrologers
  Future<void> loadKidsSpecialistAstrologers() async {
    await runWithLoading(
      () async {
        isLoadingKidsSpecialistAstrologers.value = true;
        final response = await _astrologerService.getAstrologers(
          page: 1,
          limit: 5,
          astrologerCategory: 'KID_ASTROLOGER',
          sortBy: 'rating',
        );

        if (response != null && response.astrologers.isNotEmpty) {
          kidsSpecialistAstrologers.value = response.astrologers;
        }
      },
      showBusy: false,
      silent401ForGuest: true,
    ).whenComplete(() => isLoadingKidsSpecialistAstrologers.value = false);
  }

  // Load Celebrity Astrologers
  Future<void> loadCelebrityAstrologers() async {
    await runWithLoading(
      () async {
        isLoadingCelebrityAstrologers.value = true;
        final response = await _astrologerService.getAstrologers(
          page: 1,
          limit: 5,
          astrologerCategory: 'CELEBRITY_ASTROLOGER',
          sortBy: 'rating',
        );

        if (response != null && response.astrologers.isNotEmpty) {
          celebrityAstrologers.value = response.astrologers;
        }
      },
      showBusy: false,
      silent401ForGuest: true,
    ).whenComplete(() => isLoadingCelebrityAstrologers.value = false);
  }

  // Load Courses
  Future<void> loadCourses() async {
    await runWithLoading(
      () async {
        isLoadingCourses.value = true;
        final response = await _coursesService.getCourses(
          page: 1,
          limit: 5,
          isPublished: true,
        );

        if (response != null && response.courses.isNotEmpty) {
          courses.value = response.courses;
        }
      },
      showBusy: false,
      silent401ForGuest: true,
    ).whenComplete(() => isLoadingCourses.value = false);
  }

  // Check for live webinars from enrolled courses
  Future<void> checkForLiveWebinarFromEnrolledCourses() async {
    try {
      // Get enrolled courses - try progress overview first, then enrollments API
      final progressOverview = await _coursesService.getProgressOverview();
      List<dynamic>? coursesList;

      if (progressOverview != null && progressOverview['courses'] != null) {
        // Format from progress overview
        coursesList = progressOverview['courses'] as List<dynamic>?;
      } else {
        // Fallback: Get enrollments directly
        final enrollmentsData = await _coursesService.getEnrollments(page: 1);
        if (enrollmentsData != null) {
          // Check both possible response formats
          coursesList =
              enrollmentsData['courses'] as List<dynamic>? ??
              enrollmentsData['data'] as List<dynamic>?;
        }
      }

      if (coursesList == null || coursesList.isEmpty) {
        debugPrint("No enrolled courses found");
        liveWebinarForEnrolledCourse.value = null;
        hasLiveWebinarForEnrolledCourse.value = false;
        return;
      }

      // Extract enrolled course IDs - handle both response formats
      final enrolledCourseIds = <String>{};
      for (var courseJson in coursesList) {
        final courseMap = courseJson as Map<String, dynamic>;

        // Try different possible field names for course ID
        String? courseId = courseMap['courseId'] as String?;
        if (courseId == null) {
          // Check if course is an object with _id
          final courseObj = courseMap['course'] as Map<String, dynamic>?;
          if (courseObj != null) {
            courseId =
                courseObj['_id'] as String? ?? courseObj['id'] as String?;
          } else {
            // Direct _id or id
            courseId =
                courseMap['_id'] as String? ?? courseMap['id'] as String?;
          }
        }

        if (courseId != null && courseId.isNotEmpty) {
          enrolledCourseIds.add(courseId);
        }
      }

      debugPrint(
        "Found ${enrolledCourseIds.length} enrolled course IDs: $enrolledCourseIds",
      );

      if (enrolledCourseIds.isEmpty) {
        liveWebinarForEnrolledCourse.value = null;
        hasLiveWebinarForEnrolledCourse.value = false;
        return;
      }

      // Get live webinars
      final liveWebinars = await _webinarService.getLiveWebinars();
      debugPrint("Found ${liveWebinars.length} live webinars");

      if (liveWebinars.isEmpty) {
        liveWebinarForEnrolledCourse.value = null;
        hasLiveWebinarForEnrolledCourse.value = false;
        return;
      }

      // Find if any live webinar belongs to an enrolled course
      for (var webinar in liveWebinars) {
        final webinarCourseId = webinar.courseId?.sId ?? webinar.courseId?.id;

        debugPrint(
          "Checking webinar: ${webinar.title}, courseId: $webinarCourseId",
        );

        if (webinarCourseId != null &&
            enrolledCourseIds.contains(webinarCourseId)) {
          debugPrint(
            "Match found! Live webinar for enrolled course: ${webinar.title}",
          );
          liveWebinarForEnrolledCourse.value = webinar;
          hasLiveWebinarForEnrolledCourse.value = true;
          return;
        }
      }

      debugPrint("No live webinar found for enrolled courses");
      // No live webinar found for enrolled courses
      liveWebinarForEnrolledCourse.value = null;
      hasLiveWebinarForEnrolledCourse.value = false;
    } catch (e, stackTrace) {
      debugPrint("Error checking for live webinar from enrolled courses: $e");
      debugPrint("Stack trace: $stackTrace");
      liveWebinarForEnrolledCourse.value = null;
      hasLiveWebinarForEnrolledCourse.value = false;
    }
  }

  Future<void> loadBlogs({bool requireAuth = true}) async {
    await runWithLoading(
      () async {
        isLoadingBlogs.value = true;
        final response = await _blogService.getBlogs(
          page: 1,
          useAuthHeader: requireAuth,
        );
        if (response != null && response.data != null) {
          // Filter only published blogs and limit to 5 for dashboard
          blogs.value = response.data!
              .where(
                (blog) =>
                    blog.status == 'published' && !(blog.isDeleted ?? false),
              )
              .take(5)
              .toList();
        }
      },
      showBusy: false,
      silent401ForGuest: true,
    ).whenComplete(() => isLoadingBlogs.value = false);
  }

  // Get filtered personas (for search)
  List<PersonaModel> get filteredPersonas {
    if (searchQuery.value.isEmpty) {
      return List.from(aiAstrologersPersonas);
    }

    final query = searchQuery.value.toLowerCase();
    return aiAstrologersPersonas
        .where(
          (persona) =>
              persona.displayName.toLowerCase().contains(query) ||
              persona.description.toLowerCase().contains(query) ||
              persona.tags.any((tag) => tag.toLowerCase().contains(query)) ||
              persona.specializations.any(
                (spec) => spec.toLowerCase().contains(query),
              ),
        )
        .toList();
  }

  /// Load remedy categories for Astro Remedy section
  Future<void> loadRemedyCategories() async {
    await runWithLoading(
      () async {
        isLoadingRemedyCategories.value = true;
        // Load featured categories for remedy section
        final categoryData = await _ecommerceService.getCategories(
          page: 1,
          limit: 10,
          isActive: true,
          isFeatured: true,
        );

        if (categoryData != null &&
            categoryData.items != null &&
            categoryData.items!.isNotEmpty) {
          // Filter to only top-level categories (no parent) and limit to 6
          remedyCategories.value = categoryData.items!
              .where((cat) => cat.parent == null)
              .take(6)
              .toList();
        } else {
          // Fallback: try category tree
          final treeResult = await _ecommerceService.getCategoryTree();
          if (treeResult != null && treeResult.isNotEmpty) {
            remedyCategories.value = treeResult
                .where((cat) => cat.isFeatured == true && cat.parent == null)
                .take(6)
                .toList();
          }
        }
      },
      showBusy: false,
      silent401ForGuest: true,
    ).whenComplete(() => isLoadingRemedyCategories.value = false);
  }

  /// Load all categories for Digital Mart tab (grid of products)
  Future<void> loadDigitalMartCategories() async {
    await runWithLoading(
      () async {
        isLoadingDigitalMartCategories.value = true;
        final categoryData = await _ecommerceService.getCategories(
          page: 1,
          limit: 50,
          isActive: true,
        );

        if (categoryData != null &&
            categoryData.items != null &&
            categoryData.items!.isNotEmpty) {
          digitalMartCategories.value = categoryData.items!
              .where((cat) => cat.parent == null)
              .toList();
        } else {
          final treeResult = await _ecommerceService.getCategoryTree();
          if (treeResult != null && treeResult.isNotEmpty) {
            digitalMartCategories.value = treeResult
                .where((cat) => cat.parent == null && (cat.isActive ?? true))
                .toList();
          } else {
            digitalMartCategories.clear();
          }
        }
      },
      showBusy: false,
      silent401ForGuest: true,
    ).whenComplete(() => isLoadingDigitalMartCategories.value = false);
  }

  /// Pull-to-refresh handler for dashboard content
  /// Load YouTube videos from channel
  Future<void> loadYouTubeVideos({String? apiKey}) async {
    await runWithLoading(
      () async {
        isLoadingYoutubeVideos.value = true;
        final videos = await _youtubeService.getChannelVideos(apiKey: apiKey);
        youtubeVideos.value = videos;

        if (kDebugMode) {
          print('Loaded ${videos.length} YouTube videos');
        }
      },
      showBusy: false,
      silent401ForGuest: true,
    ).whenComplete(() => isLoadingYoutubeVideos.value = false);
  }

  Future<void> refreshDashboard() async {
    final requireAuth = !_isGuest;
    if (requireAuth) {
      _loadUserData();
      await loadUserProfile();
      await checkForLiveWebinarFromEnrolledCourses();
    }
    await loadLiveStreams();
    await loadDailyQuote(requireAuth: requireAuth);
    await loadBanners();
    await loadBlogs(requireAuth: requireAuth);
    await loadVedicAstrologers();
    await loadKidsSpecialistAstrologers();
    await loadCelebrityAstrologers();
    await loadAiAstrologers();
    await loadCourses();
    await loadRemedyCategories();
    await loadDigitalMartCategories();
  }

  /// Initialize Speech-to-AutoTranslateText
  Future<void> _initializeSTT() async {
    try {
      final available = await _speechToText.initialize(
        onError: (error) {
          debugPrint('STT Error: $error');
          isListening.value = false;
        },
        onStatus: (status) {
          debugPrint('STT Status: $status');
          if (status == 'done' || status == 'notListening') {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!_speechToText.isListening) {
                isListening.value = false;
              }
            });
          }
        },
      );
      _sttInitialized = available;
      debugPrint('STT Initialized: $_sttInitialized');
    } catch (e) {
      debugPrint('Error initializing STT: $e');
      _sttInitialized = false;
    }
  }

  /// Toggle listening for voice search
  Future<void> toggleVoiceSearch() async {
    if (!_sttInitialized) {
      await _initializeSTT();
    }

    if (!_sttInitialized) {
      Get.snackbar(
        'Error',
        'Speech recognition not available',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isListening.value) {
      await _stopListening();
    } else {
      await _startListening();
    }
  }

  /// Start listening for voice input
  Future<void> _startListening() async {
    try {
      await _speechToText.stop(); // Stop any ongoing listening
      stopTypewriterAnimation(); // Stop animation when listening starts
      isListening.value = true;

      await _speechToText.listen(
        onResult: (result) {
          searchQuery.value = result.recognizedWords;
          if (result.finalResult) {
            _processSearch(result.recognizedWords);
            _stopListening();
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        localeId: 'en_US', // Can be made dynamic based on language
        partialResults: true,
      );
    } catch (e) {
      debugPrint('Error starting STT: $e');
      isListening.value = false;
    }
  }

  /// Stop listening
  Future<void> _stopListening() async {
    try {
      await _speechToText.stop();
      isListening.value = false;
      // Resume animation if search bar is empty
      Future.delayed(const Duration(milliseconds: 300), () {
        if (searchController.text.isEmpty && !isListening.value) {
          resumeTypewriterAnimation();
        }
      });
    } catch (e) {
      debugPrint('Error stopping STT: $e');
    }
  }

  /// Process text search. [fromHeaderSearch] when invoked from header search overlay.
  void processTextSearch(String query, {bool fromHeaderSearch = false}) {
    if (query.trim().isEmpty) return;
    _processSearch(query.trim(), fromHeaderSearch: fromHeaderSearch);
  }

  /// Process search query and navigate
  void _processSearch(String query, {bool fromHeaderSearch = false}) {
    if (query.trim().isEmpty) return;

    debugPrint('Dashboard Search: Processing query: "$query"');

    final route = _searchService.searchRoute(query);

    if (route != null) {
      debugPrint('Dashboard Search: Navigating to: $route');
      Get.toNamed(route);
      if (fromHeaderSearch) {
        headerSearchController.clear();
        isHeaderSearchOpen.value = false;
        headerSearchFocusNode.unfocus();
      } else {
        searchController.clear();
        searchQuery.value = '';
        animatedSearchText.value = '';
        Future.delayed(const Duration(milliseconds: 500), () {
          if (_shouldAnimate && !_isAnimating) {
            _startTypewriterAnimation();
          }
        });
      }
    } else {
      Get.snackbar(
        'Search',
        'No results found for "$query". Try searching for: horoscope, kundli, tarot, palm reading, etc.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void openHeaderSearch() {
    isHeaderSearchOpen.value = true;
    Future.delayed(const Duration(milliseconds: 100), () {
      headerSearchFocusNode.requestFocus();
    });
  }

  void closeHeaderSearch() {
    isHeaderSearchOpen.value = false;
    headerSearchController.clear();
    headerSearchFocusNode.unfocus();
  }

  /// Start typewriter animation
  Future<void> _startTypewriterAnimation() async {
    if (_isAnimating || !_shouldAnimate) {
      debugPrint('Typewriter: Already animating or should not animate');
      return;
    }

    debugPrint('Typewriter: Starting animation');
    _isAnimating = true;

    while (_shouldAnimate) {
      // Check if search bar is empty and not listening
      if (searchController.text.isNotEmpty || isListening.value) {
        await Future.delayed(const Duration(milliseconds: 500));
        continue;
      }

      final prompt = _searchPrompts[_currentPromptIndex];
      debugPrint('Typewriter: Starting prompt: $prompt');

      // Type out the text
      await _typeText(prompt);

      // Check again before waiting
      if (!_shouldAnimate ||
          searchController.text.isNotEmpty ||
          isListening.value) {
        animatedSearchText.value = '';
        break;
      }

      // Wait before erasing
      await Future.delayed(const Duration(seconds: 3));

      // Check again before erasing
      if (!_shouldAnimate ||
          searchController.text.isNotEmpty ||
          isListening.value) {
        animatedSearchText.value = '';
        break;
      }

      // Erase the text
      debugPrint('Typewriter: Starting erase');
      await _eraseText();

      // Check again before next prompt
      if (!_shouldAnimate ||
          searchController.text.isNotEmpty ||
          isListening.value) {
        animatedSearchText.value = '';
        break;
      }

      // Wait before next prompt
      await Future.delayed(const Duration(milliseconds: 500));

      // Move to next prompt
      _currentPromptIndex = (_currentPromptIndex + 1) % _searchPrompts.length;
    }

    debugPrint('Typewriter: Animation stopped');
    _isAnimating = false;
  }

  /// Type text character by character
  Future<void> _typeText(String text) async {
    animatedSearchText.value = '';
    for (int i = 0; i < text.length; i++) {
      if (!_shouldAnimate ||
          searchController.text.isNotEmpty ||
          isListening.value) {
        animatedSearchText.value = '';
        return;
      }
      animatedSearchText.value = text.substring(0, i + 1);
      await Future.delayed(const Duration(milliseconds: 80)); // Typing speed
    }
  }

  /// Erase text character by character from end
  Future<void> _eraseText() async {
    String currentText = animatedSearchText.value;
    for (int i = currentText.length; i >= 0; i--) {
      if (!_shouldAnimate ||
          searchController.text.isNotEmpty ||
          isListening.value) {
        animatedSearchText.value = '';
        return;
      }
      animatedSearchText.value = currentText.substring(0, i);
      await Future.delayed(const Duration(milliseconds: 50)); // Erasing speed
    }
  }

  /// Stop animation when user interacts
  void stopTypewriterAnimation() {
    _shouldAnimate = false;
    animatedSearchText.value = '';
  }

  /// Resume animation when search bar is empty
  void resumeTypewriterAnimation() {
    if (searchController.text.isEmpty && !isListening.value && !_isAnimating) {
      _shouldAnimate = true;
      _startTypewriterAnimation();
    }
  }
}

class VideoIconController extends GetxController {
  final String assetPath;
  VideoPlayerController? videoController;
  RxBool isInitialized = false.obs;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  // Static counter to ensure sequential initialization
  static int _initCounter = 0;
  static final Map<String, int> _videoDelays = {};

  VideoIconController({required this.assetPath});

  @override
  void onInit() {
    super.onInit();
    // Small delay to ensure controller is fully registered
    Future.microtask(() => _initializeVideo());
  }

  Future<void> _initializeVideo({bool isRetry = false}) async {
    // Only apply delay on first attempt, not on retries
    if (!isRetry) {
      // Assign delay based on order of creation - ensure sequential initialization
      int delayMs;
      if (!_videoDelays.containsKey(assetPath)) {
        delayMs =
            _initCounter *
            600; // 600ms between each video (0, 600, 1200, 1800ms)
        _videoDelays[assetPath] = delayMs;
        _initCounter++;

        // Reset counter if too many videos
        if (_initCounter > 10) {
          _initCounter = 0;
        }
      } else {
        delayMs = _videoDelays[assetPath]!;
      }

      print(
        "Video ($assetPath) - Starting initialization with delay: ${delayMs}ms",
      );

      // Wait for our assigned delay
      await Future.delayed(Duration(milliseconds: delayMs));
    } else {
      print(
        "Video ($assetPath) - Retrying initialization (attempt $_retryCount)",
      );
    }

    // Check if controller was disposed during delay
    if (isClosed) {
      print("Video ($assetPath) - Controller closed during delay");
      return;
    }

    try {
      print("Video ($assetPath) - Creating VideoPlayerController");
      videoController = VideoPlayerController.asset(assetPath);

      print("Video ($assetPath) - Initializing...");
      await videoController!.initialize();
      print(
        "Video ($assetPath) - Initialized: ${videoController!.value.isInitialized}",
      );

      // Double-check controller is still valid
      if (isClosed) {
        print("Video ($assetPath) - Controller closed after initialization");
        videoController?.dispose();
        return;
      }

      if (videoController == null || !videoController!.value.isInitialized) {
        print("Video ($assetPath) - Controller not properly initialized");
        videoController?.dispose();
        videoController = null;
        isInitialized.value = false;
        return;
      }

      print("Video ($assetPath) - Setting looping and volume");
      await videoController!.setLooping(true);
      await videoController!.setVolume(0.0);

      // Mark as initialized BEFORE calling play - this allows UI to render immediately
      // The video will start playing once the VideoPlayer widget is rendered
      if (!isClosed &&
          videoController != null &&
          videoController!.value.isInitialized) {
        print("Video ($assetPath) - Marking as initialized");
        isInitialized.value = true;
      }

      print("Video ($assetPath) - Starting playback");
      // Call play() but don't wait for it - let it play asynchronously
      videoController!.play().catchError((error) {
        print("Video ($assetPath) - Error during play: $error");
        // Retry play after a delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!isClosed && videoController != null) {
            videoController!.play();
          }
        });
      });

      // Verify it's playing after a short delay (non-blocking)
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!isClosed && videoController != null) {
          if (!videoController!.value.isPlaying) {
            print("Video ($assetPath) - Not playing after delay, retrying...");
            videoController!.play();
          } else {
            print("Video ($assetPath) - Successfully playing");
          }
        }
      });
    } catch (e, stackTrace) {
      print("Video Error ($assetPath): $e");
      print("Stack trace: $stackTrace");
      videoController?.dispose();
      videoController = null;

      // Retry on error if we haven't exceeded max retries
      if (_retryCount < _maxRetries && !isClosed) {
        _retryCount++;
        await Future.delayed(Duration(milliseconds: 500 * _retryCount));
        if (!isClosed) {
          await _initializeVideo(isRetry: true);
        }
      } else {
        isInitialized.value = false;
      }
    }
  }

  @override
  void onClose() {
    videoController?.pause();
    videoController?.dispose();
    videoController = null;
    super.onClose();
  }
}
