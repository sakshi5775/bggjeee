import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/tarot_reading/controller/tarot_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Fortune Cookie Widget
class TarotFortuneCookieWidget extends StatelessWidget {
  const TarotFortuneCookieWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TarotController>();

    return Obx(() {
      if (controller.selectedReadingType.value != 'fortune-cookie') {
        return const SizedBox.shrink();
      }
      
      final response = controller.fortuneCookieResponse.value;
      if (response == null) {
        // Show loading state
        return Container(
          color: Colors.black.withOpacity(0.7),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      return GestureDetector(
        onTap: () => controller.closeReading(),
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: Center(
            child: GestureDetector(
              onTap: () {},
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
                        margin: EdgeInsets.symmetric(horizontal: 24.w),
                        padding: EdgeInsets.all(32.w),
                        decoration: BoxDecoration(
                          color: '#ede7c8'.toColor(),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.amber,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Cookie icon
                            Icon(
                              Icons.cookie,
                              color: Colors.amber,
                              size: 60.w,
                            ),
                            Spacing.h(24),
                            AutoTranslateText(
                              'Your Fortune',
                              style: MyTextTheme.largeBCB.copyWith(
                                color: '#820B17'.toColor(),
                              ),
                            ),
                            Spacing.h(24),
                            Container(
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.amber.withOpacity(0.3),
                                ),
                              ),
                              child: AutoTranslateText(
                                response.message,
                                style: MyTextTheme.mediumBCN.copyWith(
                                  color: '#820B17'.toColor(),
                                  height: 1.6,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Spacing.h(24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () => controller.closeReading(),
                                  icon: Icon(
                                    Icons.close,
                                    color: '#820B17'.toColor(),
                                    size: 24.w,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () => controller.closeReading(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32.w,
                                  vertical: 12.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: AutoTranslateText(
                                'Close',
                                style: MyTextTheme.smallBCN.copyWith(
                                  color: '#820B17'.toColor(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}

