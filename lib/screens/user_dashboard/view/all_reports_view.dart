import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/ComingSoonPage.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AllReportsView extends StatelessWidget {
  const AllReportsView({Key? key}) : super(key: key);

  static const List<Map<String, String>> _reports = [
    {'title': 'Brihat Kundli', 'image': AppConstant.astrologyReportBrihatKudli},
    {'title': 'Raj Yoga', 'image': AppConstant.astrologyRajYogaReport},
    {'title': 'Year Book', 'image': AppConstant.astrologyYearBookReport},
    {'title': 'Horoscope', 'image': AppConstant.astrologyReportHoroscope2026},
    {'title': 'Shani Report', 'image': AppConstant.astrologyYearBookReportShani},
    {'title': 'Atharvaveda', 'image': 'https://astrobharatai.s3.ap-south-1.amazonaws.com/Sacred+Library/atharvaveda.jpeg'},
    {'title': 'Jyotish Vedang', 'image': 'https://astrobharatai.s3.ap-south-1.amazonaws.com/Sacred+Library/jyotishVedang.jpeg'},
    {'title': 'Rigveda', 'image': 'https://astrobharatai.s3.ap-south-1.amazonaws.com/Sacred+Library/rigveda.jpeg'},
    {'title': 'Samveda', 'image': 'https://astrobharatai.s3.ap-south-1.amazonaws.com/Sacred+Library/samveda.jpeg'},
    {'title': 'Yajurveda', 'image': 'https://astrobharatai.s3.ap-south-1.amazonaws.com/Sacred+Library/yajurveda.jpeg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: ['#FCE5AA'.toColor(), '#FFFCF3'.toColor(), '#FFFFFF'.toColor()],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: '#3D0C11'.toColor(), size: 24.w),
            onPressed: () => Get.back(),
          ),
          title: AutoTranslateText(
            'Reports',
            style: AppTypography.h3.copyWith(
              color: '#3D0C11'.toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
              ),
              itemCount: _reports.length,
              itemBuilder: (context, index) {
                final item = _reports[index];
                return _ReportCard(
                  title: item['title']!,
                  imagePath: item['image']!,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String imagePath;

  const _ReportCard({required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final isAsset = imagePath.startsWith('assets/');

    return GestureDetector(
      onTap: () => Get.to(() => const ComingSoonPage()),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: '#DBCCA8'.toColor().withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                child: isAsset
                    ? Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : Image.network(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: AutoTranslateText(
                title,
                style: AppTypography.body2.copyWith(
                  color: '#3D0C11'.toColor(),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: '#FCE5AA'.toColor(),
      child: Icon(
        Icons.menu_book,
        size: 48.w,
        color: AppColors.deepOrange,
      ),
    );
  }
}
