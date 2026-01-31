import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/screens/ai_chat/controllers/ai_chat_controller.dart';
import 'package:astrobharataiuser/screens/ai_chat/widgets/category_filter_chips.dart';
import 'package:astrobharataiuser/screens/ai_chat/widgets/chat_profile_dialog.dart';
import 'package:astrobharataiuser/screens/ai_chat/widgets/empty_state_widget.dart';
import 'package:astrobharataiuser/screens/ai_chat/widgets/persona_card.dart';
import 'package:astrobharataiuser/screens/ai_chat/widgets/persona_list_card.dart';
import 'package:astrobharataiuser/services/chat_call_precheck_service.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/profile_check_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class AiChatView extends BasePage<AiChatController> {
  final bool showBackButton;
  /// When true, header (logo, back, wallet, search) is hidden — e.g. when embedded below dashboard slider.
  final bool hideHeader;

  const AiChatView({super.key, this.showBackButton = true, this.hideHeader = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: hideHeader
          ? null
          : BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          top: !hideHeader,
          child: Column(
            children: [
              if (!hideHeader) _buildHeader(),

              // Category Filter Chips
              // SizedBox(height: 16.h),
              // const CategoryFilterChips(),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: GestureDetector(
                    onTap: () => controller.toggleViewMode(),
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      child: Obx(
                        () => Icon(
                          controller.isGridView.value
                              ? Icons.view_list
                              : Icons.grid_view,
                          size: 20.w,
                          color: const Color(0xFF5F2221),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Personas Grid
              Expanded(
                child: Obx(() {
                  final filteredList = controller.filteredPersonas;

                  if (controller.isLoading.value &&
                      controller.personas.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.deepOrange,
                        ),
                      ),
                    );
                  }

                  if (filteredList.isEmpty) {
                    return EmptyStateWidget(
                      isEmpty: controller.personas.isEmpty,
                      hasFilter:
                          controller.selectedCategory.value != null ||
                          controller.searchQuery.value.isNotEmpty,
                      onClearFilter: () {
                        controller.clearFilter();
                        controller.searchQuery.value = '';
                        controller.searchController.clear();
                      },
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.refresh,
                    color: AppColors.deepOrange,
                    child: Obx(
                      () => NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (!controller.isLoadingMore.value &&
                              controller.hasMoreData.value &&
                              scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent) {
                            controller.loadMore();
                          }
                          return false;
                        },
                        child: controller.isGridView.value
                            ? _buildGridView(context, filteredList, controller)
                            : _buildListView(context, filteredList, controller),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Stack(
        children: [
          // Animated fullchakra background
          Positioned(
            right: -30.w,
            top: -20.h,
            child: _AnimatedChakra(
              child: SvgAssets(
                path: 'assets/app/fullchakra.svg',
                width: 150.w,
                height: 150.h,
              ),
            ),
          ),
          // Header content
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back arrow and title
              Expanded(
                child: Row(
                  children: [
                    // Back button (conditional)
                    if (showBackButton) ...[
                      GestureDetector(
                        onTap: () {
                          // When showBackButton is true, it means we navigated from elsewhere (not bottom nav)
                          // Since AI chat is in the main navigator (not nested), use Get.back()
                          try {
                            final context = Get.context;
                            if (context != null &&
                                Navigator.of(context).canPop()) {
                              Get.back();
                            } else {
                              // If can't pop, navigate to dashboard
                              Get.offAllNamed('/user-dashboard');
                            }
                          } catch (e) {
                            // If any error, navigate to dashboard
                            Get.offAllNamed('/user-dashboard');
                          }
                        },
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: '#68171E'.toColor().withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20.w,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                    ],
                    SvgAssets(
                      path: AppConstant.astroBharatLogo,
                      width: 150.w,
                      height: 30.h,
                    ),
                  ],
                ),
              ),
              // Right side icons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Wallet
                  _buildHeaderIcon(
                    icon: Icons.account_balance_wallet,

                    onTap: () {
                      Get.toNamed(AppRoutes.wallet);
                    },
                  ),
                  SizedBox(width: 8.w),
                  // Headphone

                  // Bell
                  // Search
                  _buildHeaderIcon(
                    icon: Icons.search,
                    onTap: () {
                      // TODO: Show search
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon({
    IconData? icon,
    String? label,
    VoidCallback? onTap,
    Widget? child,
  }) {
    if (label != null) {
      // Wallet with label
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            gradient: AppColors.orangeGradient,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: '#F38B3B'.toColor().withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon ?? Icons.account_balance_wallet,
                size: 20.w,
                color: Colors.white,
              ),
              SizedBox(width: 4.w),
              AutoTranslateText(
                label,
                style: MyTextTheme.smallBCB
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w600)
                    .merge(AppTypography.body2),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          gradient: AppColors.orangeGradient,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: '#F38B3B'.toColor().withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child:
            child ??
            Icon(icon ?? Icons.search, size: 20.w, color: Colors.white),
      ),
    );
  }

  Widget _buildGridView(
    BuildContext context,
    List<PersonaModel> filteredList,
    AiChatController controller,
  ) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.68,
      ),
      itemCount: filteredList.length + (controller.hasMoreData.value ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == filteredList.length) {
          // Load more indicator
          return Obx(
            () => controller.isLoadingMore.value
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.deepOrange,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          );
        }

        return PersonaCard(
          persona: filteredList[index],
          onTap: () {
            Get.toNamed(
              AppRoutes.personaDetail,
              arguments: {
                'personaId': filteredList[index].id,
                'persona': filteredList[index],
              },
            );
          },
          onCallTap: () async {
            final persona = filteredList[index];
            final precheckService = ChatCallPrecheckService();
            final canProceed = await precheckService.checkBeforeProceeding(
              persona: persona,
              pricePerMinute: persona.pricePerMin,
              estimatedMinutes: 15,
            );
            if (canProceed) {
              Get.toNamed(
                AppRoutes.personaVoiceCall,
                arguments: {'personaId': persona.id, 'persona': persona},
              );
            }
          },
          onChatTap: () async {
            await _startChatWithPersona(context, filteredList[index]);
          },
        );
      },
    );
  }

  Widget _buildListView(
    BuildContext context,
    List<PersonaModel> filteredList,
    AiChatController controller,
  ) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: filteredList.length + (controller.hasMoreData.value ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == filteredList.length) {
          // Load more indicator
          return Obx(
            () => controller.isLoadingMore.value
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.deepOrange,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          );
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: PersonaListCard(
            persona: filteredList[index],
            onTap: () {
              Get.toNamed(
                AppRoutes.personaDetail,
                arguments: {
                  'personaId': filteredList[index].id,
                  'persona': filteredList[index],
                },
              );
            },
            onCallTap: () async {
              final persona = filteredList[index];
              final precheckService = ChatCallPrecheckService();
              final canProceed = await precheckService.checkBeforeProceeding(
                persona: persona,
                pricePerMinute: persona.pricePerMin,
                estimatedMinutes: 15,
              );
              if (canProceed) {
                Get.toNamed(
                  AppRoutes.personaVoiceCall,
                  arguments: {'personaId': persona.id, 'persona': persona},
                );
              }
            },
            onChatTap: () async {
              await _startChatWithPersona(context, filteredList[index]);
            },
          ),
        );
      },
    );
  }

  Future<void> _startChatWithPersona(
    BuildContext context,
    PersonaModel persona,
  ) async {
    final precheckService = ChatCallPrecheckService();
    final canProceed = await precheckService.checkBeforeProceeding(
      persona: persona,
      pricePerMinute: persona.pricePerMin,
      estimatedMinutes: 15,
    );
    if (!canProceed) return;

    final profileHelper = ProfileCheckHelper();
    final existingProfile = await profileHelper.getUserProfile();
    final profileResult = await showPersonaChatProfileDialog(
      context,
      existingProfile,
    );
    if (profileResult == null) return;

    Get.toNamed(
      AppRoutes.personaChat,
      arguments: {
        'persona': persona,
        'chatProfile': profileResult.profile,
        'languageCode': profileResult.languageCode,
      },
    );
  }
}

// Animated Chakra Widget
class _AnimatedChakra extends StatefulWidget {
  final Widget child;

  const _AnimatedChakra({required this.child});

  @override
  State<_AnimatedChakra> createState() => _AnimatedChakraState();
}

class _AnimatedChakraState extends State<_AnimatedChakra>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: Opacity(opacity: 0.15, child: widget.child),
        );
      },
    );
  }
}
