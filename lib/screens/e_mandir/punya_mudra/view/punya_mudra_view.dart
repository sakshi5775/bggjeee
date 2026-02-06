import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/controller/punya_mudra_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/punya_mudra_tabs_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/punya_mudra_tab_content_widget.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';

class PunyaMudraView extends GetView<PunyaMudraController> {
  const PunyaMudraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            CommonHeader(
              title: "Punya Mudras",
              subtitle: AutoTranslateText(
                "User id : 85910542",
                style: AppTypography.body1.copyWith(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              customActions: [_pointsWidget()],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Center(child: Image.asset(AppConstant.eMandirRemMandir)),
                    const SizedBox(height: 16),
                    const PunyaMudraTabsWidget(),
                    Obx(
                      () => PunyaMudraTabContentWidget(
                        selectedTab: controller.selectedTab.value,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pointsWidget() {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        border: Border.all(color: Colors.orange),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: const Text(
              "66",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const CircleAvatar(
            radius: 14,
            backgroundImage: AssetImage(AppConstant.eMandirOmmIcon),
          ),
        ],
      ),
    );
  }
}
