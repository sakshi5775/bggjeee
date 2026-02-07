import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/astrologer_chat_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/controllers/astrologer_chat_history_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AstrologerChatHistoryView extends StatelessWidget {
  const AstrologerChatHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AstrologerChatHistoryController());
    final isMobile = MediaQuery.of(context).size.width < 768;
    final maxWidth = isMobile ? double.infinity : 600.w;

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const CommonHeader(title: 'Chat History', showSearch: false),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    children: [
                      // Search Section
                      _buildSearchSection(controller),

                      // Content Section
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoading.value &&
                              controller.historyList.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.saffron,
                              ),
                            );
                          }

                          final filteredList = controller.filteredHistoryList;

                          if (filteredList.isEmpty &&
                              !controller.isLoading.value) {
                            return _buildEmptyState(controller);
                          }

                          return RefreshIndicator(
                            onRefresh: () =>
                                controller.loadHistory(reset: true),
                            color: AppColors.saffron,
                            child: ListView.builder(
                              padding: AppPaddings.all(16),
                              itemCount:
                                  filteredList.length +
                                  (controller.hasMore &&
                                          controller.searchQuery.value.isEmpty
                                      ? 1
                                      : 0),
                              itemBuilder: (context, index) {
                                // Show "Load More" button at the end
                                if (index == filteredList.length &&
                                    controller.hasMore &&
                                    controller.searchQuery.value.isEmpty) {
                                  return _buildLoadMoreButton(controller);
                                }

                                final session = filteredList[index];
                                return _buildHistoryItem(
                                  context,
                                  controller,
                                  session,
                                );
                              },
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection(AstrologerChatHistoryController controller) {
    return Container(
      padding: AppPaddings.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8F0),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
              ),
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search by chat ID or status...',
                  hintStyle: MyTextTheme.smallBCN.copyWith(
                    color: Colors.grey[600],
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                    size: 20.w,
                  ),
                  suffixIcon: Obx(
                    () => controller.searchQuery.value.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, size: 20.w),
                            onPressed: controller.clearSearch,
                          )
                        : const SizedBox.shrink(),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AstrologerChatHistoryController controller) {
    final hasSearch = controller.searchQuery.value.isNotEmpty;

    return Center(
      child: Padding(
        padding: AppPaddings.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasSearch ? Icons.search_off : Icons.chat_bubble_outline,
              size: 80.w,
              color: Colors.grey[400],
            ),
            Spacing.h(24),
            AutoTranslateText(
              hasSearch ? 'No Results Found' : 'No Chat History Yet',
              style: MyTextTheme.largeBCB
                  .copyWith(
                    color: const Color(0xFF5F2221),
                    fontWeight: FontWeight.bold,
                  )
                  .merge(AppTypography.h2),
            ),
            Spacing.h(8),
            AutoTranslateText(
              hasSearch
                  ? 'Try adjusting your search criteria'
                  : 'Your chat session history will appear here',
              style: MyTextTheme.mediumBCN.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            if (hasSearch) ...[
              Spacing.h(16),
              ElevatedButton(
                onPressed: controller.clearSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.saffron,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: AutoTranslateText(
                  'Clear Search',
                  style: MyTextTheme.mediumBCB.copyWith(color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    AstrologerChatHistoryController controller,
    AstrologerChatSession session,
  ) {
    final stats = session.messageStats;
    final status = session.status;
    final date = session.completedAt ?? session.createdAt;
    final statusColor = controller.getStatusColor(status);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: AppPaddings.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Status and Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: statusColor, width: 1),
                ),
                child: AutoTranslateText(
                  status.toUpperCase(),
                  style: MyTextTheme.smallBCB
                      .copyWith(color: statusColor, fontWeight: FontWeight.w600)
                      .merge(AppTypography.label),
                ),
              ),
              AutoTranslateText(
                controller.formatDate(date),
                style: MyTextTheme.smallBCN.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
          Spacing.h(12),

          // Chat ID
          AutoTranslateText(
            'Chat ID: ${session.chatId}',
            style: MyTextTheme.smallBCN.copyWith(
              color: const Color(0xFF666666),
            ),
          ),
          Spacing.h(12),

          // Message Stats
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8F0),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total', '${stats.totalMessages}', Icons.chat),
                _buildStatItem('You', '${stats.userMessages}', Icons.person),
                _buildStatItem(
                  'Astrologer',
                  '${stats.astrologerMessages}',
                  Icons.psychology,
                ),
                _buildStatItem('Images', '${stats.imagesShared}', Icons.image),
              ],
            ),
          ),
          Spacing.h(12),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Navigate to chat view
                    // Note: You'll need astrologer info to navigate
                    // For now, show a message
                    Get.snackbar(
                      'Chat Session',
                      'Opening chat session...',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  icon: Icon(Icons.chat, size: 18.w),
                  label: AutoTranslateText(
                    'View Chat',
                    style: MyTextTheme.smallBCB.copyWith().merge(
                      AppTypography.body2,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.saffron,
                    side: BorderSide(color: AppColors.saffron),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () =>
                      controller.downloadChatTranscript(session.chatId),
                  icon: Icon(Icons.download, size: 18.w),
                  label: AutoTranslateText(
                    'Download',
                    style: MyTextTheme.smallBCB
                        .copyWith(color: Colors.white)
                        .merge(AppTypography.body2),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.saffron,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20.w, color: AppColors.saffron),
        Spacing.h(4),
        AutoTranslateText(
          value,
          style: MyTextTheme.mediumBCB.copyWith(
            color: const Color(0xFF5F2221),
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.h(2),
        AutoTranslateText(
          label,
          style: MyTextTheme.smallBCN
              .copyWith(color: Colors.grey[600])
              .merge(AppTypography.label),
        ),
      ],
    );
  }

  Widget _buildLoadMoreButton(AstrologerChatHistoryController controller) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Center(
          child: controller.isLoadingMore.value
              ? const CircularProgressIndicator(color: AppColors.saffron)
              : ElevatedButton(
                  onPressed: controller.loadMore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.saffron,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: AutoTranslateText(
                    'Load More',
                    style: MyTextTheme.mediumBCB.copyWith(color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }
}
