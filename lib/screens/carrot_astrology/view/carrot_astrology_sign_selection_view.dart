import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/carrot_astrology/utils/carrot_astrology_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/widgets/zodiac_sign_selection_grid.dart';

class CarrotAstrologySignSelectionView extends StatelessWidget {
  const CarrotAstrologySignSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: UserDashboardView.buildDrawer(context),
        body: Column(
          children: [
            const CommonHeader(title: 'Carrot Astrology'),
            // Zodiac signs grid
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 16.h),
                child: ZodiacSignSelectionGrid(
                  cardBorderColor: CarrotAstrologyColors.orangeColor,
                  onSignSelected: (name) {
                    // Navigate to carrot astrology results with selected sign
                    UserMainController.pushInCurrentTab(
                      AppRoutes.carrotAstrologyResults,
                      arguments: {'selectedSign': name},
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
