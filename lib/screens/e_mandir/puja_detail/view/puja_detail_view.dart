import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_detail/controller/puja_detail_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_detail/widgets/puja_media_card_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_detail/widgets/puja_info_cards_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_detail/widgets/puja_about_section_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_detail/widgets/puja_temple_section_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_detail/widgets/puja_benefits_section_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_detail/widgets/puja_process_steps_section_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_detail/widgets/puja_bottom_action_bar_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PujaDetailView extends BasePage<PujaDetailController> {
  const PujaDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() {
          if (controller.isLoading.value && controller.puja.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.value.isNotEmpty &&
              controller.puja.value == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoTranslateText(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.loadPujaDetail(),
                    child: const AutoTranslateText('Retry'),
                  ),
                ],
              ),
            );
          }

          if (controller.puja.value == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AutoTranslateText(
                    'Puja not found',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const AutoTranslateText('Go Back'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              CommonHeader(title: 'Puja Details'),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const PujaDetailHeaderWidget(), // Removed as replaced by CommonHeader
                      const SizedBox(height: 16),
                      const PujaMediaCardWidget(),
                      const SizedBox(height: 16),
                      const PujaInfoCardsWidget(),
                      const SizedBox(height: 24),
                      const PujaAboutSectionWidget(),
                      const SizedBox(height: 24),
                      const PujaTempleSectionWidget(),
                      const SizedBox(height: 24),
                      const PujaBenefitsSectionWidget(),
                      const SizedBox(height: 24),
                      const PujaProcessStepsSectionWidget(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              const PujaBottomActionBarWidget(),
            ],
          );
        }),
      ),
    );
  }
}
