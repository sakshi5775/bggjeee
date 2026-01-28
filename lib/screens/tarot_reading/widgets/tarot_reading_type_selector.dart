import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/screens/tarot_reading/controller/tarot_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Reading type selector widget
class TarotReadingTypeSelector extends StatelessWidget {
  const TarotReadingTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TarotController>();

    return Obx(() {
      if (!controller.showCards.value || controller.cards.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: '#ede7c8'.toColor(),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: "#F38B3B".toColor().withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
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
                  Icons.auto_awesome,
                  color: "#F38B3B".toColor(),
                  size: 24.w,
                ),
                Spacing.w(8),
                AutoTranslateText(
                  'Choose Reading Type',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: '#820B17'.toColor(),
                  ),
                ),
              ],
            ),
            Spacing.h(16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  _buildReadingButton(
                    controller: controller,
                    type: 'yesno',
                    icon: Icons.check_circle,
                    label: 'Yes/No',
                    color: "#F38B3B".toColor(),
                    onTap: () => controller.getYesNoReading(),
                  ),
                  _buildReadingButton(
                    controller: controller,
                    type: 'career',
                    icon: Icons.work,
                    label: 'Career',
                    color: '#820B17'.toColor(),
                    onTap: () => controller.getCareerReading(),
                  ),
                  _buildReadingButton(
                    controller: controller,
                    type: 'love',
                    icon: Icons.favorite,
                    label: 'Love',
                    color: Colors.pink,
                    onTap: () => controller.getLoveReading(),
                  ),
                  _buildReadingButton(
                    controller: controller,
                    type: 'daily',
                    icon: Icons.calendar_today,
                    label: 'Daily',
                    color: Colors.blue,
                    onTap: () => controller.getDailyReading(),
                  ),
                  _buildReadingButton(
                    controller: controller,
                    type: 'romantic-breakup',
                    icon: Icons.favorite_border,
                    label: 'Romantic Breakup',
                    color: Colors.red,
                    onTap: () => controller.getRomanticBreakupReading(),
                  ),
                  _buildReadingButton(
                    controller: controller,
                    type: 'business-breakup',
                    icon: Icons.business_center,
                    label: 'Business Breakup',
                    color: "#F38B3B".toColor(),
                    onTap: () => controller.getBusinessBreakupReading(),
                  ),
                  _buildReadingButton(
                    controller: controller,
                    type: 'fortune-cookie',
                    icon: Icons.cookie,
                    label: 'Fortune Cookie',
                    color: Colors.amber,
                    onTap: () => controller.getFortuneCookie(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildReadingButton({
    required TarotController controller,
    required String type,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isSelected = controller.selectedReadingType.value == type;
    final isLoading = controller.isLoadingReading.value;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading && controller.selectedReadingType.value == type)
              SizedBox(
                width: 16.w,
                height: 16.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isSelected ? Colors.white : color,
                  ),
                ),
              )
            else
              Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 20.w,
              ),
            Spacing.w(8),
            AutoTranslateText(
              label,
              style: MyTextTheme.smallBCN.copyWith(
                color: isSelected ? Colors.white : '#820B17'.toColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

