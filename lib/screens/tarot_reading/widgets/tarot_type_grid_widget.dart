import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/tarot_reading/controller/tarot_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TarotTypeGridWidget extends StatelessWidget {
  const TarotTypeGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacing.h(12),
          // Page header
          AutoTranslateText(
            'What do you want to explore?',
            style: MyTextTheme.largeBCB.copyWith(
              color: '#820B17'.toColor(),
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          Spacing.h(4),
          AutoTranslateText(
            'Choose a reading to begin your journey',
            style: MyTextTheme.smallBCN.copyWith(
              color: '#68171E'.toColor().withValues(alpha: 0.65),
              fontSize: 13.sp,
            ),
          ),
          Spacing.h(20),

          // 2-column grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.82,
            children: [
              _ReadingTypeCard(
                emoji: '🔮',
                title: 'Yes / No',
                tagline: 'Get a clear answer to your question',
                color: const Color(0xFF7C3AED),
                onTap: () =>
                    Get.find<TarotController>().chooseReadingType('yesno'),
              ),
              _ReadingTypeCard(
                emoji: '❤️',
                title: 'Love',
                tagline: 'Explore your heart & relationships',
                color: const Color(0xFFE11D48),
                hasSub: true,
                onTap: () => _showLoveSheet(context),
              ),
              _ReadingTypeCard(
                emoji: '💼',
                title: 'Career',
                tagline: 'Unlock your professional path',
                color: const Color(0xFF0369A1),
                onTap: () =>
                    Get.find<TarotController>().chooseReadingType('career'),
              ),
              _ReadingTypeCard(
                emoji: '🌅',
                title: 'Daily Guidance',
                tagline: "Today's energy & outlook",
                color: const Color(0xFFF59E0B),
                onTap: () =>
                    Get.find<TarotController>().chooseReadingType('daily'),
              ),
              _ReadingTypeCard(
                emoji: '💔',
                title: 'Breakup',
                tagline: 'Heal & find your way forward',
                color: const Color(0xFF9F1239),
                hasSub: true,
                onTap: () => _showBreakupSheet(context),
              ),
              _ReadingTypeCard(
                emoji: '🍀',
                title: 'Fortune Cookie',
                tagline: 'Instant mystic message — no card draw',
                color: const Color(0xFF059669),
                onTap: () =>
                    Get.find<TarotController>().chooseReadingType('fortune-cookie'),
              ),
            ],
          ),

          Spacing.h(20),

          // Consultation promo banner (compact)
          _ConsultationBanner(),
        ],
      ),
    );
  }

  void _showLoveSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _LoveSubTypeSheet(),
    );
  }

  void _showBreakupSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _BreakupSubTypeSheet(),
    );
  }
}

// ─── Individual reading type card ─────────────────────────────────────────────

class _ReadingTypeCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String tagline;
  final Color color;
  final bool hasSub;
  final VoidCallback onTap;

  const _ReadingTypeCard({
    required this.emoji,
    required this.title,
    required this.tagline,
    required this.color,
    required this.onTap,
    this.hasSub = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: color.withValues(alpha: 0.18), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: TextStyle(fontSize: 24.sp),
                ),
              ),
            ),
            Spacing.h(12),

            // Title
            AutoTranslateText(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: '#1E0A0A'.toColor(),
                fontFamily: 'Poppins',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Spacing.h(4),

            // Tagline
            Expanded(
              child: AutoTranslateText(
                tagline,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: '#68171E'.toColor().withValues(alpha: 0.6),
                  height: 1.35,
                  fontFamily: 'Poppins',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacing.h(10),

            // Begin button
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoTranslateText(
                    hasSub ? 'Choose' : 'Begin',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    hasSub ? Icons.expand_more : Icons.arrow_forward,
                    color: Colors.white,
                    size: 13.w,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Love Sub-type Bottom Sheet ────────────────────────────────────────────────

class _LoveSubTypeSheet extends StatelessWidget {
  const _LoveSubTypeSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Row(
            children: [
              Text('❤️', style: TextStyle(fontSize: 22.sp)),
              SizedBox(width: 10.w),
              AutoTranslateText(
                'Choose Love Reading Type',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#820B17'.toColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 17.sp,
                ),
              ),
            ],
          ),
          Spacing.h(16),
          _SubTypeOption(
            emoji: '💞',
            title: 'Deep Love',
            desc: 'Explore your relationship in depth',
            color: const Color(0xFFE11D48),
            onTap: () {
              Navigator.pop(context);
              Get.find<TarotController>()
                  .chooseReadingType('love', loveSubType: 'in-depth');
            },
          ),
          _SubTypeOption(
            emoji: '💑',
            title: 'Made for Each Other',
            desc: 'Discover your compatibility & soulmate energy',
            color: const Color(0xFFDB2777),
            onTap: () {
              Navigator.pop(context);
              Get.find<TarotController>()
                  .chooseReadingType('love', loveSubType: 'made-for-each-other');
            },
          ),
          _SubTypeOption(
            emoji: '😘',
            title: 'Flirt',
            desc: 'New connections & playful attractions',
            color: const Color(0xFFF97316),
            onTap: () {
              Navigator.pop(context);
              Get.find<TarotController>()
                  .chooseReadingType('love', loveSubType: 'flirt');
            },
          ),
          _SubTypeOption(
            emoji: '🔺',
            title: 'Love Triangle',
            desc: 'Complex 3-person dynamics (picks 3 cards)',
            color: const Color(0xFF7C3AED),
            onTap: () {
              Navigator.pop(context);
              Get.find<TarotController>()
                  .chooseReadingType('love', loveSubType: 'triangle');
            },
          ),
          _SubTypeOption(
            emoji: '🔥',
            title: 'Erotic Love',
            desc: 'Passionate & physical energy',
            color: const Color(0xFFDC2626),
            onTap: () {
              Navigator.pop(context);
              Get.find<TarotController>()
                  .chooseReadingType('love', loveSubType: 'erotic');
            },
          ),
          Spacing.h(8),
        ],
      ),
    );
  }
}

// ─── Breakup Sub-type Bottom Sheet ────────────────────────────────────────────

class _BreakupSubTypeSheet extends StatelessWidget {
  const _BreakupSubTypeSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Row(
            children: [
              Text('💔', style: TextStyle(fontSize: 22.sp)),
              SizedBox(width: 10.w),
              AutoTranslateText(
                'Choose Breakup Reading Type',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#820B17'.toColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 17.sp,
                ),
              ),
            ],
          ),
          Spacing.h(16),
          _SubTypeOption(
            emoji: '💔',
            title: 'Romantic Breakup',
            desc: 'Heal from a relationship ending (picks 2 cards)',
            color: const Color(0xFF9F1239),
            onTap: () {
              Navigator.pop(context);
              Get.find<TarotController>().chooseReadingType('romantic-breakup');
            },
          ),
          _SubTypeOption(
            emoji: '🤝',
            title: 'Business Breakup',
            desc: 'Navigate a professional separation (picks 2 cards)',
            color: const Color(0xFF1D4ED8),
            onTap: () {
              Navigator.pop(context);
              Get.find<TarotController>().chooseReadingType('business-breakup');
            },
          ),
          Spacing.h(8),
        ],
      ),
    );
  }
}

// ─── Sub-type option row ───────────────────────────────────────────────────────

class _SubTypeOption extends StatelessWidget {
  final String emoji;
  final String title;
  final String desc;
  final Color color;
  final VoidCallback onTap;

  const _SubTypeOption({
    required this.emoji,
    required this.title,
    required this.desc,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1.2),
        ),
        child: Row(
          children: [
            Text(emoji, style: TextStyle(fontSize: 22.sp)),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: '#1E0A0A'.toColor(),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 2.h),
                  AutoTranslateText(
                    desc,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      color: '#68171E'.toColor().withValues(alpha: 0.6),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 14.w),
          ],
        ),
      ),
    );
  }
}

// ─── Consultation Banner (compact) ────────────────────────────────────────────

class _ConsultationBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          UserMainController.pushInCurrentTab(AppRoutes.astrologyServices),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: '#68171E'.toColor().withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.psychology,
                color: AppColors.templeGold,
                size: 24.w,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    'Need Expert Guidance?',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  AutoTranslateText(
                    'Talk to an astrologer for personalized reading',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 11.sp,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AutoTranslateText(
                'Chat',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
