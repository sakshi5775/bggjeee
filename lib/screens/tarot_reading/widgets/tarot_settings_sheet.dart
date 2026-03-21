import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/tarot_reading/controller/tarot_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TarotSettingsSheet extends StatelessWidget {
  const TarotSettingsSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const TarotSettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TarotController>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Row(
            children: [
              Icon(Icons.tune, color: '#820B17'.toColor(), size: 20.w),
              SizedBox(width: 8.w),
              AutoTranslateText(
                'Card Settings',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#820B17'.toColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 17.sp,
                ),
              ),
            ],
          ),
          Spacing.h(20),

          // Card Theme
          _SectionLabel(
            icon: Icons.palette_outlined,
            label: 'Card Theme',
          ),
          Spacing.h(8),
          Obx(() => _HorizontalChips(
                items: const ['classic', 'artwork', 'dark', 'ghibli'],
                selected: controller.selectedTheme.value,
                onSelect: controller.setTheme,
                labelBuilder: (t) => t[0].toUpperCase() + t.substring(1),
              )),

          Spacing.h(20),

          // Card Back
          _SectionLabel(
            icon: Icons.style_outlined,
            label: 'Card Back Design',
          ),
          Spacing.h(8),
          Obx(() => _HorizontalChips(
                items: const [
                  'classic',
                  'dark',
                  'indigo_star',
                  'playing_blue',
                  'playing_red',
                  'ghibli_sun',
                  'ghibli_tree',
                ],
                selected: controller.selectedBackType.value,
                onSelect: controller.setBackType,
                labelBuilder: (t) =>
                    t.replaceAll('_', ' ')[0].toUpperCase() +
                    t.replaceAll('_', ' ').substring(1),
              )),

          Spacing.h(20),

          // Shuffle Type
          _SectionLabel(
            icon: Icons.shuffle,
            label: 'Default Shuffle Type',
          ),
          Spacing.h(8),
          Obx(() => _HorizontalChips(
                items: const ['minor', 'both', 'major'],
                selected: controller.selectedShuffleType.value,
                onSelect: controller.setShuffleType,
                labelBuilder: (t) =>
                    t[0].toUpperCase() + t.substring(1) + ' Arcana',
              )),
          Spacing.h(8),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: '#68171E'.toColor(), size: 18.w),
        SizedBox(width: 6.w),
        AutoTranslateText(
          label,
          style: MyTextTheme.smallBCN.copyWith(
            color: '#68171E'.toColor(),
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
        ),
      ],
    );
  }
}

class _HorizontalChips extends StatelessWidget {
  final List<String> items;
  final String selected;
  final void Function(String) onSelect;
  final String Function(String) labelBuilder;

  const _HorizontalChips({
    required this.items,
    required this.selected,
    required this.onSelect,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          final isSelected = selected == item;
          return GestureDetector(
            onTap: () => onSelect(item),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.orangeGradient : null,
                color: isSelected ? null : '#F5F0E8'.toColor(),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : '#68171E'.toColor().withValues(alpha: 0.2),
                  width: 1.2,
                ),
              ),
              child: AutoTranslateText(
                labelBuilder(item),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : '#68171E'.toColor(),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
