import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/tarot_reading/controller/tarot_controller.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_confetti_widget.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_card_display_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Love Reading Widget with Toggle
class TarotLoveWidget extends StatelessWidget {
  const TarotLoveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TarotController>();

    return Obx(() {
      final readingType = controller.selectedReadingType.value;
      final loveType = controller.selectedLoveType.value;
      final hasTriangleResponse = controller.loveTriangleResponse.value != null;
      final triangleStep = controller.triangleSelectionStep.value;

      // Hide if reading type is explicitly set to 'none' (close button clicked)
      if (readingType == 'none') {
        return const SizedBox.shrink();
      }

      // Only show if reading type is 'love'
      if (readingType != 'love') {
        return const SizedBox.shrink();
      }

      // For triangle: only show popup when all 3 cards are selected and response is ready
      if (loveType == 'triangle') {
        if (triangleStep != 'complete' || !hasTriangleResponse) {
          return const SizedBox.shrink(); // Don't show popup during selection
        }
      }

      // Show confetti for made-for-each-other (positive match)
      final showConfetti =
          controller.selectedLoveType.value == 'made-for-each-other' &&
          controller.madeForEachOtherResponse.value != null;

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
                                    'Love Reading',
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
                              Spacing.h(16),
                              // Love type selector
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children:
                                      [
                                        'in-depth',
                                        'erotic',
                                        'made-for-each-other',
                                        'flirt',
                                        'triangle',
                                      ].map((type) {
                                        final isSelected =
                                            controller.selectedLoveType.value ==
                                            type;
                                        return GestureDetector(
                                          onTap: () {
                                            controller.setLoveType(type);
                                            controller.getLoveReading();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(right: 8.w),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 8.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Colors.pink
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              border: Border.all(
                                                color: isSelected
                                                    ? Colors.pink
                                                    : Colors.pink.withOpacity(
                                                        0.5,
                                                      ),
                                                width: 2,
                                              ),
                                            ),
                                            child: AutoTranslateText(
                                              type
                                                  .replaceAll('-', ' ')
                                                  .toUpperCase(),
                                              style: MyTextTheme.smallBCN
                                                  .copyWith(
                                                    color: isSelected
                                                        ? Colors.white
                                                        : Colors.pink,
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
                              ),
                              Spacing.h(24),
                              _buildLoveContent(controller),
                              Spacing.h(16),
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
                                    color: Colors.pink,
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
          // Confetti animation for positive matches
          if (showConfetti) const TarotConfettiWidget(),
        ],
      );
    });
  }

  Widget _buildLoveContent(TarotController controller) {
    return Obx(() {
      final loveType = controller.selectedLoveType.value;
      final isLoading = controller.isLoadingReading.value;

      if (loveType == 'triangle') {
        // Explicitly watch the response to ensure reactivity
        final response = controller.loveTriangleResponse.value;
        debugPrint(
          'ðŸ” Triangle Widget - isLoading: $isLoading, response: ${response != null ? "exists" : "null"}',
        );
        if (response != null) {
          debugPrint(
            'ðŸ” Triangle Response - self: ${response.self.name}, lover1: ${response.lover1.name}, lover2: ${response.lover2.name}',
          );
        }
        // Show loading if currently loading API
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        // If response is null and not loading, we're waiting for card selection
        // Don't show anything - let the selection progress widget show
        if (response == null) {
          return const SizedBox.shrink();
        }
        // Response is available, show the content
        // Check if response has valid data
        if (response.self.name.isEmpty &&
            response.lover1.name.isEmpty &&
            response.lover2.name.isEmpty) {
          debugPrint('âš ï¸ Triangle Response has empty data');
          return const SizedBox.shrink(); // Don't show empty response
        }
        return _buildTriangleContent(response);
      } else if (loveType == 'in-depth') {
        final response = controller.inDepthLoveResponse.value;
        if (response == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildSimpleLoveContent(
          response.name ?? controller.selectedCard?.name ?? 'Unknown Card',
          response.description,
        );
      } else if (loveType == 'erotic') {
        final response = controller.eroticLoveResponse.value;
        if (response == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildSimpleLoveContent(
          response.name ?? controller.selectedCard?.name ?? 'Unknown Card',
          response.description,
        );
      } else if (loveType == 'made-for-each-other') {
        final response = controller.madeForEachOtherResponse.value;
        if (response == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildSimpleLoveContent(
          response.name ?? controller.selectedCard?.name ?? 'Unknown Card',
          response.description,
        );
      } else if (loveType == 'flirt') {
        final response = controller.flirtReadingResponse.value;
        if (response == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildSimpleLoveContent(
          response.name ?? controller.selectedCard?.name ?? 'Unknown Card',
          response.description,
        );
      }

      return const SizedBox.shrink();
    });
  }

  Widget _buildSimpleLoveContent(String cardName, String description) {
    final controller = Get.find<TarotController>();

    return Obx(() {
      final response = controller.selectedLoveType.value == 'in-depth'
          ? controller.inDepthLoveResponse.value
          : controller.selectedLoveType.value == 'erotic'
          ? controller.eroticLoveResponse.value
          : controller.selectedLoveType.value == 'made-for-each-other'
          ? controller.madeForEachOtherResponse.value
          : controller.flirtReadingResponse.value;

      if (response == null) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card front image (theme selectable)
          Center(
            child: TarotCardDisplayWidget(
              cardImage: response.cardImage,
              width: 120.w,
              height: 180.h,
            ),
          ),

          Spacing.h(16),

          // Card back image (theme selectable - global theme applies)
          Center(
            child: TarotCardBackDisplayWidget(
              cardImagesBack: response.cardImagesBack,
              width: 120.w,
              height: 180.h,
            ),
          ),

          Spacing.h(16),

          // Card name
          AutoTranslateText(
            cardName,
            style: MyTextTheme.mediumBCN.copyWith(color: "#F38B3B".toColor()),
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
              description.isNotEmpty ? description : 'No description available',
              style: MyTextTheme.smallBCN.copyWith(
                color: '#820B17'.toColor(),
                height: 1.5,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTriangleContent(dynamic response) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLoveCard('You', response.self),
        Spacing.h(16),
        _buildLoveCard('Partner 1', response.lover1),
        Spacing.h(16),
        _buildLoveCard('Partner 2', response.lover2),
        Spacing.h(24),
      ],
    );
  }

  Widget _buildLoveCard(String title, dynamic card) {
    final cardName = card?.name ?? 'Unknown';
    final traits = card?.traits ?? <String>[];
    final description = card?.description ?? '';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.pink.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            '$title: $cardName',
            style: MyTextTheme.mediumBCN.copyWith(color: Colors.pink),
          ),
          Spacing.h(8),

          // Card image (theme selectable)
          TarotCardDisplayWidget(
            cardImage: card?.cardImage,
            width: 100.w,
            height: 150.h,
          ),

          Spacing.h(8),
          if (traits.isNotEmpty) ...[
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: traits.map<Widget>((trait) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.pink.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: AutoTranslateText(
                    trait.toString(),
                    style: MyTextTheme.smallBCN.copyWith(color: Colors.pink),
                  ),
                );
              }).toList(),
            ),
            Spacing.h(8),
          ],
          AutoTranslateText(
            description,
            style: MyTextTheme.smallBCN.copyWith(
              color: '#820B17'.toColor(),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

