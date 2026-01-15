import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/planets_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/planets_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PlanetsView extends BasePage<PlanetsController> {
  const PlanetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xFFFFF6C2),
          Color(0xFFFFF9E5)
        ])
      ),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              // Content
              Expanded(
                child: Obx(() {
                  if (controller.isLoadingPlanetDetails.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: '#FF6B35'.toColor(),
                          ),
                          Spacing.h(16),
                          AutoTranslateText(
                            'Loading planet details...',
                            style: MyTextTheme.mediumBCN.copyWith(
                              color: '#3E2723'.toColor().withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  if (controller.planetDetailsData.value == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64.w,
                            color: Colors.red.withOpacity(0.7),
                          ),
                          Spacing.h(16),
                          AutoTranslateText(
                            'No data available',
                            style: MyTextTheme.mediumBCN.copyWith(
                              color: '#3E2723'.toColor().withOpacity(0.7),
                            ),
                          ),
                          Spacing.h(16),
                          ElevatedButton(
                            onPressed: () => controller.fetchPlanetDetails(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: "#ed6f30".toColor(),
                              foregroundColor: Colors.white,
                            ),
                            child: AutoTranslateText('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return PlanetsWidget(controller: controller);
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
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            '#3D0C11'.toColor(),
            '#5D1C21'.toColor(),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24)
        )
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFFE3B341), size: 24.w),
            onPressed: () => Get.back(),
          ),
          
          Spacing.w(8),
          
          // Title
          Expanded(
            child: AutoTranslateText(
              'Planets',
              style: MyTextTheme.largeBCB.copyWith(
                color: Color(0xFFE3B341),
                fontWeight: FontWeight.bold,
              ).merge(AppTypography.h2),
            ),
          ),
        ],
      ),
    );
  }
}










