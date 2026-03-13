import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/controller/ramal_shastra_controller.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/widgets/ramal_shastra_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RamalShastraConfirmationView extends StatelessWidget {
  const RamalShastraConfirmationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RamalShastraController>();

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            const CommonHeader(title: 'Confirmation'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacing.h(24),
                    AutoTranslateText(
                      'Generated Matrix',
                      style: MyTextTheme.veryLargeBCB
                          .copyWith(
                            color: '#3E2723'.toColor(),
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.h1),
                    ),
                    Spacing.h(32),
                    Obx(() => _buildMatrix(controller.generatedPoints)),
                    Spacing.h(32),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                controller.regeneratePoints();
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[600],
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: AutoTranslateText(
                                'Regenerate',
                                style: MyTextTheme.mediumBCB.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Spacing.w(16),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: AppColors.orangeGradient,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: "#F38B3B".toColor().withOpacity(
                                      0.35,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Show loading widget
                                  Get.dialog(
                                    RamalShastraLoadingWidget(
                                      message:
                                          'Ramal Shastra is analyzing your question...',
                                    ),
                                    barrierDismissible: false,
                                  );

                                  try {
                                    await controller.analyzeRamal();
                                    // Dialog will be closed by navigation in controller
                                    // If navigation happens, dialog auto-closes
                                  } catch (e) {
                                    // Close loading dialog on error
                                    if (Get.isDialogOpen ?? false) {
                                      Get.back();
                                    }
                                    // Error is already shown in controller's analyzeRamal method
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                ),
                                child: AutoTranslateText(
                                  'Confirm & Analyze',
                                  style: MyTextTheme.mediumBCB.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacing.h(32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatrix(List<int> points) {
    if (points.length != 16) {
      return Center(
        child: AutoTranslateText(
          'Invalid matrix',
          style: MyTextTheme.mediumBCN.copyWith(color: Colors.red),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: '#F5D7B8'.toColor(), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: List.generate(4, (row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (col) {
              final index = row * 4 + col;
              final value = points[index];
              return Container(
                width: 60.w,
                height: 60.w,
                margin: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: value == 1 ? "#F38B3B".toColor() : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: value == 1 ? '#E85C0D'.toColor() : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    value == 1 ? '●' : '○',
                    style: TextStyle(
                      fontSize: 32.sp,
                      color: value == 1 ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
