import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class QuoteOfTheDayWidget extends BasePage<UserDashboardController> {
  const QuoteOfTheDayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final quote = controller.dailyQuote.value;
      final isFallback = quote?.isFallback ?? false;
      final title = isFallback ? 'Quote' : 'Quote of the Day';

      return LayoutBuilder(
        builder: (context, constraints) {
          // Calculate full width (screen width)
          final double screenWidth = constraints.maxWidth;
          final double imageWidth = screenWidth;
          // Maintain aspect ratio: 990 / 768
          final double imageHeight = (imageWidth * 768) / 990;

          return SizedBox(
            width: imageWidth,
            height: imageHeight,
            child: Stack(
              children: [
                // Background image - takes full width, maintains aspect ratio
                // Using fitWidth ensures image scales to full width without stretching
                Positioned.fill(
                  child: Image.asset(
                    AppConstant.quoteBackground,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    width: imageWidth,
                  ),
                ),
                // Text content with proper padding to stay within scroll boundaries
                Positioned.fill(
                  child: Padding(
                    // Padding calculated as percentage to ensure text stays well within scroll edges
                    // Left/Right: Accounts for rolled scroll edges
                    // Top/Bottom: Accounts for scroll finials at top and bottom
                    padding: EdgeInsets.only(
                      left: imageWidth * 0.10, // 10% of width from left edge
                      right: imageWidth * 0.10, // 10% of width from right edge
                      top: imageHeight * 0.18, // 18% of height from top (below finial)
                      bottom: imageHeight * 0.18, // 18% of height from bottom (above finial)
                    ),
                    child: ClipRect(
                      // ClipRect ensures text never overflows the padded area
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Title
                            AutoTranslateText(
                              title,
                              style: MyTextTheme.mediumBCB
                                  .copyWith(
                                    color: "#6F221E".toColor(),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Baloo Bhai 2',
                                    fontSize: 15.sp,
                                  )
                                  .merge(AppTypography.h3),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 10.h),
                            // Sanskrit text
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: AutoTranslateText(
                                quote?.sanskrit.text ?? '',
                                style: MyTextTheme.mediumBCB.copyWith(
                                  color: "#F38B3B".toColor(),
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Poppins',
                                  fontSize: 15.sp,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            // Meaning/Translation
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: AutoTranslateText(
                                quote?.sanskrit.meaning ?? '',
                                style: MyTextTheme.mediumBCN.copyWith(
                                  color: "#551F23".toColor(),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  fontSize: 14.sp,
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

