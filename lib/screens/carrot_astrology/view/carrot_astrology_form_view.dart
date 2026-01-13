import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/carrot_astrology/controller/carrot_astrology_controller.dart';
import 'package:astrobharataiuser/screens/carrot_astrology/utils/carrot_astrology_colors.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CarrotAstrologyFormView extends StatelessWidget {
  const CarrotAstrologyFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CarrotAstrologyController());
    final isMobile = MediaQuery.of(context).size.width < 768;
    final maxWidth = isMobile ? double.infinity : 600.w;

    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  Spacing.h(12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: AutoTranslateText(
                      'Select Your Zodiac Sign',
                      style: MyTextTheme.veryLargeBCB.copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.bold,
                      ).merge(AppTypography.h1),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: AutoTranslateText(
                      'Choose your zodiac sign to discover your vegetable match',
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: '#3E2723'.toColor(),
                      ).merge(AppTypography.body1),
                    ),
                  ),
                  Spacing.h(20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _buildZodiacSignGrid(controller),
                  ),
                  Spacing.h(24),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _buildAnalyzeButton(controller),
                  ),
                  Spacing.h(24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: '#ffffff'.toColor(),
                borderRadius: BorderRadius.circular(8.r),
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
        ],
      ),
    );
  }

  Widget _buildZodiacSignGrid(CarrotAstrologyController controller) {
    return Obx(() {
      // Access observable directly in Obx scope
      final selectedSign = controller.selectedZodiacSign.value;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.85,
        ),
        itemCount: controller.zodiacSigns.length,
        itemBuilder: (context, index) {
          final sign = controller.zodiacSigns[index];
          final isSelected = selectedSign == sign;
        
        return GestureDetector(
          onTap: () => controller.setSelectedZodiacSign(sign),
          child: Container(
            decoration: BoxDecoration(
              gradient: isSelected ? CarrotAstrologyColors.orangeGradient : null,
              color: isSelected ? null : '#ffffff'.toColor(),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: isSelected ? CarrotAstrologyColors.orangeColorDark : '#F5D7B8'.toColor(),
                width: isSelected ? 2 : 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isSelected ? 0.15 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoTranslateText(
                    controller.getZodiacSymbol(sign),
                    style: AppTypography.h1.copyWith(
                      fontSize: 28.sp,
                      color: isSelected ? '#ffffff'.toColor() : '#3E2723'.toColor(),
                    ),
                  ),
                  Spacing.h(6),
                  Flexible(
                    child: AutoTranslateText(
                      sign,
                      style: MyTextTheme.smallBCB.copyWith(
                        color: isSelected ? '#ffffff'.toColor() : '#3E2723'.toColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected) ...[
                    Spacing.h(2),
                    Icon(
                      Icons.check_circle,
                      color: '#ffffff'.toColor(),
                      size: 16.w,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
      );
    });
  }

  Widget _buildAnalyzeButton(CarrotAstrologyController controller) {
    return Obx(() => SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: controller.isAnalyzing.value 
              ? null 
              : CarrotAstrologyColors.orangeGradient,
          color: controller.isAnalyzing.value 
              ? CarrotAstrologyColors.orangeColor.withOpacity(0.6)
              : null,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: CarrotAstrologyColors.orangeColorDark.withOpacity(0.35),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: controller.isAnalyzing.value ? null : () => controller.analyzeCarrotAstrology(),
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
              child: controller.isAnalyzing.value
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>('#ffffff'.toColor()),
                        ),
                      ),
                      Spacing.w(12),
                      AutoTranslateText(
                        'Analyzing...',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: '#ffffff'.toColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 20.w,
                        color: '#ffffff'.toColor(),
                      ),
                      Spacing.w(8),
                      AutoTranslateText(
                        'Analyze Carrot Astrology',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: '#ffffff'.toColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
            ),
          ),
        ),
      ),
    ));
  }
}

