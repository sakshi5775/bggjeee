import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrustedEducationSection extends StatelessWidget {
  const TrustedEducationSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF3E1212),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        children: [
          AutoTranslateText(
            'Trusted Education',
            style: AppTypography.h2.copyWith(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 32.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTrustedItem(Icons.school_outlined, 'Structured Syllabus'),
              _buildTrustedItem(
                Icons.verified_outlined,
                'Certified & Accredited',
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTrustedItem(
                Icons.verified_user_outlined,
                'Ethical Guidance',
              ),
              _buildTrustedItem(Icons.people_outline, 'Alumni Network'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrustedItem(IconData icon, String label) {
    return SizedBox(
      width: 140.w,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32.w),
          SizedBox(height: 12.h),
          AutoTranslateText(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.body1.copyWith(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
