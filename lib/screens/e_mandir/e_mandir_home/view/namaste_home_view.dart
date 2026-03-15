import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/controller/namaste_home_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/widgets/festival_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/widgets/main_banner_widget.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/widgets/quick_actions_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NamasteHomeView extends StatefulWidget {
  final bool hideHeader;
  final bool showBackButton;

  const NamasteHomeView({
    super.key,
    this.hideHeader = false,
    this.showBackButton = true,
  });

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
    }
  }

  @override
  void deactivate() {
    // Stop sound when widget is deactivated (e.g. navigated away or removed from tree)
    controller.stopShankh();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: SafeArea(
          top: !widget.hideHeader,
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: widget.hideHeader ? 0 : 10.h,
                bottom: 20.h + 70.h + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.hideHeader) ...[
                    CommonHeader(
                      title: 'Digital Mandir',
                      showDrawer: false,
                      showBackButton: widget.showBackButton,
                    ),
                    SizedBox(height: 10.h),
                  ],
                  const MainBannerWidget(),
                  SizedBox(height: 15.h),
                  const QuickActionsWidget(),
                  SizedBox(height: 15.h),
                  const FestivalWidget(),
                  SizedBox(height: 20.h),
                  // const LiveDarshanWidget(),
                  // SizedBox(height: 15.h),
                  // AutoTranslateText(
                  //   "Today's Special",
                  //   style: AppTypography.h3.copyWith(
                  //     color: AppColors.textColorMaroon,
                  //   ),
                  // ),
                  // SizedBox(height: 12.h),
                  // const TodaysSpecialWidget(),
                  // SizedBox(height: 24.h),
                  // const TempleHighlightsWidget(),
                  // SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
