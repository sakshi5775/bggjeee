import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/vastu/controller/vastu_reading_controller.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/compass_dial.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/direction_overlay.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/calibration_hint.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/camera_compass_overlay.dart';

class VastuReadingView extends StatefulWidget {
  const VastuReadingView({Key? key}) : super(key: key);

  @override
  State<VastuReadingView> createState() => _VastuReadingViewState();
}

class _VastuReadingViewState extends State<VastuReadingView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final controller = Get.find<VastuReadingController>(tag: 'vastu_compass');
    controller.pauseSensors();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = Get.find<VastuReadingController>(tag: 'vastu_compass');
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      controller.pauseSensors();
    } else if (state == AppLifecycleState.resumed) {
      controller.resumeSensors();
    }
  }

  @override
  Widget build(BuildContext context) {
    // CRITICAL: Always ensure controller exists BEFORE GetBuilder tries to access it
    VastuReadingController controllerRef;
    if (!Get.isRegistered<VastuReadingController>(tag: 'vastu_compass')) {
      controllerRef = Get.put(VastuReadingController(), tag: 'vastu_compass', permanent: false);
    } else {
      controllerRef = Get.find<VastuReadingController>(tag: 'vastu_compass');
      controllerRef.resumeSensors();
    }

    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(),
      body: SafeArea(
        child: GetBuilder<VastuReadingController>(
          tag: 'vastu_compass',
          init: controllerRef, // Explicitly provide controller instance
          builder: (controller) {
            // Camera mode
            if (controller.isCameraMode) {
              return CameraCompassOverlay(
                heading: controller.heading,
                direction: controller.currentDirection,
                isCalibrated: controller.isCalibrated,
                onClose: () => controller.toggleCameraMode(),
              );
            }
            
            // Normal compass mode
            return Column(
              children: [
                // Header
                _buildHeader(),
                
                // Main compass area
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Compass dial
                      CompassDial(
                        heading: controller.heading,
                        isCalibrated: controller.isCalibrated,
                      ),
                      
                      // Direction overlay
                      DirectionOverlay(
                        direction: controller.currentDirection,
                        heading: controller.heading,
                      ),
                      
                      // Calibration hint
                      if (!controller.isCalibrated)
                        Positioned(
                          bottom: 100.h,
                          child: CalibrationHint(),
                        ),
                    ],
                  ),
                ),
                
                // Bottom controls
                _buildBottomControls(controller),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: '#ffffff'.toColor(),
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back,
                color: '#3E2723'.toColor(),
                size: 20.w,
              ),
            ),
          ),
          Spacer(),
          // Camera toggle button
          GetBuilder<VastuReadingController>(
            builder: (controller) {
              return GestureDetector(
                onTap: () => controller.toggleCameraMode(),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: controller.isCameraMode 
                        ? "#F38B3B".toColor() 
                        : '#ffffff'.toColor(),
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: controller.isCameraMode 
                        ? '#ffffff'.toColor() 
                        : '#3E2723'.toColor(),
                    size: 20.w,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(VastuReadingController controller) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: '#ffffff'.toColor(),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Direction info card
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: '#FFF2E8'.toColor(),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: '#F5D7B8'.toColor(),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                AutoTranslateText(
                  controller.currentDirection,
                  style: MyTextTheme.largeBCB.copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.bold,
                  ).merge(AppTypography.h2),
                  textAlign: TextAlign.center,
                ),
                Spacing.h(8),
                AutoTranslateText(
                  'Heading: ${controller.heading.toStringAsFixed(1)}°',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: '#666666'.toColor(),
                  ).merge(AppTypography.body1),
                ),
              ],
            ),
          ),
          Spacing.h(16),
          // Vastu info button
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: "#F38B3B".toColor().withOpacity(0.35),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => controller.showVastuInfo(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: '#ffffff'.toColor(),
                  padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20.w,
                    color: '#ffffff'.toColor(),
                  ),
                  Spacing.w(8),
                  AutoTranslateText(
                    'Vastu Information',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#ffffff'.toColor(),
                      fontWeight: FontWeight.bold,
                    ).merge(AppTypography.body1),
                  ),
                ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

