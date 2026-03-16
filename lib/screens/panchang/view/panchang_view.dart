import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/panchang_controller.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/celestial_info_card_widget.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/celestial_time_card_widget.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/panchang_tool_button_widget.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/home_tab_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class PanchangView extends BasePage<PanchangController> {
  final bool hideHeader;

  const PanchangView({super.key, this.hideHeader = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: hideHeader ? null : AppColors.gradientBackground,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            if (!hideHeader) const CommonHeader(title: 'Panchang'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (hideHeader)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: const HomeTabBanner(category: 'general'),
                      ),
                    Spacing.h(hideHeader ? 12 : 20),
                    // Celestial Times Section
                    _buildCelestialTimesSection(),

                    Spacing.h(15.33),

                    // Panchang Tools Section
                    _buildPanchangToolsSection(),

                    // Bottom spacing
                    Spacing.h(hideHeader ? 80 : 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCelestialTimesSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Container(
        padding: EdgeInsets.only(
          top: 20.12.h,
          left: 20.12.w,
          right: 20.12.w,
          bottom: 0.96.h,
        ),
        decoration: BoxDecoration(
          color: "#FFFFFF".toColor(),
          borderRadius: BorderRadius.circular(15.33.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            AutoTranslateText(
              'Celestial Times',
              style: MyTextTheme.mediumBCB.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: "#6B1B1A".toColor(),
              ),
            ),
            Spacing.h(15.33),

            // 2x2 Grid of Time Cards
            Row(
              spacing: 10.w,
              children: [
                Expanded(
                  child: CelestialTimeCardWidget(
                    iconPath: AppConstant.sunriseIcon,
                    label: 'Sunrise',
                    time: controller.sunriseTime,
                    iconColor: Colors.white,
                  ),
                ),

                Expanded(
                  child: CelestialTimeCardWidget(
                    iconPath: AppConstant.sunsetIcon,
                    label: 'Sunset',
                    time: controller.sunsetTime,
                    iconColor: Colors.white,
                  ),
                ),
              ],
            ),
            Spacing.h(10),
            Row(
              spacing: 10.w,
              children: [
                Expanded(
                  child: CelestialTimeCardWidget(
                    iconPath: AppConstant.moonriseIcon,
                    label: 'Moonrise',
                    time: controller.moonriseTime,
                    iconColor: Colors.white,
                  ),
                ),

                Expanded(
                  child: CelestialTimeCardWidget(
                    iconPath: AppConstant.moonsetIcon,
                    label: 'Moonset',
                    time: controller.moonsetTime,
                    iconColor: Colors.white,
                  ),
                ),
              ],
            ),

            // Row(
            //   children: [
            //     Expanded(
            //       child: Column(
            //         children: [
            //           CelestialTimeCardWidget(
            //             iconPath: AppConstant.sunriseIcon,
            //             label: 'Sunrise',
            //             time: controller.sunriseTime,
            //             iconColor: Colors.white,
            //           ),
            //           Spacing.h(11.5),
            //           CelestialTimeCardWidget(
            //             iconPath: AppConstant.moonriseIcon,
            //             label: 'Moonrise',
            //             time: controller.moonriseTime,
            //             iconColor: Colors.white,
            //           ),
            //         ],
            //       ),
            //     ),
            //     Spacing.w(11.5),
            //     Expanded(
            //       child: Column(
            //         children: [
            //           CelestialTimeCardWidget(
            //             iconPath: AppConstant.sunsetIcon,
            //             label: 'Sunset',
            //             time: controller.sunsetTime,
            //             iconColor: Colors.white,
            //           ),
            //           Spacing.h(11.5),
            //           CelestialTimeCardWidget(
            //             iconPath: AppConstant.moonsetIcon,
            //             label: 'Moonset',
            //             time: controller.moonsetTime,
            //             iconColor: Colors.white,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            Spacing.h(11.5),

            // Solar Noon and Moon Phase Cards
            Obx(
              () => CelestialInfoCardWidget(
                iconPath: AppConstant.solarNoonIcon,
                label: 'Solar Noon',
                value: controller.solarNoonTime.value.isNotEmpty
                    ? controller.solarNoonTime.value
                    : '--:-- --',
                iconBgColor: "#FFA602".toColor().withValues(alpha: 0.2),
              ),
            ),
            Spacing.h(11.5),
            GestureDetector(
              onTap: () => _showMoonPhasePopup(),
              child: Obx(
                () => CelestialInfoCardWidget(
                  iconPath: AppConstant.moonPhaseIcon,
                  label: 'Moon Phase',
                  value:
                      controller.moonPhaseData.value?['state']?.toString() ??
                      'Waning Crescent',
                  iconBgColor: "#7F00BB".toColor().withValues(alpha: 0.2),
                ),
              ),
            ),
            Spacing.h(10),
          ],
        ),
      ),
    );
  }

  Widget _buildPanchangToolsSection() {
    return Padding(
      padding: AppPaddings.symmetric(h: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: AutoTranslateText(
              'Panchang Tools',
              style: MyTextTheme.largeBCB.copyWith(
                fontWeight: FontWeight.w500,
                color: "#4C2B2A".toColor(),
              ),
            ),
          ),

          // Grid of Tool Buttons
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 600 ? 4 : 3;
              final spacing = 11.5.w;
              final runSpacing = 11.5.h;

              return GridView.builder(
                shrinkWrap: true,
                padding: AppPaddings.symmetric(h: 10, v: 15),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: runSpacing,
                  childAspectRatio: 0.85,
                ),
                itemCount: controller.panchangFeatures.length,
                itemBuilder: (context, index) {
                  final feature = controller.panchangFeatures[index];
                  return _buildToolButton(feature);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(Map<String, dynamic> feature) {
    final title = feature['title'] as String;
    String iconPath;

    // Check if title starts with "Festival" (dynamic year)
    if (title.startsWith('Festival ')) {
      iconPath = AppConstant.festivalIcon;
    } else {
      // Map feature titles to icon paths
      switch (title) {
        case 'Daily Panchang':
          iconPath = AppConstant.dailyPanchangIcon;
          break;
        case 'Monthly Calendar':
          iconPath = AppConstant.monthlyCalendarIcon;
          break;
        case 'Hindu Calendar':
          iconPath = AppConstant.hinduCalendarIcon;
          break;
        case 'Yearly Vrat':
          iconPath = AppConstant.yearlyVratIcon;
          break;
        case 'Hora':
          iconPath = AppConstant.horaIcon;
          break;
        case 'Chogadia':
          iconPath = AppConstant.chogadiaIcon;
          break;
        // case 'Do Ghati':
        //   iconPath = AppConstant.doGhatiIcon;
        //   break;
        case 'Rahu Kaal':
          iconPath = AppConstant.rahuKaalIcon;
          break;
        case 'Other Calendars':
          iconPath = AppConstant.otherCalendarsIcon;
          break;
        // case 'Panchak':
        //   iconPath = AppConstant.panchakIcon;
        //   break;
        case 'Bhadra':
          iconPath = AppConstant.bhadraIcon;
          break;
        case 'Muhurat':
          iconPath = AppConstant.muhuratIcon;
          break;
        // case 'Lagna Table':
        //   iconPath = AppConstant.lagnaTableIcon;
        //   break;
        default:
          iconPath = AppConstant.servicePanchang;
      }
    }

    return PanchangToolButtonWidget(
      iconPath: iconPath,
      title: title,
      onTap: () => controller.onFeatureTap(feature),
    );
  }

  void _showMoonPhasePopup() {
    final moonPhase = controller.moonPhaseData.value;
    if (moonPhase == null) {
      Get.snackbar(
        'No Data',
        'Moon phase data is not available',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final botResponse =
        moonPhase['bot_respone']?.toString() ?? 'No information available';
    final state = moonPhase['state']?.toString() ?? '';
    final paksha = moonPhase['paksha']?.toString() ?? '';
    final luminance = moonPhase['luminance']?.toString() ?? '';
    final phase = moonPhase['phase']?.toString() ?? '';

    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.nightlight_round,
              color: "#E3B341".toColor(),
              size: 24.w,
            ),
            Spacing.w(8),
            Expanded(
              child: AutoTranslateText(
                'Moon Phase',
                style: MyTextTheme.largeBCB.copyWith(
                  color: "#8B1925".toColor(),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.isNotEmpty) ...[
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: "#E3B341".toColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: "#E3B341".toColor(),
                        size: 20.w,
                      ),
                      Spacing.w(8),
                      Expanded(
                        child: AutoTranslateText(
                          state,
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: "#8B1925".toColor(),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacing.h(12),
              ],
              if (paksha.isNotEmpty) ...[
                Row(
                  children: [
                    AutoTranslateText(
                      'Paksha: ',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: "#8B1925".toColor().withValues(alpha: 0.7),
                        fontSize: 14.sp,
                      ),
                    ),
                    AutoTranslateText(
                      paksha,
                      style: MyTextTheme.smallBCB.copyWith(
                        color: "#8B1925".toColor(),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacing.h(8),
              ],
              if (luminance.isNotEmpty) ...[
                Row(
                  children: [
                    AutoTranslateText(
                      'Luminance: ',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: "#8B1925".toColor().withValues(alpha: 0.7),
                        fontSize: 14.sp,
                      ),
                    ),
                    AutoTranslateText(
                      luminance,
                      style: MyTextTheme.smallBCB.copyWith(
                        color: "#8B1925".toColor(),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacing.h(8),
              ],
              if (phase.isNotEmpty) ...[
                Row(
                  children: [
                    AutoTranslateText(
                      'Phase: ',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: "#8B1925".toColor().withValues(alpha: 0.7),
                        fontSize: 14.sp,
                      ),
                    ),
                    AutoTranslateText(
                      phase,
                      style: MyTextTheme.smallBCB.copyWith(
                        color: "#8B1925".toColor(),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacing.h(16),
              ],
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: "#8B1925".toColor().withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  botResponse,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: "#8B1925".toColor(),
                    fontSize: 14.sp,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: AutoTranslateText(
              'Close',
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#E3B341".toColor(),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
