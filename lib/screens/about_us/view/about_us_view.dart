import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const CommonHeader(title: 'About Us', showDrawer: false),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      top: 16.h,
                      bottom:
                          16.h + 70.h + MediaQuery.of(context).padding.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),

                        // ── Hero section ──
                        _buildHeroSection(),
                        SizedBox(height: 24.h),

                        // ── Our Motto ──
                        _buildMottoSection(),
                        SizedBox(height: 24.h),

                        // ── Vision & Mission ──
                        _buildVisionMissionSection(),
                        SizedBox(height: 24.h),

                        // ── Founders ──
                        _buildSectionTitle('Our Founders'),
                        SizedBox(height: 14.h),
                        _buildFounderCard(
                          name: 'Dr. Kunwar Harshit Rajveer',
                          role: 'Founder',
                          imageUrl: AppConstant.aboutUsImage2,
                          description:
                              'AstroBharat AI was founded by Dr. Kunwar Harshit Rajveer, dedicated to bridging the gap between ancient Vedic astrology and modern AI technology. Our journey began with a vision to bring timeless wisdom into the digital age, making authentic astrological guidance accessible to everyone.',
                          quote:
                              '"True astrology is not what scares you, but what guides your karma in the right direction."',
                        ),
                        SizedBox(height: 16.h),
                        _buildFounderCard(
                          name: 'Sri Gurpreet Singh',
                          role: 'Co-Founder',
                          imageUrl: AppConstant.aboutUsImage,
                          description:
                              'Sri Gurpreet Singh is a co-founder associated with AstroBharatAI and a director of the Parashari Indian Institute of Astrology and Research Centre. He is a prominent entrepreneur and business leader, recognized as a dynamic business tycoon with strong strategic and operational leadership.',
                          quote: null,
                        ),
                        SizedBox(height: 24.h),

                        // ── Our Promise / Why Choose ──
                        _buildSectionTitle('Our Promise'),
                        _buildSectionSubtitle(
                          'Why Choose',
                          'Discover what makes us your trusted partner in spiritual guidance and personal growth',
                          isLogo: true,
                        ),
                        SizedBox(height: 14.h),
                        _buildPromiseGrid(),
                        SizedBox(height: 24.h),

                        // ── All Services ──
                        _buildSectionTitle('All Services'),
                        SizedBox(height: 14.h),
                        _buildServicesSection(),
                        SizedBox(height: 24.h),

                        // ── Our Values ──
                        _buildSectionTitle('Our Values'),
                        SizedBox(height: 14.h),
                        _buildValuesGrid(),
                        SizedBox(height: 24.h),

                        // ── Why Choose Us ──
                        _buildSectionTitle('Why Choose Us'),
                        _buildSectionSubtitle('Reasons to choose Us', null),
                        SizedBox(height: 14.h),
                        _buildWhyChooseUsGrid(),
                        SizedBox(height: 24.h),

                        // ── Milestones ──
                        _buildSectionTitle('Milestones at a Glance'),
                        _buildSectionSubtitle(
                          'Parashari Indian Institute of Astrology & AstroBharatAI',
                          null,
                        ),
                        SizedBox(height: 14.h),
                        _buildMilestonesTimeline(),
                        SizedBox(height: 30.h),
                      ],
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

  // ═══════════════════════════════════════════════════
  // HERO SECTION
  // ═══════════════════════════════════════════════════
  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.saffron.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.auto_awesome, color: AppColors.templeGold, size: 36),
          SizedBox(height: 12.h),
          AutoTranslateText(
            'Bridging Ancient Wisdom\n& Modern Technology',
            style: AppTypography.h2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          AutoTranslateText(
            'Merging AI with ancient Vedic wisdom to guide millions safely.',
            style: AppTypography.body2.copyWith(
              color: AppColors.cream,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  // OUR MOTTO
  // ═══════════════════════════════════════════════════
  Widget _buildMottoSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.templeGold.withValues(alpha: 0.15),
            AppColors.cream.withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.templeGold.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          AutoTranslateText(
            'Our Motto',
            style: AppTypography.h3.copyWith(
              color: AppColors.templeGold,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 8.h),
          AutoTranslateText(
            'Your Astrology Guidance Partner\nfor Life.',
            style: AppTypography.h2.copyWith(
              color: AppColors.textColorMaroon,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          AutoTranslateText(
            'Blending ancient Indian wisdom with modern digital guidance to illuminate your life\'s path.',
            style: AppTypography.body2.copyWith(
              color: Colors.grey.shade700,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  // VISION & MISSION
  // ═══════════════════════════════════════════════════
  Widget _buildVisionMissionSection() {
    return Column(
      children: [
        _buildVisionMissionCard(
          icon: Icons.visibility_rounded,
          title: 'Our Vision',
          content:
              'To become the world\'s most trusted digital astrology and spiritual guidance partner, offering lifelong support through transparency, responsibility, and a deeply human-centered approach—while preserving and honoring the authenticity of ancient Indian wisdom.',
          gradient: LinearGradient(
            colors: [Colors.orange.shade50, Colors.amber.shade50],
          ),
          iconColor: AppColors.deepOrange,
        ),
        SizedBox(height: 14.h),
        _buildVisionMissionCard(
          icon: Icons.rocket_launch_rounded,
          title: 'Our Mission',
          content:
              'To empower individuals worldwide with trusted astrology and spiritual guidance by combining traditional knowledge, ethical practices, and expert human insight, while offering free foundational astrology services that help people gain clarity, confidence, and direction in their daily lives.',
          gradient: LinearGradient(
            colors: [Colors.red.shade50, Colors.orange.shade50],
          ),
          iconColor: AppColors.textColorMaroon,
        ),
      ],
    );
  }

  Widget _buildVisionMissionCard({
    required IconData icon,
    required String title,
    required String content,
    required LinearGradient gradient,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: iconColor, size: 22.h),
              ),
              SizedBox(width: 10.w),
              AutoTranslateText(
                title,
                style: AppTypography.h3.copyWith(
                  color: AppColors.textColorMaroon,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          AutoTranslateText(
            content,
            style: AppTypography.body2.copyWith(
              color: Colors.grey.shade800,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════
  Widget _buildSectionTitle(String title) {
    return AutoTranslateText(
      title,
      style: AppTypography.h2.copyWith(
        color: AppColors.textColorMaroon,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSectionSubtitle(
    String subtitle,
    String? description, {
    bool isLogo = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 4.h),
        Row(
          children: [
            Flexible(
              child: AutoTranslateText(
                subtitle,
                style: AppTypography.body1.copyWith(
                  color: AppColors.deepOrange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (isLogo) ...[
              SizedBox(width: 10.w),
              SvgAssets(path: AppConstant.astroBharatLogo, width: 100.w),
            ],
          ],
        ),
        if (description != null) ...[
          SizedBox(height: 4.h),
          AutoTranslateText(
            description,
            style: AppTypography.body2.copyWith(
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════
  // FOUNDER CARD
  // ═══════════════════════════════════════════════════
  Widget _buildFounderCard({
    required String name,
    required String role,
    required String imageUrl,
    required String description,
    String? quote,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.orange.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.templeGold, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.templeGold.withValues(alpha: 0.25),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 36.r,
                  backgroundImage: NetworkImage(imageUrl),
                  backgroundColor: Colors.orange.shade50,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      name,
                      style: AppTypography.h3.copyWith(
                        color: AppColors.textColorMaroon,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: AutoTranslateText(
                        role,
                        style: AppTypography.label.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          AutoTranslateText(
            description,
            style: AppTypography.body2.copyWith(
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
          if (quote != null) ...[
            SizedBox(height: 14.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.templeGold.withValues(alpha: 0.1),
                    AppColors.cream.withValues(alpha: 0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
                border: Border(
                  left: BorderSide(color: AppColors.templeGold, width: 3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.format_quote_rounded,
                    color: AppColors.templeGold,
                    size: 22.h,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: AutoTranslateText(
                      quote,
                      style: AppTypography.body2.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.textColorMaroon,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  // OUR PROMISE GRID (8 items)
  // ═══════════════════════════════════════════════════
  Widget _buildPromiseGrid() {
    final items = [
      _GridItem(
        Icons.star_rounded,
        'Free & Accessible Astrology',
        'Daily/Monthly Horoscopes, Kundli, Face Reading, and Palmistry—explore with confidence without any cost.',
      ),
      _GridItem(
        Icons.headset_mic_rounded,
        'Expert-Guided Consultations',
        'Connect with verified astrologers through live chat and calls for personal guidance.',
      ),
      _GridItem(
        Icons.all_inclusive_rounded,
        'All-in-One Spiritual Ecosystem',
        'From Live Chats to Digital Mandir and a Spiritual E-Mart—everything in one place.',
      ),
      _GridItem(
        Icons.temple_hindu_rounded,
        'Digital Mandir with Social Purpose',
        'Proceeds from our Digital Mandir services support charitable trust initiatives.',
      ),
      _GridItem(
        Icons.person_pin_rounded,
        'Personalized, Not Generic',
        'Services tailored to your personal birth details and life goals.',
      ),
      _GridItem(
        Icons.verified_user_rounded,
        'Ethical & Trust-First',
        'Clear pricing, verified experts, and no fear-based predictions.',
      ),
      _GridItem(
        Icons.public_rounded,
        'Global Reach, Indian Roots',
        'Deeply rooted in Indian traditions, serving users in India, US, UK, Canada, and Europe.',
      ),
      _GridItem(
        Icons.lock_rounded,
        'Secure, Private & Reliable',
        'Your data, charts, and conversations are protected with strict confidentiality.',
      ),
    ];
    return _buildEqualHeightGrid(items, AppColors.deepOrange);
  }

  Widget _buildServicesSection() {
    final kundliServices = [
      {
        'label': 'Kundli',
        'route': AppRoutes.kundliForm,
        'icon': AppConstant.serviceGenerateKundali,
      },
      {
        'label': 'Kundli Matching',
        'route': AppRoutes.matchMakingForm,
        'icon': AppConstant.serviceMatchMaking,
      },
      {
        'label': 'Horoscope',
        'route': AppRoutes.horoscopeForm,
        'icon': AppConstant.horoscope,
      },
      {
        'label': 'Predictions',
        'route': AppRoutes.kundliForm,
        'icon': AppConstant.lifePredictions,
      },
      {
        'label': 'Dasha',
        'route': AppRoutes.kundliForm,
        'icon': AppConstant.dasha,
      },
      {
        'label': 'Dosh',
        'route': AppRoutes.kundliForm,
        'icon': AppConstant.dosh,
      },
      {
        'label': 'Lal Kitab',
        'route': AppRoutes.kundliForm,
        'icon': AppConstant.lalKitab,
      },
      {
        'label': 'KP Astrology',
        'route': AppRoutes.kundliForm,
        'icon': AppConstant.kpN,
      },
      {
        'label': 'Numerology',
        'route': AppRoutes.numerologyForm,
        'icon': AppConstant.serviceNumerology,
      },
      {
        'label': 'Panchang',
        'route': AppRoutes.panchang,
        'icon': AppConstant.servicePanchang,
      },
    ];

    final astrologyTools = [
      {
        'label': 'Face Reading',
        'route': AppRoutes.faceReading,
        'image':
            'https://d3c2un7ipdye89.cloudfront.net/Scanner+Slider/face2.jpeg',
      },
      {
        'label': 'Palm Reading',
        'route': AppRoutes.palmReading,
        'image':
            'https://d3c2un7ipdye89.cloudfront.net/Scanner+Slider/hand.jpeg',
      },
      {
        'label': 'Vastu Reading',
        'route': AppRoutes.vastuDashboard,
        'image':
            'https://d3c2un7ipdye89.cloudfront.net/Scanner+Slider/vastu.jpeg',
      },
      {
        'label': 'Ramal Shastra',
        'route': AppRoutes.ramalShastra,
        'image':
            'https://d3c2un7ipdye89.cloudfront.net/Scanner+Slider/ramal.jpeg',
      },
      {
        'label': 'Writing Astrology',
        'route': AppRoutes.handwritingAstrology,
        'image':
            'https://d3c2un7ipdye89.cloudfront.net/Scanner+Slider/writing.jpeg',
      },
      {
        'label': 'Prashna Kundli',
        'route': AppRoutes.prashnaKundali,
        'image':
            'https://d3c2un7ipdye89.cloudfront.net/Scanner+Slider/PrashanKundli.jpg',
      },
      {
        'label': 'Tarot Reading',
        'route': AppRoutes.tarotReading,
        'image':
            'https://d3c2un7ipdye89.cloudfront.net/Scanner+Slider/TarotReading.png',
      },
      {
        'label': 'Carrot Astrology',
        'route': AppRoutes.carrotAstrology,
        'image':
            'https://d3c2un7ipdye89.cloudfront.net/Astro+Service/carrotAstro.png',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Kundli & Horoscopic Services ──
        AutoTranslateText(
          'Horoscopic Services',
          style: AppTypography.body1.copyWith(
            color: AppColors.deepOrange,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 12.w) / 2;
            return Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: kundliServices.map((s) {
                return SizedBox(
                  width: cardWidth,
                  child: _buildServiceGridCard(
                    label: s['label'] as String,
                    route: s['route'] as String,
                    iconUrl: s['icon'] as String,
                    isNetworkImage: false,
                  ),
                );
              }).toList(),
            );
          },
        ),
        SizedBox(height: 20.h),

        // ── Astrology Tools ──
        AutoTranslateText(
          'Astrology Tools',
          style: AppTypography.body1.copyWith(
            color: AppColors.deepOrange,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 12.w) / 2;
            return Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: astrologyTools.map((s) {
                return SizedBox(
                  width: cardWidth,
                  child: _buildServiceGridCard(
                    label: s['label'] as String,
                    route: s['route'] as String,
                    iconUrl: s['image'] as String,
                    isNetworkImage: true,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildServiceGridCard({
    required String label,
    required String route,
    required String iconUrl,
    required bool isNetworkImage,
  }) {
    return GestureDetector(
      onTap: () => UserMainController.pushInCurrentTab(route),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.orange.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(isNetworkImage ? 10.r : 0),
              child: NetworkImageWithLoader(
                url: iconUrl,
                width: 36.w,
                height: 36.w,
                fit: isNetworkImage ? BoxFit.cover : BoxFit.contain,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: AutoTranslateText(
                label,
                style: AppTypography.body2.copyWith(
                  color: AppColors.textColorMaroon,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  // OUR VALUES GRID (6 items – equal height)
  // ═══════════════════════════════════════════════════
  Widget _buildValuesGrid() {
    final values = [
      _GridItem(
        Icons.verified_rounded,
        'Authenticity',
        'Genuine Vedic astrological guidance based on ancient scriptures.',
      ),
      _GridItem(
        Icons.shield_rounded,
        'Trust & Privacy',
        'Your data and personal information are protected with the highest security standards.',
      ),
      _GridItem(
        Icons.public_rounded,
        'Accessibility',
        'Making astrological wisdom accessible to everyone, everywhere, anytime.',
      ),
      _GridItem(
        Icons.lightbulb_rounded,
        'Innovation',
        'Bridging the gap between ancient wisdom and modern technology.',
      ),
      _GridItem(
        Icons.people_rounded,
        'Community',
        'Building a strong community of believers and seekers of cosmic wisdom.',
      ),
      _GridItem(
        Icons.diamond_rounded,
        'Excellence',
        'Striving for excellence in every service we provide.',
      ),
    ];

    final colors = [
      AppColors.deepOrange,
      AppColors.textColorMaroon,
      AppColors.templeGold,
      AppColors.peacockBlue,
      AppColors.spiritualPurple,
      AppColors.sacredRed,
    ];

    return _buildEqualHeightGridWithColors(values, colors);
  }

  // ═══════════════════════════════════════════════════
  // WHY CHOOSE US (6 items – equal height)
  // ═══════════════════════════════════════════════════
  Widget _buildWhyChooseUsGrid() {
    final items = [
      _GridItem(
        Icons.psychology_rounded,
        'AI-Powered Insights',
        'Advanced AI technology combined with Vedic knowledge for accurate predictions.',
      ),
      _GridItem(
        Icons.person_search_rounded,
        'Expert Astrologers',
        'Connect with verified and experienced astrologers for personalized consultations.',
      ),
      _GridItem(
        Icons.apps_rounded,
        'Multiple Services',
        'Comprehensive range of astrological services under one platform.',
      ),
      _GridItem(
        Icons.touch_app_rounded,
        'Easy Access',
        'Access all services from anywhere, anytime with just a few clicks.',
      ),
      _GridItem(
        Icons.monetization_on_rounded,
        'Affordable Pricing',
        'Quality astrological services at affordable prices for everyone.',
      ),
      _GridItem(
        Icons.support_agent_rounded,
        '24/7 Support',
        'Round-the-clock customer support to assist you whenever you need.',
      ),
    ];
    return _buildEqualHeightGrid(items, AppColors.deepOrange);
  }

  // ═══════════════════════════════════════════════════
  // MILESTONES TIMELINE
  // ═══════════════════════════════════════════════════
  Widget _buildMilestonesTimeline() {
    final milestones = [
      _MilestoneItem(
        '2019–2020',
        'Vision Born',
        'Post-COVID shift toward spirituality. Alignment to take India\'s divine knowledge globally.',
      ),
      _MilestoneItem(
        '2021–2022',
        'Idea Generation',
        'Conceptualized Parashari Indian Institute of Astrology with structured teaching and research.',
      ),
      _MilestoneItem(
        '2023',
        'AstroBharatAI Conceptualized',
        'Vision set to scale astrology and spiritual services through a global digital platform.',
      ),
      _MilestoneItem(
        '2025',
        'Platform Foundation',
        'Development of digital ecosystem and expansion of faculty and astrologer network.',
      ),
      _MilestoneItem(
        '2025–2026',
        'Launch & Expansion',
        'Global outreach launch with the Parashari Institute as the academic and research backbone.',
      ),
    ];

    return Column(
      children: List.generate(milestones.length, (index) {
        final m = milestones[index];
        final isLast = index == milestones.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Timeline line + dot ──
              SizedBox(
                width: 30.w,
                child: Column(
                  children: [
                    Container(
                      width: 14.w,
                      height: 14.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.orangeGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.deepOrange.withValues(alpha: 0.3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: AppColors.deepOrange.withValues(alpha: 0.25),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),

              // ── Content card ──
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.orange.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Year badge ──
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.orangeGradient,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          m.year,
                          style: AppTypography.label.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      AutoTranslateText(
                        m.title,
                        style: AppTypography.body1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColorMaroon,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      AutoTranslateText(
                        m.description,
                        style: AppTypography.body2.copyWith(
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ═══════════════════════════════════════════════════
  // EQUAL HEIGHT GRID BUILDERS
  // ═══════════════════════════════════════════════════

  /// Builds a 2-column grid with equal-height cards using a single accent color.
  Widget _buildEqualHeightGrid(List<_GridItem> items, Color accentColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12.w) / 2;
        return Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: items.map((item) {
            return SizedBox(
              width: cardWidth,
              height: 170.h,
              child: _buildGridCard(item, accentColor),
            );
          }).toList(),
        );
      },
    );
  }

  /// Builds a 2-column grid with equal-height cards, each with its own color.
  Widget _buildEqualHeightGridWithColors(
    List<_GridItem> items,
    List<Color> colors,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12.w) / 2;
        return Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: List.generate(items.length, (i) {
            return SizedBox(
              width: cardWidth,
              height: 170.h,
              child: _buildGridCard(items[i], colors[i % colors.length]),
            );
          }),
        );
      },
    );
  }

  Widget _buildGridCard(_GridItem item, Color accentColor) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: accentColor.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              // color: accentColor.withValues(alpha: 0.1),
              gradient: AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(item.icon, color: Colors.white, size: 22.h),
          ),
          SizedBox(height: 10.h),
          AutoTranslateText(
            item.title,
            style: AppTypography.body1.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textColorMaroon,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Expanded(
            child: AutoTranslateText(
              item.description,
              style: AppTypography.label.copyWith(
                color: Colors.grey.shade600,
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
// DATA CLASSES
// ═══════════════════════════════════════════════════

class _GridItem {
  final IconData icon;
  final String title;
  final String description;
  _GridItem(this.icon, this.title, this.description);
}

class _MilestoneItem {
  final String year;
  final String title;
  final String description;
  _MilestoneItem(this.year, this.title, this.description);
}
