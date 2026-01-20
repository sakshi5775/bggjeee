import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/e_mandir/namaste_home_screen/controller/namaste_home_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/namaste_home_screen/widgets/live_darshan_section_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/namaste_home_screen/widgets/main_banner_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/namaste_home_screen/widgets/namaste_header_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/namaste_home_screen/widgets/quick_actions_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/namaste_home_screen/widgets/temple_list_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/namaste_home_screen/widgets/todays_special_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class NamasteHomeView extends BasePage<NamasteHomeController> {
  const NamasteHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const NamasteHeaderWidget(),
                  const SizedBox(height: 10),

                  /// MAIN BANNER
                  const MainBannerWidget(),
                  const SizedBox(height: 15),

                  AutoTranslateText(
                    "Quick Actions",
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: const Color(0xFF3E2723),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const QuickActionsWidget(),
                  const SizedBox(height: 15),

                  const LiveDarshanSectionWidget(),
                  const SizedBox(height: 15),

                  AutoTranslateText(
                    "Today's Special",
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: const Color(0xFF3E2723),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const TodaysSpecialWidget(),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoTranslateText(
                        "Temple Highlights",
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: const Color(0xFF3E2723),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            AutoTranslateText(
                              "View All",
                              style: MyTextTheme.mediumBCN.copyWith(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.orange,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const TempleListWidget(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
