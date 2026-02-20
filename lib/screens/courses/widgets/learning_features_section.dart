import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LearningFeaturesSection extends StatelessWidget {
  const LearningFeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeatureItem(
            icon: Icons.auto_awesome,
            title: 'Logic Over Superstition',
            subtitle: 'Energy, Psychology & Systems',
            iconColor: const Color(0xFFD68D3C), // Gold-ish
          ),
          _buildDivider(),
          _buildFeatureItem(
            icon: Icons.science,
            title: 'Theory + Practical',
            subtitle: 'Real Charts & Case Studies',
            iconColor: const Color(0xFFD68D3C),
          ),
          _buildDivider(),
          _buildFeatureItem(
            icon: Icons.school,
            title: 'Career-Ready Learning',
            subtitle: 'From Curiosity to Mastery',
            iconColor: const Color(0xFFD68D3C),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 60.h,
      width: 1,
      color: Colors.grey.withOpacity(0.3),
      margin: EdgeInsets.only(top: 8.h),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            child: Icon(icon, color: iconColor, size: 32.w),
          ),
          SizedBox(height: 12.h),
          AutoTranslateText(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.body1.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: const Color(0xFF5D2E17), // Dark brown
            ),
            maxLines: 2,
          ),
          SizedBox(height: 4.h),
          AutoTranslateText(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTypography.body2.copyWith(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
