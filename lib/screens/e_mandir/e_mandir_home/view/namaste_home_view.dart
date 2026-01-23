import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/controller/namaste_home_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/widgets/live_darshan_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/widgets/main_banner_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/widgets/namaste_header_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/widgets/quick_actions_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/widgets/temple_highlights_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/widgets/todays_special_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NamasteHomeView extends GetView<NamasteHomeController> {
  const NamasteHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const NamasteHeaderWidget(),
                SizedBox(height: 10.h),
                const MainBannerWidget(),
                SizedBox(height: 15.h),
                const QuickActionsWidget(),
                SizedBox(height: 15.h),
                const LiveDarshanWidget(),
                SizedBox(height: 15.h),
                AutoTranslateText(
                  "Today's Special",
                  style: AppTypography.h3.copyWith(
                    color: AppColors.textColorMaroon,
                  ),
                ),
                SizedBox(height: 12.h),
                const TodaysSpecialWidget(),
                SizedBox(height: 24.h),
                const TempleHighlightsWidget(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
