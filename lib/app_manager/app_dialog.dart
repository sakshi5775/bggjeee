
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../core/value/dimension.dart';
class AppDialog{

  static void appDialog(context , {
    String ? title,
    String ?subtitle,
   required String confirmButtonText,
  required void Function() onPress,
    Widget ? content,



  }) {
    showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Colors.white,
        insetPadding: AppPaddings.all(12),

        title: subtitle!=null?Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            AutoTranslateText(title.toString(),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            AutoTranslateText(subtitle.toString(),
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ): AutoTranslateText(title.toString(),
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
              style: TextButton.styleFrom(
                side: BorderSide(color: Colors.black),
              ),
              onPressed: () {
                Get.back();
              },
              child: AutoTranslateText(
                'Cancel',
                style: MyTextTheme.mediumBCN,
              )),
          TextButton(
              style: TextButton.styleFrom(
                  backgroundColor:AppColors.saffron
              ),
              onPressed: () {
               onPress();
              },
              child: AutoTranslateText(
                 confirmButtonText,
                style: MyTextTheme.mediumWCB.copyWith(
                  color: Colors.white
                ),
              )),
        ],
        content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: content ?? Container()),
      );
    });








  }





  static void deleteDialog(
      context, {
        final String? buttonText,
        final String? title,
        final String? subTitle,
        final String? imagePath,
        final TextStyle ?titleStyle,
        required final VoidCallback onPress,
        final bool ? showButtonInRow =false,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset(AppConstant.closeIcon))),
          iconColor: Colors.black,
          insetPadding: EdgeInsets.all(5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 15,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SvgPicture.asset(
                      height: 150.h,
                      imagePath??AppConstant.deleteImage
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),

                AutoTranslateText(
                  title?? 'Are you sure want to delete ?',
                  style:titleStyle?? MyTextTheme.veryLargeBCB,
                ),
                SizedBox(
                  height: 5.h,
                ),
                AutoTranslateText(
                  subTitle?? '',
                  style:titleStyle?? MyTextTheme.mediumBCB,
                ),
                if(showButtonInRow == false) ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.saffron,
                    fixedSize: Size(MediaQuery
                        .sizeOf(context)
                        .width, 40.h),
                  ),
                  onPressed: () {
                    onPress();
                  },
                  child: AutoTranslateText(buttonText ?? 'Delete',
                      style: AppTypography.h3.copyWith(color: Colors.white)),
                ),

                if(showButtonInRow == false) ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery
                          .sizeOf(context)
                          .width, 40.h),
                      backgroundColor: AppColors.saffron.withValues(alpha: 0.3)
                  ),
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  child: const AutoTranslateText('Cancel'),
                ),

                if(showButtonInRow == true) Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  AppColors.saffron,
                          fixedSize: Size(MediaQuery
                              .sizeOf(context)
                              .width, 40.h),
                        ),
                        onPressed: () {
                          onPress();
                        },
                        child: AutoTranslateText(buttonText ?? 'Delete',
                            style:MyTextTheme.mediumBCB.copyWith(
                              color: Colors.white
                            )),
                      ),
                    ),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(MediaQuery
                                .sizeOf(context)
                                .width, 40.h),
                            backgroundColor: AppColors.saffron.withValues(alpha: 0.3)),
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
                        },
                        child: AutoTranslateText('Cancel', style: AppTypography.body1),
                      ),
                    ),
                  ],
                )


              ],
            ),
          ),
        );
      },
    );
  }




}
