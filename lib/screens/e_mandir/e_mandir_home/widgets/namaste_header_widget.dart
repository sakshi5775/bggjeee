import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/controller/namaste_home_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NamasteHeaderWidget extends GetView<NamasteHomeController> {
  const NamasteHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textColorMaroon),
          onPressed: () => Get.back(),
        ),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoTranslateText(
                'Namaste',
                style: AppTypography.h2.copyWith(
                  color: AppColors.textColorMaroon,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              AutoTranslateText(
                'Welcome to Divine Temple',
                style: AppTypography.body2.copyWith(color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        InkWell(
          onTap: controller.navigateToPunyaMudra,
          child: Container(
            height: 50.h,
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              color: Colors.white,
              border: Border.all(color: Colors.orange),
            ),
            // child: Row(
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.all(8.0.w),
            //       child: AutoTranslateText(
            //         '66',
            //         style: AppTypography.h3.copyWith(
            //           color: Colors.black,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //     ),
            //     Padding(
            //       padding: EdgeInsets.all(4.0.w),
            //       child: CircleAvatar(
            //         radius: 20.r,
            //         backgroundImage: const AssetImage(
            //           AppConstant.eMandirOmmIcon,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ),
        ),
      ],
    );
  }
}
