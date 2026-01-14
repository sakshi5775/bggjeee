import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/dasha_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class VimshottariDashaWidget extends StatelessWidget {
  final DashaController controller;

  const VimshottariDashaWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final currentList = controller.getCurrentList();
      
      if (currentList.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                      Color(0xFFFF8C42),
                      Color(0xFFE63946),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Icons.table_chart,
                color: Colors.white,
                size: 24.w,
              ),
            ),
            Spacing.w(16),
  // Title
            AutoTranslateText(
              controller.getLevelTitle(),
              style: MyTextTheme.largeBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
              ],
            ),
            
            
            Spacing.h(16),
            
            // Dasha List
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: "#ed6f30".toColor().withOpacity(0.1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: AutoTranslateText(
                            'Dasha',
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: "#6F221E".toColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: AutoTranslateText(
                            'Lord',
                            textAlign: TextAlign.center,
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: "#6F221E".toColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: AutoTranslateText(
                            'End Date',
                            textAlign: TextAlign.right,
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: "#6F221E".toColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // List Items
                  ...currentList.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isLast = index == currentList.length - 1;
                    final planetName = item['name'] as String? ?? '';
                    final endDate = item['end'] as String? ?? '';
                    final formattedDate = endDate.isNotEmpty ? controller.formatDate(endDate) : '';
                    final planetShort = controller.getPlanetShortName(planetName);
                    final fullPath = controller.getFullPath(planetShort);
                    final hasNextLevel = controller.getNextLevel() != null;
                    
                    return GestureDetector(
                      onTap: hasNextLevel ? () => controller.onDashaItemTap(index) : null,
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isLast ? Colors.transparent : "#ed6f30".toColor().withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Full Path (e.g., "Me/Me/Me/Me/Me")
                            Expanded(
                              flex: 2,
                              child: AutoTranslateText(
                                fullPath,
                                style: MyTextTheme.mediumBCB.copyWith(
                                  color: "#6F221E".toColor(),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            
                            // Lord (Planet Name)
                            Expanded(
                              flex: 2,
                              child: AutoTranslateText(
                                planetName,
                                textAlign: TextAlign.center,
                                style: MyTextTheme.mediumBCN.copyWith(
                                  color: "#ed6f30".toColor(),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            
                            // End Date
                            Expanded(
                              flex: 2,
                              child: AutoTranslateText(
                                formattedDate,
                                textAlign: TextAlign.right,
                                style: MyTextTheme.smallBCN.copyWith(
                                  color: "#6F221E".toColor().withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            
            Spacing.h(16),
            
            // BACK Button (only show when not at top level)
            if (controller.canGoBack())
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 16.h),
                child: ElevatedButton(
                  onPressed: () => controller.navigateBack(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: "#DFB343".toColor(),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  child: AutoTranslateText(
                    'BACK',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            
            // Note
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: "#ed6f30".toColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    'Note:- ',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: "#6F221E".toColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: AutoTranslateText(
                      controller.getNextLevel() != null
                          ? 'Dates shown are dasha ending dates. Please tap any row to show ${_getNextLevelName(controller)}.'
                          : 'Dates shown are dasha ending dates.',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: "#6F221E".toColor().withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  String _getNextLevelName(DashaController controller) {
    final nextLevel = controller.getNextLevel();
    switch (nextLevel) {
      case 'antardasha':
        return 'Antar Dasha';
      case 'paryantardasha':
        return 'Paryantar Dasha';
      case 'shookshamadasha':
        return 'Shooksham Dasha';
      case 'pranadasha':
        return 'Pran Dasha';
      default:
        return 'next level';
    }
  }
}

