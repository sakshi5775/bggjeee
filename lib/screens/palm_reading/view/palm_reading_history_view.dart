import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/palm_reading_model.dart';
import 'package:astrobharataiuser/screens/palm_reading/controller/palm_reading_history_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PalmReadingHistoryView extends StatelessWidget {
  const PalmReadingHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PalmReadingHistoryController());
    final isMobile = MediaQuery.of(context).size.width < 768;
    final maxWidth = isMobile ? double.infinity : 600.w;

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Light yellow background
        body: Column(
          children: [
            const CommonHeader(title: 'History'),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    children: [
                      // Search and Filter Section
                      _buildSearchAndFilterSection(controller),

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
                                // Show "Load More" button at the end (only if no search query)
                                if (index == filteredList.length &&
                                    controller.hasMore &&
                                    controller.searchQuery.value.isEmpty) {
                                  return _buildLoadMoreButton(controller);
                                }

                                final item = filteredList[index];
                                return _buildHistoryItem(
                                  context,
                                  controller,
                                  item,
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

  Widget _buildSearchAndFilterSection(PalmReadingHistoryController controller) {
    return Container(
      padding: AppPaddings.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: controller.searchController,
            onChanged: controller.onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search by name...',
              hintStyle: MyTextTheme.mediumBCN.copyWith(
                color: Colors.grey[500],
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey[600],
                size: 20.w,
              ),
              suffixIcon: Obx(
                () => controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey[600],
                          size: 20.w,
                        ),
                        onPressed: controller.clearSearch,
                      )
                    : const SizedBox.shrink(),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
            style: MyTextTheme.mediumBCB.copyWith(
              color: const Color(0xFF5F2221),
            ),
          ),
          Spacing.h(12),
          // Filter Row
          Row(
            children: [
              // Status Filter
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Obx(
                    () => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedStatus.value.isEmpty
                            ? null
                            : controller.selectedStatus.value,
                        isExpanded: true,
                        hint: Row(
                          children: [
                            Icon(
                              Icons.filter_list,
                              color: Colors.grey[600],
                              size: 18.w,
                            ),
                            Spacing.w(8),
                            AutoTranslateText(
                              controller.statusDisplayText,
                              style: MyTextTheme.mediumBCN.copyWith(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        items: controller.statusOptions.map((status) {
                          String displayText;
                          switch (status) {
                            case 'PROCESSING':
                              displayText = 'Processing';
                              break;
                            case 'COMPLETED':
                              displayText = 'Completed';
                              break;
                            case 'FAILED':
                              displayText = 'Failed';
                              break;
                            default:
                              displayText = 'All Status';
                          }
                          return DropdownMenuItem<String>(
                            value: status.isEmpty ? null : status,
                            child: AutoTranslateText(
                              displayText,
                              style: MyTextTheme.mediumBCN.copyWith(
                                color: const Color(0xFF5F2221),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: controller.onStatusFilterChanged,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey[600],
                          size: 24.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Spacing.w(12),
              // Clear Filters Button
              Obx(
                () =>
                    (controller.searchQuery.value.isNotEmpty ||
                        controller.selectedStatus.value.isNotEmpty)
                    ? TextButton.icon(
                        onPressed: controller.clearFilters,
                        icon: Icon(
                          Icons.clear_all,
                          size: 18.w,
                          color: "#F38B3B".toColor(),
                        ),
                        label: AutoTranslateText(
                          'Clear',
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: "#F38B3B".toColor(),
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(PalmReadingHistoryController controller) {
    final hasFilters =
        controller.searchQuery.value.isNotEmpty ||
        controller.selectedStatus.value.isNotEmpty;

    return Center(
      child: Padding(
        padding: AppPaddings.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasFilters ? Icons.search_off : Icons.history,
              size: 80.w,
              color: Colors.grey[400],
            ),
            Spacing.h(24),
            AutoTranslateText(
              hasFilters ? 'No Results Found' : 'No History Yet',
              style: MyTextTheme.largeBCB.copyWith(
                color: const Color(0xFF5F2221),
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.h(8),
            AutoTranslateText(
              hasFilters
                  ? 'Try adjusting your search or filter criteria'
                  : 'Your palm reading history will appear here',
              style: MyTextTheme.mediumBCN.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              Spacing.h(16),
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: ElevatedButton(
                  onPressed: controller.clearFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: AutoTranslateText(
                    'Clear Filters',
                    style: MyTextTheme.mediumBCB.copyWith(color: Colors.white),
                  ),
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
    PalmReadingHistoryController controller,
    PalmReadingData item,
  ) {
    final date = item.createdAt;
    final summary = item.summary.isNotEmpty
        ? item.summary
        : (item.overallReading.isNotEmpty
              ? item.overallReading
              : 'Palm Reading');
    final handType = item.handType;
    final status = item.status ?? 'COMPLETED';
    final userName = item.userInput?.name ?? 'Unknown';
    final isFailed = status == 'FAILED' || handType.toUpperCase() == 'UNKNOWN';

    return GestureDetector(
      onTap: () => controller.onHistoryItemTap(item),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: AppPaddings.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail image
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.pan_tool,
                            size: 40.w,
                            color: Colors.grey[400],
                          );
                        },
                      )
                    : Icon(Icons.pan_tool, size: 40.w, color: Colors.grey[400]),
              ),
            ),
            Spacing.w(16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and hand type
                  Row(
                    children: [
                      Expanded(
                        child: AutoTranslateText(
                          userName,
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: const Color(0xFF5F2221),
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Spacing.w(8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: isFailed
                              ? Colors.red.withValues(alpha: 0.1)
                              : "#F38B3B".toColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: AutoTranslateText(
                          handType.isNotEmpty ? handType : 'UNKNOWN',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: isFailed ? Colors.red : "#F38B3B".toColor(),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacing.h(6),
                  // Summary
                  AutoTranslateText(
                    summary,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: const Color(0xFF5F2221),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacing.h(8),
                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14.w,
                        color: Colors.grey[600],
                      ),
                      Spacing.w(4),
                      AutoTranslateText(
                        controller.formatDate(date),
                        style: MyTextTheme.smallBCN.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow icon
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 24.w),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton(PalmReadingHistoryController controller) {
    return Obx(() {
      if (controller.isLoadingMore.value) {
        return Container(
          padding: AppPaddings.all(16),
          alignment: Alignment.center,
          child: Column(
            children: [
              const CircularProgressIndicator(color: AppColors.saffron),
              Spacing.h(8),
              AutoTranslateText(
                'Loading more...',
                style: MyTextTheme.smallBCN.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      if (!controller.hasMore) {
        return Container(
          padding: AppPaddings.all(16),
          alignment: Alignment.center,
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 24.w,
                color: Colors.grey[400],
              ),
              Spacing.h(8),
              AutoTranslateText(
                'All ${controller.totalItems} items loaded',
                style: MyTextTheme.smallBCN.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      final remainingItems =
          controller.totalItems - controller.historyList.length;
      return Container(
        padding: AppPaddings.all(16),
        child: Column(
          children: [
            if (controller.totalItems > 0)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: AutoTranslateText(
                  'Showing ${controller.historyList.length} of ${controller.totalItems} items',
                  style: MyTextTheme.smallBCN.copyWith(color: Colors.grey[600]),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: ElevatedButton(
                onPressed: controller.loadMore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoTranslateText(
                      'Load More ($remainingItems remaining)',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacing.w(8),
                    Icon(Icons.arrow_downward, size: 18.w, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

