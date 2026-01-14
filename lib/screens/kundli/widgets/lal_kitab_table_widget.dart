import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/lal_kitab_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LalKitabTableWidget extends StatelessWidget {
  final LalKitabController controller;

  const LalKitabTableWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Table Rows
          ...controller.lalKitabTableData.map((row) {
            final leftText = row['left'] as String;
            final rightText = row['right'] as String? ?? '';
            final hasApiLeft = row['hasApi'] as bool? ?? false;
            final hasApiRight = row['hasApiRight'] as bool? ?? false;
            
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  // Left Column
                  Expanded(
                    child: _buildCard(
                      leftText,
                      hasApiLeft,
                      leftText.isNotEmpty ? () => controller.navigateToTab(leftText) : null,
                    ),
                  ),
                  if (rightText.isNotEmpty) ...[
                    Spacing.w(12),
                    // Right Column
                    Expanded(
                      child: _buildCard(
                        rightText,
                        hasApiRight,
                        () => controller.navigateToTab(rightText),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCard(String title, bool hasApi, VoidCallback? onTap) {
    return GestureDetector(
      onTap: hasApi && onTap != null ? onTap : null,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: hasApi
                ? [
                    "#FF8C42".toColor().withOpacity(0.9),
                    "#E63946".toColor().withOpacity(0.7),
                  ]
                : [
                    "#3D0C11".toColor(),
                    "#5D1C21".toColor(),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoTranslateText(
              title,
              textAlign: TextAlign.center,
              style: MyTextTheme.mediumBCB.copyWith(
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.bold,
              ).merge(AppTypography.body1),
            ),
            if (!hasApi) ...[
              Spacing.h(4),
              AutoTranslateText(
                'Coming Soon',
                textAlign: TextAlign.center,
                style: MyTextTheme.smallBCN.copyWith(
                  color: Color(0xFFFFFFFF),
                ).merge(AppTypography.label),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

