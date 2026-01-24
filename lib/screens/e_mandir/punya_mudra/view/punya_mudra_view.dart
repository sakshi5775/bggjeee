import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/controller/punya_mudra_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/punya_mudra_header_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/punya_mudra_tabs_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/punya_mudra_tab_content_widget.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';

class PunyaMudraView extends GetView<PunyaMudraController> {
  const PunyaMudraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3DC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PunyaMudraHeaderWidget(),
              const SizedBox(height: 12),
              Center(
                child: Image.asset(AppConstant.eMandirRemMandir),
              ),
              const SizedBox(height: 16),
              const PunyaMudraTabsWidget(),
              Obx(() => PunyaMudraTabContentWidget(
                    selectedTab: controller.selectedTab.value,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
