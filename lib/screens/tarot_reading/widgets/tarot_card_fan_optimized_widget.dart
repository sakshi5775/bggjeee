import 'dart:math' as math;
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/tarot_card_model.dart';
import 'package:astrobharataiuser/screens/tarot_reading/controller/tarot_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Production-ready optimized fan spread widget
/// Handles 78 cards with lazy loading and viewport optimization
class TarotCardFanOptimizedWidget extends StatelessWidget {
  const TarotCardFanOptimizedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TarotController>();

    return Obx(() {
      final showCards = controller.showCards.value;
      final hasCards = controller.cards.isNotEmpty;
      final progress = controller.fanSpreadProgress.value;
      // Watch theme and backType to force rebuild when they change
      final theme = controller.selectedTheme.value;
      final backType = controller.selectedBackType.value;
      
      debugPrint('🎴 FanWidget: showCards=$showCards, hasCards=$hasCards, progress=$progress, cardCount=${controller.cards.length}, theme=$theme, backType=$backType');
      
      if (!showCards || !hasCards) {
        debugPrint('🎴 FanWidget: Returning SizedBox.shrink() - showCards=$showCards, hasCards=$hasCards');
        return const SizedBox.shrink();
      }

      // Cards are already sorted by API index in controller
      final cards = controller.cards;
      final selectedIndex = controller.selectedCardIndex.value;
      final isRevealing = controller.isRevealing.value;
      final isCardOpen = controller.isCardOpen.value; // Check if card is open
      final screenWidth = MediaQuery.of(context).size.width;

      // Calculate viewport bounds for lazy loading (optimize for 78 cards)
      // Only render cards visible in viewport + buffer
      final viewportLeft = -screenWidth * 0.3;
      final viewportRight = screenWidth * 1.3;

      // Sort indices: non-selected first, then selected (for proper z-index)
      final sortedIndices = List.generate(cards.length, (i) => i)
        ..sort((a, b) {
          if (selectedIndex == a) return 1;
          if (selectedIndex == b) return -1;
          return a.compareTo(b);
        });

      debugPrint('🎴 FanWidget: Building Stack with ${cards.length} cards, progress=$progress');
      
      // Ensure progress is at least a small value so cards are visible
      final effectiveProgress = progress > 0 ? progress : 0.1;
      
      return SizedBox(
        height: 450.h, // Increased to accommodate taller cards
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Render only visible cards (lazy loading optimization)
            ...sortedIndices.where((index) {
              // Calculate if card is in viewport
              final position = _calculateCardPosition(
                index: index,
                totalCards: cards.length,
                progress: effectiveProgress,
                screenWidth: screenWidth,
              );
              final inViewport = position.dx >= viewportLeft && position.dx <= viewportRight;
              if (index < 3) {
                debugPrint('🎴 FanWidget: Card $index position=${position.dx}, inViewport=$inViewport');
              }
              return inViewport;
            }).map((index) {
              return _buildCard(
                card: cards[index],
                index: index,
                totalCards: cards.length,
                progress: effectiveProgress,
                isSelected: selectedIndex == index,
                isRevealing: isRevealing && selectedIndex == index,
                isCardOpen: isCardOpen && selectedIndex == index, // Pass isCardOpen state
                controller: controller,
                screenWidth: screenWidth,
                theme: theme,
                backType: backType,
              );
            }),
          ],
        ),
      );
    });
  }

  Offset _calculateCardPosition({
    required int index,
    required int totalCards,
    required double progress,
    required double screenWidth,
  }) {
    final totalAngle = math.min(math.pi * 0.8, (totalCards * 0.05));
    final startAngle = -totalAngle / 2;
    final angleStep = totalCards > 1 ? totalAngle / (totalCards - 1) : 0;
    final angle = startAngle + (angleStep * index);

    final baseRadius = 180.w; // Increased from 140.w
    final radius = baseRadius * progress;
    final x = radius * math.sin(angle);
    final cardWidth = 150.w; // Increased from 130.w

    return Offset(
      (screenWidth / 2) + (x * progress) - (cardWidth / 2),
      100.h,
    );
  }

  Widget _buildCard({
    required TarotCardModel card,
    required int index,
    required int totalCards,
    required double progress,
    required bool isSelected,
    required bool isRevealing,
    required bool isCardOpen, // Card is open/sticky
    required TarotController controller,
    required double screenWidth,
    required String theme,
    required String backType,
  }) {
    // Calculate fan spread angle - wider spread for better visibility
    final totalAngle = math.min(math.pi * 1.2, (totalCards * 0.08)); // Increased from 0.8 to 1.2 and 0.05 to 0.08
    final startAngle = -totalAngle / 2;
    final angleStep = totalCards > 1 ? totalAngle / (totalCards - 1) : 0;
    final angle = startAngle + (angleStep * index);

    // Calculate position - wider radius for more spread
    final baseRadius = 180.w; // Increased from 140.w
    final radius = baseRadius * progress;
    final x = radius * math.sin(angle);
    final y = -radius * math.cos(angle) * 0.4;

    // Rotation and scale with smooth easing - improved curves
    // Fan spread rotation (cards fan out in an arc)
    final fanRotation = angle * progress;
    // Use smoother easing curve
    final easedProgress = 1 - math.pow(1 - progress, 2.5); // Changed from 3 to 2.5 for smoother
    final scale = isSelected ? 1.4 : (0.9 + (0.1 * easedProgress));
    
    // For multi-card selections (triangle, breakup), keep cards visible
    // Check if we're in a multi-card selection flow (either in progress or completed with response)
    final isTriangleFlow = controller.selectedLoveType.value == 'triangle';
    final isBreakupFlow = controller.selectedReadingType.value == 'romantic-breakup' || 
                          controller.selectedReadingType.value == 'business-breakup';
    
    // Keep cards visible if:
    // 1. We're in triangle flow and either selection is in progress OR response is available
    // 2. We're in breakup flow and either selection is in progress OR response is available
    final triangleResponseAvailable = controller.loveTriangleResponse.value != null;
    final breakupResponseAvailable = controller.romanticBreakupResponse.value != null || 
                                     controller.businessBreakupResponse.value != null;
    
    final isMultiCardSelection = (isTriangleFlow && (controller.triangleSelectionStep.value != 'complete' || triangleResponseAvailable)) ||
                                 (isBreakupFlow && (controller.breakupSelectionStep.value != 'complete' || breakupResponseAvailable));
    
    // Hide the card in fan spread if it's open (to avoid duplicate) - but not during multi-card selection
    final opacity = (isCardOpen && !isMultiCardSelection) ? 0.0 : (isSelected ? 1.0 : (isRevealing ? 0.2 : math.max(0.1, (0.7 + (0.2 * easedProgress)))));

    final cardWidth = 150.w; // Increased from 130.w

    return Positioned(
      left: (screenWidth / 2) + (x * progress) - (cardWidth / 2),
      top: 100.h + (y * progress),
      child: Transform(
        transform: Matrix4.identity()
          ..rotateZ(fanRotation) // Fan spread rotation only (card direction rotation is handled in _buildCardFront)
          ..scale(scale),
        alignment: Alignment.center,
        child: Opacity(
          opacity: opacity,
          child: GestureDetector(
            onTap: () {
              // If a card is open, close it when tapping any card
              if (controller.isCardOpen.value) {
                controller.closeCard();
              } else {
                controller.selectCard(index);
              }
            },
            child: RepaintBoundary(
              child: _OptimizedTarotCardWidget(
                card: card,
                isRevealed: isRevealing,
                theme: theme,
                backType: backType,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Optimized individual card widget with performance enhancements
class _OptimizedTarotCardWidget extends StatelessWidget {
  final TarotCardModel card;
  final bool isRevealed;
  final String theme;
  final String backType;

  const _OptimizedTarotCardWidget({
    required this.card,
    required this.isRevealed,
    required this.theme,
    required this.backType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('card_${theme}_${backType}_${card.id}'), // Force rebuild on theme/backType change
      width: 150.w, // Increased from 130.w
      height: 280.h, // Increased to show full card without cutting
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
          if (isRevealed)
            BoxShadow(
              color: "#F38B3B".toColor().withOpacity(0.7),
              blurRadius: 25,
              spreadRadius: 8,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        clipBehavior: Clip.antiAlias, // Better edge rendering
        child: SizedBox.expand(
          child: isRevealed ? _buildCardFront() : _buildCardBack(),
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    final imageUrl = card.getCardImageUrl(theme);
    final isReversed = card.isReversed;

    return Transform.rotate(
      angle: isReversed ? math.pi : 0.0,
      alignment: Alignment.center,
      child: imageUrl.isNotEmpty
          ? FittedBox(
              fit: BoxFit.contain, // Show full image without cutting
              child: CachedNetworkImage(
                key: ValueKey('front_${theme}_${imageUrl}'), // Force rebuild on theme change
                imageUrl: imageUrl,
                cacheKey: '${imageUrl}_theme_$theme', // Force cache refresh on theme change
                fit: BoxFit.contain, // Show full image without cutting
                placeholder: (context, url) => Container(
                  width: 150.w, // Increased from 130.w
                  height: 280.h, // Increased to show full card without cutting
                  color: '#ede7c8'.toColor(),
                  child: Center(
                    child: SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        color: "#F38B3B".toColor(),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 150.w, // Increased from 130.w
                  height: 280.h, // Increased to show full card without cutting
                  color: '#ede7c8'.toColor(),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          color: '#820B17'.toColor(),
                          size: 30.w,
                        ),
                        Spacing.h(8),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: AutoTranslateText(
                            card.name,
                            style: AppTypography.label.copyWith(
                              color: '#820B17'.toColor(),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Container(
              width: 150.w, // Increased from 130.w
              height: 280.h, // Increased to show full card without cutting
              color: '#ede7c8'.toColor(),
              child: Center(
                child: AutoTranslateText(
                  card.name,
                  style: AppTypography.body2.copyWith(
                    color: '#820B17'.toColor(),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
    );
  }

  Widget _buildCardBack() {
    final backImageUrl = card.getBackImageUrl(backType: backType);

    return backImageUrl.isNotEmpty
        ? FittedBox(
            fit: BoxFit.contain, // Show full image without cutting
            child: CachedNetworkImage(
              key: ValueKey('back_${backType}_${backImageUrl}'), // Force rebuild on backType change
              imageUrl: backImageUrl,
              cacheKey: '${backImageUrl}_back_$backType', // Force cache refresh on backType change
              fit: BoxFit.contain, // Show full image without cutting
              placeholder: (context, url) => Container(
                width: 150.w, // Match card front width
                height: 280.h, // Increased to show full card without cutting
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      '#820B17'.toColor(),
                      "#F38B3B".toColor(),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      color: '#ede7c8'.toColor(),
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 150.w, // Match card front width
                height: 280.h, // Increased to show full card without cutting
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      '#820B17'.toColor(),
                      "#F38B3B".toColor(),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: '#ede7c8'.toColor(),
                  size: 50.w,
                ),
              ),
            ),
          )
        : Container(
            width: 130.w,
            height: 200.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  '#820B17'.toColor(),
                  '#ee7532'.toColor(),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              Icons.auto_awesome,
              color: '#ede7c8'.toColor(),
              size: 50.w,
            ),
          );
  }
}

