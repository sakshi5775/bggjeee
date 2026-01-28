


import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
 
import '../svg_assets.dart'; 

class StepperWidget extends StatelessWidget {
  final int activeStep;
  final void Function(int) onStepReached;
  final int stepperLength;
  final List<String> stepTitles;

  const StepperWidget({
    super.key,
    required this.activeStep,
    required this.onStepReached,
    required this.stepperLength,
    required this.stepTitles,
  });

  @override
  Widget build(BuildContext context) {
    return EasyStepper(
      activeStep: activeStep,
      activeStepBackgroundColor: AppColors.saffron,
      unreachedStepBackgroundColor: AppColors.saffron.withValues(alpha: 0.2),
      internalPadding: 30.h,
      showLoadingAnimation: false,
      stepRadius: 15.h,
      showStepBorder: false,
      enableStepTapping: false,
      steps: List.generate(stepperLength, (index) {
        final isCompleted = activeStep > index;
        return EasyStep(
          customStep: isCompleted
              ? SvgAssets(
            path: AppConstant.checkIcon,
            colorFilter: ColorFilter.mode(
                AppColors.success, BlendMode.srcIn),
          )
              : AutoTranslateText('${index + 1}', style: MyTextTheme.smallWCB.copyWith(
            color: Colors.white
          )),
          title: stepTitles[index],
          topTitle: index % 2 != 0,
        );
      }),
      onStepReached: onStepReached,
    );
  }
}
