import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/controller/ramal_shastra_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RamalShastraCastingDotsView extends StatefulWidget {
  const RamalShastraCastingDotsView({Key? key}) : super(key: key);

  @override
  State<RamalShastraCastingDotsView> createState() => _RamalShastraCastingDotsViewState();
}

class _RamalShastraCastingDotsViewState extends State<RamalShastraCastingDotsView> {
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
      Get.toNamed(AppRoutes.ramalShastraConfirmation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Spacing.h(24),
            AutoTranslateText(
              'Tap Randomly on Screen',
              style: MyTextTheme.veryLargeBCB.copyWith(
                color: '#3E2723'.toColor(),
                fontWeight: FontWeight.bold,
              ).merge(AppTypography.h1),
            ),
            Spacing.h(8),
            AutoTranslateText(
              'Tap ${currentTapIndex + 1} of 16',
              style: MyTextTheme.mediumBCN.copyWith(
                color: '#666666'.toColor(),
              ),
            ),
            Spacing.h(32),
            Expanded(
              child: GestureDetector(
                onTapDown: _onScreenTap,
                child: Container(
                  margin: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: '#F5D7B8'.toColor(),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.brightness_1,
                          size: 80.w,
                          color: "#F38B3B".toColor(),
                        ),
                        Spacing.h(16),
                        AutoTranslateText(
                          'Tap Here',
                          style: MyTextTheme.largeBCB.copyWith(
                            color: '#3E2723'.toColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacing.h(8),
                        AutoTranslateText(
                          'Tap Count: ${tapCounts[currentTapIndex]}',
                          style: MyTextTheme.mediumBCN.copyWith(
                            color: '#666666'.toColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: _buildDotGrid(),
                  ),
                  Spacing.w(16),
                  ElevatedButton(
                    onPressed: _confirmTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tapCounts[currentTapIndex] > 0 
                          ? '#4CAF50'.toColor() 
                          : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
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
            Spacing.h(16),
          ],
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
              color: isCurrent 
                  ? "#F38B3B".toColor()
                  : Colors.transparent,
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


