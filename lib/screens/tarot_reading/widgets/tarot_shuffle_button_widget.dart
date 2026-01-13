import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/tarot_reading/controller/tarot_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Three-part shuffle button widget
/// Part 1: Minor shuffle
/// Part 2: Both (Major + Minor) shuffle
/// Part 3: Major shuffle
class TarotShuffleButtonWidget extends StatelessWidget {
  const TarotShuffleButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TarotController>();

    return Obx(() {
      final isLoading = controller.isLoading.value || controller.isShuffling.value;
      
      return Container(
        width: double.infinity,
        height: 56.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Part 1: Minor Shuffle
            Expanded(
              child: _buildShuffleButtonPart(
                controller: controller,
                type: 'minor',
                label: 'Minor\nShuffle',
                isLoading: isLoading,
                isSelected: controller.selectedShuffleType.value == 'minor',
              ),
            ),
            // Divider
            Container(
              width: 1.w,
              color: '#ede7c8'.toColor().withOpacity(0.3),
            ),
            // Part 2: Both Shuffle
            Expanded(
              child: _buildShuffleButtonPart(
                controller: controller,
                type: 'both',
                label: 'Both\nShuffle',
                isLoading: isLoading,
                isSelected: controller.selectedShuffleType.value == 'both',
              ),
            ),
            // Divider
            Container(
              width: 1.w,
              color: '#ede7c8'.toColor().withOpacity(0.3),
            ),
            // Part 3: Major Shuffle
            Expanded(
              child: _buildShuffleButtonPart(
                controller: controller,
                type: 'major',
                label: 'Major\nShuffle',
                isLoading: isLoading,
                isSelected: controller.selectedShuffleType.value == 'major',
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildShuffleButtonPart({
    required TarotController controller,
    required String type,
    required String label,
    required bool isLoading,
    required bool isSelected,
  }) {
    final isActive = controller.selectedShuffleType.value == type;
    
    return GestureDetector(
      onTap: isLoading ? null : () {
        controller.setShuffleType(type);
        controller.shuffleCards();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  colors: [
                    '#ee7532'.toColor(),
                    '#820B17'.toColor(),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isActive ? null : '#ede7c8'.toColor(),
          borderRadius: _getBorderRadius(type),
        ),
        child: Center(
          child: isLoading && isActive
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                )
              : AutoTranslateText(
                  label,
                  textAlign: TextAlign.center,
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: isActive ? Colors.white : '#820B17'.toColor(),
                    height: 1.2,
                  ),
                ),
        ),
      ),
    );
  }

  BorderRadius _getBorderRadius(String type) {
    switch (type) {
      case 'minor':
        return BorderRadius.only(
          topLeft: Radius.circular(16.r),
          bottomLeft: Radius.circular(16.r),
        );
      case 'major':
        return BorderRadius.only(
          topRight: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r),
        );
      case 'both':
      default:
        return BorderRadius.zero;
    }
  }
}



