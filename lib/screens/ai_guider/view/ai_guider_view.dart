import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/app_manager/widgets/language_selector_widget.dart';
import 'package:astrobharataiuser/core/localization/language_controller.dart';
import 'package:astrobharataiuser/core/localization/language_controller_v2.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/ai_guider/controller/ai_guider_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class AiGuiderView extends StatefulWidget {
  /// When true, header (back, sound, language) is hidden — e.g. when embedded below dashboard slider.
  final bool hideHeader;

  const AiGuiderView({super.key, this.hideHeader = false});

  @override
  State<AiGuiderView> createState() => _AiGuiderViewState();
}

class _AiGuiderViewState extends State<AiGuiderView>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Fade animation for main content
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Slide animation for cards
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Pulse animation for AI icon
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();

    final controller = Get.find<AiGuiderController>();
    // Show welcome message on first open
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 500));
      await controller.showWelcomeMessage();
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AiGuiderController>();

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            if (!widget.hideHeader) const CommonHeader(title: 'AI Guide'),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Spacing.h(8),
                            _buildMainIcon(),
                            Spacing.h(8),
                            _buildTitle(),
                            Spacing.h(4),
                            _buildSubtitle(),
                            Spacing.h(12),
                            SlideTransition(
                              position: _slideAnimation,
                              child: _buildAnimationArea(controller),
                            ),
                            Spacing.h(12),
                            _buildConversationArea(controller),
                            Spacing.h(12),
                            _buildServiceGrid(),
                            Spacing.h(10),
                            _buildCategoryFilters(),
                            Spacing.h(14),
                          ],
                        ),
                      ),
                    ),
                    _buildInputArea(controller),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AiGuiderController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => controller.closeGuider(),
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back,
                color: '#3E2723'.toColor(),
                size: 18.w,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Obx(
            () => GestureDetector(
              onTap: () => controller.toggleSoundMuted(),
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Icon(
                  controller.isSoundMuted.value
                      ? Icons.volume_off
                      : Icons.volume_up,
                  color: controller.isSoundMuted.value
                      ? Colors.grey
                      : '#FF6B35'.toColor(),
                  size: 18.w,
                ),
              ),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () => _showLanguageSelector(controller),
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(
                Icons.language,
                color: '#FF6B35'.toColor(),
                size: 18.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const List<Map<String, dynamic>> _serviceItems = [
    {
      'title': 'Talk to Astrologer',
      'icon': Icons.person,
      'route': AppRoutes.liveAstrologers,
    },
    {
      'title': 'View Kundali',
      'icon': Icons.bar_chart,
      'route': AppRoutes.kundliForm,
    },
    {
      'title': 'Shop - Gemstones',
      'icon': Icons.diamond,
      'route': AppRoutes.ecommerceHome,
    },
    {
      'title': 'Book Pooja',
      'icon': Icons.temple_hindu,
      'route': AppRoutes.bookPuja,
    },
    {
      'title': 'View Panchang',
      'icon': Icons.calendar_today,
      'route': AppRoutes.panchang,
    },
    {
      'title': 'Numerology',
      'icon': Icons.numbers,
      'route': AppRoutes.numerologyForm,
    },
    {
      'title': 'AI Astrologer',
      'icon': Icons.smart_toy,
      'route': AppRoutes.aiGuider,
    },
    {
      'title': 'Kundli Matching',
      'icon': Icons.favorite,
      'route': AppRoutes.matchMakingGif,
    },
    {
      'title': 'Palmistry',
      'icon': Icons.back_hand,
      'route': AppRoutes.palmReading,
    },
    {
      'title': 'Learning Portal',
      'icon': Icons.menu_book,
      'route': AppRoutes.courses,
    },
  ];

  Widget _buildServiceGrid() {
    final orangeStart = AppColors.orangeGradient.colors.first;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: AutoTranslateText(
              'Quick access',
              style: MyTextTheme.mediumBCB
                  .copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  )
                  .merge(AppTypography.h3),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8.h,
              crossAxisSpacing: 8.w,
              childAspectRatio: 1.0,
            ),
            itemCount: _serviceItems.length,
            itemBuilder: (context, index) {
              final item = _serviceItems[index];
              final title = item['title'] as String;
              final icon = item['icon'] as IconData;
              final route = item['route'] as String;
              final isCurrentPage = route == AppRoutes.aiGuider;
              return GestureDetector(
                onTap: () {
                  if (isCurrentPage) return;
                  UserMainController.pushInCurrentTab(route);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: isCurrentPage
                          ? orangeStart.withValues(alpha: 0.5)
                          : Colors.black.withValues(alpha: 0.05),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (AppColors.orangeGradient.colors.length > 1
                                    ? AppColors.orangeGradient.colors.last
                                    : orangeStart)
                                .withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                      BoxShadow(
                        color: orangeStart.withValues(alpha: 0.18),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: isCurrentPage
                              ? orangeStart.withValues(alpha: 0.2)
                              : orangeStart.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(icon, color: orangeStart, size: 20.w),
                      ),
                      Spacing.h(4),
                      AutoTranslateText(
                        title,
                        style: MyTextTheme.smallBCB
                            .copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.sp,
                              height: 1.15,
                            )
                            .merge(AppTypography.body2),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  static const List<Map<String, String>> _categoryItems = [
    {'label': 'Astrologer', 'route': AppRoutes.liveAstrologers},
    {'label': 'Shop', 'route': AppRoutes.ecommerceHome},
    {'label': 'Pooja', 'route': AppRoutes.bookPuja},
    {'label': 'Kundli', 'route': AppRoutes.kundliForm},
  ];

  Widget _buildCategoryFilters() {
    final orangeStart = AppColors.deepOrange;
    final orangeEnd = AppColors.orangeGradient.colors.length > 1
        ? AppColors.deepOrange
        : orangeStart;
    return SizedBox(
      height: 28.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        itemCount: _categoryItems.length,
        separatorBuilder: (_, __) => SizedBox(width: 6.w),
        itemBuilder: (context, index) {
          final item = _categoryItems[index];
          final label = item['label']!;
          final route = item['route']!;
          return GestureDetector(
            onTap: () => UserMainController.pushInCurrentTab(route),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: orangeStart.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: orangeStart.withValues(alpha: 0.35),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: orangeEnd.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: orangeStart.withValues(alpha: 0.12),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: AutoTranslateText(
                label,
                style: MyTextTheme.smallBCB
                    .copyWith(
                      color: AppColors.deepOrange,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                    )
                    .merge(AppTypography.body2),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainIcon() {
    final orangeStart = AppColors.orangeGradient.colors.first;
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: AppColors.orangeGradient,
              boxShadow: [
                BoxShadow(
                  color: orangeStart.withValues(alpha: 0.4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 36.w,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        SvgPicture.network(
          'https://astrobharatai.s3.ap-south-1.amazonaws.com/homepageVideos/Frame+1321314931.svg',
          height: 36.h,
          fit: BoxFit.contain,
        ),
        Spacing.h(4),
        AutoTranslateText(
          'Guide',
          style: MyTextTheme.largeBCB
              .copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              )
              .merge(AppTypography.h2),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AutoTranslateText(
        'Your Intelligent Astrology Assistant',
        style: MyTextTheme.mediumBCN
            .copyWith(color: AppColors.textSecondary, fontSize: 11.sp)
            .merge(AppTypography.body1),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAnimationArea(AiGuiderController controller) {
    final orangeStart = AppColors.orangeGradient.colors.first;
    final orangeEnd = AppColors.orangeGradient.colors.length > 1
        ? AppColors.orangeGradient.colors.last
        : orangeStart;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: orangeStart.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: orangeEnd.withValues(alpha: 0.15),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: orangeStart.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        String statusText = 'Ready to help';
        IconData statusIcon = Icons.check_circle_rounded;
        Color statusColor = AppColors.green;
        switch (controller.currentState.value) {
          case AiGuiderState.idle:
            if (controller.isSoundMuted.value) {
              statusText = 'Tap speaker to enable voice';
              statusIcon = Icons.volume_off_rounded;
              statusColor = AppColors.textSecondary;
            } else {
              statusText = 'Ready to help';
              statusIcon = Icons.check_circle_rounded;
              statusColor = AppColors.green;
            }
            break;
          case AiGuiderState.listening:
            statusText = 'Listening...';
            statusIcon = Icons.mic_rounded;
            statusColor = orangeStart;
            break;
          case AiGuiderState.thinking:
            statusText = 'Thinking...';
            statusIcon = Icons.psychology_rounded;
            statusColor = AppColors.warning;
            break;
          case AiGuiderState.speaking:
            statusText = 'Speaking...';
            statusIcon = Icons.volume_up_rounded;
            statusColor = orangeStart;
            break;
          case AiGuiderState.interrupted:
            statusText = 'Interrupted';
            statusIcon = Icons.pause_circle_rounded;
            statusColor = AppColors.textSecondary;
            break;
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(statusIcon, color: statusColor, size: 16.w),
            Spacing.w(5),
            AutoTranslateText(
              statusText,
              style: MyTextTheme.mediumBCN
                  .copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  )
                  .merge(AppTypography.h3),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildConversationArea(AiGuiderController controller) {
    return Obx(() {
      final userQuery = controller.userQuery.value;
      final aiReply = controller.aiReply.value;
      final transcribedText = controller.transcribedText.value;
      final suggestions = controller.suggestions;

      // Always show conversation area - messages will appear when available
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (userQuery.isNotEmpty) ...[
              _buildMessageCard(userQuery, isUser: true),
              Spacing.h(8),
            ],
            if (aiReply.isNotEmpty) ...[
              _buildMessageCard(aiReply, isUser: false),
              Spacing.h(8),
            ],
            if (transcribedText.isNotEmpty) ...[
              _buildTranscribedCard(transcribedText),
              Spacing.h(8),
            ],
            if (suggestions.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoTranslateText(
                    'Suggestions:',
                    style: MyTextTheme.mediumBCB
                        .copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        )
                        .merge(AppTypography.h3),
                  ),
                  Spacing.h(6),
                  Wrap(
                    spacing: 5.w,
                    runSpacing: 5.h,
                    children: suggestions.map((suggestion) {
                      return GestureDetector(
                        onTap: () => controller.onSuggestionTap(suggestion),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.orangeGradient.colors.first
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.orangeGradient.colors.first
                                  .withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: AutoTranslateText(
                            suggestion,
                            style: MyTextTheme.smallBCN
                                .copyWith(
                                  color: AppColors.deepOrange,
                                  fontSize: 11.sp,
                                )
                                .merge(AppTypography.body2),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
          ],
        ),
      );
    });
  }

  Widget _buildMessageCard(String message, {required bool isUser}) {
    if (message.trim().isEmpty) return const SizedBox.shrink();
    final orangeStart = AppColors.orangeGradient.colors.first;
    final orangeEnd = AppColors.orangeGradient.colors.length > 1
        ? AppColors.orangeGradient.colors.last
        : orangeStart;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 4.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: isUser ? orangeStart.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isUser
              ? orangeStart.withValues(alpha: 0.35)
              : orangeStart.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: orangeEnd.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: orangeStart.withValues(alpha: 0.18),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUser ? Icons.person_rounded : Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 14.w,
            ),
          ),
          Spacing.w(8),
          Expanded(
            child: AutoTranslateText(
              message,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.textPrimary,
                height: 1.35,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ).merge(AppTypography.body1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscribedCard(String text) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: '#F1F8E9'.toColor(),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: '#8BC34A'.toColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.mic, color: '#8BC34A'.toColor(), size: 16.w),
          Spacing.w(6),
          Expanded(
            child: AutoTranslateText(
              text,
              style: MyTextTheme.smallBCN
                  .copyWith(
                    color: '#666666'.toColor(),
                    fontStyle: FontStyle.italic,
                    fontSize: 11.sp,
                  )
                  .merge(AppTypography.body2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(AiGuiderController controller) {
    final orangeStart = AppColors.orangeGradient.colors.first;
    final orangeEnd = AppColors.orangeGradient.colors.length > 1
        ? AppColors.orangeGradient.colors.last
        : orangeStart;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: orangeEnd.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
          BoxShadow(
            color: orangeStart.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(
            () => GestureDetector(
              onTap: () => controller.toggleListening(),
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  gradient: controller.isListening.value
                      ? AppColors.orangeGradient
                      : null,
                  color: controller.isListening.value
                      ? null
                      : AppColors.textSecondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  controller.isListening.value
                      ? Icons.mic_rounded
                      : Icons.mic_off_rounded,
                  color: controller.isListening.value
                      ? Colors.white
                      : AppColors.textSecondary,
                  size: 20.w,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: _inputController,
              style: MyTextTheme.mediumBCN
                  .copyWith(color: AppColors.textPrimary, fontSize: 13.sp)
                  .merge(AppTypography.body1),
              decoration: InputDecoration(
                hintText: 'What can I help you with?',
                hintStyle: MyTextTheme.mediumBCN
                    .copyWith(color: AppColors.textSecondary, fontSize: 12.sp)
                    .merge(AppTypography.body1),
                filled: true,
                fillColor: AppColors.gradientBackground.colors[1],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  controller.submitTextQuery(value);
                  _inputController.clear();
                }
              },
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: () {
              final text = _inputController.text.trim();
              if (text.isNotEmpty) {
                controller.submitTextQuery(text);
                _inputController.clear();
              }
            },
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: orangeStart.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.send_rounded, color: Colors.white, size: 18.w),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector(AiGuiderController controller) async {
    String? previousLanguage;
    if (Get.isRegistered<LanguageControllerV2>()) {
      try {
        final c = Get.find<LanguageControllerV2>();
        previousLanguage = c.currentLanguage.value?.code;
      } catch (e) {
        debugPrint('Error getting LanguageControllerV2: $e');
      }
    } else if (Get.isRegistered<LanguageController>()) {
      try {
        final languageController = Get.find<LanguageController>();
        previousLanguage = languageController.currentLanguage.value?.code;
      } catch (e) {
        debugPrint('Error getting LanguageController: $e');
      }
    }

    await Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          constraints: BoxConstraints(maxHeight: Get.height * 0.8),
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    'Select Language',
                    style: MyTextTheme.largeBCB
                        .copyWith(
                          color: '#3E2723'.toColor(),
                          fontWeight: FontWeight.bold,
                        )
                        .merge(AppTypography.h2),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: '#3E2723'.toColor()),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              Spacing.h(16),
              Expanded(
                child: SingleChildScrollView(
                  child: const LanguageSelectorWidget(showTitle: false),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (Get.isRegistered<LanguageControllerV2>()) {
      try {
        final c = Get.find<LanguageControllerV2>();
        final currentLanguage = c.currentLanguage.value?.code;
        if (currentLanguage != previousLanguage) {
          await controller.onLanguageChanged();
        }
      } catch (e) {
        debugPrint('Error checking language change: $e');
      }
    } else if (Get.isRegistered<LanguageController>()) {
      try {
        final languageController = Get.find<LanguageController>();
        final currentLanguage = languageController.currentLanguage.value?.code;
        if (currentLanguage != previousLanguage) {
          await controller.onLanguageChanged();
        }
      } catch (e) {
        debugPrint('Error checking language change: $e');
      }
    }
  }
}
