import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kp_system_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/kp_system_table_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/kp_chart_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/kp_rasi_chart_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/kp_planets_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/kp_cusps_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/kp_planet_signification_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/kp_house_significators_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/kp_planet_signification_level_wise_widget.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/kp_coming_soon_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class KpSystemView extends BasePage<KpSystemController> {
  const KpSystemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: '#FFF8E1'.toColor(),

    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFFFF6C2), Color(0xFFFFE8A3), Color(0xFFFFD580) ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        ),
        
      ),
      child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              // Tabs (always visible when not in table view)
              Obx(() {
                if (controller.selectedTabIndex.value == -1) {
                  return SizedBox.shrink();
                }
                return _buildTabs();
              }),
              
              // Content
              Expanded(
                child: Obx(() {
                  // Show table view if selectedTabIndex is -1
                  if (controller.selectedTabIndex.value == -1) {
                    return KpSystemTableWidget(controller: controller);
                  }
                  // Otherwise show swipeable PageView for tabs
                  return PageView(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    children: [
                      KpChartWidget(controller: controller),
                      KpRasiChartWidget(controller: controller),
                      KpPlanetsWidget(controller: controller),
                      KpCuspsWidget(controller: controller),
                      KpPlanetSignificationWidget(controller: controller),
                      KpHouseSignificatorsWidget(controller: controller),
                      KpPlanetSignificationLevelWiseWidget(controller: controller),
                      KpComingSoonWidget(title: 'Nakshatra Nadi'),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
    ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3D0C11), Color(0xFF5D1C21)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFFF7C443), size: 24.w),
            onPressed: () => Get.back(),
          ),
          
          Spacing.w(8),
          
          // Title
          Expanded(
            child: AutoTranslateText(
              'KP System',
              style: MyTextTheme.largeBCB.copyWith(
                color: Color(0xFFF7C443),
                fontWeight: FontWeight.bold,
              ).merge(AppTypography.h2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTab('KP CHART', 0),
            _buildTab('RASI CHART', 1),
            _buildTab('PLANETS', 2),
            _buildTab('CUSPS', 3),
            _buildTab('PLANET SIGNIFICATION', 4),
            _buildTab('HOUSE SIGNIFICATORS', 5),
            _buildTab('PLANET SIGNIFICATION(VIEW2)', 6),
            _buildTab('NAKSHATRA NADI', 7),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    return Obx(() {
      final isSelected = controller.selectedTabIndex.value == index;
      
      return GestureDetector(
        onTap: () {
          controller.onTabSelected(index);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected ? '#FF6B35'.toColor().withOpacity(0.1) : Colors.transparent,
            
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected ? '#FF6B35'.toColor() : Colors.transparent,
                width: 3,
              ),
            ),
            
          ),
          child: AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB.copyWith(
                      color: isSelected ? '#FF6B35'.toColor() : '#3E2723'.toColor().withOpacity(0.6),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ).merge(AppTypography.body2),
          ),
        ),
      );
    });
  }
}

