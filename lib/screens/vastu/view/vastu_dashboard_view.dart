import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class VastuDashboardView extends StatefulWidget {
  const VastuDashboardView({Key? key}) : super(key: key);

  @override
  State<VastuDashboardView> createState() => _VastuDashboardViewState();
}

class _VastuDashboardViewState extends State<VastuDashboardView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Home Vastu',
      'subtitle': 'Room-wise Vastu guidance',
      'icon': Icons.home,
      'route': AppRoutes.homeVastuList,
      'color': '#F38B3B',
    },
    {
      'title': 'Office Vastu',
      'subtitle': 'Workspace Vastu solutions',
      'icon': Icons.business,
      'route': AppRoutes.officeVastuList,
      'color': '#4A90E2',
    },
    {
      'title': 'Vastu Dosh',
      'subtitle': 'Identify and remedy defects',
      'icon': Icons.warning_amber,
      'route': AppRoutes.vastuDosh,
      'color': '#E74C3C',
    },
    {
      'title': 'Vastu Shastra',
      'subtitle': 'Ancient wisdom & principles',
      'icon': Icons.menu_book,
      'route': AppRoutes.vastuShastra,
      'color': '#9B59B6',
    },
    {
      'title': 'Vastu Tips',
      'subtitle': 'Quick tips for daily life',
      'icon': Icons.lightbulb,
      'route': AppRoutes.vastuTips,
      'color': '#F39C12',
    },
    {
      'title': 'AR Vastu',
      'subtitle': 'Experience Vastu in AR mode',
      'icon': Icons.view_in_ar,
      'route': AppRoutes.arVastu,
      'color': '#9C27B0',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000), // Smooth, spiritual feel
      vsync: this,
    );

    // Create staggered animations
    final categoryCount = _categories.length;
    final intervalStep =
        0.8 / categoryCount; // Use 80% of animation for staggered effect

    _fadeAnimations = List.generate(
      categoryCount,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * intervalStep,
            (index * intervalStep) + 0.2, // Each item gets 20% of the interval
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    _slideAnimations = List.generate(
      categoryCount,
      (index) =>
          Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                index * intervalStep,
                (index * intervalStep) +
                    0.2, // Each item gets 20% of the interval
                curve: Curves.easeOutCubic,
              ),
            ),
          ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: UserDashboardView.buildDrawer(context),
        endDrawer: const CommonEndDrawer(),
        body: Padding(
          padding: EdgeInsets.only(
            top:
                (MediaQuery.of(context).padding.top > 0
                        ? MediaQuery.of(context).padding.top * 0.5
                        : 0.0)
                    .clamp(6.0, 24.0)
                    .toDouble(),
          ),
          child: Column(
            children: [
              CommonHeader(title: 'Vastu Reading'),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Spacing.h(24),

                      // Main icon
                      _buildMainIcon(),

                      Spacing.h(16),

                      Spacing.h(8),

                      // Subtitle
                      _buildSubtitle(),

                      Spacing.h(24),

                      // Category cards
                      _buildCategoryCards(),

                      Spacing.h(24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainIcon() {
    return Container(
      width: 140.w,
      height: 140.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: NetworkImageWithLoader(
          url: AppConstant.vastu,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: AutoTranslateText(
        'Ancient Vastu Shastra • Intelligent Guidance System',
        style: MyTextTheme.mediumBCN
            .copyWith(color: '#3E2723'.toColor())
            .merge(AppTypography.body1),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCategoryCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: List.generate(_categories.length, (index) {
          final category = _categories[index];
          return AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimations[index],
                child: SlideTransition(
                  position: _slideAnimations[index],
                  child: _buildCategoryCard(
                    title: category['title'],
                    subtitle: category['subtitle'],
                    icon: category['icon'],
                    color: category['color'],
                    onTap: () =>
                        UserMainController.pushInCurrentTab(category['route']),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: '#ffffff'.toColor(),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: '#F5D7B8'.toColor(), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: color.toColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(icon, color: color.toColor(), size: 28.w),
              ),
              Spacing.w(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      title,
                      style: MyTextTheme.largeBCB
                          .copyWith(
                            color: '#3E2723'.toColor(),
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.h2),
                    ),
                    Spacing.h(4),
                    AutoTranslateText(
                      subtitle,
                      style: MyTextTheme.mediumBCN
                          .copyWith(color: '#666666'.toColor())
                          .merge(AppTypography.body2),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: '#3E2723'.toColor(),
                size: 18.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
