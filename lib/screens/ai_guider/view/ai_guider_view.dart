import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/widgets/language_selector_widget.dart';
import 'package:astrobharataiuser/core/localization/language_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/ai_guider/controller/ai_guider_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AiGuiderView extends StatefulWidget {
  const AiGuiderView({super.key});

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

  @override
  void initState() {
    super.initState();
    
    // Fade animation for main content
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Slide animation for cards
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
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
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AiGuiderController>();

    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(controller),
            
            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacing.h(20),
                      
                      // Main AI Icon with pulse animation
                      _buildMainIcon(),
                      
                      Spacing.h(16),
                      
                      // Title
                      _buildTitle(),
                      
                      Spacing.h(8),
                      
                      // Subtitle
                      _buildSubtitle(),
                      
                      Spacing.h(32),
                      
                      // AI Animation Area
                      SlideTransition(
                        position: _slideAnimation,
                        child: _buildAnimationArea(controller),
                      ),
                      
                      Spacing.h(24),
                      
                      // Conversation Area - Always show, but content is conditional
                      _buildConversationArea(controller),
                      
                      Spacing.h(24),
                      
                      // Features Section
                      SlideTransition(
                        position: _slideAnimation,
                        child: _buildFeaturesSection(),
                      ),
                      
                      Spacing.h(24),
                      
                      // About AI Guide Section
                      SlideTransition(
                        position: _slideAnimation,
                        child: _buildAboutSection(),
                      ),
                      
                      Spacing.h(32),
                    ],
                  ),
                ),
              ),
            ),
            
            // Input area
            _buildInputArea(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AiGuiderController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => controller.closeGuider(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: '#ffffff'.toColor(),
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back,
                color: '#3E2723'.toColor(),
                size: 20.w,
              ),
            ),
          ),
          Spacer(),
          // Language selector icon
          Builder(
            builder: (context) {
              if (Get.isRegistered<LanguageController>()) {
                return GetBuilder<LanguageController>(
                  builder: (langController) => GestureDetector(
                    onTap: () => _showLanguageSelector(controller),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: '#ffffff'.toColor(),
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.language,
                        color: '#FF6B35'.toColor(),
                        size: 20.w,
                      ),
                    ),
                  ),
                );
              }
              return GestureDetector(
                onTap: () => _showLanguageSelector(controller),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: '#ffffff'.toColor(),
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.language,
                    color: '#FF6B35'.toColor(),
                    size: 20.w,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMainIcon() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 140.w,
            height: 140.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  '#FF6B35'.toColor(),
                  '#FF8C42'.toColor(),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: '#FF6B35'.toColor().withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.auto_awesome,
                size: 70.w,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return AutoTranslateText(
      'AstroBharatAI Guide',
      style: MyTextTheme.veryLargeBCB.copyWith(
        color: '#3E2723'.toColor(),
        fontWeight: FontWeight.bold,
      ).merge(AppTypography.h1),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: AutoTranslateText(
        'Your Intelligent Astrology Assistant • Voice & AutoTranslateText Support',
        style: MyTextTheme.mediumBCN.copyWith(
          color: '#3E2723'.toColor(),
        ).merge(AppTypography.body1),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAnimationArea(AiGuiderController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: '#ffffff'.toColor(),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: '#F5D7B8'.toColor(),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Obx(() {
        String statusText = 'Ready to help';
        IconData statusIcon = Icons.check_circle;
        Color statusColor = '#4CAF50'.toColor();
        
        switch (controller.currentState.value) {
          case AiGuiderState.idle:
            statusText = 'Ready to help';
            statusIcon = Icons.check_circle;
            statusColor = '#4CAF50'.toColor();
            break;
          case AiGuiderState.listening:
            statusText = 'Listening...';
            statusIcon = Icons.mic;
            statusColor = '#FF6B35'.toColor();
            break;
          case AiGuiderState.thinking:
            statusText = 'Thinking...';
            statusIcon = Icons.psychology;
            statusColor = '#FF9800'.toColor();
            break;
          case AiGuiderState.speaking:
            statusText = 'Speaking...';
            statusIcon = Icons.volume_up;
            statusColor = '#2196F3'.toColor();
            break;
          case AiGuiderState.interrupted:
            statusText = 'Interrupted';
            statusIcon = Icons.pause_circle;
            statusColor = '#9E9E9E'.toColor();
            break;
        }
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(statusIcon, color: statusColor, size: 20.w),
            Spacing.w(8),
            AutoTranslateText(
              statusText,
              style: MyTextTheme.mediumBCN.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ).merge(AppTypography.h3),
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
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // User Query
            if (userQuery.isNotEmpty) ...[
              _buildMessageCard(
                userQuery,
                isUser: true,
              ),
              Spacing.h(12),
            ],
            
            // AI Reply
            if (aiReply.isNotEmpty) ...[
              _buildMessageCard(
                aiReply,
                isUser: false,
              ),
              Spacing.h(12),
            ],
            
            // Transcribed AutoTranslateText (while listening)
            if (transcribedText.isNotEmpty) ...[
              _buildTranscribedCard(transcribedText),
              Spacing.h(12),
            ],
            
            // Suggestions
            if (suggestions.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoTranslateText(
                    'Suggestions:',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                    ).merge(AppTypography.h3),
                  ),
                  Spacing.h(12),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: suggestions.map((suggestion) {
                      return GestureDetector(
                        onTap: () => controller.onSuggestionTap(suggestion),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: '#FFF2E8'.toColor(),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: '#FF6B35'.toColor().withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: AutoTranslateText(
                            suggestion,
                            style: MyTextTheme.smallBCN.copyWith(
                              color: '#FF6B35'.toColor(),
                            ).merge(AppTypography.body2),
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
    
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isUser ? '#FFF2E8'.toColor() : '#ffffff'.toColor(),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isUser
              ? '#FF6B35'.toColor().withOpacity(0.5)
              : '#F5D7B8'.toColor(),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: (isUser ? '#FF6B35' : '#FF6B35').toColor().withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUser ? Icons.person : Icons.auto_awesome,
              color: '#FF6B35'.toColor(),
              size: 18.w,
            ),
          ),
          Spacing.w(12),
          Expanded(
            child: AutoTranslateText(
              message,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: '#3E2723'.toColor(),
                height: 1.5,
                fontWeight: FontWeight.w500,
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
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: '#F1F8E9'.toColor(),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: '#8BC34A'.toColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.mic,
            color: '#8BC34A'.toColor(),
            size: 18.w,
          ),
          Spacing.w(8),
          Expanded(
            child: AutoTranslateText(
              text,
              style: MyTextTheme.smallBCN.copyWith(
                color: '#666666'.toColor(),
                fontStyle: FontStyle.italic,
              ).merge(AppTypography.body2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'What AI Guide Can Do',
            style: MyTextTheme.largeBCB.copyWith(
              color: '#3E2723'.toColor(),
              fontWeight: FontWeight.bold,
            ).merge(AppTypography.h2),
          ),
          Spacing.h(16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildFeatureCard(
                      icon: Icons.voice_chat,
                      title: 'Voice Commands',
                      description: 'Speak naturally.',
                    ),
                    Spacing.h(12),
                    _buildFeatureCard(
                      icon: Icons.text_fields,
                      title: 'AutoTranslateText Input',
                      description: 'Type your questions.',
                    ),
                    Spacing.h(12),
                    _buildFeatureCard(
                      icon: Icons.language,
                      title: 'Multi-Language',
                      description: '14+ languages.',
                    ),
                  ],
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: Column(
                  children: [
                    _buildFeatureCard(
                      icon: Icons.navigation,
                      title: 'Smart Navigation',
                      description: 'Auto-direct to pages.',
                    ),
                    Spacing.h(12),
                    _buildFeatureCard(
                      icon: Icons.psychology,
                      title: 'AI Powered',
                      description: 'Intelligent responses.',
                    ),
                    Spacing.h(12),
                    _buildFeatureCard(
                      icon: Icons.offline_bolt,
                      title: 'Offline Ready',
                      description: 'Works without internet.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return SizedBox(
      height: 158.h,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: '#ffffff'.toColor(),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: '#F5D7B8'.toColor(),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: '#FFF2E8'.toColor(),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: '#FF6B35'.toColor(),
                size: 22.w,
              ),
            ),
            Spacing.h(10),
            AutoTranslateText(
              title,
              style: MyTextTheme.mediumBCB.copyWith(
                color: '#3E2723'.toColor(),
                fontWeight: FontWeight.bold,
              ).merge(AppTypography.body1),
            ),
            Spacing.h(4),
            Expanded(
              child: AutoTranslateText(
                description,
                style: MyTextTheme.smallBCN.copyWith(
                  color: '#666666'.toColor(),
                  height: 1.25,
                ).merge(AppTypography.body2),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              '#FF6B35'.toColor(),
              '#FF8C42'.toColor(),
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
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
                      '#FF8C42'.toColor().withOpacity(0.35),
                      '#FF6B35'.toColor().withOpacity(0.15),
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
                      'About AI Guide',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: '#ffffff'.toColor(),
                        fontWeight: FontWeight.bold,
                      ).merge(AppTypography.h2),
                    ),
                  ],
                ),
                Spacing.h(12),
                AutoTranslateText(
                  'AI Guide is your intelligent astrology assistant powered by advanced AI. Ask questions naturally, get instant responses, and navigate to any astrology service with voice or text commands.',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: '#ffffff'.toColor(),
                    height: 1.5,
                  ).merge(AppTypography.body1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(AiGuiderController controller) {
    final textController = TextEditingController();

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: '#ffffff'.toColor(),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: '#3E2723'.toColor(),
                  ).merge(AppTypography.body1),
                  decoration: InputDecoration(
                    hintText: 'Type your question...',
                    hintStyle: MyTextTheme.mediumBCN.copyWith(
                      color: '#999999'.toColor(),
                    ).merge(AppTypography.body1),
                    filled: true,
                    fillColor: '#F5F5F5'.toColor(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 14.h,
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      controller.submitTextQuery(value);
                      textController.clear();
                    }
                  },
                ),
              ),
              Spacing.w(12),
              Obx(() => GestureDetector(
                    onTap: () => controller.toggleListening(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: controller.isListening.value
                              ? [
                                  '#F44336'.toColor(),
                                  '#E91E63'.toColor(),
                                ]
                              : [
                                  '#FF6B35'.toColor(),
                                  '#FF8C42'.toColor(),
                                ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (controller.isListening.value
                                    ? '#F44336'.toColor()
                                    : '#FF6B35'.toColor())
                                .withOpacity(0.5),
                            blurRadius: 15.r,
                            spreadRadius: 2.r,
                          ),
                        ],
                      ),
                      child: Icon(
                        controller.isListening.value
                            ? Icons.mic
                            : Icons.mic_none,
                        color: Colors.white,
                        size: 28.w,
                      ),
                    ),
                  )),
            ],
          ),
          Spacing.h(12),
          AutoTranslateText(
            'Tap mic to speak or type your question',
            style: MyTextTheme.smallBCN.copyWith(
              color: '#999999'.toColor(),
            ).merge(AppTypography.label),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector(AiGuiderController controller) async {
    String? previousLanguage;
    
    if (Get.isRegistered<LanguageController>()) {
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
          constraints: BoxConstraints(
            maxHeight: Get.height * 0.8,
          ),
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
                    style: MyTextTheme.largeBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                    ).merge(AppTypography.h2),
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
    
    if (Get.isRegistered<LanguageController>()) {
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
