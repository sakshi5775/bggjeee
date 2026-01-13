import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/Material.dart';
import 'package:get/get.dart';
import '../core/value/dimension.dart'; 

class ProgressDialogue {
  show({String? loadingText}) async {
    showProgressDialogue(loadingText);
  }

  hide() async {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }
}

showProgressDialogue(loadingText) async {
  return Get.dialog(
    PopScope(
      canPop: true,

      child: Container(
        color: Colors.black45,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: AppPaddings.all(8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Card(
                  //   shape: const CircleBorder(),
                  //   elevation: 10,
                  //   color: Colors.white,
                  //   child: SizedBox(
                  //     width: 40.h,
                  //     height: 40.h,
                  //   ),
                  // ),
                  // Lottie.asset(AppConstant.loading, height: 60.h),
                  // SvgAssets(
                  //   path: Constant.closeIcon,
                  //   height: 60.h,
                  //   width: 60.w,
                  //   colorFilter: ColorFilter.mode(
                  //     Colors.white,
                  //     BlendMode.srcIn,
                  //   ),
                  // ),
                  CircularProgressIndicator()
                ],
              ),
            ),
            Spacing.h(10),
            AutoTranslateText(
              'Loading...',

              style: MyTextTheme.largeWCB.copyWith(
                decoration: TextDecoration.none,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            // DefaultTextStyle(
            //   style: MyTextTheme.largeWCB.copyWith(
            //     color: Colors.white,
            //     fontWeight: FontWeight.bold,
            //   ),
            //   child: AnimatedTextKit(
            //     isRepeatingAnimation: true,

            //     animatedTexts: [
            //       WavyAnimatedText(
            //         'Loading...',
            //         textStyle: MyTextTheme.largeWCB.copyWith(
            //           color: Colors.white,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    ),
  );
}
