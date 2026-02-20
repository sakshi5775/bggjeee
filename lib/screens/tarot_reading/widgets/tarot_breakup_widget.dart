import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/tarot_reading/controller/tarot_controller.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_card_display_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Breakup Reading Widget (Romantic & Business)
class TarotBreakupWidget extends StatelessWidget {
  final bool isRomantic;

  const TarotBreakupWidget({super.key, this.isRomantic = true});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TarotController>();
    final readingType = isRomantic ? 'romantic-breakup' : 'business-breakup';

    return Obx(() {
      final currentReadingType = controller.selectedReadingType.value;
      final hasResponse = isRomantic
          ? controller.romanticBreakupResponse.value != null
          : controller.businessBreakupResponse.value != null;
      final breakupStep = controller.breakupSelectionStep.value;

      // Hide if reading type is explicitly set to 'none' (close button clicked)
      if (currentReadingType == 'none') {
        return const SizedBox.shrink();
      }

      // Only show if reading type matches exactly
      if (currentReadingType != readingType) {
        return const SizedBox.shrink();
      }

      // Only show popup when both cards are selected and response is ready
      if (breakupStep != 'complete' || !hasResponse) {
        return const SizedBox.shrink(); // Don't show popup during selection
      }

      // Explicitly watch the response to ensure reactivity
      final response = isRomantic
          ? controller.romanticBreakupResponse.value
          : controller.businessBreakupResponse.value;
      final isLoading = controller.isLoadingReading.value;

      debugPrint(
        'ðŸ” Breakup Widget (${isRomantic ? "romantic" : "business"}) - isLoading: $isLoading, response: ${response != null ? "exists" : "null"}, readingType: ${controller.selectedReadingType.value}',
      );
      if (response != null) {
        debugPrint(
          'ðŸ” Breakup Response - cause: ${response.cause.name}, advise: ${response.advise.name}',
        );
      }

      // Show loading if currently loading API
      if (isLoading) {
        return Container(
          color: Colors.black.withValues(alpha: 0.7),
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      // If response is null and not loading, we're waiting for card selection
      // Don't show anything - let the selection progress widget show
      if (response == null) {
        return const SizedBox.shrink();
      }

      // Response is available, show the content
      // Check if response has valid data
      if (response.cause.name.isEmpty && response.advise.name.isEmpty) {
        return const SizedBox.shrink(); // Don't show empty response
      }

      return Stack(
        children: [
          // Background overlay - tappable to close
          GestureDetector(
            onTap: () {
              debugPrint('ðŸ”´ Background tapped - closing');
              controller.closeReading();
            },
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.black.withValues(alpha: 0.7)),
          ),
          // Content - not tappable to close
          Center(
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
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                      ),
                      decoration: BoxDecoration(
                        color: '#ede7c8'.toColor(),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoTranslateText(
                                    isRomantic
                                        ? 'Romantic Breakup'
                                        : 'Business Breakup',
                                    style: MyTextTheme.largeBCB.copyWith(
                                      color: '#820B17'.toColor(),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () =>
                                            controller.exportToPdf(),
                                        icon: Icon(
                                          Icons.picture_as_pdf_rounded,
                                          color: '#820B17'.toColor(),
                                          size: 24.w,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          debugPrint('ðŸ”´ Close icon tapped');
                                          controller.closeReading();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8.w),
                                          child: Icon(
                                            Icons.close,
                                            color: '#820B17'.toColor(),
                                            size: 24.w,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Spacing.h(24),
                              // Cause Card
                              _buildBreakupCard(
                                title: 'Cause',
                                card: response.cause,
                                color: Colors.red,
                              ),
                              Spacing.h(16),
                              // Advise Card
                              _buildBreakupCard(
                                title: 'Advice',
                                card: response.advise,
                                color: Colors.blue,
                              ),
                              Spacing.h(24),
                              GestureDetector(
                                onTap: () {
                                  debugPrint('ðŸ”´ Close button tapped');
                                  controller.closeReading();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 32.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: "#F38B3B".toColor(),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  alignment: Alignment.center,
                                  child: AutoTranslateText(
                                    'Close',
                                    style: MyTextTheme.smallBCN.copyWith(
                                      color: Colors.white,
                                    ),
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
        ],
      );
    });
  }

  Widget _buildBreakupCard({
    required String title,
    required dynamic card,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                title == 'Cause' ? Icons.warning : Icons.lightbulb,
                color: color,
                size: 24.w,
              ),
              Spacing.w(8),
              AutoTranslateText(
                title,
                style: MyTextTheme.mediumBCN.copyWith(color: color),
              ),
            ],
          ),
          Spacing.h(12),

          // Card image (theme selectable)
          TarotCardDisplayWidget(
            cardImage: card?.cardImage,
            width: 100.w,
            height: 150.h,
          ),

          Spacing.h(8),

          AutoTranslateText(
            card.name ?? card.id ?? 'Unknown Card',
            style: MyTextTheme.mediumBCN.copyWith(color: '#820B17'.toColor()),
          ),
          Spacing.h(8),
          AutoTranslateText(
            (card.description ?? '').isNotEmpty
                ? card.description!
                : 'No description available',
            style: MyTextTheme.smallBCN.copyWith(
              color: '#820B17'.toColor(),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

