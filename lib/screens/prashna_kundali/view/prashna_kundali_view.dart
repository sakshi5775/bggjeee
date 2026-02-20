import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/prashna_kundali/controller/prashna_kundali_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PrashnaKundaliView extends GetView<PrashnaKundaliController> {
  const PrashnaKundaliView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // Header with back button and history
            CommonHeader(
              title: 'Prashna kundli',
              customActions: [
                IconButton(
                  onPressed: () async {
                    final ok = await LoginGuard.ensureLoggedIn(
                      message: 'Login to view your Prashna kundli history.',
                    );
                    if (ok) {
                      Get.toNamed(AppRoutes.prashnaKundaliHistory);
                    }
                  },
                  icon: Icon(
                    Icons.history,
                    color: '#EA632B'.toColor(),
                    size: 24.w,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Main icon
                    _buildMainIcon(),

                    // Title
                    _buildTitle(),

                    Spacing.h(8),

                    // Subtitle
                    _buildSubtitle(),

                    Spacing.h(32),

                    // Start Your Reading section
                    _buildStartReadingSection(),

                    Spacing.h(32),

                    // How Prashna Kundali Works section
                    _buildHowItWorksSection(),

                    Spacing.h(32),

                    // Key Features section
                    _buildKeyFeaturesSection(),

                    Spacing.h(32),

                    // About Prashna Kundali section
                    _buildAboutSection(),
                    Spacing.h(32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainIcon() {
    return Container(
      width: 140.w,
      height: 140.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: SvgAssets(
          path: AppConstant.prashnaKundali,
          width: 140.w,
          height: 140.w,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return AutoTranslateText(
      'Prashna kundli',
      style: MyTextTheme.veryLargeBCB
          .copyWith(color: '#3E2723'.toColor(), fontWeight: FontWeight.bold)
          .merge(AppTypography.h1),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: AutoTranslateText(
        'Ancient Horary Astrology â€¢ AI-Powered Insights',
        style: MyTextTheme.mediumBCN.copyWith(color: '#3E2723'.toColor()),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildStartReadingSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Start Your Reading header
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: "#F38B3B".toColor(),
                  size: 20.w,
                ),
                Spacing.w(8),
                AutoTranslateText(
                  'Start Your Reading',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: "#F38B3B".toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacing.h(12),
            // Heading
            AutoTranslateText(
              'Get Instant Divine Answers',
              style: MyTextTheme.largeBCB
                  .copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.bold,
                  )
                  .merge(AppTypography.h2),
            ),
            Spacing.h(12),
            // Description
            AutoTranslateText(
              'Ask a question and receive astrological insights based on the precise time and location of your query using ancient Vedic wisdom.',
              style: MyTextTheme.mediumBCN.copyWith(
                color: '#666666'.toColor(),
                height: 1.5,
              ),
            ),
            Spacing.h(20),

            // Question Selection Dropdown
            _buildQuestionDropdown(),

            Spacing.h(16),

            // Location Display
            _buildLocationDisplay(),

            Spacing.h(20),

            // Get Reading button
            _buildGetReadingButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          "Select your question",
          style: MyTextTheme.mediumBCB.copyWith(
            color: '#3E2723'.toColor(),
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacing.h(8),
        Obx(() {
          if (controller.isLoadingQuestions.value) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.h),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation("#F38B3B".toColor()),
                ),
              ),
            );
          }
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: '#FFF8E1'.toColor(),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: '#F5D7B8'.toColor(), width: 1.2),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                isExpanded: true,
                value: controller.selectedQuestion.value?.id,
                hint: AutoTranslateText(
                  "Choose a question...",
                  style: TextStyle(color: '#999999'.toColor()),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: "#F38B3B".toColor(),
                ),
                items: controller.questions.map((q) {
                  return DropdownMenuItem<int>(
                    value: q.id,
                    child: AutoTranslateText(
                      q.question,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: '#3E2723'.toColor(),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    final question = controller.questions.firstWhere(
                      (q) => q.id == val,
                    );
                    controller.selectQuestion(question);
                  }
                },
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLocationDisplay() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: '#FFF8E1'.toColor(),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: '#F5D7B8'.toColor(), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: '#FFF2E8'.toColor(),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on,
              color: "#F38B3B".toColor(),
              size: 18.w,
            ),
          ),
          Spacing.w(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  "Analysis Location",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: '#999999'.toColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacing.h(2),
                Obx(
                  () => AutoTranslateText(
                    controller.currentCity.value,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => controller.onInit(),
            style: TextButton.styleFrom(
              foregroundColor: "#F38B3B".toColor(),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            ),
            child: AutoTranslateText(
              "Update",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGetReadingButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            gradient: controller.isAnalyzing.value
                ? null
                : AppColors.orangeGradient,
            color: controller.isAnalyzing.value ? '#CCCCCC'.toColor() : null,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: controller.isAnalyzing.value
                ? null
                : [
                    BoxShadow(
                      color: "#F38B3B".toColor().withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: ElevatedButton(
            onPressed: controller.isAnalyzing.value
                ? null
                : () => controller.analyzeQuestion(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: '#ffffff'.toColor(),
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (controller.isAnalyzing.value)
                  SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                else
                  Icon(Icons.psychology_alt, size: 18.w),
                Spacing.w(8),
                AutoTranslateText(
                  controller.isAnalyzing.value ? "Analyzing..." : "Get Reading",
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHowItWorksSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'How Prashna kundli Works',
            style: MyTextTheme.largeBCB
                .copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                )
                .merge(AppTypography.h2),
          ),
          Spacing.h(16),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildProcessCard(
                    icon: Icons.help_outline,
                    title: 'Ask Question',
                    description: 'Select from curated questions',
                  ),
                ),
                Spacing.w(12),
                Expanded(
                  child: _buildProcessCard(
                    icon: Icons.schedule,
                    title: 'Exact Timing',
                    description: 'Chart at query moment',
                  ),
                ),
                Spacing.w(12),
                Expanded(
                  child: _buildProcessCard(
                    icon: Icons.auto_awesome,
                    title: 'AI Analysis',
                    description: 'Instant divine insights',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: '#FFFAF0'.toColor(),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: '#F5D7B8'.toColor(), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: '#FFF2E8'.toColor(),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: "#F38B3B".toColor(), size: 22.w),
          ),
          Spacing.h(10),
          AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB.copyWith(
              color: '#3E2723'.toColor(),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Spacing.h(4),
          SizedBox(
            height: 36.h,
            child: AutoTranslateText(
              description,
              style: MyTextTheme.smallBCN.copyWith(
                color: '#666666'.toColor(),
                height: 1.25,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyFeaturesSection() {
    final features = [
      {'title': 'Direct Answer', 'desc': 'Clear yes/no response.'},
      {'title': 'Timing', 'desc': 'When it will happen.'},
      {'title': 'Planetary', 'desc': 'Celestial influences.'},
      {'title': 'Remedies', 'desc': 'Solutions to improve.'},
      {'title': 'Accuracy', 'desc': 'Precise predictions.'},
      {'title': 'Guidance', 'desc': 'Actionable advice.'},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Key Insights You Get',
            style: MyTextTheme.largeBCB
                .copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                )
                .merge(AppTypography.h2),
          ),
          Spacing.h(16),
          // Responsive Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 130.w,
              mainAxisExtent: 150.h,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final item = features[index];
              return _buildFeatureCard(
                title: item['title']!,
                description: item['desc']!,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: '#FFFAF0'.toColor(),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: '#F5D7B8'.toColor(), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: '#FFF2E8'.toColor(),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.star, color: "#F38B3B".toColor(), size: 18.w),
          ),
          Spacing.h(8),
          AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB
                .copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                )
                .merge(AppTypography.body2),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Spacing.h(4),
          SizedBox(
            height: 36.h,
            child: AutoTranslateText(
              description,
              style: MyTextTheme.smallBCN
                  .copyWith(color: '#666666'.toColor())
                  .merge(AppTypography.label),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: AppColors.orangeGradient,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -30.h,
              right: -40.w,
              child: Container(
                width: 140.w,
                height: 140.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      "#DD2914".toColor().withValues(alpha: 0.35),
                      "#F38B3B".toColor().withValues(alpha: 0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: '#ffffff'.toColor(),
                      size: 20.w,
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      'About Prashna kundli',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: '#ffffff'.toColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacing.h(12),
                AutoTranslateText(
                  'Prashna kundli (Horary Astrology) is an ancient Vedic technique where a birth chart is created for the exact moment a question is asked. This method reveals divine answers through planetary positions at that precise time, making it a powerful tool for instant guidance on any specific question.',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: '#ffffff'.toColor(),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

