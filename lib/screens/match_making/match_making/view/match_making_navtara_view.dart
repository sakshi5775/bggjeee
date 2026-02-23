import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/navtara/controller/navtara_controller.dart';
import 'package:astrobharataiuser/screens/navtara/widgets/navtara_analyze_tab.dart';
import 'package:astrobharataiuser/screens/navtara/widgets/navtara_history_tab.dart';
import 'package:astrobharataiuser/screens/navtara/widgets/navtara_timing_tab.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MatchMakingNavtaraView extends StatefulWidget {
  const MatchMakingNavtaraView({super.key});

  @override
  State<MatchMakingNavtaraView> createState() => _MatchMakingNavtaraViewState();
}

class _MatchMakingNavtaraViewState extends State<MatchMakingNavtaraView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NavtaraController controller = Get.find<NavtaraController>();

  final List<String> _tabs = ['Analyze', 'Timing', 'History'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    // Ensure history is fetched when entering
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.history.isEmpty) {
        controller.fetchHistory();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            CommonHeader(title: 'Navtara Analysis'),
            SizedBox(height: 12.h),
            _buildTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics:
                    const NeverScrollableScrollPhysics(), // Prevent swipe to avoid conflict
                children: [
                  NavtaraAnalyzeTab(controller: controller),
                  NavtaraTimingTab(controller: controller),
                  NavtaraHistoryTab(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.deepOrange,
          borderRadius: BorderRadius.circular(25.r),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF6F221E),
        labelStyle: MyTextTheme.mediumBCB.copyWith(fontSize: 12.sp),
        unselectedLabelStyle: MyTextTheme.mediumBCN.copyWith(fontSize: 12.sp),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        padding: EdgeInsets.all(4.w),
        tabs: _tabs.map((tab) => Tab(child: AutoTranslateText(tab))).toList(),
      ),
    );
  }
}
