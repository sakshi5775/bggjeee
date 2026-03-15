import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/support_ticket_model.dart';
import 'package:astrobharataiuser/screens/support/controller/support_ticket_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:intl/intl.dart';

class SupportTicketsListView extends GetView<SupportTicketController> {
  final bool showBackButton;
  const SupportTicketsListView({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            gradient: AppColors.orangeGradient,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepOrange.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: () => UserMainController.pushInCurrentTab(AppRoutes.createSupportTicket),
            backgroundColor: Colors.transparent,
            elevation: 0,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const AutoTranslateText(
              'New Ticket',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: Column(
          children: [
            CommonHeader(
              title: 'Support Tickets',
              showBackButton: showBackButton,
            ),
            Obx(() => _buildFilters()),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingTickets.value &&
                    controller.tickets.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.tickets.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.support_agent_outlined,
                          size: 64.sp,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 16.h),
                        AutoTranslateText(
                          'No tickets found',
                          style: AppTypography.h2.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        AutoTranslateText(
                          'Create a new ticket to get support',
                          style: AppTypography.body1.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.loadTickets(refresh: true),
                  child: ListView.separated(
                    padding: EdgeInsets.all(16.w),
                    itemCount:
                        controller.tickets.length +
                        (controller.pagination.value?.hasNextPage == true
                            ? 1
                            : 0),
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      if (index == controller.tickets.length) {
                        // Load more indicator
                        controller.loadMoreTickets();
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final ticket = controller.tickets[index];
                      return _TicketCard(ticket: ticket);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  label: 'Status',
                  value: controller.selectedStatus.value,
                  items: ['All', ...SupportTicketController.statusOptions],
                  onChanged: (value) {
                    controller.selectedStatus.value = value == 'All'
                        ? null
                        : value;
                    controller.applyFilters();
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildFilterDropdown(
                  label: 'Category',
                  value: controller.selectedCategory.value,
                  items: ['All', ...SupportTicketController.categoryOptions],
                  onChanged: (value) {
                    controller.selectedCategory.value = value == 'All'
                        ? null
                        : value;
                    controller.applyFilters();
                  },
                ),
              ),
            ],
          ),
          if (controller.selectedStatus.value != null ||
              controller.selectedCategory.value != null)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: TextButton.icon(
                onPressed: controller.clearFilters,
                icon: const Icon(Icons.clear, size: 18),
                label: const AutoTranslateText('Clear Filters'),
                style: TextButton.styleFrom(foregroundColor: AppColors.saffron),
              ),
            ),
        ],
      ),
    );
  }

  static String _statusDisplayLabel(String value) {
    if (value == 'All') return value;
    switch (value) {
      case 'OPEN': return 'Open';
      case 'UNDER_REVIEW': return 'Under Review';
      case 'RESOLVED': return 'Resolved';
      case 'CLOSED': return 'Closed';
      default: return value;
    }
  }

  Widget _buildFilterDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    final isStatus = label == 'Status';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value ?? 'All',
          isExpanded: true,
          hint: AutoTranslateText(label),
          items: items.map((item) {
            final display = isStatus ? _statusDisplayLabel(item) : item;
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                display,
                style: AppTypography.body1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final SupportTicketModel ticket;

  const _TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SupportTicketController>();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: () => UserMainController.pushInCurrentTab(
          AppRoutes.supportTicketDetail,
          arguments: ticket.ticketId,
        ),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AutoTranslateText(
                      ticket.subject,
                      style: AppTypography.h3.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (ticket.unreadByReporter)
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: const BoxDecoration(
                        color: AppColors.saffron,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  _buildChip(
                    label: ticket.status,
                    color: controller.getStatusColor(ticket.status),
                  ),
                  SizedBox(width: 8.w),
                  _buildChip(label: ticket.category, color: AppColors.info),
                  SizedBox(width: 8.w),
                  _buildChip(
                    label: ticket.priority,
                    color: controller.getPriorityColor(ticket.priority),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              AutoTranslateText(
                ticket.description,
                style: AppTypography.body1.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    'ID: ${ticket.ticketId}',
                    style: AppTypography.body2.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  AutoTranslateText(
                    _formatDate(ticket.createdAt),
                    style: AppTypography.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip({required String label, required Color color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: AutoTranslateText(
        label,
        style: AppTypography.label.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return '${difference.inMinutes}m ago';
        }
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return DateFormat('dd MMM yyyy').format(date);
      }
    } catch (e) {
      return dateStr;
    }
  }
}
