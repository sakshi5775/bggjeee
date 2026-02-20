import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';
import 'package:astrobharataiuser/screens/vastu/controller/royal_compass_controller.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/royal_vastu_compass.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/vastu_history_timeline.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/direction_overlay.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/calibration_hint.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/camera_compass_overlay.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';

/// Royal Vastu Compass View
/// Premium image-based compass with all advanced features
class RoyalVastuCompassView extends StatefulWidget {
  final VastuRoomConfig? roomConfig;

  const RoyalVastuCompassView({Key? key, this.roomConfig}) : super(key: key);

  @override
  State<RoyalVastuCompassView> createState() => _RoyalVastuCompassViewState();
}

class _RoyalVastuCompassViewState extends State<RoyalVastuCompassView>
    with WidgetsBindingObserver {
  RoyalCompassController? _controller;
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize royal compass controller
    _controller = Get.put(
      RoyalCompassController(),
      tag: 'royal_compass',
      permanent: false,
    );

    // Verify controller is findable
    try {
      Get.find<RoyalCompassController>(tag: 'royal_compass');
    } catch (e) {
      _controller = Get.put(
        RoyalCompassController(),
        tag: 'royal_compass',
        permanent: false,
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.pauseSensors();
    if (Get.isRegistered<RoyalCompassController>(tag: 'royal_compass')) {
      Get.delete<RoyalCompassController>(tag: 'royal_compass');
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null) {
      if (Get.isRegistered<RoyalCompassController>(tag: 'royal_compass')) {
        _controller = Get.find<RoyalCompassController>(tag: 'royal_compass');
      }
    }

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _controller?.pauseSensors();
    } else if (state == AppLifecycleState.resumed) {
      _controller?.resumeSensors();
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;
    final roomConfig =
        arguments?['roomConfig'] as VastuRoomConfig? ?? widget.roomConfig;

    if (_controller == null) {
      if (Get.isRegistered<RoyalCompassController>(tag: 'royal_compass')) {
        _controller = Get.find<RoyalCompassController>(tag: 'royal_compass');
      } else {
        _controller = Get.put(
          RoyalCompassController(),
          tag: 'royal_compass',
          permanent: false,
        );
      }
    }

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GetBuilder<RoyalCompassController>(
          tag: 'royal_compass',
          builder: (controller) {
            // Camera mode
            if (controller.isCameraMode) {
              return CameraCompassOverlay(
                heading: controller.heading,
                direction: controller.currentDirection,
                isCalibrated: controller.isCalibrated,
                onClose: () => controller.toggleCameraMode(),
                roomConfig: roomConfig,
              );
            }

            // History view or Main compass view
            return Column(
              children: [
                if (_showHistory)
                  CommonHeader(
                    title: 'Vastu History',
                    customActions: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _showHistory = !_showHistory;
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          color: '#6F221E'.toColor(),
                          size: 24.w,
                        ),
                      ),
                    ],
                  )
                else
                  CommonHeader(
                    title: roomConfig?.displayName ?? 'Vastu Compass',
                    customActions: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _showHistory = !_showHistory;
                          });
                        },
                        icon: Icon(
                          Icons.history,
                          color: '#6F221E'.toColor(),
                          size: 24.w,
                        ),
                      ),
                    ],
                  ),
                Expanded(
                  child: _showHistory
                      ? VastuHistoryTimeline(
                          history: controller.getHistory(),
                          onItemTap: (entry) {
                            // Show details or navigate
                          },
                          onClear: () {
                            controller.clearHistory();
                            setState(() {});
                          },
                        )
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            // Royal compass (image-based)
                            RoyalVastuCompass(
                              heading: controller.heading,
                              isCalibrated: controller.isCalibrated,
                              roomConfig: roomConfig,
                              currentDirection: controller.currentDirection,
                              isLocked: controller.isLocked,
                              onCenterTap: () {
                                if (controller.isLocked) {
                                  controller.unlockDirection();
                                } else {
                                  controller.lockDirection();
                                  // Locked - can show remedy layer here if needed
                                  setState(() {});
                                }
                              },
                              tiltX: controller.tiltX,
                              tiltY: controller.tiltY,
                              compassSize: 320.0,
                            ),

                            // Direction overlay
                            Positioned(
                              top: 80.h,
                              child: DirectionOverlay(
                                direction: controller.currentDirection,
                                heading: controller.heading,
                              ),
                            ),

                            // Degree indicator
                            Positioned(
                              top: 140.h,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: '#D4AF37'.toColor().withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: AutoTranslateText(
                                  '${controller.heading.toStringAsFixed(1)}Â°',
                                  style: MyTextTheme.mediumBCB
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      )
                                      .merge(AppTypography.h3),
                                ),
                              ),
                            ),

                            // Calibration hint
                            if (!controller.isCalibrated)
                              Positioned(
                                bottom: 120.h,
                                child: CalibrationHint(),
                              ),
                          ],
                        ),
                ),
                _buildBottomControls(controller, roomConfig),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomControls(
    RoyalCompassController controller,
    VastuRoomConfig? roomConfig,
  ) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Accuracy indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                controller.isCalibrated
                    ? Icons.check_circle
                    : Icons.info_outline,
                size: 18.w,
                color: controller.isCalibrated
                    ? '#2E7D32'.toColor()
                    : '#D4AF37'.toColor(),
              ),
              Spacing.w(8),
              AutoTranslateText(
                controller.isCalibrated ? 'High Accuracy' : 'Calibrating...',
                style: MyTextTheme.smallBCN
                    .copyWith(color: '#666666'.toColor())
                    .merge(AppTypography.body2),
              ),
            ],
          ),
          Spacing.h(16),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: "#F38B3B".toColor().withValues(alpha: 0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to AR mode for full remedy experience
                      if (roomConfig != null) {
                        Get.toNamed(
                          AppRoutes.arVastu,
                          arguments: {'roomConfig': roomConfig},
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    icon: Icon(Icons.lightbulb_outline, size: 18.w),
                    label: AutoTranslateText(
                      'Remedies',
                      style: MyTextTheme.smallBCB
                          .copyWith(fontWeight: FontWeight.bold)
                          .merge(AppTypography.body2),
                    ),
                  ),
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (roomConfig != null) {
                      controller.saveToHistory(
                        roomType: roomConfig.roomType,
                        roomName: roomConfig.displayName,
                      );
                      Get.snackbar(
                        'Saved',
                        'Direction saved to history',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: '#D4AF37'.toColor(),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    side: BorderSide(color: '#D4AF37'.toColor(), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  icon: Icon(Icons.bookmark_border, size: 18.w),
                  label: AutoTranslateText(
                    'Save',
                    style: MyTextTheme.smallBCB
                        .copyWith(fontWeight: FontWeight.bold)
                        .merge(AppTypography.body2),
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(12),

          // AR Mode button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed(
                AppRoutes.arVastu,
                arguments: {'roomConfig': roomConfig},
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: '#9C27B0'.toColor(),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 6,
              ),
              icon: Icon(Icons.view_in_ar, size: 20.w),
              label: AutoTranslateText(
                'AR Mode',
                style: MyTextTheme.mediumBCB
                    .copyWith(fontWeight: FontWeight.bold)
                    .merge(AppTypography.body1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

