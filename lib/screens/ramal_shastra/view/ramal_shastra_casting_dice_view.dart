import 'dart:math';
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

class RamalShastraCastingDiceView extends StatefulWidget {
  const RamalShastraCastingDiceView({Key? key}) : super(key: key);

  @override
  State<RamalShastraCastingDiceView> createState() => _RamalShastraCastingDiceViewState();
}

class _RamalShastraCastingDiceViewState extends State<RamalShastraCastingDiceView> {
  final RamalShastraController controller = Get.find<RamalShastraController>();
  final List<int> allDiceValues = [];
  final List<int> currentRoundValues = [0, 0, 0, 0];
  int currentRound = 0;
  bool isRolling = false;

  @override
  void initState() {
    super.initState();
    allDiceValues.clear();
    currentRound = 0;
    for (int i = 0; i < 4; i++) {
      currentRoundValues[i] = 0;
    }
  }

  void _rollDice() {
    if (isRolling) return;
    
    setState(() {
      isRolling = true;
    });

    // Animate dice rolling
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        for (int i = 0; i < 4; i++) {
          currentRoundValues[i] = Random().nextInt(6) + 1; // 1-6
        }
        isRolling = false;
      });
    });
  }

  void _confirmRound() {
    if (currentRoundValues.any((v) => v == 0)) {
      Get.snackbar(
        'Error',
        'Please roll the dice first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    allDiceValues.addAll(currentRoundValues);
    
    if (currentRound < 3) {
      setState(() {
        currentRound++;
        for (int i = 0; i < 4; i++) {
          currentRoundValues[i] = 0;
        }
      });
    } else {
      // All 16 values collected (4 rounds × 4 dice)
      controller.generatePointsFromDice(allDiceValues);
      Get.toNamed(AppRoutes.ramalShastraConfirmation);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                'Roll the Dice',
                style: MyTextTheme.veryLargeBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ).merge(AppTypography.h1),
              ),
              Spacing.h(8),
              AutoTranslateText(
                'Round ${currentRound + 1} of 4',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: '#666666'.toColor(),
                ),
              ),
              Spacing.h(32),
              // Dice Grid
              _buildDiceGrid(),
              Spacing.h(32),
              // Roll Button
              if (currentRoundValues.any((v) => v == 0))
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ElevatedButton(
                    onPressed: _rollDice,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: AutoTranslateText(
                      isRolling ? 'Rolling...' : 'Roll Dice',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: _confirmRound,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: '#4CAF50'.toColor(),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: AutoTranslateText(
                    currentRound < 3 ? 'Confirm & Next Round' : 'Confirm & Proceed',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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

  Widget _buildDiceGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) {
          return _buildDice(currentRoundValues[index], index);
        }),
      ),
    );
  }

  Widget _buildDice(int value, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: 70.w,
      height: 70.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: value > 0 ? "#F38B3B".toColor() : '#F5D7B8'.toColor(),
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
      child: Center(
        child: value > 0
            ? Text(
                '$value',
                style: MyTextTheme.largeBCB.copyWith(
                  color: "#F38B3B".toColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 28.sp,
                ),
              )
            : Icon(
                Icons.casino,
                color: '#F5D7B8'.toColor(),
                size: 32.w,
              ),
      ),
    );
  }
}


