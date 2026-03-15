import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/screens/ai_chat/controllers/ai_chat_controller.dart';
import 'package:astrobharataiuser/screens/ai_chat/widgets/chat_profile_dialog.dart';
import 'package:astrobharataiuser/screens/ai_chat/widgets/empty_state_widget.dart';
import 'package:astrobharataiuser/screens/ai_chat/widgets/persona_card.dart';
import 'package:astrobharataiuser/screens/ai_chat/widgets/persona_list_card.dart';
import 'package:astrobharataiuser/services/chat_call_precheck_service.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/profile_check_helper.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class AiChatView extends BasePage<AiChatController> {
  final bool showBackButton;

  /// When true, header (logo, back, wallet, search) is hidden — e.g. when embedded below dashboard slider.
  final bool hideHeader;

  /// When set, this widget is shown at the top of the scroll (banner), then the persona grid/list — same pattern as AllAstrologersView.
  final Widget? bannerWidget;

  const AiChatView({
    super.key,
    this.showBackButton = true,
    this.hideHeader = false,
    this.bannerWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: hideHeader
          ? null
          : BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: SafeArea(
          top: !hideHeader,
          bottom: false,
          child: Column(
            children: [
              if (!hideHeader)
                CommonHeader(
                  title: 'AI Chat',
                  showBackButton: showBackButton,
                  onBackTap: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else if (Get.isRegistered<UserMainController>()) {
                      Get.find<UserMainController>().handleBackNavigation();
                    }
                  },
                ),

              // View toggle row
              Align(
                alignment: Alignment.topRight,
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

              SizedBox(height: 1.h),

              // Personas: with banner as first sliver, or plain list
              Expanded(
                child: bannerWidget != null
                    ? _buildScrollWithBanner(context)
                    : _buildContentWithoutBanner(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentWithoutBanner(BuildContext context) {
    return Obx(() {
      final filteredList = controller.filteredPersonas;

      if (controller.isLoading.value && controller.personas.isEmpty) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.deepOrange),
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
    });
  }

  Widget _buildScrollWithBanner(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refresh,
      color: AppColors.deepOrange,
      child: Obx(() {
        final filteredList = controller.filteredPersonas;

        if (controller.isLoading.value && controller.personas.isEmpty) {
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: bannerWidget),
              SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.deepOrange,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        if (filteredList.isEmpty) {
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: bannerWidget),
              SliverFillRemaining(
                child: EmptyStateWidget(
                  isEmpty: controller.personas.isEmpty,
                  hasFilter:
                      controller.selectedCategory.value != null ||
                      controller.searchQuery.value.isNotEmpty,
                  onClearFilter: () {
                    controller.clearFilter();
                    controller.searchQuery.value = '';
                    controller.searchController.clear();
                  },
                ),
              ),
            ],
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!controller.isLoadingMore.value &&
                controller.hasMoreData.value &&
                scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 200) {
              controller.loadMore();
            }
            return false;
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: bannerWidget),
              ..._buildContentSlivers(context, filteredList),
              SliverPadding(
                padding: EdgeInsets.only(
                  bottom: hideHeader ? 80.h : 16.h,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> _buildContentSlivers(
    BuildContext context,
    List<PersonaModel> filteredList,
  ) {
    return [
      Obx(() {
        if (controller.isGridView.value) {
          return SliverPadding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 8.h,
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.68,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == filteredList.length) {
                    return controller.isLoadingMore.value
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.deepOrange,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  }
                  return PersonaCard(
                    persona: filteredList[index],
                    onTap: () {
                      UserMainController.pushInCurrentTab(
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
                      final canProceed = await precheckService
                          .checkBeforeProceeding(
                        persona: persona,
                        pricePerMinute: persona.callPricePerMinute ?? persona.pricePerMin,
                        estimatedMinutes: 15,
                      );
                      if (canProceed) {
                        UserMainController.pushInCurrentTab(
                          AppRoutes.personaVoiceCall,
                          arguments: {
                            'personaId': persona.id,
                            'persona': persona,
                          },
                        );
                      }
                    },
                    onChatTap: () async {
                      await _startChatWithPersona(
                        context,
                        filteredList[index],
                      );
                    },
                  );
                },
                childCount: filteredList.length +
                    (controller.hasMoreData.value ? 1 : 0),
              ),
            ),
          );
        }
        return SliverPadding(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 8.h,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == filteredList.length) {
                  return controller.isLoadingMore.value
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.deepOrange,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                }
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: PersonaListCard(
                    persona: filteredList[index],
                    onTap: () {
                      UserMainController.pushInCurrentTab(
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
                      final canProceed = await precheckService
                          .checkBeforeProceeding(
                        persona: persona,
                        pricePerMinute: persona.callPricePerMinute ?? persona.pricePerMin,
                        estimatedMinutes: 15,
                      );
                      if (canProceed) {
                        UserMainController.pushInCurrentTab(
                          AppRoutes.personaVoiceCall,
                          arguments: {
                            'personaId': persona.id,
                            'persona': persona,
                          },
                        );
                      }
                    },
                    onChatTap: () async {
                      await _startChatWithPersona(
                        context,
                        filteredList[index],
                      );
                    },
                  ),
                );
              },
              childCount: filteredList.length +
                  (controller.hasMoreData.value ? 1 : 0),
            ),
          ),
        );
      }),
    ];
  }

  Widget _buildGridView(
    BuildContext context,
    List<PersonaModel> filteredList,
    AiChatController controller,
  ) {
    return GridView.builder(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 8.h,
        bottom: hideHeader ? 80.h : 8.h,
      ),
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
            UserMainController.pushInCurrentTab(
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
              pricePerMinute: persona.callPricePerMinute ?? persona.pricePerMin,
              estimatedMinutes: 1,
            );
            if (canProceed) {
              UserMainController.pushInCurrentTab(
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
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 8.h,
        bottom: hideHeader ? 80.h : 8.h,
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

        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: PersonaListCard(
            persona: filteredList[index],
            onTap: () {
              UserMainController.pushInCurrentTab(
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
                pricePerMinute: persona.chatPricePerMinute ?? persona.pricePerMin,
                estimatedMinutes: 15,
              );
              if (canProceed) {
                UserMainController.pushInCurrentTab(
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
      pricePerMinute: persona.chatPricePerMinute ?? persona.pricePerMin,
      estimatedMinutes: 15,
    );
    if (!canProceed) return;

    final profileHelper = ProfileCheckHelper();
    final existingProfile = await profileHelper.getUserProfile();
    if (!context.mounted) return;
    final profileResult = await showPersonaChatProfileDialog(
      context,
      existingProfile,
    );
    if (profileResult == null) return;

    UserMainController.pushInCurrentTab(
      AppRoutes.personaChat,
      arguments: {
        'persona': persona,
        'chatProfile': profileResult.profile,
        'languageCode': profileResult.languageCode,
      },
    );
  }
}
