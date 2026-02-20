import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KeyCourseModulesSection extends StatelessWidget {
  const KeyCourseModulesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        children: [
          AutoTranslateText(
            'Key Course Modules',
            style: AppTypography.h2.copyWith(
              color: const Color(0xFF3E1212),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                _buildModuleCard(
                  image: AppConstant.dEKeyCourseModule1,
                  title: 'Energy foundations & planetary amplification',
                ),
                SizedBox(width: 16.w),
                _buildModuleCard(
                  image: AppConstant.dEKeyCourseModule2,
                  title: 'Real vs Fake gemstone identification',
                ),
                SizedBox(width: 16.w),
                _buildModuleCard(
                  image: AppConstant.dEKeyCourseModule3,
                  title: 'KP-based selection with Face & Palm confirmation',
                ),
                SizedBox(width: 16.w),
                _buildModuleCard(
                  image: AppConstant.dEKeyCourseModule4,
                  title: 'Ethical usage, side effects & professional practice',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard({required String image, required String title}) {
    return Container(
      width: 180.w,
      height: 240.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7), // Light beige
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFD68D3C).withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.broken_image, color: Colors.grey[400]),
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          AutoTranslateText(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.body1.copyWith(
              color: const Color(0xFF3E1212),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}
