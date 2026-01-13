import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/models/app_language_model.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
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
      child: Scaffold(
        backgroundColor: '#ede7c8'.toColor(), // Cream background
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
    );
  }

  Widget _buildMainContent() {
    return GetBuilder<TarotController>(
      builder: (controller) {
        return Column(
          children: [
            // Header section with dark red background
            _buildHeaderSection(),

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
                    color: '#820B17'.toColor().withOpacity(0.7),
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

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: ['#820B17'.toColor(), '#820B17'.toColor().withOpacity(0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.only(
        top: 16.h,
        bottom: 32.h,
        left: 16.w,
        right: 16.w,
      ),
      child: Column(
        children: [
          // Back button and title row with language selector
          Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back,
                  color: '#ede7c8'.toColor(),
                  size: 24.w,
                ),
              ),
              Spacing.w(8),
              Expanded(
                child: AutoTranslateText(
                  'CARD READING',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: '#ede7c8'.toColor(),
                    // Using h2 (18px) as closest match
                    letterSpacing: 0.8, // Reduced from 1.2
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Language selector
              GetBuilder<TarotController>(
                builder: (controller) {
                  return FutureBuilder<List<dynamic>>(
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
                        icon: Icon(
                          Icons.language,
                          color: '#ede7c8'.toColor(),
                          size: 22.w, // Reduced from 24.w to prevent overflow
                        ),
                        constraints: BoxConstraints(
                          maxWidth: 200.w, // Constrain popup width
                        ),
                        color: '#ede7c8'.toColor(),
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
                                    color: '#ee7532'.toColor(),
                                    size: 18.w,
                                  )
                                else
                                  SizedBox(width: 18.w),
                                Spacing.w(8),
                                Expanded(
                                  child: AutoTranslateText(
                                    name,
                                    style: TextStyle(
                                      color: '#820B17'.toColor(),
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
                  );
                },
              ),
            ],
          ),

          Spacing.h(20),

          // Golden icon
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: '#ee7532'.toColor(),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.auto_awesome,
              color: '#ede7c8'.toColor(),
              size: 50.w,
            ),
          ),

          Spacing.h(20),
        ],
      ),
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
                      color: '#ee7532'.toColor(),
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
          gradient: LinearGradient(
            colors: ['#ee7532'.toColor(), '#820B17'.toColor()],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: '#ee7532'.toColor().withOpacity(0.4),
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
              Icon(Icons.auto_awesome, color: '#ede7c8'.toColor(), size: 70.w),
              Spacing.h(12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: '#ede7c8'.toColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  'Tap to Shuffle',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: '#ede7c8'.toColor(),
                  ),
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
              Icon(Icons.palette, color: '#820B17'.toColor(), size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                'Card Theme',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: '#820B17'.toColor(),
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
                        color: isSelected ? '#ee7532'.toColor() : Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isSelected
                              ? '#ee7532'.toColor()
                              : '#820B17'.toColor().withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: AutoTranslateText(
                        theme.toUpperCase(),
                        style: MyTextTheme.smallBCN.copyWith(
                          color: isSelected
                              ? Colors.white
                              : '#820B17'.toColor(),
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
              Icon(Icons.style, color: '#820B17'.toColor(), size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                'Card Back',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: '#820B17'.toColor(),
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
                        color: isSelected ? '#ee7532'.toColor() : Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isSelected
                              ? '#ee7532'.toColor()
                              : '#820B17'.toColor().withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: AutoTranslateText(
                        backType.replaceAll('_', ' ').toUpperCase(),
                        style: MyTextTheme.smallBCN.copyWith(
                          color: isSelected
                              ? Colors.white
                              : '#820B17'.toColor(),
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
