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
import 'package:intl/intl.dart';

class YoginiDashaWidget extends StatelessWidget {
  final DashaController controller;

  const YoginiDashaWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading for main
      if (controller.yoginiCurrentLevel.value == 'main' && controller.isLoadingYoginiMain.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }
      
      // Show loading for sub
      if (controller.yoginiCurrentLevel.value == 'sub' && controller.isLoadingYoginiSub.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final currentList = controller.yoginiCurrentLevel.value == 'main'
          ? controller.getYoginiMainList()
          : controller.getYoginiSubList();
      
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
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 50.h,
                  width: 50.w,
                  padding: EdgeInsets.all(8.w),
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
                  child: Icon(Icons.import_contacts, color: Colors.white),
                  ),
                Spacing.w(16),
// Title
            AutoTranslateText(
              controller.getYoginiLevelTitle(),
              style: MyTextTheme.largeBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
              ],
            ),

            
            
            Spacing.h(16),
            
            // Main Dasha Info (only show when in sub level)
            if (controller.yoginiCurrentLevel.value == 'sub') ...[
              _buildMainDashaInfo(),
              Spacing.h(16),
            ],
            
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
                  if (controller.yoginiCurrentLevel.value == 'main')
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
                    final dasha = item['dasha'] as String? ?? '';
                    final lord = item['lord'] as String? ?? '';
                    final endDate = item['end_date'] as String? ?? '';
                    final formattedDate = endDate.isNotEmpty ? _formatDate(endDate) : '';
                    final hasNextLevel = controller.yoginiCurrentLevel.value == 'main';
                    // Get full path with slashes
                    final fullPath = controller.getYoginiFullPath(dasha);
                    
                    return GestureDetector(
                      onTap: hasNextLevel ? () => controller.onYoginiMainItemTap(index) : null,
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
                        child: controller.yoginiCurrentLevel.value == 'main'
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Full Path (e.g., "Mangala")
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
                                  Expanded(
                                    flex: 2,
                                    child: AutoTranslateText(
                                      lord,
                                      textAlign: TextAlign.center,
                                      style: MyTextTheme.mediumBCN.copyWith(
                                        color: "#ed6f30".toColor(),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
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
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Full Path (e.g., "Mangala/Mangala")
                                  Expanded(
                                    child: AutoTranslateText(
                                      fullPath,
                                      style: MyTextTheme.mediumBCB.copyWith(
                                        color: "#6F221E".toColor(),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Spacing.w(16),
                                  AutoTranslateText(
                                    formattedDate,
                                    style: MyTextTheme.smallBCN.copyWith(
                                      color: "#6F221E".toColor().withOpacity(0.7),
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
            if (controller.canGoBackYogini())
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3D0C11), Color(0xFF5D1C21),]
                  ),
                  borderRadius: BorderRadius.circular(12.r)
                ),
                margin: EdgeInsets.only(bottom: 16.h),
                child: ElevatedButton(
                  onPressed: () => controller.navigateYoginiBack(),
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: "#DFB343".toColor(),
                    
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  child: AutoTranslateText(
                    'BACK',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Color(0xFFE3B341),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'baloo2'
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
                  // Container(
                  //   height: 10.h,
                  //   width: 10.w,
                  //   decoration: BoxDecoration(
                  //     color: Colors.red.shade100,
                  //     borderRadius: BorderRadius.circular(50.r)
                  //   ),
                  //   child: Icon(Icons.info_outline, color: Colors.white,)
                  // ),
                  Expanded(
                    child: AutoTranslateText(
                      controller.yoginiCurrentLevel.value == 'main'
                          ? 'Dates shown are dasha ending dates. Please tap any row to show Yogini Dasha Sub.'
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

  Widget _buildMainDashaInfo() {
    final mainInfo = controller.getSelectedYoginiMainInfo();
    if (mainInfo == null) return SizedBox.shrink();
    
    final mainDasha = mainInfo['main_dasha']?.toString() ?? '';
    final mainDashaLord = mainInfo['main_dasha_lord']?.toString() ?? '';
    final startDate = mainInfo['sub_dasha_start_dates']?.toString() ?? '';
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: "#ed6f30".toColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Main Dasha: $mainDasha',
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          if (mainDashaLord.isNotEmpty) ...[
            Spacing.h(4),
            AutoTranslateText(
              'Lord: $mainDashaLord',
              style: MyTextTheme.mediumBCN.copyWith(
                color: "#ed6f30".toColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          if (startDate.isNotEmpty) ...[
            Spacing.h(4),
            AutoTranslateText(
              'Start: ${_formatDate(startDate)}',
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor().withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      // Try parsing formats like "Sat, Mar 6, 2027, 12:00:00 AM" or "Sat, Mar 5, 2022, 06:00:00 PM"
      final formats = [
        'EEE, MMM d, yyyy, hh:mm:ss a',
        'EEE, MMM d, yyyy, h:mm:ss a',
        'EEE MMM dd yyyy',
        'EEE, MMM dd yyyy',
        'MMM dd yyyy',
        'dd/MM/yyyy',
      ];
      
      for (final format in formats) {
        try {
          final date = DateFormat(format).parse(dateStr);
          return DateFormat('dd/MM/yyyy').format(date);
        } catch (e) {
          continue;
        }
      }
      
      return dateStr;
    } catch (e) {
      return dateStr;
    }
  }
}
