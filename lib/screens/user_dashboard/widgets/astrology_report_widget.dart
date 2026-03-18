import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app_manager/ext/hex_color_ext.dart';
import '../../../widgets/auto_translate_text.dart';
import 'book_open_page.dart';

class AstrologyReportWidget extends StatelessWidget {
  const AstrologyReportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          //  top: 4.h,
          bottom: 2.h,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(
                  'Sacred Library',
                  style: AppTypography.h2.copyWith(color: "#820B17".toColor()),
                ),
              ],
            ),
            Spacing.h(6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10.w,
                children: [
                  _buildAstrologyReportCard(
                    context: context,
                    imageUrl:
                        'https://d3c2un7ipdye89.cloudfront.net/Sacred+Library/atharvaveda.jpeg',
                    title: 'Atharvaveda',
                  ),
                  _buildAstrologyReportCard(
                    context: context,
                    imageUrl:
                        'https://d3c2un7ipdye89.cloudfront.net/Sacred+Library/jyotishVedang.jpeg',
                    title: 'Jyotish Vedang',
                  ),
                  _buildAstrologyReportCard(
                    context: context,
                    imageUrl:
                        'https://d3c2un7ipdye89.cloudfront.net/Sacred+Library/rigveda.jpeg',
                    title: 'Rigveda',
                  ),
                  _buildAstrologyReportCard(
                    context: context,
                    imageUrl:
                        'https://d3c2un7ipdye89.cloudfront.net/Sacred+Library/samveda.jpeg',
                    title: 'Samveda',
                  ),
                  _buildAstrologyReportCard(
                    context: context,
                    imageUrl:
                        'https://d3c2un7ipdye89.cloudfront.net/Sacred+Library/yajurveda.jpeg',
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
    required BuildContext context,
    required String imageUrl,
    required String title,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            settings: const RouteSettings(name: '/book-open-page'),
            builder: (_) => BookOpenPage(imageUrl: imageUrl, title: title),
          ),
        );
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
                child: NetworkImageWithLoader(url: imageUrl, fit: BoxFit.cover),
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
                        Colors.black.withValues(alpha: 0.7),
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
