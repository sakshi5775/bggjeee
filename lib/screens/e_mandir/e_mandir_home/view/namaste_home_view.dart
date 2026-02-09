import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/controller/namaste_home_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/widgets/live_darshan_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/widgets/main_banner_widget.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/widgets/quick_actions_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/widgets/temple_highlights_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/widgets/todays_special_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NamasteHomeView extends StatefulWidget {
  final bool hideHeader;

  const NamasteHomeView({super.key, this.hideHeader = false});

  @override
  State<NamasteHomeView> createState() => _NamasteHomeViewState();
}

class _NamasteHomeViewState extends State<NamasteHomeView>
    with WidgetsBindingObserver {
  late NamasteHomeController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = Get.find<NamasteHomeController>();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      controller.stopShankh();
    } else if (state == AppLifecycleState.resumed) {
      // Check if this view is currently visible before resuming
      final route = ModalRoute.of(context);
      if (route != null && route.isCurrent) {
        controller.resumeAudioIfNeeded();
      }
    }
  }

  @override
  void deactivate() {
    // Stop sound when widget is deactivated (e.g. navigated away or removed from tree)
    controller.stopShankh();
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only resume audio when route is current (screen is visible)
    // This prevents multiple calls and works in both debug and release mode
    final route = ModalRoute.of(context);
    if (route != null && route.isCurrent) {
      // Small delay to ensure route is fully active
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && route.isCurrent) {
          controller.resumeAudioIfNeeded();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          top: !widget.hideHeader,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.hideHeader) ...[
                    const CommonHeader(title: 'E-Mandir', showDrawer: false),
                    SizedBox(height: 10.h),
                  ],
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
      ),
    );
  }
}
