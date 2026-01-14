import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class BirthDetailsWidget extends StatelessWidget {
  final KundliResultController controller;

  const BirthDetailsWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading if fetching data
      if (controller.isLoadingPlanetDetails.value || controller.isLoadingMangalDosh.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: "#ed6f30".toColor(),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Loading birth details...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            AutoTranslateText(
              'Birth Details',
              style: MyTextTheme.largeBCB.copyWith(
                color: "#6F221E".toColor(),
              ),
            ),
            
            Spacing.h(16),
            
            // Birth Details Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
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
                  _buildDetailRow('Name', controller.getName()),
                  _buildDivider(),
                  _buildDetailRow('Date', controller.getDate()),
                  _buildDivider(),
                  _buildDetailRow('Time', controller.getTime()),
                  _buildDivider(),
                  _buildDetailRow('Place', controller.getPlace()),
                  _buildDivider(),
                  _buildDetailRow('Gender', controller.getGender()),
                  _buildDivider(),
                  _buildDetailRow('Ayanamsa', controller.getAyanamsa()),
                  _buildDivider(),
                  _buildDetailRow('DST', controller.getDST()),
                  _buildDivider(),
                  _buildDetailRow('Mangal Dosh', controller.getMangalDosh()),
                  _buildDivider(),
                  _buildDetailRow('Rashi', controller.getRashi()),
                  _buildDivider(),
                  _buildDetailRow('Age', controller.getAge()),
                  _buildDivider(),
                  _buildDetailRow('Bal. Dasa', controller.getBalDasa()),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          SizedBox(
            width: 120.w,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#6F221E".toColor().withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          Spacing.w(16),
          
          // Value
          Expanded(
            child: AutoTranslateText(
              value,
              style: MyTextTheme.mediumBCN.copyWith(
                color: "#6F221E".toColor(),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: "#6F221E".toColor().withOpacity(0.1),
    );
  }
}
