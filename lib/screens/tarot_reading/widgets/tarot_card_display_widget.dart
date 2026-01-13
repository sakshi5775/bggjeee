import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/screens/tarot_reading/controller/tarot_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Reusable card display widget with theme support
/// Shows card image with theme selector
class TarotCardDisplayWidget extends StatelessWidget {
  final Map<String, String>? cardImage;
  final double? width;
  final double? height;
  final BoxFit fit;

  const TarotCardDisplayWidget({
    super.key,
    this.cardImage,
    this.width,
    this.height,
    this.fit = BoxFit.contain, // Changed from cover to contain to show full image without cutting
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TarotController>();

    return Obx(() {
      final theme = controller.selectedTheme.value;
      
      // Get card image URL from API response
      String? cardImageUrl;
      if (cardImage != null && cardImage!.isNotEmpty) {
        cardImageUrl = cardImage![theme] ?? cardImage!['classic'] ?? '';
      }
      
      // If no image URL, return empty
      if (cardImageUrl == null || cardImageUrl.isEmpty) {
        return const SizedBox.shrink();
      }

      final cardWidth = width ?? 120.w;
      final cardHeight = height ?? 180.h;

      return Container(
        key: ValueKey('card_${theme}_${cardImageUrl}'), // Force rebuild on theme change
        width: cardWidth,
        height: cardHeight,
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: CachedNetworkImage(
            key: ValueKey('img_${theme}_${cardImageUrl}'), // Force image reload on URL/theme change
            imageUrl: cardImageUrl,
            cacheKey: '${cardImageUrl}_theme_$theme', // Force cache refresh on theme change
            fit: fit,
            placeholder: (context, url) => Container(
              color: Colors.grey[200],
              child: Center(
                child: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    color: '#ee7532'.toColor(),
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[200],
              child: Icon(
                Icons.error,
                color: '#820B17'.toColor(),
                size: 30.w,
              ),
            ),
          ),
        ),
      );
    });
  }
}

/// Reusable card back display widget with theme support
class TarotCardBackDisplayWidget extends StatelessWidget {
  final Map<String, String>? cardImagesBack;
  final double? width;
  final double? height;
  final BoxFit fit;

  const TarotCardBackDisplayWidget({
    super.key,
    this.cardImagesBack,
    this.width,
    this.height,
    this.fit = BoxFit.contain, // Changed from cover to contain to show full image without cutting
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TarotController>();

    return Obx(() {
      final backType = controller.selectedBackType.value;
      
      // Get card back image URL from API response
      String? backImageUrl;
      if (cardImagesBack != null && cardImagesBack!.isNotEmpty) {
        backImageUrl = cardImagesBack![backType] ?? 
                      cardImagesBack!['classic'] ?? '';
      }
      
      // If no image URL, return empty
      if (backImageUrl == null || backImageUrl.isEmpty) {
        return const SizedBox.shrink();
      }

      final cardWidth = width ?? 120.w;
      final cardHeight = height ?? 180.h;

      return Container(
        key: ValueKey('back_${backType}_${backImageUrl}'), // Force rebuild on theme change
        width: cardWidth,
        height: cardHeight,
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: CachedNetworkImage(
            key: ValueKey('back_img_${backType}_${backImageUrl}'), // Force image reload on URL/theme change
            imageUrl: backImageUrl,
            cacheKey: '${backImageUrl}_back_$backType', // Force cache refresh on back type change
            fit: fit,
            placeholder: (context, url) => Container(
              color: Colors.grey[200],
              child: Center(
                child: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    color: '#ee7532'.toColor(),
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[200],
              child: Icon(
                Icons.error,
                color: '#820B17'.toColor(),
                size: 30.w,
              ),
            ),
          ),
        ),
      );
    });
  }
}

/// Reusable theme selector widget for card front
class TarotCardThemeSelector extends StatelessWidget {
  const TarotCardThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TarotController>();

    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ['classic', 'artwork', 'dark', 'ghibli'].map((theme) {
            final isSelected = controller.selectedTheme.value == theme;
            return GestureDetector(
              onTap: () => controller.setTheme(theme),
              child: Container(
                margin: EdgeInsets.only(right: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? '#ee7532'.toColor() 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected 
                        ? '#ee7532'.toColor() 
                        : '#ede7c8'.toColor().withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: AutoTranslateText(
                  theme.toUpperCase(),
                  style: TextStyle(
                    color: isSelected 
                        ? Colors.white 
                        : '#820B17'.toColor(),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}

/// Reusable back type selector widget
class TarotCardBackSelector extends StatelessWidget {
  const TarotCardBackSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TarotController>();

    return Obx(() {
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
            final isSelected = controller.selectedBackType.value == backType;
            return GestureDetector(
              onTap: () => controller.setBackType(backType),
              child: Container(
                margin: EdgeInsets.only(right: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? '#ee7532'.toColor() 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected 
                        ? '#ee7532'.toColor() 
                        : '#ede7c8'.toColor().withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: AutoTranslateText(
                  backType.replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(
                    color: isSelected 
                        ? Colors.white 
                        : '#820B17'.toColor(),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}

