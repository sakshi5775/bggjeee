import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/models/app_language_model.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/screens/tarot_reading/controller/tarot_controller.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_breakup_widget.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_card_fan_widget.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_card_reveal_widget.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_career_widget.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_daily_widget.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_fortune_cookie_widget.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_lottie_shuffle_widget.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_love_widget.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_reading_type_selector.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_shuffle_button_widget.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_selection_progress_widget.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_yes_no_popup.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_card_unsuitable_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_appbar.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TarotReadingView extends BasePage<TarotController> {
  const TarotReadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TarotController>();
    return PopScope(
      canPop: controller.selectedReadingType.value == 'none',
      onPopInvoked: (didPop) {
        if (!didPop && controller.selectedReadingType.value != 'none') {
          controller.closeReading();
        }
      },
      child: Container(
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(child: _buildMainContent()),
                // Reading overlays
                const TarotYesNoPopup(),
                const TarotCareerWidget(),
                const TarotLoveWidget(),
                const TarotDailyWidget(),
                const TarotBreakupWidget(isRomantic: true),
                const TarotBreakupWidget(isRomantic: false),
                const TarotFortuneCookieWidget(),
                // Card unsuitable message overlay (should be on top)
                _buildUnsuitableCardMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return GetBuilder<TarotController>(
      builder: (controller) {
        return Column(
          children: [
            // Header using CommonHeader
            _buildHeaderSection(),

            Spacing.h(16),

            // Consultation Card
            _buildConsultationCard(),

            Spacing.h(16),

            // Global Theme Selector (MOVED TO TOP for better visibility)
            _buildGlobalThemeSelector(),

            Spacing.h(24),

            // Card interaction section
            _buildCardInteractionSection(),

            Spacing.h(16), // Reduced gap from 32 to 16
            // Selection progress widget (shows selected cards and next steps)
            const TarotSelectionProgressWidget(),

            Spacing.h(16),

            // Reading type selector (shown after cards are drawn)
            const TarotReadingTypeSelector(),

            Spacing.h(16),

            // Three-part shuffle button
            const TarotShuffleButtonWidget(),

            Spacing.h(16),

            // Instruction text
            Obx(() {
              final controller = Get.find<TarotController>();
              final isLoading =
                  controller.isLoading.value || controller.isShuffling.value;
              if (isLoading) return const SizedBox.shrink();

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: AutoTranslateText(
                  controller.showCards.value
                      ? 'Tap a card to reveal your reading'
                      : 'Tap the deck to begin your reading',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: '#68171E'.toColor().withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }),

            Spacing.h(24),
          ],
        );
      },
    );
  }

  Widget _buildConsultationCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.astrologyServices),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: '#68171E'.toColor().withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.templeGold.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.psychology,
                  color: AppColors.templeGold,
                  size: 32.w,
                ),
              ),
              SizedBox(width: 16.w),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      'Need Expert Consultation?',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    AutoTranslateText(
                      'Connect with our experienced astrologers for personalized guidance',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12.sp,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.deepOrange.withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AutoTranslateText(
                            'Book Now',
                            style: MyTextTheme.smallBCB.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 14.w,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return GetBuilder<TarotController>(
      builder: (controller) {
        return CommonHeader(
          title: 'CARD READING',
          titleColor: AppColors.templeGold,
          actions: [
            // Language selector
            FutureBuilder<List<dynamic>>(
              future: _loadLanguages(),
              builder: (context, snapshot) {
                final languages =
                    snapshot.data ??
                    [
                      {'code': 'en', 'name': 'English'},
                      {'code': 'hi', 'name': 'Hindi'},
                      {'code': 'bn', 'name': 'Bengali'},
                      {'code': 'te', 'name': 'Telugu'},
                      {'code': 'mr', 'name': 'Marathi'},
                      {'code': 'ta', 'name': 'Tamil'},
                      {'code': 'gu', 'name': 'Gujarati'},
                    ];

                return PopupMenuButton<String>(
                  icon: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.deepOrange.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.language,
                      color: Colors.white,
                      size: 20.w,
                    ),
                  ),
                  constraints: BoxConstraints(maxWidth: 200.w),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  itemBuilder: (context) => languages.map((lang) {
                    final code = lang['code'] as String;
                    final name = lang['name'] as String;
                    final isSelected =
                        controller.selectedLanguage.value == code;
                    return PopupMenuItem(
                      value: code,
                      child: Row(
                        children: [
                          if (isSelected)
                            Icon(
                              Icons.check,
                              color: AppColors.deepOrange,
                              size: 18.w,
                            )
                          else
                            SizedBox(width: 18.w),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: AutoTranslateText(
                              name,
                              style: TextStyle(
                                color: '#68171E'.toColor(),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onSelected: (value) async {
                    if (controller.selectedLanguage.value != value) {
                      controller.selectedLanguage.value = value;
                      // If cards are already loaded, reshuffle with new language
                      if (controller.cards.isNotEmpty) {
                        await controller.shuffleCards();
                      }
                    }
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCardInteractionSection() {
    return GetBuilder<TarotController>(
      builder: (controller) {
        return Obx(() {
          final isShuffling = controller.isShuffling.value;
          final showCards = controller.showCards.value;
          final isLoading = controller.isLoading.value;
          final hasCards = controller.cards.isNotEmpty;

          debugPrint(
            '🎴 UI State: isShuffling=$isShuffling, showCards=$showCards, isLoading=$isLoading, hasCards=$hasCards',
          );

          return Container(
            height: 380.h, // Further reduced from 450.h to 380.h
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Shuffle animation (when shuffling)
                if (isShuffling)
                  TarotLottieShuffleWidget(
                    progress: controller.shuffleProgress.value,
                  ),

                // Card fan spread (when cards are shown and not shuffling)
                if (showCards && !isShuffling && hasCards)
                  const TarotCardFanWidget(),

                // Loading indicator (when loading but not shuffling and no cards shown)
                if (isLoading && !isShuffling && !showCards)
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.deepOrange,
                      ),
                    ),
                  ),

                // Card reveal overlay (when card is being revealed)
                Obx(() {
                  final selectedCard = controller.selectedCard;
                  final isRevealing = controller.isRevealing.value;

                  final isCardOpen = controller.isCardOpen.value;
                  if ((isRevealing || isCardOpen) && selectedCard != null) {
                    return Positioned.fill(
                      child: IgnorePointer(
                        ignoring: false,
                        child: GestureDetector(
                          onTap: () {
                            // Close on tap outside or retap
                            if (isCardOpen) {
                              controller.closeCard();
                            }
                          },
                          child: Container(
                            color: Colors.transparent, // No background
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  // Close card when tapping the open card itself
                                  if (isCardOpen) {
                                    controller.closeCard();
                                  }
                                },
                                child: Hero(
                                  tag: 'tarot_card_${selectedCard.id}',
                                  flightShuttleBuilder:
                                      (
                                        BuildContext flightContext,
                                        Animation<double> animation,
                                        HeroFlightDirection flightDirection,
                                        BuildContext fromHeroContext,
                                        BuildContext toHeroContext,
                                      ) {
                                        return TarotCardRevealWidget(
                                          card: selectedCard,
                                          theme: controller.selectedTheme.value,
                                          isOpen: isCardOpen,
                                        );
                                      },
                                  child: TarotCardRevealWidget(
                                    card: selectedCard,
                                    theme: controller.selectedTheme.value,
                                    isOpen: isCardOpen,
                                    onAnimationComplete: () {
                                      // Animation complete
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // Initial deck (when no cards)
                if (!showCards && !isShuffling) _buildInitialDeck(),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildInitialDeck() {
    return GestureDetector(
      onTap: () {
        final controller = Get.find<TarotController>();
        controller.shuffleCards();
      },
      child: Container(
        width: 160.w,
        height: 240.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: AppColors.orangeGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOrange.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, color: Colors.white, size: 70.w),
              Spacing.h(12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  'Tap to Shuffle',
                  style: MyTextTheme.smallBCN.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlobalThemeSelector() {
    final controller = Get.find<TarotController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Theme Selector
          Row(
            children: [
              Icon(Icons.palette, color: '#68171E'.toColor(), size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                'Card Theme',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: '#68171E'.toColor(),
                ),
              ),
            ],
          ),
          Spacing.h(8),
          Obx(() {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['classic', 'artwork', 'dark', 'ghibli'].map((theme) {
                  final isSelected = controller.selectedTheme.value == theme;
                  return GestureDetector(
                    onTap: () => controller.setTheme(theme),
                    child: Container(
                      margin: EdgeInsets.only(right: 8.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppColors.orangeGradient : null,
                        color: isSelected ? null : Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : '#68171E'.toColor().withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.deepOrange.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: AutoTranslateText(
                        theme.toUpperCase(),
                        style: MyTextTheme.smallBCN.copyWith(
                          color: isSelected
                              ? Colors.white
                              : '#68171E'.toColor(),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }),

          Spacing.h(16),

          // Card Back Selector
          Row(
            children: [
              Icon(Icons.style, color: '#68171E'.toColor(), size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                'Card Back',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: '#68171E'.toColor(),
                ),
              ),
            ],
          ),
          Spacing.h(8),
          Obx(() {
            final backTypes = [
              'classic',
              'dark',
              'indigo_star',
              'playing_blue',
              'playing_red',
              'ghibli_sun',
              'ghibli_tree',
            ];
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: backTypes.map((backType) {
                  final isSelected =
                      controller.selectedBackType.value == backType;
                  return GestureDetector(
                    onTap: () => controller.setBackType(backType),
                    child: Container(
                      margin: EdgeInsets.only(right: 8.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppColors.orangeGradient : null,
                        color: isSelected ? null : Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : '#68171E'.toColor().withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.deepOrange.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: AutoTranslateText(
                        backType.replaceAll('_', ' ').toUpperCase(),
                        style: MyTextTheme.smallBCN.copyWith(
                          color: isSelected
                              ? Colors.white
                              : '#68171E'.toColor(),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Load languages for selector
  Future<List<Map<String, String>>> _loadLanguages() async {
    try {
      final languages = await LanguageModelService.getLanguages();
      return languages
          .map((lang) => {'code': lang.code, 'name': lang.nameEn})
          .toList();
    } catch (e) {
      // Fallback to common languages
      return [
        {'code': 'en', 'name': 'English'},
        {'code': 'hi', 'name': 'Hindi'},
        {'code': 'bn', 'name': 'Bengali'},
        {'code': 'te', 'name': 'Telugu'},
        {'code': 'mr', 'name': 'Marathi'},
        {'code': 'ta', 'name': 'Tamil'},
        {'code': 'gu', 'name': 'Gujarati'},
        {'code': 'ur', 'name': 'Urdu'},
        {'code': 'kn', 'name': 'Kannada'},
        {'code': 'ml', 'name': 'Malayalam'},
      ];
    }
  }

  Widget _buildUnsuitableCardMessage() {
    final controller = Get.find<TarotController>();
    return Obx(() {
      final showMessage = controller.showUnsuitableCardMessage.value;
      final cardName = controller.unsuitableCardName.value;
      final categoryName = controller.unsuitableCategoryName.value;

      debugPrint(
        '🔍 Unsuitable Card Widget - showMessage: $showMessage, cardName: $cardName, categoryName: $categoryName',
      );

      if (!showMessage || cardName.isEmpty || categoryName.isEmpty) {
        return const SizedBox.shrink();
      }

      return Positioned(
        top: 60.h,
        left: 0,
        right: 0,
        child: Material(
          type: MaterialType.transparency,
          elevation: 10,
          child: TarotCardUnsuitableWidget(
            cardName: cardName,
            categoryName: categoryName,
            onAnimationComplete: () {
              debugPrint(
                '✅ Unsuitable card animation complete, calling auto-retry',
              );
              controller.handleUnsuitableCardAutoRetry();
            },
          ),
        ),
      );
    });
  }
}
