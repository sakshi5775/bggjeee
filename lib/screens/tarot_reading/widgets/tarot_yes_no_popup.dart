import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/tarot_reading/controller/tarot_controller.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_confetti_widget.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_card_display_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Yes/No Reading Popup Widget with Animation
class TarotYesNoPopup extends StatelessWidget {
  const TarotYesNoPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TarotController>();

    return Obx(() {
      if (controller.selectedReadingType.value != 'yesno') {
        return const SizedBox.shrink();
      }
      
      final response = controller.yesNoResponse.value;
      final isLoading = controller.isLoadingReading.value;
      
      // Only show loader if actually loading API, not when waiting for direction selection
      if (response == null && isLoading) {
        // Show loading state only during API call
        return Container(
          color: Colors.black.withOpacity(0.7),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      
      // If response is null but not loading, we're waiting for direction selection
      // Don't show anything - let the direction selector show
      if (response == null) {
        return const SizedBox.shrink();
      }

      final isPositive = response.meaning.isNotEmpty && response.meaning.toLowerCase() == 'yes';

      return GestureDetector(
        onTap: () => controller.closeReading(),
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: Stack(
            children: [
              // Confetti animation for positive results
              if (isPositive)
                const TarotConfettiWidget(),
              Center(
                child: GestureDetector(
                  onTap: () {}, // Prevent closing when tapping inside
                  child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  final clampedValue = value.clamp(0.0, 1.0);
                  return Transform.scale(
                    scale: clampedValue,
                    child: Opacity(
                      opacity: clampedValue,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 24.w),
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.85,
                        ),
                        decoration: BoxDecoration(
                          color: '#ede7c8'.toColor(),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: response.meaning.toLowerCase() == 'yes'
                                ? Colors.green
                                : Colors.red,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(24.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                            // Close button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () => controller.closeReading(),
                                  icon: Icon(
                                    Icons.close,
                                    color: '#820B17'.toColor(),
                                    size: 24.w,
                                  ),
                                ),
                              ],
                            ),
                            
                            // Yes/No indicator
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 32.w,
                                vertical: 16.h,
                              ),
                              decoration: BoxDecoration(
                                color: (response.meaning.isNotEmpty && response.meaning.toLowerCase() == 'yes')
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: AutoTranslateText(
                                response.meaning.isNotEmpty 
                                    ? response.meaning.toUpperCase() 
                                    : 'UNKNOWN',
                                style: MyTextTheme.largeBCB.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            
                            Spacing.h(24),
                            
                            // Card front image (theme selectable)
                            Center(
                              child: TarotCardDisplayWidget(
                                cardImage: response.cardImage,
                                width: 140.w,
                                height: 200.h,
                              ),
                            ),
                            
                            Spacing.h(16),
                            
                            // Card name and direction
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutoTranslateText(
                                  response.name ?? controller.selectedCard?.name ?? 'Unknown Card',
                                  style: MyTextTheme.mediumBCN.copyWith(
                                    color: '#820B17'.toColor(),
                                  ),
                                ),
                                if (response.direction != null) ...[
                                  Spacing.w(8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: response.direction!.toLowerCase() == 'upright'
                                          ? Colors.green.withOpacity(0.2)
                                          : Colors.orange.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: AutoTranslateText(
                                      response.direction!.toUpperCase(),
                                      style: MyTextTheme.smallBCN.copyWith(
                                        color: response.direction!.toLowerCase() == 'upright'
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            
                            Spacing.h(16),
                            
                            // Description
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: AutoTranslateText(
                                response.description.isNotEmpty 
                                    ? response.description 
                                    : 'No description available',
                                style: MyTextTheme.smallBCN.copyWith(
                                  color: '#820B17'.toColor(),
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            
                            Spacing.h(16),
                            
                            // Close button
                            ElevatedButton(
                              onPressed: () => controller.closeReading(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: '#ee7532'.toColor(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32.w,
                                  vertical: 12.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: AutoTranslateText(
                                'Close',
                                style: MyTextTheme.smallBCN.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

