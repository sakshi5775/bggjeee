import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app_manager/ext/hex_color_ext.dart';
import '../../../widgets/auto_translate_text.dart';
import 'ComingSoonPage.dart';
import 'book_open_page.dart';

class AstrologyReportWidget extends StatelessWidget {
  const AstrologyReportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const ComingSoonPage());
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(
                  'Digital Education',
                  style: AppTypography.h2.copyWith(color: "#820B17".toColor()),
                ),
              
              ],
            ),
            Spacing.h(10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10.w,
                children: [
                  _buildAstrologyReportCard(
                    imageUrl: 'https://astrobharatai.s3.ap-south-1.amazonaws.com/Sacred+Library/atharvaveda.jpeg',
                    title: 'Atharvaveda',
                  ),
                  _buildAstrologyReportCard(
                    imageUrl: 'https://astrobharatai.s3.ap-south-1.amazonaws.com/Sacred+Library/jyotishVedang.jpeg',
                    title: 'Jyotish Vedang',
                  ),
                  _buildAstrologyReportCard(
                    imageUrl: 'https://astrobharatai.s3.ap-south-1.amazonaws.com/Sacred+Library/rigveda.jpeg',
                    title: 'Rigveda',
                  ),
                  _buildAstrologyReportCard(
                    imageUrl: 'https://astrobharatai.s3.ap-south-1.amazonaws.com/Sacred+Library/samveda.jpeg',
                    title: 'Samveda',
                  ),
                  _buildAstrologyReportCard(
                    imageUrl: 'https://astrobharatai.s3.ap-south-1.amazonaws.com/Sacred+Library/yajurveda.jpeg',
                    title: 'Yajurveda',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAstrologyReportCard({
    required String imageUrl,
    required String title,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(() => BookOpenPage(
              imageUrl: imageUrl,
              title: title,
            ));
      },
      child: ClipRRect(
        borderRadius: AppRadius.only(
          topLeft: 13.r,
          topRight: 13.r,
          bottomRight: 13.r,
        ),
        child: Container(
          width: 82.w,
          height: 100.h,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: imageUrl,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.withOpacity(0.3),
                    child: const Icon(Icons.error_outline),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: AppPaddings.symmetric(h: 5, v: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: AutoTranslateText(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
