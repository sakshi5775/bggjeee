import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

import 'package:astrobharataiuser/widgets/zodiac_sign_selection_grid.dart';

class HoroscopeSignSelectionView extends StatelessWidget {
  const HoroscopeSignSelectionView({super.key});

  // Zodiac signs with their image paths (kept for compatibility with HoroscopeTabWidget)
  static const List<Map<String, String>> zodiacSigns =
      ZodiacSignSelectionGrid.zodiacSigns;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // drawer: UserDashboardView.buildDrawer(context),
        body: Column(
          children: [
            const CommonHeader(title: 'Daily Horoscope', showEndDrawer: false),
            // Zodiac signs grid
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 16.h),
                child: ZodiacSignSelectionGrid(
                  onSignSelected: (name) {
                    // Get form data from arguments if available
                    final arguments = Get.arguments as Map<String, dynamic>?;
                    final formData =
                        arguments?['formData'] as Map<String, dynamic>?;

                    // Navigate to main horoscope page with selected sign and form data
                    UserMainController.pushInCurrentTab(
                      AppRoutes.horoscopeMain,
                      arguments: {
                        'selectedSign': name,
                        if (formData != null) 'formData': formData,
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
