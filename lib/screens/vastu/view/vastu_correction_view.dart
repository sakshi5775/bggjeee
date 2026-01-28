import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_energy_model.dart';
import 'package:astrobharataiuser/screens/vastu/widgets/correction_step_card.dart';
import 'package:astrobharataiuser/screens/vastu/controller/vastu_reading_controller.dart';

class VastuCorrectionView extends StatelessWidget {
  const VastuCorrectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;
    final roomConfig = arguments?['roomConfig'] as VastuRoomConfig?;
    
    if (roomConfig == null) {
      return Scaffold(
        body: Center(
          child: AutoTranslateText('Room not found'),
        ),
      );
    }

    // Get controller safely - may not exist if navigated directly
    String currentDirection = 'N';
    if (Get.isRegistered<VastuReadingController>(tag: 'vastu_compass')) {
      final controller = Get.find<VastuReadingController>(tag: 'vastu_compass');
      currentDirection = controller.currentDirection;
    }
    
    final energyModel = VastuIntelligenceEngine.analyzeRoom(
      roomConfig,
      currentDirection,
    );

    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(roomConfig.displayName),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Energy status card
                    _buildEnergyStatusCard(energyModel),
                    Spacing.h(24),
                    
                    // Dosh warnings
                    if (energyModel.hasDosh) ...[
                      _buildDoshWarningCard(energyModel),
                      Spacing.h(24),
                    ],
                    
                    // Correction steps
                    AutoTranslateText(
                      'Correction Steps',
                      style: MyTextTheme.largeBCB.copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.bold,
                      ).merge(AppTypography.h2),
                    ),
                    Spacing.h(16),
                    ...energyModel.correctionSteps.asMap().entries.map((entry) {
                      return CorrectionStepCard(
                        stepNumber: entry.key + 1,
                        title: _extractStepTitle(entry.value),
                        description: entry.value,
                        icon: _getStepIcon(entry.key),
                      );
                    }),
                    
                    Spacing.h(24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String roomName) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
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
          Spacing.w(12),
          Expanded(
            child: AutoTranslateText(
              '$roomName Correction Guide',
              style: MyTextTheme.largeBCB.copyWith(
                color: '#3E2723'.toColor(),
                fontWeight: FontWeight.bold,
              ).merge(AppTypography.h2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyStatusCard(VastuEnergyModel energyModel) {
    final statusColor = _getStatusColor(energyModel.energyStatus);
    
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: statusColor,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getStatusIcon(energyModel.energyStatus),
                color: statusColor,
                size: 32.w,
              ),
              Spacing.w(12),
              AutoTranslateText(
                energyModel.energyStatus,
                style: MyTextTheme.veryLargeBCB.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ).merge(AppTypography.h1),
              ),
            ],
          ),
          Spacing.h(12),
          AutoTranslateText(
            'Vastu Score: ${(energyModel.vastuScore * 100).toInt()}%',
            style: MyTextTheme.mediumBCN.copyWith(
              color: '#666666'.toColor(),
            ).merge(AppTypography.body1),
          ),
        ],
      ),
    );
  }

  Widget _buildDoshWarningCard(VastuEnergyModel energyModel) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: '#FFEBEE'.toColor(),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: '#F44336'.toColor(),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: '#F44336'.toColor(),
                size: 24.w,
              ),
              Spacing.w(8),
              AutoTranslateText(
                'Vastu Dosh Detected',
                style: MyTextTheme.largeBCB.copyWith(
                  color: '#F44336'.toColor(),
                  fontWeight: FontWeight.bold,
                ).merge(AppTypography.h2),
              ),
            ],
          ),
          Spacing.h(12),
          ...energyModel.doshWarnings.map((warning) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline,
                  color: '#F44336'.toColor(),
                  size: 16.w,
                ),
                Spacing.w(8),
                Expanded(
                  child: AutoTranslateText(
                    warning,
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: '#666666'.toColor(),
                    ).merge(AppTypography.body1),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Balanced':
        return const Color(0xFF4CAF50);
      case 'Neutral':
        return const Color(0xFFFFC107);
      case 'Disturbed':
        return const Color(0xFFE53935);
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Balanced':
        return Icons.check_circle;
      case 'Neutral':
        return Icons.info;
      case 'Disturbed':
        return Icons.warning;
      default:
        return Icons.help;
    }
  }

  String _extractStepTitle(String step) {
    // Extract first sentence or first 50 chars as title
    final sentences = step.split('.');
    if (sentences.isNotEmpty && sentences[0].length < 50) {
      return sentences[0].trim();
    }
    return step.length > 50 ? '${step.substring(0, 50)}...' : step;
  }

  IconData _getStepIcon(int index) {
    final icons = [
      Icons.home,
      Icons.place,
      Icons.color_lens,
      Icons.lightbulb,
      Icons.build,
    ];
    return icons[index % icons.length];
  }
}

