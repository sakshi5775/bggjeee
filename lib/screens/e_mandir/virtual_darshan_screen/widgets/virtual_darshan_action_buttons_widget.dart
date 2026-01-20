import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan_screen/controller/virtual_darshan_controller.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VirtualDarshanActionButtonsWidget extends StatelessWidget {
  const VirtualDarshanActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VirtualDarshanController>();

    return Stack(
      children: [
        /// FLOWER BUTTON (Aarti)
        Positioned(
          bottom: 90,
          left: 18,
          child: InkWell(
            onTap: controller.openOfferingBottomSheet,
            child: Image.asset(AppConstant.eMandirAartiIcon),
          ),
        ),

        /// LADDU BUTTON
        Positioned(
          bottom: 22,
          left: 18,
          child: Image.asset(AppConstant.eMandirLadduIcon),
        ),

        /// MUSIC BUTTON
        Positioned(
          bottom: 22,
          right: 18,
          child: InkWell(
            onTap: () => Get.toNamed(AppRoutes.devotionalLibrary),
            child: Image.asset(
              AppConstant.eMandirListenNowIcon,
              width: 50,
              height: 50,
            ),
          ),
        ),

        /// LISTEN NOW TEXT
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: AppPaddings.only(right: 6),
            child: Container(
              padding: AppPaddings.symmetric(h: 6, v: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: AppRadius.all(20),
              ),
              child: AutoTranslateText(
                "Listen Now",
                style: MyTextTheme.mediumBCN.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
