import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kp_system_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class KpPlanetsWidget extends StatelessWidget {
  final KpSystemController controller;

  const KpPlanetsWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingKpPlanetDetails.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final data = controller.kpPlanetDetailsData.value;
      
      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      final response = data['data']?['response'] as Map<String, dynamic>?;
      if (response == null) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      final planets = response['planets'] as List<dynamic>? ?? [];
      final ascendant = response['ascendant'] as Map<String, dynamic>?;

      return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ascendant Card
            if (ascendant != null)
              _buildPlanetCard('Ascendant', ascendant),
            
            Spacing.h(16),
            
            // Planets List
            ...planets.map((planet) {
              final planetData = planet as Map<String, dynamic>;
              final name = planetData['name'] as String? ?? 'Unknown';
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: _buildPlanetCard(name, planetData),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildPlanetCard(String name, Map<String, dynamic> data) {
    return Container(
      padding: EdgeInsets.all(16.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Planet Name
          AutoTranslateText(
            name,
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ).merge(AppTypography.h2),
          ),
          Spacing.h(12),
          
          // Details Grid
          _buildDetailRow('Longitude', _formatDegree(_parseDouble(data['longitude']))),
          _buildDetailRow('Latitude', _formatDegree(_parseDouble(data['latitude']))),
          if (data['distance'] != null)
            _buildDetailRow('Distance', '${_parseDouble(data['distance']).toStringAsFixed(4)}'),
          if (data['speed'] != null)
            _buildDetailRow('Speed', '${_parseDouble(data['speed']).toStringAsFixed(4)}'),
          if (data['siderealLongitude'] != null)
            _buildDetailRow('Sidereal Longitude', _formatDegree(_parseDouble(data['siderealLongitude']))),
          if (data['sign'] != null)
            _buildDetailRow('Sign', data['sign'] as String? ?? ''),
          if (data['signLord'] != null)
            _buildDetailRow('Sign Lord', data['signLord'] as String? ?? ''),
          if (data['nakshatra'] != null)
            _buildDetailRow('Nakshatra', data['nakshatra'] as String? ?? ''),
          if (data['nakshatraLord'] != null)
            _buildDetailRow('Nakshatra Lord', data['nakshatraLord'] as String? ?? ''),
          if (data['subLord'] != null)
            _buildDetailRow('Sub Lord', data['subLord'] as String? ?? ''),
          if (data['subSubLord'] != null)
            _buildDetailRow('Sub Sub Lord', data['subSubLord'] as String? ?? ''),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor().withOpacity(0.7),
              ).merge(AppTypography.body2),
            ),
          ),
          Expanded(
            flex: 3,
            child: AutoTranslateText(
              value,
              textAlign: TextAlign.right,
              style: MyTextTheme.smallBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.w600,
              ).merge(AppTypography.body2),
            ),
          ),
        ],
      ),
    );
  }

  double _parseDouble(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    }
    return 0.0;
  }

  String _formatDegree(double degree) {
    return '${degree.toStringAsFixed(2)}°';
  }
}

