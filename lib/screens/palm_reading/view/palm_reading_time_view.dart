import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/palm_reading/controller/palm_reading_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PalmReadingTimeView extends StatelessWidget {
  const PalmReadingTimeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PalmReadingController>();
    final isMobile = MediaQuery.of(context).size.width < 768;
    final maxWidth = isMobile ? double.infinity : 500.w;

    return Scaffold(
      backgroundColor: '#F7EFBD'.toColor(), // Match face reading background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: AppPaddings.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: '#3E2723'.toColor(),
                            size: 20.w,
                          ),
                        ),
                      ),
                    ),
                    
                    Spacing.h(40),
                    
                    // Question
                    AutoTranslateText(
                      'What time were you born? (Optional)',
                      style: MyTextTheme.veryLargeBCB.copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.bold,
                      ).merge(AppTypography.h1),
                      textAlign: TextAlign.center,
                    ),
                    
                    Spacing.h(12),
                    
                    // Subtitle
                    AutoTranslateText(
                      'Help us calculate your planetary position (optional)',
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: Colors.grey[700],
                      ).merge(AppTypography.body1),
                      textAlign: TextAlign.center,
                    ),
                    
                    Spacing.h(60),
                    
                    // Time picker
                    _buildTimePicker(controller),
                    
                    Spacing.h(60),
                    
                    // Next button
                    _buildNextButton(controller),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(PalmReadingController controller) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hours picker
          Expanded(
            child: _buildPickerColumn(
              controller,
              'hours',
              List.generate(12, (i) => i + 1),
            ),
          ),
          
          // Separator
          AutoTranslateText(
            ':',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ).merge(AppTypography.h1),
          ),
          
          // Minutes picker
          Expanded(
            child: _buildPickerColumn(
              controller,
              'minutes',
              List.generate(60, (i) => i),
            ),
          ),
          
          // AM/PM picker
          Expanded(
            child: _buildPickerColumn(
              controller,
              'ampm',
              ['AM', 'PM'],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerColumn(
    PalmReadingController controller,
    String type,
    List<dynamic> items,
  ) {
    return Obx(() {
      int selectedIndex;
      if (type == 'hours') {
        selectedIndex = controller.selectedHour.value - 1;
      } else if (type == 'minutes') {
        selectedIndex = controller.selectedMinute.value;
      } else {
        selectedIndex = controller.selectedAmPm.value == 'AM' ? 0 : 1;
      }

      return ListWheelScrollView.useDelegate(
        itemExtent: 50.h,
        diameterRatio: 1.5,
        perspective: 0.003,
        physics: const FixedExtentScrollPhysics(),
        controller: FixedExtentScrollController(initialItem: selectedIndex),
        onSelectedItemChanged: (index) {
          if (type == 'hours') {
            controller.selectedHour.value = items[index] as int;
          } else if (type == 'minutes') {
            controller.selectedMinute.value = items[index] as int;
          } else {
            controller.selectedAmPm.value = items[index] as String;
          }
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index >= items.length) return null;
            final item = items[index];
            final isSelected = index == selectedIndex;
            
            return Center(
              child: AutoTranslateText(
                item.toString().padLeft(type == 'hours' ? 2 : 0, '0'),
                style: TextStyle(
                  color: isSelected
                      ? '#EA632B'.toColor()
                      : Colors.grey[600],
                  fontSize: isSelected ? 24.sp : 18.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  decoration: isSelected
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
            );
          },
          childCount: items.length,
        ),
      );
    });
  }

  Widget _buildNextButton(PalmReadingController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => controller.onContinueFromTime(),
        style: ElevatedButton.styleFrom(
          backgroundColor: '#EA632B'.toColor(),
          foregroundColor: Colors.white,
          padding: AppPaddings.symmetric(v: 16, h: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 4,
        ),
        child: AutoTranslateText(
          'Next',
          style: MyTextTheme.mediumBCB.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ).merge(AppTypography.h3),
        ),
      ),
    );
  }
}


