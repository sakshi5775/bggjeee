import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/controller/punya_mudra_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/bhakti_chakra_section_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/earn_punya_section_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/passbook_section_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/punya_mudra_header_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/punya_mudra_tab_bar_widget.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PunyaMudraView extends BasePage<PunyaMudraController> {
  const PunyaMudraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PunyaMudraHeaderWidget(),
                Spacing.h(12),
                Center(child: Image.asset(AppConstant.eMandirRemMandir)),
                Spacing.h(16),
                const PunyaMudraTabBarWidget(),
                Obx(() {
                  if (controller.selectedTab.value == 0) {
                    return const EarnPunyaSectionWidget();
                  } else if (controller.selectedTab.value == 1) {
                    return const BhaktiChakraSectionWidget();
                  } else {
                    return const PassbookSectionWidget();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
