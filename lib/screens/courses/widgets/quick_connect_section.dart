import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class QuickConnectSection extends StatelessWidget {
  const QuickConnectSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF3E1212), // Dark Brown Background
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars, color: const Color(0xFFFFCC80), size: 24.w),
              SizedBox(width: 12.w),
              AutoTranslateText(
                'Quick Connect',
                style: AppTypography.h2.copyWith(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildConnectOption(
            icon: Icons.people_outline,
            title: 'Consult with Astrologer',
            subtitle: 'Get answers via chat or call',
            gradientColors: [
              const Color(0xFF4facfe),
              const Color(0xFF00f2fe),
            ], // Blue gradient
            onTap: () => Get.toNamed(AppRoutes.allAstrologers),
          ),
          SizedBox(height: 16.h),
          _buildConnectOption(
            icon: Icons.smart_toy_outlined,
            title: 'Ask AI Astrologer',
            subtitle: '24/7 Instant insights',
            gradientColors: [
              const Color(0xFFfa709a),
              const Color(0xFFfee140),
            ], // Pink/Yellow gradient
            onTap: () => Get.toNamed(AppRoutes.aichat),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(icon, color: Colors.white, size: 24.w),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    title,
                    style: AppTypography.body1.copyWith(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  AutoTranslateText(
                    subtitle,
                    style: AppTypography.body2.copyWith(
                      color: Colors.white70,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16.w),
          ],
        ),
      ),
    );
  }
}
