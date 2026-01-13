import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
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

    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(),
              Spacing.h(24),
              AutoTranslateText(
                'Generated Matrix',
                style: MyTextTheme.veryLargeBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ).merge(AppTypography.h1),
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
                      child: ElevatedButton(
                        onPressed: () async {
                          // Show loading widget
                          Get.dialog(
                            RamalShastraLoadingWidget(
                              message: 'Ramal Shastra is analyzing your question...',
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
                          backgroundColor: '#FF6B35'.toColor(),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 6,
                          shadowColor: '#FF6B35'.toColor().withOpacity(0.35),
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
                  ],
                ),
              ),
              Spacing.h(32),
            ],
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

  Widget _buildMatrix(List<int> points) {
    if (points.length != 16) {
      return Center(
        child: AutoTranslateText(
          'Invalid matrix',
          style: MyTextTheme.mediumBCN.copyWith(
            color: Colors.red,
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: '#F5D7B8'.toColor(),
          width: 1.5,
        ),
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
                  color: value == 1 ? '#FF6B35'.toColor() : Colors.grey[300],
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

