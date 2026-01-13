import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/tarot_card_model.dart';
import 'package:astrobharataiuser/screens/tarot_reading/controller/tarot_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Visual card selection progress widget
/// Shows selected cards and next steps instead of snackbars
class TarotSelectionProgressWidget extends StatelessWidget {
  const TarotSelectionProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TarotController>();

    return Obx(() {
      // Show Love Triangle selection progress
      if (controller.selectedLoveType.value == 'triangle' && 
          controller.triangleSelectionStep.value != 'complete') {
        return _buildTriangleProgress(controller);
      }

      // Show Breakup selection progress
      if ((controller.selectedReadingType.value == 'romantic-breakup' || 
           controller.selectedReadingType.value == 'business-breakup') &&
          controller.breakupSelectionStep.value != 'complete') {
        return _buildBreakupProgress(controller);
      }

      // Show Direction selection for Yes/No and Career (only if reading not yet loaded)
      final readingType = controller.selectedReadingType.value;
      if ((readingType == 'yesno' || readingType == 'career') &&
          controller.selectedCard != null) {
        final showSelector = (readingType == 'yesno' && controller.yesNoResponse.value == null) ||
                            (readingType == 'career' && controller.careerResponse.value == null);
        if (showSelector) {
          return _buildDirectionSelector(controller);
        }
      }

      return const SizedBox.shrink();
    });
  }

  /// Build Love Triangle selection progress (3 cards)
  Widget _buildTriangleProgress(TarotController controller) {
    final step = controller.triangleSelectionStep.value;
    final theme = controller.selectedTheme.value;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.pink.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite,
                color: Colors.pink,
                size: 24.w,
              ),
              Spacing.w(8),
              AutoTranslateText(
                'Love Triangle Reading',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: '#820B17'.toColor(),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          Spacing.h(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCardSlot(
                label: 'You',
                card: controller.triangleCardSelf.value,
                isActive: step == 'self',
                isCompleted: step != 'self',
                theme: theme,
              ),
              _buildCardSlot(
                label: 'Partner 1',
                card: controller.triangleCardLover1.value,
                isActive: step == 'lover1',
                isCompleted: step == 'lover2' || step == 'complete',
                theme: theme,
              ),
              _buildCardSlot(
                label: 'Partner 2',
                card: controller.triangleCardLover2.value,
                isActive: step == 'lover2',
                isCompleted: step == 'complete',
                theme: theme,
              ),
            ],
          ),
          Spacing.h(12),
          Center(
            child: AutoTranslateText(
              _getTriangleInstruction(step),
              style: MyTextTheme.smallBCN.copyWith(
                color: '#820B17'.toColor().withOpacity(0.7),
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Spacing.h(12),
          Center(
            child: ElevatedButton(
              onPressed: () => controller.skipTriangleCard(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.withOpacity(0.1),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: BorderSide(color: Colors.pink, width: 1),
                ),
              ),
              child: AutoTranslateText(
                'Skip (Auto-select)',
                style: MyTextTheme.smallBCN.copyWith(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build Breakup selection progress (2 cards)
  Widget _buildBreakupProgress(TarotController controller) {
    final step = controller.breakupSelectionStep.value;
    final theme = controller.selectedTheme.value;
    final isRomantic = controller.selectedBreakupType.value == 'romantic';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: (isRomantic ? Colors.red : Colors.orange).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isRomantic ? Colors.red : Colors.orange).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isRomantic ? Icons.favorite_border : Icons.business_center,
                color: isRomantic ? Colors.red : Colors.orange,
                size: 24.w,
              ),
              Spacing.w(8),
              AutoTranslateText(
                '${isRomantic ? 'Romantic' : 'Business'} Breakup Reading',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: '#820B17'.toColor(),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          Spacing.h(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCardSlot(
                label: 'Cause',
                card: controller.breakupCardCause.value,
                isActive: step == 'cause',
                isCompleted: step != 'cause',
                theme: theme,
              ),
              _buildCardSlot(
                label: 'Advise',
                card: controller.breakupCardAdvise.value,
                isActive: step == 'advise',
                isCompleted: step == 'complete',
                theme: theme,
              ),
            ],
          ),
          Spacing.h(12),
          Center(
            child: AutoTranslateText(
              _getBreakupInstruction(step),
              style: MyTextTheme.smallBCN.copyWith(
                color: '#820B17'.toColor().withOpacity(0.7),
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Spacing.h(12),
          Center(
            child: ElevatedButton(
              onPressed: () => controller.skipBreakupCard(),
              style: ElevatedButton.styleFrom(
                backgroundColor: (isRomantic ? Colors.red : Colors.orange).withOpacity(0.1),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: BorderSide(
                    color: isRomantic ? Colors.red : Colors.orange,
                    width: 1,
                  ),
                ),
              ),
              child: AutoTranslateText(
                'Skip (Auto-select)',
                style: MyTextTheme.smallBCN.copyWith(
                  color: isRomantic ? Colors.red : Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build Direction selector for Yes/No and Career
  Widget _buildDirectionSelector(TarotController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: '#ee7532'.toColor().withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: '#ee7532'.toColor().withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.compass_calibration,
                color: '#ee7532'.toColor(),
                size: 24.w,
              ),
              Spacing.w(8),
              Expanded(
                child: AutoTranslateText(
                  'Select Card Direction (Optional)',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: '#820B17'.toColor(),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDirectionButton(
                label: 'Upright',
                direction: 'upright',
                controller: controller,
                icon: Icons.arrow_upward,
              ),
              _buildDirectionButton(
                label: 'Reversed',
                direction: 'reversed',
                controller: controller,
                icon: Icons.arrow_downward,
              ),
            ],
          ),
          Spacing.h(12),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Skip direction selection - API will auto-select
                controller.setDirection('');
                if (controller.selectedReadingType.value == 'yesno') {
                  controller.performYesNoReading();
                } else if (controller.selectedReadingType.value == 'career') {
                  controller.performCareerReading();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: '#ee7532'.toColor().withOpacity(0.1),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: BorderSide(color: '#ee7532'.toColor(), width: 1),
                ),
              ),
              child: AutoTranslateText(
                'Skip Direction (Auto-select)',
                style: MyTextTheme.smallBCN.copyWith(
                  color: '#ee7532'.toColor(),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a card slot in selection progress
  Widget _buildCardSlot({
    required String label,
    required TarotCardModel? card,
    required bool isActive,
    required bool isCompleted,
    required String theme,
  }) {
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 120.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isActive
                  ? Colors.pink
                  : isCompleted
                      ? Colors.green
                      : Colors.grey.withOpacity(0.3),
              width: isActive ? 3 : 2,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: card != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CachedNetworkImage(
                    imageUrl: card.getCardImageUrl(theme),
                    fit: BoxFit.contain, // Changed from cover to contain to show full image
                    placeholder: (context, url) => Container(
                      color: '#ede7c8'.toColor(),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: '#ee7532'.toColor(),
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: '#ede7c8'.toColor(),
                      child: Icon(
                        Icons.auto_awesome,
                        color: '#820B17'.toColor(),
                        size: 30.w,
                      ),
                    ),
                  ),
                )
              : Container(
                  color: '#ede7c8'.toColor(),
                  child: Center(
                    child: Icon(
                      isActive ? Icons.touch_app : Icons.help_outline,
                      color: isActive
                          ? Colors.pink
                          : Colors.grey.withOpacity(0.5),
                      size: 30.w,
                    ),
                  ),
                ),
        ),
        Spacing.h(8),
        AutoTranslateText(
          label,
          style: MyTextTheme.smallBCN.copyWith(
            color: isActive
                ? Colors.pink
                : isCompleted
                    ? Colors.green
                    : '#820B17'.toColor().withOpacity(0.5),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Poppins',
          ),
        ),
        if (isActive)
          Container(
            margin: EdgeInsets.only(top: 4.h),
            width: 60.w,
            height: 2.h,
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.circular(1.r),
            ),
          ),
      ],
    );
  }

  /// Build direction selection button
  Widget _buildDirectionButton({
    required String label,
    required String direction,
    required TarotController controller,
    required IconData icon,
  }) {
    final isSelected = controller.selectedDirection.value == direction;

    return GestureDetector(
      onTap: () {
        controller.setDirection(direction);
        // Auto-trigger reading when direction is selected
        if (controller.selectedReadingType.value == 'yesno') {
          controller.performYesNoReading();
        } else if (controller.selectedReadingType.value == 'career') {
          controller.performCareerReading();
        }
      },
      child: Container(
        width: 120.w,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? '#ee7532'.toColor() : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? '#ee7532'.toColor()
                : '#ee7532'.toColor().withOpacity(0.5),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: '#ee7532'.toColor().withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : '#ee7532'.toColor(),
              size: 32.w,
            ),
            Spacing.h(8),
            AutoTranslateText(
              label,
              style: MyTextTheme.smallBCN.copyWith(
                color: isSelected ? Colors.white : '#820B17'.toColor(),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTriangleInstruction(String step) {
    switch (step) {
      case 'self':
        return 'Shuffle and select card for "You" (optional - can skip)';
      case 'lover1':
        return 'Shuffle and select card for "Partner 1" (optional - can skip)';
      case 'lover2':
        return 'Shuffle and select card for "Partner 2" (optional - can skip)';
      default:
        return '';
    }
  }

  String _getBreakupInstruction(String step) {
    switch (step) {
      case 'cause':
        return 'Shuffle and select card for "Cause" (optional - can skip)';
      case 'advise':
        return 'Shuffle and select card for "Advise" (optional - can skip)';
      default:
        return '';
    }
  }
}

