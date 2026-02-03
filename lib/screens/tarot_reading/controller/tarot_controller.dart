import 'dart:async';
import 'dart:math' as math;
import 'package:astrobharataiuser/core/localization/language_controller_v2.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/tarot_card_model.dart';
import 'package:astrobharataiuser/data_model/tarot_reading_models.dart';
import 'package:astrobharataiuser/screens/tarot_reading/service/tarot_service.dart';
import 'package:astrobharataiuser/screens/tarot_reading/utils/tarot_audio_haptic.dart';
import 'package:astrobharataiuser/screens/tarot_reading/utils/tarot_card_validation_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TarotController extends BaseController {
  final TarotService _tarotService = TarotService();

  // State
  final RxList<TarotCardModel> cards = <TarotCardModel>[].obs;
  final RxString selectedShuffleType = 'both'.obs; // 'minor', 'major', 'both'
  final RxString selectedTheme =
      'ghibli'.obs; // 'classic', 'artwork', 'dark', 'ghibli'
  final RxString selectedBackType = 'classic'
      .obs; // 'classic', 'dark', 'indigo_star', 'playing_blue', 'playing_red', 'ghibli_sun', 'ghibli_tree'
  final Rxn<String> selectedLanguage =
      Rxn<String>(); // Optional language from API header
  final RxnInt remainingApiCalls =
      RxnInt(); // Track remaining API calls from response
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isShuffling = false.obs;
  final RxBool showCards = false.obs;
  final RxnInt selectedCardIndex = RxnInt();
  final RxBool isRevealing = false.obs;
  final RxBool isCardOpen = false.obs; // Track if card is open/sticky

  // Animation controllers
  final RxDouble shuffleProgress = 0.0.obs;
  final RxDouble fanSpreadProgress = 0.0.obs;

  // Reading type state
  final RxString selectedReadingType =
      'none'.obs; // 'none', 'yesno', 'career', 'love', 'daily'
  final RxString selectedLoveType = 'in-depth'
      .obs; // 'in-depth', 'erotic', 'made-for-each-other', 'flirt', 'triangle'
  final RxString selectedBreakupType = 'romantic'.obs; // 'romantic', 'business'

  // Direction selection for Yes/No and Career
  final RxString selectedDirection = 'upright'.obs; // 'upright', 'reversed'

  // Multi-card selection state
  // For Love Triangle: need 3 cards (self, lover1, lover2)
  final Rxn<TarotCardModel> triangleCardSelf = Rxn<TarotCardModel>();
  final Rxn<TarotCardModel> triangleCardLover1 = Rxn<TarotCardModel>();
  final Rxn<TarotCardModel> triangleCardLover2 = Rxn<TarotCardModel>();
  final RxString triangleSelectionStep =
      'self'.obs; // 'self', 'lover1', 'lover2', 'complete'

  // For Breakup readings: need 2 cards (cause, advise)
  final Rxn<TarotCardModel> breakupCardCause = Rxn<TarotCardModel>();
  final Rxn<TarotCardModel> breakupCardAdvise = Rxn<TarotCardModel>();
  final RxString breakupSelectionStep =
      'cause'.obs; // 'cause', 'advise', 'complete'

  // Reading responses
  final Rxn<TarotYesNoResponse> yesNoResponse = Rxn<TarotYesNoResponse>();
  final Rxn<TarotCareerResponse> careerResponse = Rxn<TarotCareerResponse>();
  final Rxn<TarotInDepthLoveResponse> inDepthLoveResponse =
      Rxn<TarotInDepthLoveResponse>();
  final Rxn<TarotEroticLoveResponse> eroticLoveResponse =
      Rxn<TarotEroticLoveResponse>();
  final Rxn<TarotMadeForEachOtherResponse> madeForEachOtherResponse =
      Rxn<TarotMadeForEachOtherResponse>();
  final Rxn<TarotFlirtReadingResponse> flirtReadingResponse =
      Rxn<TarotFlirtReadingResponse>();
  final Rxn<TarotLoveTriangleResponse> loveTriangleResponse =
      Rxn<TarotLoveTriangleResponse>();
  final Rxn<TarotDailyResponse> dailyResponse = Rxn<TarotDailyResponse>();
  final Rxn<TarotRomanticBreakupResponse> romanticBreakupResponse =
      Rxn<TarotRomanticBreakupResponse>();
  final Rxn<TarotBusinessBreakupResponse> businessBreakupResponse =
      Rxn<TarotBusinessBreakupResponse>();
  final Rxn<TarotFortuneCookieResponse> fortuneCookieResponse =
      Rxn<TarotFortuneCookieResponse>();

  final RxBool isLoadingReading = false.obs;

  // Card unsuitable message state
  final RxBool showUnsuitableCardMessage = false.obs;
  final RxString unsuitableCardName = ''.obs;
  final RxString unsuitableCategoryName = ''.obs;

  // Retry tracking to prevent infinite loops
  final RxInt autoRetryCount = 0.obs;
  final RxInt maxAutoRetries = 3.obs; // Maximum retries before giving up

  @override
  void onInit() {
    super.onInit();
    // Initialize state properly
    _initializeState();

    // Listen to global language changes
    _setupLanguageWorker();
  }

  void _setupLanguageWorker() {
    final languageController = Get.find<LanguageControllerV2>();
    // Initial sync
    selectedLanguage.value = languageController.currentLanguageCode;

    // Listen for changes
    ever(languageController.currentLanguage, (language) {
      if (language != null && selectedLanguage.value != language.code) {
        debugPrint(
          '🌍 TarotController: Language changed to ${language.code}, triggering reshuffle',
        );
        selectedLanguage.value = language.code;
        // If cards are already loaded, reshuffle with new language
        if (cards.isNotEmpty && !isShuffling.value) {
          shuffleCards();
        }
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    // Get language from API header if available
    _getLanguageFromHeader();
  }

  void _initializeState() {
    // Reset all state to initial values
    selectedReadingType.value = 'none';
    selectedCardIndex.value = null;
    isCardOpen.value = false;
    showCards.value = false;
    isShuffling.value = false;
    isLoading.value = false;
    isLoadingReading.value = false;
    errorMessage.value = '';
    shuffleProgress.value = 0.0;
    fanSpreadProgress.value = 0.0;
    // Clear all reading responses
    _clearAllReadingResponses();
  }

  void _clearAllReadingResponses() {
    yesNoResponse.value = null;
    careerResponse.value = null;
    inDepthLoveResponse.value = null;
    eroticLoveResponse.value = null;
    madeForEachOtherResponse.value = null;
    flirtReadingResponse.value = null;
    loveTriangleResponse.value = null;
    dailyResponse.value = null;
    romanticBreakupResponse.value = null;
    businessBreakupResponse.value = null;
    fortuneCookieResponse.value = null;
  }

  void _getLanguageFromHeader() {
    // Language can be passed from API response or set manually
    // For now, we'll keep it optional
  }

  /// Shuffle cards based on selected type
  /// [preserveSelectionState] - if true, preserves reading type and selection state (for multi-card flows)
  Future<void> shuffleCards({bool preserveSelectionState = false}) async {
    try {
      // Clear all previous reading data and reset state (unless preserving for multi-card selection)
      if (!preserveSelectionState) {
        selectedReadingType.value = 'none';
        selectedCardIndex.value = null;
        isCardOpen.value = false;
        _clearAllReadingResponses();
      }

      isShuffling.value = true;
      isLoading.value = true;
      errorMessage.value = '';
      showCards.value = false;
      shuffleProgress.value = 0.0;
      fanSpreadProgress.value = 0.0;

      // Play haptic (sound will play after API)
      await TarotAudioHaptic.lightHaptic();

      // Simulate shuffle progress (for Lottie animation)
      _animateShuffleProgress();

      // Call API
      final response = await _tarotService.shuffleCardsWithRetry(
        shuffleType: selectedShuffleType.value,
        language: selectedLanguage.value,
      );

      // Sort cards by index to maintain API order
      cards.value = response.cards..sort((a, b) => a.index.compareTo(b.index));
      debugPrint('✅ Cards received: ${cards.length} cards');

      // Update language if provided
      if (response.language != null) {
        selectedLanguage.value = response.language;
      }

      // Store remaining API calls from response
      if (response.remainingApiCalls != null) {
        remainingApiCalls.value = response.remainingApiCalls;
      }

      // Wait for Lottie animation to complete
      debugPrint('⏳ Waiting for Lottie animation...');
      await Future.delayed(const Duration(milliseconds: 1500));
      debugPrint('✅ Lottie animation complete');

      // Set isShuffling to false before showing cards so they can render
      isShuffling.value = false;
      debugPrint('✅ isShuffling set to false');

      // Show cards with fan spread animation (sound will play during expansion)
      debugPrint('🎴 Starting fan spread animation...');
      await _animateFanSpread();
      debugPrint('✅ Fan spread animation complete');

      isLoading.value = false;
      debugPrint('✅ isLoading set to false, cards should be visible');
    } catch (e) {
      isShuffling.value = false;
      isLoading.value = false;
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      debugPrint('❌ Tarot Shuffle Error: $errorMessage');
      debugPrint('❌ Full Error: $e');
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  void _animateShuffleProgress() {
    // Animate shuffle progress from 0 to 1
    const duration = Duration(milliseconds: 1500);
    const steps = 30;
    final stepDuration = duration ~/ steps;
    var step = 0;

    Timer.periodic(stepDuration, (timer) {
      step++;
      shuffleProgress.value = (step / steps).clamp(0.0, 1.0);
      if (step >= steps) {
        timer.cancel();
        shuffleProgress.value = 1.0;
      }
    });
  }

  Future<void> _animateFanSpread() async {
    try {
      debugPrint('🎴 _animateFanSpread: Setting showCards to true');
      showCards.value = true;
      debugPrint('🎴 _animateFanSpread: showCards is now ${showCards.value}');

      // Play sound simultaneously with fan spread animation (don't await)
      TarotAudioHaptic.playShuffleSound(); // Fire and forget - plays in parallel

      // Dynamic duration based on card count (optimized for 78 cards)
      final cardCount = cards.length;
      if (cardCount == 0) {
        debugPrint('❌ _animateFanSpread: No cards available!');
        return;
      }

      final duration = _getFanSpreadDuration(cardCount);
      const steps = 60; // More steps for smoother animation
      final stepDurationMs = duration.inMilliseconds ~/ steps;

      // Ensure stepDuration is at least 16ms (60fps = ~16ms per frame)
      final safeStepDurationMs = stepDurationMs > 0 ? stepDurationMs : 16;

      debugPrint(
        '🎴 _animateFanSpread: Starting animation with $cardCount cards, duration: ${duration.inMilliseconds}ms, steps: $steps, stepDuration: ${safeStepDurationMs}ms',
      );

      // Initialize progress to 0
      fanSpreadProgress.value = 0.0;

      // Use Completer to wait for animation to complete
      final completer = Completer<void>();
      var step = 0;
      Timer? timer;

      timer = Timer.periodic(Duration(milliseconds: safeStepDurationMs), (t) {
        step++;
        try {
          // Use smoother easing curve (easeOutCubic with better curve)
          final linearProgress = (step / steps).clamp(0.0, 1.0);
          // Smoother curve: easeOutCubic with slight adjustment
          fanSpreadProgress.value =
              1.0 - math.pow(1 - linearProgress, 2.5).toDouble();

          if (step % 10 == 0 || step >= steps) {
            debugPrint(
              '🎴 _animateFanSpread: Step $step/$steps, progress=${fanSpreadProgress.value}',
            );
          }

          if (step >= steps) {
            t.cancel();
            timer = null;
            fanSpreadProgress.value = 1.0;
            debugPrint(
              '🎴 _animateFanSpread: Animation complete at step $step, completing future',
            );
            if (!completer.isCompleted) {
              completer.complete();
            }
          }
        } catch (e) {
          debugPrint('❌ _animateFanSpread: Error in timer: $e');
          t.cancel();
          timer = null;
          fanSpreadProgress.value = 1.0;
          if (!completer.isCompleted) {
            completer.complete();
          }
        }
      });

      // Add timeout to ensure completer always completes (use duration * 2 to be safe)
      Future.delayed(duration * 2, () {
        if (!completer.isCompleted) {
          debugPrint(
            '⚠️ _animateFanSpread: Timeout reached after ${duration * 2}, forcing completion. Step was $step/$steps',
          );
          timer?.cancel();
          timer = null;
          fanSpreadProgress.value = 1.0;
          if (!completer.isCompleted) {
            completer.complete();
          }
        }
      });

      // Wait for animation to complete
      await completer.future;
      debugPrint(
        '🎴 _animateFanSpread: Future completed, animation finished, final progress=${fanSpreadProgress.value}',
      );
    } catch (e) {
      debugPrint('❌ _animateFanSpread: Error: $e');
      // Ensure cards are shown even if animation fails
      showCards.value = true;
      fanSpreadProgress.value = 1.0;
    }
  }

  Duration _getFanSpreadDuration(int cardCount) {
    if (cardCount <= 22) {
      return const Duration(milliseconds: 600);
    } else if (cardCount <= 56) {
      return const Duration(milliseconds: 800);
    } else {
      return const Duration(milliseconds: 1000);
    }
  }

  /// Select a card with enhanced reveal animation and toggle functionality
  void selectCard(int index) async {
    // Cards are already sorted by API index, so index matches display position
    if (index < 0 || index >= cards.length) return;

    // Check if we're in a multi-card selection flow
    if (selectedLoveType.value == 'triangle' &&
        triangleSelectionStep.value != 'complete') {
      await selectTriangleCard(index);
      return;
    }

    if ((selectedReadingType.value == 'romantic-breakup' ||
            selectedReadingType.value == 'business-breakup') &&
        breakupSelectionStep.value != 'complete') {
      await selectBreakupCard(index);
      return;
    }

    // If same card is tapped and it's open, close it
    if (selectedCardIndex.value == index && isCardOpen.value) {
      await closeCard();
      return;
    }

    // If different card is selected, close previous and open new
    if (selectedCardIndex.value != null && isCardOpen.value) {
      await closeCard();
      await Future.delayed(const Duration(milliseconds: 200));
    }

    selectedCardIndex.value = index;
    // Sound removed - only haptic feedback
    await TarotAudioHaptic.mediumHaptic();

    // Reveal animation with glow and aura
    isRevealing.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    await TarotAudioHaptic.strongHaptic();
    await Future.delayed(const Duration(milliseconds: 400));
    isRevealing.value = false;
    isCardOpen.value = true; // Mark as open/sticky
  }

  /// Close the currently open card with smooth animation
  Future<void> closeCard() async {
    if (!isCardOpen.value) return;

    // Start closing animation
    isRevealing.value = true;
    await TarotAudioHaptic.mediumHaptic();

    // Smooth close animation
    await Future.delayed(const Duration(milliseconds: 400));

    // Reset states
    isCardOpen.value = false;
    isRevealing.value = false;

    // Small delay before clearing selection for smooth transition
    await Future.delayed(const Duration(milliseconds: 100));
    selectedCardIndex.value = null;
  }

  /// Set shuffle type
  void setShuffleType(String type) {
    if (type == 'minor' || type == 'major' || type == 'both') {
      selectedShuffleType.value = type;
    }
  }

  /// Set theme (global - updates instantly)
  void setTheme(String theme) {
    if (['classic', 'artwork', 'dark', 'ghibli'].contains(theme)) {
      if (selectedTheme.value != theme) {
        selectedTheme.value = theme;
        // Force immediate rebuild of all GetBuilder widgets
        update();
      }
    }
  }

  /// Set back image type (global - updates instantly)
  void setBackType(String backType) {
    // API provides: classic, dark, indigo_star, playing_blue, playing_red, ghibli_sun, ghibli_tree
    if ([
      'classic',
      'dark',
      'indigo_star',
      'playing_blue',
      'playing_red',
      'ghibli_sun',
      'ghibli_tree',
    ].contains(backType)) {
      if (selectedBackType.value != backType) {
        selectedBackType.value = backType;
        // Force immediate rebuild of all GetBuilder widgets
        update();
      }
    }
  }

  /// Set language (global for all readings)
  void setLanguage(String? language) {
    selectedLanguage.value = language;
    // Language change is instant - all Obx widgets will update automatically
  }

  /// Reset state
  void reset() {
    cards.clear();
    selectedCardIndex.value = null;
    isCardOpen.value = false;
    showCards.value = false;
    isShuffling.value = false;
    isLoading.value = false;
    isLoadingReading.value = false;
    errorMessage.value = '';
    shuffleProgress.value = 0.0;
    fanSpreadProgress.value = 0.0;
    selectedReadingType.value = 'none';
    _clearAllReadingResponses();
  }

  /// Get selected card
  TarotCardModel? get selectedCard {
    final index = selectedCardIndex.value;
    if (index == null) return null;
    if (index >= 0 && index < cards.length) {
      return cards[index];
    }
    return null;
  }

  /// Set reading type
  void setReadingType(String type) {
    if (['none', 'yesno', 'career', 'love', 'daily'].contains(type)) {
      selectedReadingType.value = type;
    }
  }

  /// Set love reading type
  void setLoveType(String type) {
    if ([
      'in-depth',
      'erotic',
      'made-for-each-other',
      'flirt',
      'triangle',
    ].contains(type)) {
      selectedLoveType.value = type;
      // Reset triangle selection if switching away from triangle
      if (type != 'triangle') {
        triangleCardSelf.value = null;
        triangleCardLover1.value = null;
        triangleCardLover2.value = null;
        triangleSelectionStep.value = 'self';
      } else {
        // When triangle is selected, close the popup and start selection flow
        selectedReadingType.value = 'none'; // Close popup
        triangleSelectionStep.value = 'self';
        triangleCardSelf.value = null;
        triangleCardLover1.value = null;
        triangleCardLover2.value = null;
      }
    }
  }

  /// Set breakup type
  void setBreakupType(String type) {
    if (['romantic', 'business'].contains(type)) {
      selectedBreakupType.value = type;
      // Reset breakup selection when switching types
      breakupCardCause.value = null;
      breakupCardAdvise.value = null;
      breakupSelectionStep.value = 'cause';
      // Close popup when breakup type is selected
      selectedReadingType.value = 'none';
    }
  }

  /// Set direction (Upright/Reversed) - empty string means skip/auto-select
  void setDirection(String direction) {
    if (direction.isEmpty) {
      selectedDirection.value = '';
    } else if (['upright', 'reversed'].contains(direction.toLowerCase())) {
      selectedDirection.value = direction.toLowerCase();
    }
  }

  /// Select card for Love Triangle (handles 3-step selection)
  Future<void> selectTriangleCard(int index) async {
    if (index < 0 || index >= cards.length) return;

    final card = cards[index];
    final step = triangleSelectionStep.value;

    // Validate: prevent selecting the same card multiple times
    if (step == 'lover1' && triangleCardSelf.value?.id == card.id) {
      // Show animation instead of snackbar
      unsuitableCardName.value = card.name;
      unsuitableCategoryName.value = 'Love Triangle (Duplicate Card)';
      await Future.delayed(const Duration(milliseconds: 100));
      showUnsuitableCardMessage.value = true;
      // Don't proceed with selection
      return;
    }
    if (step == 'lover2' &&
        (triangleCardSelf.value?.id == card.id ||
            triangleCardLover1.value?.id == card.id)) {
      // Show animation instead of snackbar
      unsuitableCardName.value = card.name;
      unsuitableCategoryName.value = 'Love Triangle (Duplicate Card)';
      await Future.delayed(const Duration(milliseconds: 100));
      showUnsuitableCardMessage.value = true;
      // Don't proceed with selection
      return;
    }

    if (step == 'self') {
      triangleCardSelf.value = card;
      triangleSelectionStep.value = 'lover1';
      // Close current card and prepare for next selection
      await closeCard();
      // Trigger shuffle for next card (preserve selection state)
      await shuffleCards(preserveSelectionState: true);
      // Ensure reading type is set
      selectedReadingType.value = 'love';
      selectedLoveType.value = 'triangle';
      // Visual progress shown in TarotSelectionProgressWidget - no snackbar needed
    } else if (step == 'lover1') {
      triangleCardLover1.value = card;
      triangleSelectionStep.value = 'lover2';
      await closeCard();
      await shuffleCards(preserveSelectionState: true);
      // Ensure reading type is set
      selectedReadingType.value = 'love';
      selectedLoveType.value = 'triangle';
      // Visual progress shown in TarotSelectionProgressWidget - no snackbar needed
    } else if (step == 'lover2') {
      triangleCardLover2.value = card;
      triangleSelectionStep.value = 'complete';
      // Don't close card - keep it visible so user can see their selection
      // Just make API call directly
      await getLoveTriangleReading();
    }
  }

  /// Select card for Breakup reading (handles 2-step selection)
  Future<void> selectBreakupCard(int index) async {
    if (index < 0 || index >= cards.length) return;

    final card = cards[index];
    final step = breakupSelectionStep.value;

    // Validate: prevent selecting the same card for both cause and advise
    if (step == 'advise' && breakupCardCause.value?.id == card.id) {
      // Show animation instead of snackbar
      unsuitableCardName.value = card.name;
      unsuitableCategoryName.value =
          '${selectedBreakupType.value == 'romantic' ? 'Romantic' : 'Business'} Breakup (Duplicate Card)';
      await Future.delayed(const Duration(milliseconds: 100));
      showUnsuitableCardMessage.value = true;
      // Don't proceed with selection
      return;
    }

    if (step == 'cause') {
      breakupCardCause.value = card;
      breakupSelectionStep.value = 'advise';
      await closeCard();
      // Trigger shuffle for advise card (preserve selection state)
      await shuffleCards(preserveSelectionState: true);
      // Ensure reading type is set
      if (selectedBreakupType.value == 'romantic') {
        selectedReadingType.value = 'romantic-breakup';
      } else {
        selectedReadingType.value = 'business-breakup';
      }
      // Visual progress shown in TarotSelectionProgressWidget - no snackbar needed
    } else if (step == 'advise') {
      breakupCardAdvise.value = card;
      breakupSelectionStep.value = 'complete';
      // Don't close card - keep it visible so user can see their selection
      // Just make API call directly
      if (selectedBreakupType.value == 'romantic') {
        await _performRomanticBreakupReading();
      } else {
        await _performBusinessBreakupReading();
      }
    }
  }

  /// Skip card selection for Love Triangle (allows API auto-selection)
  Future<void> skipTriangleCard() async {
    final step = triangleSelectionStep.value;

    if (step == 'self') {
      triangleCardSelf.value = null; // API will auto-select
      triangleSelectionStep.value = 'lover1';
      // Trigger shuffle for next card (preserve selection state)
      await shuffleCards(preserveSelectionState: true);
      // Ensure reading type is set
      selectedReadingType.value = 'love';
      selectedLoveType.value = 'triangle';
    } else if (step == 'lover1') {
      triangleCardLover1.value = null; // API will auto-select
      triangleSelectionStep.value = 'lover2';
      // Trigger shuffle for next card (preserve selection state)
      await shuffleCards(preserveSelectionState: true);
      // Ensure reading type is set
      selectedReadingType.value = 'love';
      selectedLoveType.value = 'triangle';
    } else if (step == 'lover2') {
      triangleCardLover2.value = null; // API will auto-select
      triangleSelectionStep.value = 'complete';
      // Make API call with all nulls (API will auto-select all)
      await getLoveTriangleReading();
    }
  }

  /// Skip card selection for Breakup reading (allows API auto-selection)
  Future<void> skipBreakupCard() async {
    final step = breakupSelectionStep.value;

    if (step == 'cause') {
      breakupCardCause.value = null; // API will auto-select
      breakupSelectionStep.value = 'advise';
      // Trigger shuffle for advise card (preserve selection state)
      await shuffleCards(preserveSelectionState: true);
      // Ensure reading type is set
      if (selectedBreakupType.value == 'romantic') {
        selectedReadingType.value = 'romantic-breakup';
      } else {
        selectedReadingType.value = 'business-breakup';
      }
    } else if (step == 'advise') {
      breakupCardAdvise.value = null; // API will auto-select
      breakupSelectionStep.value = 'complete';
      // Make API call with nulls (API will auto-select)
      if (selectedBreakupType.value == 'romantic') {
        await _performRomanticBreakupReading();
      } else {
        await _performBusinessBreakupReading();
      }
    }
  }

  /// Get Love Triangle Reading (called after all 3 cards are selected or skipped)
  Future<void> getLoveTriangleReading() async {
    // Prevent multiple simultaneous calls
    if (isLoadingReading.value) {
      debugPrint('⚠️ Love Triangle API call already in progress, skipping...');
      return;
    }

    // Reset retry count when starting a new reading (not a retry)
    if (autoRetryCount.value == 0 || showUnsuitableCardMessage.value == false) {
      autoRetryCount.value = 0;
    }

    try {
      isLoadingReading.value = true;
      // Ensure reading type is set before API call
      selectedReadingType.value = 'love';
      selectedLoveType.value = 'triangle';

      debugPrint(
        '🔄 Calling Love Triangle API - self: ${triangleCardSelf.value?.id ?? "null"}, lover1: ${triangleCardLover1.value?.id ?? "null"}, lover2: ${triangleCardLover2.value?.id ?? "null"}',
      );

      final response = await _tarotService.getLoveTriangleReading(
        cardSelf: triangleCardSelf.value?.id,
        cardLover1: triangleCardLover1.value?.id,
        cardLover2: triangleCardLover2.value?.id,
        language: selectedLanguage.value,
      );
      debugPrint('✅ Love Triangle Response received');
      debugPrint(
        '✅ Love Triangle Response - success: ${response.success}, self: ${response.self.name}, lover1: ${response.lover1.name}, lover2: ${response.lover2.name}',
      );

      // Only store response if it's successful and has valid data
      if (!response.success) {
        throw Exception('Love Triangle API returned an error response');
      }

      // Validate that response has actual data (not empty strings)
      if (response.self.name.isEmpty ||
          response.lover1.name.isEmpty ||
          response.lover2.name.isEmpty) {
        throw Exception('Love Triangle API returned empty data');
      }

      loveTriangleResponse.value = response;
      if (response.remainingApiCalls != null) {
        remainingApiCalls.value = response.remainingApiCalls;
      }
      // Ensure reading type is set after response (in case it was reset)
      selectedReadingType.value = 'love';
      selectedLoveType.value = 'triangle';
      triangleSelectionStep.value = 'complete';
      // Reset retry count on success
      autoRetryCount.value = 0;
    } catch (e) {
      final fullError = e.toString();
      final errorMsg = fullError
          .replaceAll('Exception: ', '')
          .replaceAll('Love Triangle API Error: ', '');
      debugPrint('❌ Tarot Love Triangle API Error: $errorMsg');
      debugPrint('❌ Full Exception: $fullError');

      // Check if it's a card suitability error (status 400) - check the full error string
      // Also check if any cards are selected (if they are and we get an error, it's likely a suitability issue)
      final hasSelectedCards =
          triangleCardSelf.value != null ||
          triangleCardLover1.value != null ||
          triangleCardLover2.value != null;
      final isStatus400 =
          fullError.contains('Status: 400') ||
          fullError.contains('status: 400') ||
          (fullError.contains('400') && hasSelectedCards) ||
          errorMsg.contains('Status: 400') ||
          errorMsg.contains('status: 400') ||
          errorMsg.toLowerCase().contains('not suitable') ||
          errorMsg.toLowerCase().contains('invalid card');

      debugPrint('🔍 Love Triangle Error Detection - fullError: $fullError');
      debugPrint('🔍 Love Triangle Error Detection - errorMsg: $errorMsg');
      debugPrint(
        '🔍 Love Triangle Error Detection - isStatus400: $isStatus400, hasSelectedCards: $hasSelectedCards',
      );

      if (isStatus400) {
        // Check retry count to prevent infinite loops
        if (autoRetryCount.value >= maxAutoRetries.value) {
          debugPrint(
            '⚠️ Max retries reached for Love Triangle. Clearing all selections and trying with random cards.',
          );
          // Clear all selections and try with random valid cards
          await _tryLoveTriangleWithRandomCards();
          return;
        }

        // Determine which card caused the issue - prioritize the last selected card
        String? problematicCardName;
        if (triangleCardLover2.value != null) {
          problematicCardName = triangleCardLover2.value!.name;
          triangleCardLover2.value = null; // Clear it for auto-select
        } else if (triangleCardLover1.value != null) {
          problematicCardName = triangleCardLover1.value!.name;
          triangleCardLover1.value = null; // Clear it for auto-select
        } else if (triangleCardSelf.value != null) {
          problematicCardName = triangleCardSelf.value!.name;
          triangleCardSelf.value = null; // Clear it for auto-select
        }

        if (problematicCardName != null) {
          // Increment retry count
          autoRetryCount.value++;

          // Show animated message
          debugPrint(
            '🎬 Showing unsuitable card animation - Card: $problematicCardName, Category: Love Triangle',
          );
          unsuitableCardName.value = problematicCardName;
          unsuitableCategoryName.value = 'Love Triangle';
          // Use a small delay to ensure state is set before showing
          await Future.delayed(const Duration(milliseconds: 100));
          showUnsuitableCardMessage.value = true;

          // Don't show snackbar - let the animation handle it
          // Auto-retry after animation completes (handled by widget callback)
          return;
        } else {
          // All cards are null but still getting error - try with random cards
          debugPrint(
            '⚠️ All cards null but still getting error. Trying with random cards.',
          );
          await _tryLoveTriangleWithRandomCards();
          return;
        }
      }

      // Check for duplicate card error
      if (errorMsg.toLowerCase().contains('same card') ||
          errorMsg.toLowerCase().contains('duplicate')) {
        triangleSelectionStep.value = 'lover2';
        Get.snackbar(
          'Reading Error',
          'You cannot use the same card multiple times. Please select different cards.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Reset selection step to allow retry
      triangleSelectionStep.value = 'lover2';

      // Only show snackbar if we're not showing the animation
      if (!showUnsuitableCardMessage.value) {
        // Show user-friendly error message
        Get.snackbar(
          'Reading Error',
          'Unable to get reading. Please try selecting different cards or skip to auto-select.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      isLoadingReading.value = false;
    }
  }

  /// Get Yes/No Reading
  Future<void> getYesNoReading() async {
    // Set reading type first
    selectedReadingType.value = 'yesno';

    // If response already exists, don't call API again
    if (yesNoResponse.value != null) {
      return;
    }

    // Show direction selector - API will be called when direction is selected or skipped
    // The direction selector widget will trigger performYesNoReading()
    return;
  }

  /// Perform Yes/No Reading API call (called from direction selector or skip)
  Future<void> performYesNoReading() async {
    try {
      isLoadingReading.value = true;
      final card = selectedCard;
      // Use selected card if available, otherwise API will auto-select
      final response = await _tarotService.getYesNoReading(
        cardName: card?.id,
        direction:
            selectedDirection.value == 'upright' ||
                selectedDirection.value == 'reversed'
            ? selectedDirection.value
            : null,
        language: selectedLanguage.value,
      );
      debugPrint(
        '✅ Yes/No Response received - cardImage keys: ${response.cardImage.keys}',
      );
      debugPrint(
        '✅ Yes/No Response - name: ${response.name}, id: ${response.id}',
      );
      debugPrint(
        '✅ Yes/No Response - meaning: ${response.meaning}, description length: ${response.description.length}',
      );
      yesNoResponse.value = response;
      if (response.remainingApiCalls != null) {
        remainingApiCalls.value = response.remainingApiCalls;
      }
      selectedReadingType.value = 'yesno';
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      debugPrint('❌ Tarot Yes/No API Error: $errorMsg');

      // Use centralized validation handler
      final handled = await TarotCardValidationHandler.handleApiError(
        error: e,
        categoryName: 'Yes/No Reading',
        selectedCard: selectedCard,
        onShowUnsuitableMessage: (cardName, category) {
          unsuitableCardName.value = cardName;
          unsuitableCategoryName.value = category;
          showUnsuitableCardMessage.value = true;
        },
        onRetry: () => performYesNoReading(),
        currentRetryCount: autoRetryCount.value,
      );

      if (!handled) {
        Get.snackbar('Error', errorMsg);
      }
    } finally {
      isLoadingReading.value = false;
    }
  }

  /// Get Career Reading
  Future<void> getCareerReading() async {
    // Set reading type first
    selectedReadingType.value = 'career';

    // If response already exists, don't call API again
    if (careerResponse.value != null) {
      return;
    }

    // Show direction selector - API will be called when direction is selected or skipped
    // The direction selector widget will trigger performCareerReading()
    return;
  }

  /// Perform Career Reading API call (called from direction selector or skip)
  Future<void> performCareerReading() async {
    try {
      isLoadingReading.value = true;
      final card = selectedCard;
      // Use selected card if available, otherwise API will auto-select
      final response = await _tarotService.getCareerReading(
        cardName: card?.id,
        direction:
            selectedDirection.value == 'upright' ||
                selectedDirection.value == 'reversed'
            ? selectedDirection.value
            : null,
        language: selectedLanguage.value,
      );
      debugPrint(
        '✅ Career Response received - cardImage keys: ${response.cardImage.keys}',
      );
      debugPrint(
        '✅ Career Response - name: ${response.name}, id: ${response.id}',
      );
      debugPrint(
        '✅ Career Response - description length: ${response.description.length}, careerPaths count: ${response.careerPaths.length}',
      );
      careerResponse.value = response;
      if (response.remainingApiCalls != null) {
        remainingApiCalls.value = response.remainingApiCalls;
      }
      selectedReadingType.value = 'career';
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      debugPrint('❌ Tarot Career API Error: $errorMsg');

      // Use centralized validation handler
      final handled = await TarotCardValidationHandler.handleApiError(
        error: e,
        categoryName: 'Career Reading',
        selectedCard: selectedCard,
        onShowUnsuitableMessage: (cardName, category) {
          unsuitableCardName.value = cardName;
          unsuitableCategoryName.value = category;
          showUnsuitableCardMessage.value = true;
        },
        onRetry: () => performCareerReading(),
        currentRetryCount: autoRetryCount.value,
      );

      if (!handled) {
        Get.snackbar('Error', errorMsg);
      }
    } finally {
      isLoadingReading.value = false;
    }
  }

  /// Get Love Reading
  Future<void> getLoveReading() async {
    try {
      final loveType = selectedLoveType.value;
      final card = selectedCard;
      debugPrint(
        '🔄 Getting Love Reading - type: $loveType, card: ${card?.id ?? "auto-select"}',
      );

      if (loveType == 'triangle') {
        // Clear breakup state to ensure breakup widget doesn't show
        if (breakupSelectionStep.value != 'complete' ||
            selectedReadingType.value == 'romantic-breakup' ||
            selectedReadingType.value == 'business-breakup') {
          breakupSelectionStep.value = 'cause';
        }

        // If response already exists and step is complete, show it
        if (loveTriangleResponse.value != null &&
            triangleSelectionStep.value == 'complete') {
          selectedReadingType.value = 'love';
          selectedLoveType.value = 'triangle';
          // Ensure widget can display by setting reading type
          return; // Just show existing response
        }
        // Check if all 3 cards are selected
        if (triangleCardSelf.value == null ||
            triangleCardLover1.value == null ||
            triangleCardLover2.value == null) {
          // Start the triangle selection flow
          selectedReadingType.value = 'love';
          selectedLoveType.value = 'triangle';
          triangleSelectionStep.value = 'self';
          // Visual progress shown in TarotSelectionProgressWidget - no snackbar needed
          return;
        }
        // All cards selected, make API call
        isLoadingReading.value = true;
        await getLoveTriangleReading();
        return;
      } else if (loveType == 'in-depth') {
        isLoadingReading.value = true;
        final response = await _tarotService.getInDepthLoveReading(
          cardName: card?.id,
          language: selectedLanguage.value,
        );
        debugPrint(
          '✅ In-Depth Love Response - success: ${response.success}, description length: ${response.description.length}',
        );
        // Only store if successful
        if (response.success) {
          inDepthLoveResponse.value = response;
        } else {
          throw Exception('In-Depth Love API returned an error response');
        }
        if (response.remainingApiCalls != null) {
          remainingApiCalls.value = response.remainingApiCalls;
        }
        debugPrint('✅ In-Depth Love Response stored');
      } else if (loveType == 'erotic') {
        isLoadingReading.value = true;
        final response = await _tarotService.getEroticLoveReading(
          cardName: card?.id,
          language: selectedLanguage.value,
        );
        debugPrint(
          '✅ Erotic Love Response - success: ${response.success}, description length: ${response.description.length}',
        );
        // Only store if successful
        if (response.success) {
          eroticLoveResponse.value = response;
        } else {
          throw Exception('Erotic Love API returned an error response');
        }
        if (response.remainingApiCalls != null) {
          remainingApiCalls.value = response.remainingApiCalls;
        }
        debugPrint('✅ Erotic Love Response stored');
      } else if (loveType == 'made-for-each-other') {
        isLoadingReading.value = true;
        final response = await _tarotService.getMadeForEachOtherReading(
          cardName: card?.id,
          language: selectedLanguage.value,
        );
        debugPrint(
          '✅ Made For Each Other Response - success: ${response.success}, description length: ${response.description.length}',
        );
        // Only store if successful
        if (response.success) {
          madeForEachOtherResponse.value = response;
        } else {
          throw Exception('Made For Each Other API returned an error response');
        }
        if (response.remainingApiCalls != null) {
          remainingApiCalls.value = response.remainingApiCalls;
        }
        debugPrint('✅ Made For Each Other Response stored');
      } else if (loveType == 'flirt') {
        isLoadingReading.value = true;
        final response = await _tarotService.getFlirtReading(
          cardName: card?.id,
          language: selectedLanguage.value,
        );
        debugPrint(
          '✅ Flirt Reading Response - success: ${response.success}, description length: ${response.description.length}',
        );
        // Only store if successful
        if (response.success) {
          flirtReadingResponse.value = response;
        } else {
          throw Exception('Flirt Reading API returned an error response');
        }
        if (response.remainingApiCalls != null) {
          remainingApiCalls.value = response.remainingApiCalls;
        }
      }

      selectedReadingType.value = 'love';
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      debugPrint('❌ Tarot Love API Error: $errorMsg');

      // Use centralized validation handler with dynamic category name
      final categoryName = TarotCardValidationHandler.formatCategoryName(
        selectedLoveType.value,
      );
      final handled = await TarotCardValidationHandler.handleApiError(
        error: e,
        categoryName: categoryName,
        selectedCard: selectedCard,
        onShowUnsuitableMessage: (cardName, category) {
          unsuitableCardName.value = cardName;
          unsuitableCategoryName.value = category;
          showUnsuitableCardMessage.value = true;
        },
        onRetry: () => getLoveReading(),
        currentRetryCount: autoRetryCount.value,
      );

      if (!handled && !showUnsuitableCardMessage.value) {
        Get.snackbar('Error', errorMsg);
      }
    } finally {
      isLoadingReading.value = false;
    }
  }

  /// Get Daily Reading
  Future<void> getDailyReading() async {
    try {
      isLoadingReading.value = true;
      final card = selectedCard;
      // Use selected card if available, otherwise API will auto-select
      final response = await _tarotService.getDailyReading(
        cardName: card?.id,
        language: selectedLanguage.value,
      );
      dailyResponse.value = response;
      if (response.remainingApiCalls != null) {
        remainingApiCalls.value = response.remainingApiCalls;
      }
      selectedReadingType.value = 'daily';
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      debugPrint('❌ Tarot Daily API Error: $errorMsg');

      // Use centralized validation handler
      final handled = await TarotCardValidationHandler.handleApiError(
        error: e,
        categoryName: 'Daily Reading',
        selectedCard: selectedCard,
        onShowUnsuitableMessage: (cardName, category) {
          unsuitableCardName.value = cardName;
          unsuitableCategoryName.value = category;
          showUnsuitableCardMessage.value = true;
        },
        onRetry: () => getDailyReading(),
        currentRetryCount: autoRetryCount.value,
      );

      if (!handled && !showUnsuitableCardMessage.value) {
        Get.snackbar('Error', errorMsg);
      }
    } finally {
      isLoadingReading.value = false;
    }
  }

  /// Get Romantic Breakup Reading (starts selection flow if cards not selected)
  Future<void> getRomanticBreakupReading() async {
    // Set reading type and breakup type first - this ensures other reading types are hidden
    selectedBreakupType.value = 'romantic';
    selectedReadingType.value = 'romantic-breakup';
    // Clear love reading type to ensure love widget doesn't show
    if (selectedLoveType.value == 'triangle') {
      selectedLoveType.value = 'in-depth'; // Reset to default
    }

    // If response already exists and step is complete, don't restart
    if (romanticBreakupResponse.value != null &&
        breakupSelectionStep.value == 'complete') {
      return; // Just show existing response
    }

    // Check if cards are already selected
    if (breakupCardCause.value != null && breakupCardAdvise.value != null) {
      // Cards already selected, make API call
      await _performRomanticBreakupReading();
      return;
    }

    // Start selection flow
    breakupSelectionStep.value = 'cause';
    breakupCardCause.value = null;
    breakupCardAdvise.value = null;
    // Visual progress shown in TarotSelectionProgressWidget - no snackbar needed
  }

  /// Perform Romantic Breakup Reading (called after both cards are selected or skipped)
  Future<void> _performRomanticBreakupReading() async {
    // Prevent multiple simultaneous calls
    if (isLoadingReading.value) {
      debugPrint(
        '⚠️ Romantic Breakup API call already in progress, skipping...',
      );
      return;
    }

    // Reset retry count when starting a new reading (not a retry)
    if (autoRetryCount.value == 0 || showUnsuitableCardMessage.value == false) {
      autoRetryCount.value = 0;
    }

    try {
      isLoadingReading.value = true;
      // Ensure reading type is set before API call
      selectedReadingType.value = 'romantic-breakup';
      selectedBreakupType.value = 'romantic';

      debugPrint(
        '🔄 Calling Romantic Breakup API - cause: ${breakupCardCause.value?.id ?? "null"}, advise: ${breakupCardAdvise.value?.id ?? "null"}',
      );

      final response = await _tarotService.getRomanticBreakupReading(
        cardCause: breakupCardCause.value?.id,
        cardAdvise: breakupCardAdvise.value?.id,
        language: selectedLanguage.value,
      );
      debugPrint('✅ Romantic Breakup Response received');
      debugPrint(
        '✅ Romantic Breakup Response - success: ${response.success}, cause: ${response.cause.name}, advise: ${response.advise.name}',
      );

      // Only store response if it's successful
      if (!response.success) {
        throw Exception('Romantic Breakup API returned an error response');
      }

      // Validate that response has actual data (not empty strings)
      if (response.cause.name.isEmpty || response.advise.name.isEmpty) {
        throw Exception('Romantic Breakup API returned empty data');
      }

      romanticBreakupResponse.value = response;
      if (response.remainingApiCalls != null) {
        remainingApiCalls.value = response.remainingApiCalls;
      }
      // Ensure reading type is set after response (in case it was reset)
      selectedReadingType.value = 'romantic-breakup';
      selectedBreakupType.value = 'romantic';
      breakupSelectionStep.value = 'complete';
      // Reset retry count on success
      autoRetryCount.value = 0;
    } catch (e) {
      final fullError = e.toString();
      final errorMsg = fullError
          .replaceAll('Exception: ', '')
          .replaceAll('Romantic Breakup API Error: ', '');
      debugPrint('❌ Tarot Romantic Breakup API Error: $errorMsg');
      debugPrint('❌ Full Exception: $fullError');

      // Check if it's a card suitability error (status 400) - check the full error string
      final hasSelectedCards =
          breakupCardCause.value != null || breakupCardAdvise.value != null;
      final isStatus400 =
          fullError.contains('Status: 400') ||
          fullError.contains('status: 400') ||
          (fullError.contains('400') && hasSelectedCards) ||
          errorMsg.contains('Status: 400') ||
          errorMsg.contains('status: 400') ||
          errorMsg.toLowerCase().contains('not suitable') ||
          errorMsg.toLowerCase().contains('invalid card');

      debugPrint('🔍 Romantic Breakup Error Detection - fullError: $fullError');
      debugPrint(
        '🔍 Romantic Breakup Error Detection - isStatus400: $isStatus400, hasSelectedCards: $hasSelectedCards',
      );

      if (isStatus400) {
        // Check retry count to prevent infinite loops
        if (autoRetryCount.value >= maxAutoRetries.value) {
          debugPrint(
            '⚠️ Max retries reached for Romantic Breakup. Trying with random cards.',
          );
          await _tryBreakupWithRandomCards(isBusiness: false);
          return;
        }

        // Determine which card caused the issue - prioritize the last selected card
        String? problematicCardName;
        if (breakupCardAdvise.value != null) {
          problematicCardName = breakupCardAdvise.value!.name;
          breakupCardAdvise.value = null; // Clear it for auto-select
        } else if (breakupCardCause.value != null) {
          problematicCardName = breakupCardCause.value!.name;
          breakupCardCause.value = null; // Clear it for auto-select
        }

        if (problematicCardName != null) {
          // Increment retry count
          autoRetryCount.value++;

          // Show animated message
          debugPrint(
            '🎬 Showing unsuitable card animation - Card: $problematicCardName, Category: Romantic Breakup',
          );
          unsuitableCardName.value = problematicCardName;
          unsuitableCategoryName.value = 'Romantic Breakup';
          // Use a small delay to ensure state is set before showing
          await Future.delayed(const Duration(milliseconds: 100));
          showUnsuitableCardMessage.value = true;

          // Don't show snackbar - let the animation handle it
          // Auto-retry after animation completes (handled by widget callback)
          return;
        } else {
          // All cards are null but still getting error - try with random cards
          debugPrint(
            '⚠️ All cards null but still getting error. Trying with random cards.',
          );
          await _tryBreakupWithRandomCards(isBusiness: false);
          return;
        }
      }

      // Check for duplicate card error
      if (errorMsg.toLowerCase().contains('same card') ||
          errorMsg.toLowerCase().contains('duplicate')) {
        breakupSelectionStep.value = 'advise';
        Get.snackbar(
          'Reading Error',
          'You cannot use the same card for both cause and advice. Please select different cards.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Reset selection step to allow retry
      breakupSelectionStep.value = 'advise';

      // Only show snackbar if we're not showing the animation
      if (!showUnsuitableCardMessage.value) {
        // Show user-friendly error message
        Get.snackbar(
          'Reading Error',
          'Unable to get reading. Please try selecting different cards or skip to auto-select.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      isLoadingReading.value = false;
    }
  }

  /// Get Business Breakup Reading (starts selection flow if cards not selected)
  Future<void> getBusinessBreakupReading() async {
    // Set reading type and breakup type first - this ensures other reading types are hidden
    selectedBreakupType.value = 'business';
    selectedReadingType.value = 'business-breakup';
    // Clear love reading type to ensure love widget doesn't show
    if (selectedLoveType.value == 'triangle') {
      selectedLoveType.value = 'in-depth'; // Reset to default
    }

    // If response already exists and step is complete, show it
    if (businessBreakupResponse.value != null &&
        breakupSelectionStep.value == 'complete') {
      selectedReadingType.value = 'business-breakup';
      selectedBreakupType.value = 'business';
      // Ensure widget can display by setting reading type
      return; // Just show existing response
    }

    // Check if cards are already selected
    if (breakupCardCause.value != null && breakupCardAdvise.value != null) {
      // Cards already selected, make API call
      await _performBusinessBreakupReading();
      return;
    }

    // Start selection flow
    breakupSelectionStep.value = 'cause';
    breakupCardCause.value = null;
    breakupCardAdvise.value = null;
    // Visual progress shown in TarotSelectionProgressWidget - no snackbar needed
  }

  /// Perform Business Breakup Reading (called after both cards are selected or skipped)
  Future<void> _performBusinessBreakupReading() async {
    // Prevent multiple simultaneous calls
    if (isLoadingReading.value) {
      debugPrint(
        '⚠️ Business Breakup API call already in progress, skipping...',
      );
      return;
    }

    // Reset retry count when starting a new reading (not a retry)
    if (autoRetryCount.value == 0 || showUnsuitableCardMessage.value == false) {
      autoRetryCount.value = 0;
    }

    try {
      isLoadingReading.value = true;
      // Ensure reading type is set before API call
      selectedReadingType.value = 'business-breakup';
      selectedBreakupType.value = 'business';

      debugPrint(
        '🔄 Calling Business Breakup API - cause: ${breakupCardCause.value?.id ?? "null"}, advise: ${breakupCardAdvise.value?.id ?? "null"}',
      );

      final response = await _tarotService.getBusinessBreakupReading(
        cardCause: breakupCardCause.value?.id,
        cardAdvise: breakupCardAdvise.value?.id,
        language: selectedLanguage.value,
      );
      debugPrint('✅ Business Breakup Response received');
      debugPrint(
        '✅ Business Breakup Response - success: ${response.success}, cause: ${response.cause.name}, advise: ${response.advise.name}',
      );

      // Only store response if it's successful
      if (!response.success) {
        throw Exception('Business Breakup API returned an error response');
      }

      // Validate that response has actual data (not empty strings)
      if (response.cause.name.isEmpty || response.advise.name.isEmpty) {
        throw Exception('Business Breakup API returned empty data');
      }

      businessBreakupResponse.value = response;
      if (response.remainingApiCalls != null) {
        remainingApiCalls.value = response.remainingApiCalls;
      }
      // Ensure reading type is set after response (in case it was reset)
      selectedReadingType.value = 'business-breakup';
      selectedBreakupType.value = 'business';
      breakupSelectionStep.value = 'complete';
      // Reset retry count on success
      autoRetryCount.value = 0;
    } catch (e) {
      final fullError = e.toString();
      final errorMsg = fullError
          .replaceAll('Exception: ', '')
          .replaceAll('Business Breakup API Error: ', '');
      debugPrint('❌ Tarot Business Breakup API Error: $errorMsg');
      debugPrint('❌ Full Exception: $fullError');

      // Check if it's a card suitability error (status 400) - check the full error string
      final hasSelectedCards =
          breakupCardCause.value != null || breakupCardAdvise.value != null;
      final isStatus400 =
          fullError.contains('Status: 400') ||
          fullError.contains('status: 400') ||
          (fullError.contains('400') && hasSelectedCards) ||
          errorMsg.contains('Status: 400') ||
          errorMsg.contains('status: 400') ||
          errorMsg.toLowerCase().contains('not suitable') ||
          errorMsg.toLowerCase().contains('invalid card');

      debugPrint('🔍 Business Breakup Error Detection - fullError: $fullError');
      debugPrint(
        '🔍 Business Breakup Error Detection - isStatus400: $isStatus400, hasSelectedCards: $hasSelectedCards',
      );

      if (isStatus400) {
        // Check retry count to prevent infinite loops
        if (autoRetryCount.value >= maxAutoRetries.value) {
          debugPrint(
            '⚠️ Max retries reached for Business Breakup. Trying with random cards.',
          );
          await _tryBreakupWithRandomCards(isBusiness: true);
          return;
        }

        // Determine which card caused the issue - prioritize the last selected card
        String? problematicCardName;
        if (breakupCardAdvise.value != null) {
          problematicCardName = breakupCardAdvise.value!.name;
          breakupCardAdvise.value = null; // Clear it for auto-select
        } else if (breakupCardCause.value != null) {
          problematicCardName = breakupCardCause.value!.name;
          breakupCardCause.value = null; // Clear it for auto-select
        }

        if (problematicCardName != null) {
          // Increment retry count
          autoRetryCount.value++;

          // Show animated message
          debugPrint(
            '🎬 Showing unsuitable card animation - Card: $problematicCardName, Category: Business Breakup',
          );
          unsuitableCardName.value = problematicCardName;
          unsuitableCategoryName.value = 'Business Breakup';
          // Use a small delay to ensure state is set before showing
          await Future.delayed(const Duration(milliseconds: 100));
          showUnsuitableCardMessage.value = true;

          // Don't show snackbar - let the animation handle it
          // Auto-retry after animation completes (handled by widget callback)
          return;
        } else {
          // All cards are null but still getting error - try with random cards
          debugPrint(
            '⚠️ All cards null but still getting error. Trying with random cards.',
          );
          await _tryBreakupWithRandomCards(isBusiness: true);
          return;
        }
      }

      // Check for duplicate card error
      if (errorMsg.toLowerCase().contains('same card') ||
          errorMsg.toLowerCase().contains('duplicate')) {
        breakupSelectionStep.value = 'advise';
        Get.snackbar(
          'Reading Error',
          'You cannot use the same card for both cause and advice. Please select different cards.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Reset selection step to allow retry
      breakupSelectionStep.value = 'advise';

      // Only show snackbar if we're not showing the animation
      if (!showUnsuitableCardMessage.value) {
        // Show user-friendly error message
        Get.snackbar(
          'Reading Error',
          'Unable to get reading. Please try selecting different cards or skip to auto-select.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      isLoadingReading.value = false;
    }
  }

  /// Handle auto-retry after showing unsuitable card message
  Future<void> handleUnsuitableCardAutoRetry() async {
    showUnsuitableCardMessage.value = false;
    final category = unsuitableCategoryName.value;
    unsuitableCardName.value = '';
    unsuitableCategoryName.value = '';

    // If it's a duplicate card error, just hide the message (don't retry)
    if (category.contains('Duplicate Card')) {
      debugPrint(
        '⚠️ Duplicate card detected - not retrying, just hiding message',
      );
      return;
    }

    // Clear the problematic card selection
    selectedCardIndex.value = null;
    isCardOpen.value = false;

    // Auto-retry with null cards (API will auto-select)
    if (category.contains('Business Breakup')) {
      await _performBusinessBreakupReading();
    } else if (category.contains('Romantic Breakup')) {
      await _performRomanticBreakupReading();
    } else if (category.contains('Love Triangle')) {
      await getLoveTriangleReading();
    } else if (category.contains('Yes/No')) {
      await performYesNoReading();
    } else if (category.contains('Career')) {
      await performCareerReading();
    } else if (category.contains('Daily')) {
      await getDailyReading();
    } else {
      // For other love types, retry with null card
      await getLoveReading();
    }
  }

  /// Try Love Triangle with random valid cards from available cards
  Future<void> _tryLoveTriangleWithRandomCards() async {
    if (cards.isEmpty) {
      debugPrint('❌ No cards available for Love Triangle');
      Get.snackbar(
        'Error',
        'No cards available. Please shuffle cards first.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Reset retry count
    autoRetryCount.value = 0;

    // Try up to 10 different combinations
    for (int attempt = 0; attempt < 10; attempt++) {
      try {
        // Select 3 random different cards
        final availableCards = List<TarotCardModel>.from(cards);
        if (availableCards.length < 3) {
          debugPrint('❌ Not enough cards for Love Triangle');
          break;
        }

        // Shuffle and pick 3 different cards
        availableCards.shuffle();
        final card1 = availableCards[0];
        final card2 = availableCards[1];
        final card3 = availableCards[2];

        // Ensure all cards are different
        if (card1.id == card2.id ||
            card1.id == card3.id ||
            card2.id == card3.id) {
          continue; // Try next combination
        }

        debugPrint(
          '🔄 Trying Love Triangle with cards: ${card1.name}, ${card2.name}, ${card3.name}',
        );

        final response = await _tarotService.getLoveTriangleReading(
          cardSelf: card1.id,
          cardLover1: card2.id,
          cardLover2: card3.id,
          language: selectedLanguage.value,
        );

        // If successful, store the response
        if (response.success &&
            response.self.name.isNotEmpty &&
            response.lover1.name.isNotEmpty &&
            response.lover2.name.isNotEmpty) {
          debugPrint('✅ Love Triangle successful with random cards');
          loveTriangleResponse.value = response;
          triangleCardSelf.value = card1;
          triangleCardLover1.value = card2;
          triangleCardLover2.value = card3;
          if (response.remainingApiCalls != null) {
            remainingApiCalls.value = response.remainingApiCalls;
          }
          selectedReadingType.value = 'love';
          selectedLoveType.value = 'triangle';
          triangleSelectionStep.value = 'complete';
          autoRetryCount.value = 0; // Reset on success
          return;
        }
      } catch (e) {
        debugPrint('⚠️ Attempt ${attempt + 1} failed: $e');
        // Continue to next attempt
      }
    }

    // If all attempts failed, try with null (full auto-select)
    debugPrint(
      '⚠️ All random card attempts failed. Trying with full auto-select.',
    );
    triangleCardSelf.value = null;
    triangleCardLover1.value = null;
    triangleCardLover2.value = null;
    autoRetryCount.value = 0;
    await getLoveTriangleReading();
  }

  /// Try Breakup reading with random valid cards from available cards
  Future<void> _tryBreakupWithRandomCards({required bool isBusiness}) async {
    if (cards.isEmpty) {
      debugPrint('❌ No cards available for Breakup reading');
      Get.snackbar(
        'Error',
        'No cards available. Please shuffle cards first.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Reset retry count
    autoRetryCount.value = 0;

    // Try up to 10 different combinations
    for (int attempt = 0; attempt < 10; attempt++) {
      try {
        // Select 2 random different cards
        final availableCards = List<TarotCardModel>.from(cards);
        if (availableCards.length < 2) {
          debugPrint('❌ Not enough cards for Breakup reading');
          break;
        }

        // Shuffle and pick 2 different cards
        availableCards.shuffle();
        final card1 = availableCards[0];
        final card2 = availableCards[1];

        // Ensure cards are different
        if (card1.id == card2.id) {
          continue; // Try next combination
        }

        debugPrint(
          '🔄 Trying ${isBusiness ? "Business" : "Romantic"} Breakup with cards: ${card1.name}, ${card2.name}',
        );

        if (isBusiness) {
          final response = await _tarotService.getBusinessBreakupReading(
            cardCause: card1.id,
            cardAdvise: card2.id,
            language: selectedLanguage.value,
          );

          // If successful, store the response
          if (response.success &&
              response.cause.name.isNotEmpty &&
              response.advise.name.isNotEmpty) {
            debugPrint('✅ Business Breakup successful with random cards');
            businessBreakupResponse.value = response;
            breakupCardCause.value = card1;
            breakupCardAdvise.value = card2;
            if (response.remainingApiCalls != null) {
              remainingApiCalls.value = response.remainingApiCalls;
            }
            selectedReadingType.value = 'business-breakup';
            selectedBreakupType.value = 'business';
            breakupSelectionStep.value = 'complete';
            autoRetryCount.value = 0; // Reset on success
            return;
          }
        } else {
          final response = await _tarotService.getRomanticBreakupReading(
            cardCause: card1.id,
            cardAdvise: card2.id,
            language: selectedLanguage.value,
          );

          // If successful, store the response
          if (response.success &&
              response.cause.name.isNotEmpty &&
              response.advise.name.isNotEmpty) {
            debugPrint('✅ Romantic Breakup successful with random cards');
            romanticBreakupResponse.value = response;
            breakupCardCause.value = card1;
            breakupCardAdvise.value = card2;
            if (response.remainingApiCalls != null) {
              remainingApiCalls.value = response.remainingApiCalls;
            }
            selectedReadingType.value = 'romantic-breakup';
            selectedBreakupType.value = 'romantic';
            breakupSelectionStep.value = 'complete';
            autoRetryCount.value = 0; // Reset on success
            return;
          }
        }
      } catch (e) {
        debugPrint('⚠️ Attempt ${attempt + 1} failed: $e');
        // Continue to next attempt
      }
    }

    // If all attempts failed, try with null (full auto-select)
    debugPrint(
      '⚠️ All random card attempts failed. Trying with full auto-select.',
    );
    breakupCardCause.value = null;
    breakupCardAdvise.value = null;
    autoRetryCount.value = 0;
    if (isBusiness) {
      await _performBusinessBreakupReading();
    } else {
      await _performRomanticBreakupReading();
    }
  }

  /// Get Fortune Cookie
  Future<void> getFortuneCookie() async {
    try {
      isLoadingReading.value = true;
      final response = await _tarotService.getFortuneCookie(
        language: selectedLanguage.value,
      );
      fortuneCookieResponse.value = response;
      if (response.remainingApiCalls != null) {
        remainingApiCalls.value = response.remainingApiCalls;
      }
      selectedReadingType.value = 'fortune-cookie';
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      debugPrint('❌ Tarot Fortune Cookie API Error: $errorMsg');
      debugPrint('❌ Full Exception: $e');
      Get.snackbar('Error', errorMsg);
    } finally {
      isLoadingReading.value = false;
    }
  }

  /// Close reading overlay
  void closeReading() {
    selectedReadingType.value = 'none';
    // Reset triangle and breakup steps to prevent stale state
    if (triangleSelectionStep.value != 'complete') {
      triangleSelectionStep.value = 'self';
    }
    if (breakupSelectionStep.value != 'complete') {
      breakupSelectionStep.value = 'cause';
    }
    // Don't clear responses here - keep them so user can reopen
    // Only clear when starting a new shuffle
  }
}
