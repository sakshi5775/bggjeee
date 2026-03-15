import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/controller/ramal_shastra_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class RamalShastraCastingDotsView extends StatefulWidget {
  const RamalShastraCastingDotsView({Key? key}) : super(key: key);

  @override
  State<RamalShastraCastingDotsView> createState() =>
      _RamalShastraCastingDotsViewState();
}

class _RamalShastraCastingDotsViewState
    extends State<RamalShastraCastingDotsView> {
  final RamalShastraController controller = Get.find<RamalShastraController>();
  final List<int> tapCounts = List.generate(16, (_) => 0);
  int currentTapIndex = 0;

  void _onScreenTap(TapDownDetails details) {
    if (currentTapIndex < 16) {
      setState(() {
        tapCounts[currentTapIndex]++;
      });
    }
  }

  void _confirmTap() {
    if (tapCounts[currentTapIndex] == 0) {
      Get.snackbar(
        'Error',
        'Please tap on the screen first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (currentTapIndex < 15) {
      setState(() {
        currentTapIndex++;
      });
    } else {
      // All 16 taps collected
      controller.generatePointsFromDots(tapCounts);
      UserMainController.pushInCurrentTab(AppRoutes.ramalShastraConfirmation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: SafeArea(
          child: Column(
            children: [
              const CommonHeader(title: 'Ramal Shastra'),
              Spacing.h(12),
              AutoTranslateText(
                'Tap Randomly on Screen',
                style: MyTextTheme.veryLargeBCB
                    .copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    )
                    .merge(AppTypography.h1),
              ),
              Spacing.h(4),
              AutoTranslateText(
                'Tap ${currentTapIndex + 1} of 16',
                style: MyTextTheme.mediumBCN.copyWith(color: '#666666'.toColor()),
              ),
              Spacing.h(16),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 220.h,
                        child: GestureDetector(
                          onTapDown: _onScreenTap,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: '#F5D7B8'.toColor(),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20.w),
                                    decoration: BoxDecoration(
                                      color: "#F38B3B".toColor().withValues(alpha: 0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.touch_app_rounded,
                                      size: 56.w,
                                      color: "#F38B3B".toColor(),
                                    ),
                                  ),
                                  Spacing.h(16),
                                  AutoTranslateText(
                                    'Tap Here',
                                    style: MyTextTheme.largeBCB.copyWith(
                                      color: '#3E2723'.toColor(),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  Spacing.h(8),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                      color: '#F5F5F5'.toColor(),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: AutoTranslateText(
                                      'Tap Count: ${tapCounts[currentTapIndex]}',
                                      style: MyTextTheme.mediumBCB.copyWith(
                                        color: '#3E2723'.toColor(),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacing.h(16),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildDotGrid()),
                            Spacing.w(12),
                            ElevatedButton(
                              onPressed: _confirmTap,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: tapCounts[currentTapIndex] > 0
                                    ? '#4CAF50'.toColor()
                                    : Colors.grey,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 14.h,
                                ),
                                elevation: 2,
                                shadowColor: Colors.black26,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: AutoTranslateText(
                                currentTapIndex < 15 ? 'Confirm' : 'Finish',
                                style: MyTextTheme.mediumBCB.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDotGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.h,
        childAspectRatio: 1,
      ),
      itemCount: 16,
      itemBuilder: (context, index) {
        final tapCount = tapCounts[index];
        final isCompleted = index < currentTapIndex;
        final isCurrent = index == currentTapIndex;

        return Container(
          decoration: BoxDecoration(
            color: isCurrent
                ? "#F38B3B".toColor().withOpacity(0.2)
                : isCompleted
                ? '#4CAF50'.toColor().withOpacity(0.2)
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
              color: isCurrent ? "#F38B3B".toColor() : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted || isCurrent
                ? Text(
                    '$tapCount',
                    style: MyTextTheme.smallBCB.copyWith(
                      color: '#3E2723'.toColor(),
                    ),
                  )
                : Text(
                    '${index + 1}',
                    style: MyTextTheme.smallBCN.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
