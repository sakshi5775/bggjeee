import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
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
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_settings_sheet.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_shuffle_button_widget.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_selection_progress_widget.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_type_grid_widget.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_yes_no_popup.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_card_unsuitable_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TarotReadingView extends BasePage<TarotController> {
  const TarotReadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TarotController>();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (controller.selectedReadingType.value != 'none') {
          controller.closeReading();
        } else if (controller.readingTypeChosen.value) {
          controller.resetToTypeSelection();
        } else {
          Get.back();
        }
      },
      child: Container(
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Obx(() {
            final typeChosen = controller.readingTypeChosen.value;
            final label = controller.chosenReadingLabel.value;

            return Column(
              children: [
                // Header — title updates based on chosen reading type
                CommonHeader(
                  title: _tarotHeaderTitle(
                    typeChosen: typeChosen,
                    label: label,
                    fortuneActive:
                        controller.selectedReadingType.value == 'fortune-cookie',
                  ),
                  showBackButton: typeChosen ||
                      controller.selectedReadingType.value == 'fortune-cookie',
                  onBackTap: () {
                    if (controller.selectedReadingType.value != 'none') {
                      controller.closeReading();
                    } else {
                      controller.resetToTypeSelection();
                    }
                  },
                  customActions: [
                    IconButton(
                      icon: Icon(
                        Icons.tune,
                        color: '#6F221E'.toColor(),
                        size: 22.w,
                      ),
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(36.w, 36.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => TarotSettingsSheet.show(context),
                    ),
                  ],
                ),

                // Body — switches between Step 1 and Step 2
                Expanded(
                  child: Stack(
                    children: [
                      // Step 1: Reading type selection grid
                      if (!typeChosen) const TarotTypeGridWidget(),

                      // Step 2: Shuffle & pick card
                      if (typeChosen)
                        SingleChildScrollView(
                          child: _buildStep2Content(controller),
                        ),

                      // ─── Result overlays (unchanged) ─────────────────────
                      const TarotYesNoPopup(),
                      const TarotCareerWidget(),
                      const TarotLoveWidget(),
                      const TarotDailyWidget(),
                      const TarotBreakupWidget(isRomantic: true),
                      const TarotBreakupWidget(isRomantic: false),
                      const TarotFortuneCookieWidget(),
                      _buildUnsuitableCardMessage(controller),
                      _buildFindingSuitableOverlay(controller),
                    ],
                  ),
                ),

                Spacing.h(32),
              ],
            );
          }),
        ),
      ),
    );
  }

  String _tarotHeaderTitle({
    required bool typeChosen,
    required String label,
    required bool fortuneActive,
  }) {
    if (fortuneActive) return 'FORTUNE COOKIE';
    if (typeChosen && label.isNotEmpty) return label.toUpperCase();
    return 'CARD READING';
  }

  // ─── Step 2: Shuffle & Pick ────────────────────────────────────────────────

  Widget _buildStep2Content(TarotController controller) {
    return GetBuilder<TarotController>(
      builder: (ctrl) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacing.h(6),

            // Step strip — clear “you are here”
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(() {
                final label = ctrl.chosenReadingLabel.value;
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: '#68171E'.toColor().withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.auto_awesome, color: AppColors.templeGold, size: 22.w),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoTranslateText(
                              'Your reading',
                              style: MyTextTheme.smallBCN.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 11.sp,
                              ),
                            ),
                            AutoTranslateText(
                              label.isNotEmpty ? label : 'Card reading',
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),

            Spacing.h(12),

            // Multi-card selection progress (Love Triangle / Breakup) — shown at TOP
            const TarotSelectionProgressWidget(),

            Spacing.h(10),

            // Card area — orange accent frame
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(22.r),
                  boxShadow: [
                    BoxShadow(
                      color: "#F38B3B".toColor().withValues(alpha: 0.2),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(19.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: _buildCardInteractionSection(ctrl),
                  ),
                ),
              ),
            ),

            Spacing.h(16),

            // Contextual instruction text
            Obx(() {
              final isLoading = ctrl.isLoading.value || ctrl.isShuffling.value;
              if (isLoading) return const SizedBox.shrink();

              final isMultiCard =
                  (ctrl.selectedLoveType.value == 'triangle' &&
                      ctrl.triangleSelectionStep.value != 'complete') ||
                  ((ctrl.selectedReadingType.value == 'romantic-breakup' ||
                          ctrl.selectedReadingType.value ==
                              'business-breakup') &&
                      ctrl.breakupSelectionStep.value != 'complete');

              final text = ctrl.showCards.value
                  ? (isMultiCard
                      ? 'Tap the card that resonates with you'
                      : 'Tap a card — your reading updates for each new pick')
                  : 'Focus on your question, then tap the deck or use Shuffle below';

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: AutoTranslateText(
                  text,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: '#68171E'.toColor().withValues(alpha: 0.75),
                    fontSize: 13.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }),

            Spacing.h(14),

            // Shuffle type selector + shuffle button
            const TarotShuffleButtonWidget(),

            Spacing.h(24),
          ],
        );
      },
    );
  }

  // ─── Card Interaction Area (deck / shuffle animation / card fan) ──────────

  Widget _buildCardInteractionSection(TarotController controller) {
    return Obx(() {
      final isShuffling = controller.isShuffling.value;
      final showCards = controller.showCards.value;
      final isLoading = controller.isLoading.value;
      final hasCards = controller.cards.isNotEmpty;

      return Container(
        height: 360.h,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Shuffle animation
            if (isShuffling)
              TarotLottieShuffleWidget(
                progress: controller.shuffleProgress.value,
              ),

            // Card fan spread
            if (showCards && !isShuffling && hasCards)
              const TarotCardFanWidget(),

            // Loading indicator (when loading but no cards visible)
            if (isLoading && !isShuffling && !showCards)
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    "#F38B3B".toColor(),
                  ),
                ),
              ),

            // Card reveal overlay
            Obx(() {
              final selectedCard = controller.selectedCard;
              final isRevealing = controller.isRevealing.value;
              final isCardOpen = controller.isCardOpen.value;

              if ((isRevealing || isCardOpen) && selectedCard != null) {
                return Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      if (isCardOpen) controller.closeCard();
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            if (isCardOpen) controller.closeCard();
                          },
                          child: Hero(
                            tag: 'tarot_card_${selectedCard.id}',
                            flightShuttleBuilder: (
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
                              onAnimationComplete: () {},
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

            // Initial deck (tap to shuffle)
            if (!showCards && !isShuffling) _buildInitialDeck(controller),
          ],
        ),
      );
    });
  }

  Widget _buildInitialDeck(TarotController controller) {
    return GestureDetector(
      onTap: () => controller.shuffleCards(),
      child: Container(
        width: 150.w,
        height: 225.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: AppColors.orangeGradient,
          boxShadow: [
            BoxShadow(
              color: "#F38B3B".toColor().withValues(alpha: 0.45),
              blurRadius: 24,
              spreadRadius: 2,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Subtle card stack illusion
            Positioned(
              top: -4,
              left: -4,
              right: 4,
              bottom: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: "#DD6B20".toColor().withValues(alpha: 0.5),
                ),
              ),
            ),
            Positioned(
              top: -2,
              left: -2,
              right: 2,
              bottom: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: "#E97E30".toColor().withValues(alpha: 0.7),
                ),
              ),
            ),
            // Main deck face
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: AppColors.orangeGradient,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 56.w,
                    ),
                    Spacing.h(14),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: AutoTranslateText(
                        'Tap to Shuffle',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Unsuitable card message overlay ──────────────────────────────────────

  /// Loader while we auto-pick a backend-valid card (Career / Yes-No / Daily)
  Widget _buildFindingSuitableOverlay(TarotController controller) {
    return Obx(() {
      if (!controller.isFindingSuitableCard.value) {
        return const SizedBox.shrink();
      }
      return Positioned.fill(
        child: Material(
          color: Colors.black.withValues(alpha: 0.75),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 28.w),
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 26.h),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: '#68171E'.toColor().withValues(alpha: 0.45),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 44.w,
                    height: 44.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.templeGold,
                    ),
                  ),
                  Spacing.h(18),
                  AutoTranslateText(
                    controller.findingSuitableMessage.value.isNotEmpty
                        ? controller.findingSuitableMessage.value
                        : 'Finding the right card for your reading...',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontSize: 15.sp,
                      height: 1.35,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacing.h(10),
                  AutoTranslateText(
                    'This usually takes a few seconds.',
                    style: MyTextTheme.smallBCN.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildUnsuitableCardMessage(TarotController controller) {
    return Obx(() {
      final showMessage = controller.showUnsuitableCardMessage.value;
      final cardName = controller.unsuitableCardName.value;
      final categoryName = controller.unsuitableCategoryName.value;

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
              controller.handleUnsuitableCardAutoRetry();
            },
          ),
        ),
      );
    });
  }
}
