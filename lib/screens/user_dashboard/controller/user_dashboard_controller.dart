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
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_chat_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/daily_quote_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/dashboard_search_service.dart';
import 'package:astrobharataiuser/services/global_free_service_manager.dart';
import 'package:astrobharataiuser/screens/blogs/service/blog_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class UserDashboardController extends BaseController {
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userPhone = ''.obs;
  final Rx<UserRole> userRole = UserRole.user.obs;
  final RxBool showConsultationBanner = true.obs;

  // Live streams
  final LiveStreamService _liveStreamService = LiveStreamService();
  final AstrologerService _astrologerService = AstrologerService();
  final AstrologerChatService _chatService = AstrologerChatService();
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
  String? _lastQuoteDate; // Store the date of the last fetched quote

  // Blogs
  final BlogService _blogService = BlogService();
  final RxList<Blog> blogs = <Blog>[].obs;
  final RxBool isLoadingBlogs = false.obs;

  // Search functionality
  final DashboardSearchService _searchService = DashboardSearchService();
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  // Free services - now handled globally by GlobalFreeServiceManager
  final RxBool isListening = false.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();
  bool _sttInitialized = false;

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

  AuthService get _authService => Get.find<AuthService>();
  bool get _isGuest => LoginGuard.isGuest;

  @override
  void onInit() {
    super.onInit();
    final requireAuth = !_isGuest;
    _loadUserData();
    loadLiveStreams();
    loadDailyQuote(requireAuth: requireAuth);
    loadBlogs(requireAuth: requireAuth);
    _initializeSTT();
    // Start global free service manager after dashboard loads
    if (requireAuth) {
      _startGlobalFreeServiceManager();
    }
    // Start animation after a short delay to ensure UI is ready
    Future.delayed(const Duration(milliseconds: 500), () {
      _startTypewriterAnimation();
    });
    // Initialize wallet controller if not already registered (only for logged-in users)
    if (requireAuth && !Get.isRegistered<WalletController>()) {
      Get.put(WalletController());
    }

    if (requireAuth) {
      checkForActiveSessions();
      // Periodic check every 30s as per requirement
      Timer.periodic(const Duration(seconds: 30), (_) {
        if (!_isGuest) checkForActiveSessions();
      });
    }
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
    searchController.dispose();
    _speechToText.stop();
    super.onClose();
  }

  Future<void> loadLiveStreams() async {
    isLoadingLiveStreams.value = true;
    try {
      final response = await _liveStreamService.getLiveStreams(limit: 20);
      if (response != null) {
        // Filter to only show LIVE streams
        liveStreams.value = response.streams
            .where((stream) => stream.status == 'LIVE')
            .toList();
        // Fetch astrologer details for profile pictures and names
        await _loadAstrologerDetails(liveStreams);
      }
    } catch (e) {
      debugPrint('Error loading live streams: $e');
      // Handle error silently or show message
    } finally {
      isLoadingLiveStreams.value = false;
    }
  }

  Future<void> _loadAstrologerDetails(List<LiveStreamModel> streams) async {
    // Fetch astrologers to get profile pictures and names
    try {
      final astrologerResponse = await _astrologerService.getAstrologers(
        limit: 100,
      );
      if (astrologerResponse != null) {
        // Create maps of astrologerId -> profilePicture and astrologerId -> name
        final Map<String, String?> profileMap = {};
        final Map<String, String?> nameMap = {};
        for (final astrologer in astrologerResponse.astrologers) {
          // Use displayName if available, otherwise use fullName
          final name = astrologer.displayName.isNotEmpty
              ? astrologer.displayName
              : astrologer.name;

          profileMap[astrologer.astrologerId] = astrologer.profilePicture;
          profileMap[astrologer.id] =
              astrologer.profilePicture; // Also map by _id

          nameMap[astrologer.astrologerId] = name;
          nameMap[astrologer.id] = name; // Also map by _id
        }
        // Update the reactive maps
        astrologerProfilePictures.value = profileMap;
        astrologerNames.value = nameMap;
      }
    } catch (e) {
      // Handle error silently
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
    // Check if we already have today's quote
    final today = DateTime.now().toIso8601String().split(
      'T',
    )[0]; // Format: YYYY-MM-DD
    if (_lastQuoteDate == today && dailyQuote.value != null) {
      return; // Already have today's quote
    }

    isLoadingDailyQuote.value = true;
    try {
      final response = await _dailyQuoteService.getDailyQuote(
        useAuthHeader: requireAuth,
      );
      if (response != null && response.success && response.data != null) {
        dailyQuote.value = response.data;
        _lastQuoteDate = response.data!.quoteDate;
      }
    } catch (e) {
      debugPrint('Error loading daily quote: $e');
      // Handle error silently - fallback to static quote will be used in view
    } finally {
      isLoadingDailyQuote.value = false;
    }
  }

  /// Load blogs for dashboard (limit to 5 for preview)
  Future<void> loadBlogs({bool requireAuth = true}) async {
    isLoadingBlogs.value = true;
    try {
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
    } catch (e) {
      debugPrint('Error loading blogs: $e');
      // Handle error silently
    } finally {
      isLoadingBlogs.value = false;
    }
  }

  /// Pull-to-refresh handler for dashboard content
  Future<void> refreshDashboard() async {
    _loadUserData(); // Ensure user data stays up to date
    await loadLiveStreams();
    final requireAuth = !_isGuest;
    await loadDailyQuote(
      requireAuth: requireAuth,
    ); // Refresh quote on pull-to-refresh
    await loadBlogs(
      requireAuth: requireAuth,
    ); // Refresh blogs on pull-to-refresh
    if (requireAuth) await checkForActiveSessions();
  }

  Future<void> checkForActiveSessions() async {
    try {
      final activeSessions = await _chatService.getActiveSessions();
      if (activeSessions.isNotEmpty) {
        final session =
            activeSessions.first; // Latest session as per backend order

        // Find astrologer details for this session
        final astrologerResponse = await _astrologerService.getAstrologers(
          limit: 1,
          search: session.astrologerId,
        );
        final astrologer = astrologerResponse?.astrologers.firstWhereOrNull(
          (a) =>
              a.astrologerId == session.astrologerId ||
              a.id == session.astrologerId,
        );

        if (astrologer != null) {
          Get.dialog(
            barrierDismissible: false,
            AlertDialog(
              title: const Text('Ongoing Chat'),
              content: Text(
                'You have an ongoing chat session with ${astrologer.displayName}. Would you like to resume?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Later'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); // close dialog
                    Get.toNamed(
                      '/astrologer-chat',
                      arguments: {
                        'astrologer': astrologer,
                        'chatId': session.chatId,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                  ),
                  child: const Text(
                    'Resume Now',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error checking active sessions: $e');
    }
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

  /// Process text search
  void processTextSearch(String query) {
    if (query.trim().isEmpty) return;
    _processSearch(query.trim());
  }

  /// Process search query and navigate
  void _processSearch(String query) {
    if (query.trim().isEmpty) return;

    debugPrint('Dashboard Search: Processing query: "$query"');

    final route = _searchService.searchRoute(query);

    if (route != null) {
      debugPrint('Dashboard Search: Navigating to: $route');
      Get.toNamed(route);
      // Clear search after navigation
      searchController.clear();
      searchQuery.value = '';
      animatedSearchText.value = '';
      // Restart animation after navigation
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_shouldAnimate && !_isAnimating) {
          _startTypewriterAnimation();
        }
      });
    } else {
      // Show message that search didn't find anything
      Get.snackbar(
        'Search',
        'No results found for "$query". Try searching for: horoscope, kundli, tarot, palm reading, etc.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
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
