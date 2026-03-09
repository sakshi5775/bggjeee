import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class FreeServiceDialog extends StatelessWidget {
  const FreeServiceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top section with image
              _buildImageSection(),

              // Bottom section with content
              _buildContentSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        // Background image
        SizedBox(
          height: 280.h,
          width: double.infinity,
          child: NetworkImageWithLoader(
            url: AppConstant.freeservice,
            fit: BoxFit.cover,
          ),
        ),

        // Overlay gradient for better text visibility
        Container(
          height: 280.h,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.3)],
            ),
          ),
        ),

        // Close button (top-right)
        Positioned(
          top: 12.h,
          right: 12.w,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 20.w),
            ),
          ),
        ),

        // Astrological chart overlay (top-left)
        Positioned(
          top: 20.h,
          left: 20.w,
          child: Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: Color(0xFFFFD700).withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: CustomPaint(painter: AstrologicalChartPainter()),
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    return Container(
      padding: AppPaddings.all(24),
      decoration: BoxDecoration(
        color: Color(0xFFFFF8E1), // Light cream/beige background
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Headline
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Get your First Chat\n',
                  style: MyTextTheme.veryLargeBCB.copyWith(
                    fontSize: AppTypography.h1.fontSize?.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepOrange,
                    height: 1.2,
                  ),
                ),
                TextSpan(
                  text: 'Free',
                  style: MyTextTheme.veryLargeBCB.copyWith(
                    fontSize: AppTypography.h1.fontSize?.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepOrange,
                  ),
                ),
              ],
            ),
          ),

          Spacing.h(24),

          // CTA Button
          Container(
            width: double.infinity,
            height: 56.h,
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepOrange.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Get.back(); // Close dialog
                  UserMainController.pushInCurrentTab(
                    AppRoutes.astrologyServices,
                  );
                },
                borderRadius: BorderRadius.circular(16.r),
                child: Center(
                  child: AutoTranslateText(
                    'START CHAT FREE NOW!',
                    style: MyTextTheme.mediumBCB.copyWith(
                      fontSize: AppTypography.h2.fontSize?.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Spacing.h(20),

          // Social proof
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Stars
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return Padding(
                    padding: EdgeInsets.only(right: index < 4 ? 4.w : 0),
                    child: Icon(
                      Icons.star,
                      color: Color(0xFFFFD700), // Gold color
                      size: 18.w,
                    ),
                  );
                }),
              ),

              Spacing.w(6),

              // AutoTranslateText - Flexible to prevent overflow
              Flexible(
                child: AutoTranslateText(
                  '• 10,000+ Consultations',
                  style: MyTextTheme.mediumBCN.copyWith(
                    fontSize: AppTypography.body2.fontSize?.sp,
                    color: Color(0xFF666666), // Grey color
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom painter for astrological chart overlay
class AstrologicalChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFFFD700).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw concentric circles
    for (int i = 1; i <= 3; i++) {
      final radius = (size.width / 2) * (i / 3);
      canvas.drawCircle(center, radius, paint);
    }

    // Draw radial lines
    for (int i = 0; i < 8; i++) {
      final endX =
          center.dx +
          (size.width / 2) * (i.isEven ? 0.8 : 0.6) * (i % 2 == 0 ? 1 : -1);
      final endY =
          center.dy +
          (size.height / 2) *
              (i.isEven ? 0.8 : 0.6) *
              ((i ~/ 2) % 2 == 0 ? 1 : -1);
      canvas.drawLine(center, Offset(endX, endY), paint);
    }

    // Draw dots (celestial bodies)
    final dotPaint = Paint()
      ..color = Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 6; i++) {
      final radius = size.width * 0.25;
      final x =
          center.dx + radius * (i % 2 == 0 ? 1 : -1) * (i < 2 ? 0.7 : 1.0);
      final y = center.dy + radius * ((i ~/ 2) % 2 == 0 ? 1 : -1) * 0.7;
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
