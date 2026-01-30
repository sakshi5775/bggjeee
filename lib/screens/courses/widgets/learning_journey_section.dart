import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LearningJourneySection extends StatelessWidget {
  const LearningJourneySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Column(
        children: [
          AutoTranslateText(
            'Your Learning Journey',
            style: AppTypography.h2.copyWith(
              color: AppColors.textPrimary,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildJourneyStep(
                  'Intro Course',
                  '4 WEEKS',
                  '₹2,000 - ₹3,000',
                  Icons.school_outlined,
                ),
                _buildArrow(),
                _buildJourneyStep(
                  'Diploma Program',
                  '8 WEEKS',
                  '₹4,999',
                  Icons.emoji_events_outlined,
                ),
                _buildArrow(),
                _buildJourneyStep(
                  'Bachelor Program',
                  '12 WEEKS',
                  '₹9,999',
                  Icons.workspace_premium_outlined,
                ),
                _buildArrow(),
                _buildJourneyStep(
                  'Master Program',
                  '16 WEEKS',
                  '₹19,999',
                  Icons.history_edu_outlined,
                ),
                _buildArrow(),
                _buildJourneyStep(
                  'Grand Master',
                  'LIFETIME ACCESS',
                  '₹39,999',
                  Icons.stars,
                  isPremium: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Icon(
        Icons.arrow_forward_ios,
        size: 16.w,
        color: const Color(0xFFD68D3C),
      ),
    );
  }

  Widget _buildJourneyStep(
    String title,
    String duration,
    String price,
    IconData icon, {
    bool isPremium = false,
  }) {
    return Container(
      width: 150.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isPremium ? const Color(0xFF3E1212) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFD68D3C).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: isPremium
                ? Colors.white.withOpacity(0.2)
                : const Color(0xFFFFF6E5),
            radius: 24.r,
            child: Icon(
              icon,
              color: isPremium ? Colors.white : const Color(0xFFD68D3C),
              size: 24.w,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 40.h, // Fixed height for 2 lines of text
            child: Center(
              child: AutoTranslateText(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.body1.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: isPremium ? Colors.white : AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isPremium
                  ? const Color(0xFFFFCC80)
                  : const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: AutoTranslateText(
              duration,
              style: AppTypography.label.copyWith(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: isPremium
                    ? const Color(0xFF3E1212)
                    : const Color(0xFF666666),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          AutoTranslateText(
            price,
            style: AppTypography.body2.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: isPremium
                  ? const Color(0xFFFFCC80)
                  : const Color(0xFFD68D3C),
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: isPremium
                  ? const Color(0xFFFFCC80)
                  : const Color(0xFF3E1212),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: AutoTranslateText(
              'Learn More',
              textAlign: TextAlign.center,
              style: AppTypography.body2.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                color: isPremium ? const Color(0xFF3E1212) : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
