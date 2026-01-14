import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/yog_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class YogWidget extends StatelessWidget {
  final YogController controller;

  const YogWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingYog.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final data = controller.yogData.value;
      
      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No yog data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      // Extract response data
      final response = data['response'] as Map<String, dynamic>?;
      if (response == null) {
        return Center(
          child: AutoTranslateText(
            'No yog data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      // Extract yoga from panchang object
      final panchang = response['panchang'] as Map<String, dynamic>?;
      final yoga = panchang?['yoga']?.toString() ?? '';
      
      if (yoga.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No yoga data found',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      return  Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: 
          [
            Color(0xFFFFF6C2),
            Color(0xFFFFE8A3)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,),
          
        ),
        child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                AutoTranslateText(
                  'Yog',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: "#6F221E".toColor(),
                  ),
                ),
                
                Spacing.h(16),
                
                // Yoga Card
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
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Yoga Name Header
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                // color: "#ed6f30".toColor().withOpacity(0.1),
                                gradient: LinearGradient(colors: 
                                [
                                  Color(0xFFFF8C42), Color(0xFFE63946)
                                ]),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.auto_awesome,
                                color: "#FFFFFF".toColor(),
                                size: 24.w,
                              ),
                            ),
                            Spacing.w(16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoTranslateText(
                                    'Yoga',
                                    style: MyTextTheme.mediumBCB.copyWith(
                                      color: "#6F221E".toColor().withOpacity(0.7),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Spacing.h(4),
                                  AutoTranslateText(
                                    yoga,
                                    style: MyTextTheme.largeBCB.copyWith(
                                      color: "#6F221E".toColor(),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        Spacing.h(20),
                        
                        // Additional Panchang Information
                        if (panchang != null) ...[
                          Divider(
                            color: "#6F221E".toColor().withOpacity(0.1),
                          ),
                          Spacing.h(16),
                          AutoTranslateText(
                            'Panchang Details',
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: "#6F221E".toColor(),
                            ),
                          ),
                          Spacing.h(12),
                          _buildInfoRow('Tithi', panchang['tithi']?.toString() ?? '--'),
                          Spacing.h(8),
                          _buildInfoRow('Karana', panchang['karana']?.toString() ?? '--'),
                          Spacing.h(8),
                          _buildInfoRow('Day of Birth', panchang['day_of_birth']?.toString() ?? '--'),
                          Spacing.h(8),
                          _buildInfoRow('Day Lord', panchang['day_lord']?.toString() ?? '--'),
                          if (panchang['hora_lord'] != null) ...[
                            Spacing.h(8),
                            _buildInfoRow('Hora Lord', panchang['hora_lord']?.toString() ?? '--'),
                          ],
                          if (panchang['sunrise_at_birth'] != null) ...[
                            Spacing.h(8),
                            _buildInfoRow('Sunrise', panchang['sunrise_at_birth']?.toString() ?? '--'),
                          ],
                          if (panchang['sunset_at_birth'] != null) ...[
                            Spacing.h(8),
                            _buildInfoRow('Sunset', panchang['sunset_at_birth']?.toString() ?? '--'),
                          ],
                          if (panchang['ayanamsa_name'] != null) ...[
                            Spacing.h(8),
                            _buildInfoRow('Ayanamsa', panchang['ayanamsa_name']?.toString() ?? '--'),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      );
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: AutoTranslateText(
            label,
            style: MyTextTheme.smallBCB.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Spacing.w(12),
        Expanded(
          flex: 3,
          child: AutoTranslateText(
            value,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor(),
            ),
          ),
        ),
      ],
    );
  }
}

