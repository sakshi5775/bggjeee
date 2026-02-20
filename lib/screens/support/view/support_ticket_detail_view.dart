import 'package:astrobharataiuser/app_manager/common/image_picker.dart';
import 'package:astrobharataiuser/data_model/support_ticket_model.dart';
import 'package:astrobharataiuser/screens/support/controller/support_ticket_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SupportTicketDetailView extends StatefulWidget {
  final String ticketId;

  const SupportTicketDetailView({super.key, required this.ticketId});

  @override
  State<SupportTicketDetailView> createState() =>
      _SupportTicketDetailViewState();
}

class _SupportTicketDetailViewState extends State<SupportTicketDetailView> {
  final replyController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final controller = Get.find<SupportTicketController>();
    controller.loadTicketDetails(widget.ticketId);
  }

  @override
  void dispose() {
    replyController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SupportTicketController>();

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            CommonHeader(title: 'Ticket Details'),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingTicketDetails.value &&
                    controller.selectedTicket.value == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                final ticket = controller.selectedTicket.value;
                if (ticket == null) {
                  return Center(
                    child: AutoTranslateText(
                      'Ticket not found',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ).merge(AppTypography.h3),
                    ),
                  );
                }

                final isClosed = controller.isTicketClosed(ticket.status);

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTicketHeader(ticket, controller),
                            SizedBox(height: 16.h),
                            _buildTicketInfo(ticket, controller),
                            SizedBox(height: 16.h),
                            _buildDescription(ticket),
                            if (ticket.attachments.isNotEmpty) ...[
                              SizedBox(height: 16.h),
                              _buildAttachments(ticket.attachments),
                            ],
                            SizedBox(height: 24.h),
                            _buildActivitiesSection(controller),
                          ],
                        ),
                      ),
                    ),
                    if (!isClosed) _buildReplySection(controller),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketHeader(
    SupportTicketModel ticket,
    SupportTicketController controller,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ).merge(AppTypography.h2),
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
            SizedBox(height: 12.h),
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
              'Ticket ID: ${ticket.ticketId}',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketInfo(
    SupportTicketModel ticket,
    SupportTicketController controller,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildInfoRow('Created', _formatDate(ticket.createdAt)),
            if (ticket.lastReplyAt != null)
              _buildInfoRow('Last Reply', _formatDate(ticket.lastReplyAt!)),
            if (ticket.assignedToUserId != null)
              _buildInfoRow('Assigned To', ticket.assignedToUserId!),
            if (ticket.tags.isNotEmpty)
              _buildInfoRow('Tags', ticket.tags.join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: AutoTranslateText(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: AutoTranslateText(
              value,
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(SupportTicketModel ticket) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ).merge(AppTypography.h3),
            ),
            SizedBox(height: 8.h),
            AutoTranslateText(
              ticket.description,
              style: TextStyle(color: AppColors.textPrimary, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachments(List<Attachment> attachments) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              'Attachments (${attachments.length})',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ).merge(AppTypography.h3),
            ),
            SizedBox(height: 12.h),
            ...attachments.map(
              (attachment) => _buildAttachmentItem(attachment),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentItem(Attachment attachment) {
    final isImage = attachment.mimeType.startsWith('image/');

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Row(
        children: [
          Icon(
            isImage ? Icons.image : Icons.description,
            color: AppColors.saffron,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  attachment.originalName,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AutoTranslateText(
                  _formatFileSize(attachment.size),
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new, color: AppColors.saffron),
            onPressed: () {
              // Open attachment URL
              // You can use url_launcher or webview
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesSection(SupportTicketController controller) {
    if (controller.ticketActivities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Conversation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        ...controller.ticketActivities.map(
          (activity) => _buildActivityItem(activity),
        ),
      ],
    );
  }

  Widget _buildActivityItem(TicketActivity activity) {
    final isReporter = activity.senderModel == 'User';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isReporter ? AppColors.saffron.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isReporter
              ? AppColors.saffron.withOpacity(0.3)
              : AppColors.dividerLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                isReporter ? 'You' : 'Support Team',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isReporter ? AppColors.saffron : AppColors.textPrimary,
                ),
              ),
              AutoTranslateText(
                _formatDate(activity.createdAt),
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          AutoTranslateText(
            activity.message,
            style: TextStyle(color: AppColors.textPrimary, height: 1.5),
          ),
          if (activity.attachments.isNotEmpty) ...[
            SizedBox(height: 12.h),
            ...activity.attachments.map(
              (attachment) => _buildAttachmentItem(attachment),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReplySection(SupportTicketController controller) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Form(
        key: controller.replyFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.replyAttachments.isNotEmpty) ...[
              SizedBox(
                height: 60.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.replyAttachments.length,
                  itemBuilder: (context, index) {
                    final file = controller.replyAttachments[index];
                    return Container(
                      margin: EdgeInsets.only(right: 8.w),
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: AppColors.lightBackground,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.dividerLight),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.file(
                              file,
                              width: 60.w,
                              height: 60.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () =>
                                  controller.removeReplyAttachment(index),
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: const BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 12.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 8.h),
            ],
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: replyController,
                    decoration: InputDecoration(
                      hintText: 'Type your reply...',
                      filled: true,
                      fillColor: AppColors.lightBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                    maxLines: 3,
                    maxLength: 5000,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Message is required';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                IconButton(
                  onPressed: () => _pickReplyAttachment(context, controller),
                  icon: const Icon(Icons.attach_file),
                  color: AppColors.saffron,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => Container(
                  decoration: BoxDecoration(
                    gradient: controller.isSendingReply.value
                        ? null
                        : AppColors.orangeGradient,
                    color: controller.isSendingReply.value
                        ? Colors.grey[300]
                        : null,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: controller.isSendingReply.value
                        ? null
                        : [
                            BoxShadow(
                              color: AppColors.deepOrange.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: ElevatedButton(
                    onPressed: controller.isSendingReply.value
                        ? null
                        : () async {
                            controller.replyMessageController.text =
                                replyController.text;
                            final success = await controller.replyToTicket(
                              widget.ticketId,
                            );
                            if (success) {
                              replyController.clear();
                              // Scroll to bottom
                              Future.delayed(
                                const Duration(milliseconds: 300),
                                () {
                                  if (scrollController.hasClients) {
                                    scrollController.animateTo(
                                      scrollController.position.maxScrollExtent,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeOut,
                                    );
                                  }
                                },
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: controller.isSendingReply.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : AutoTranslateText(
                            'Send Reply',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip({required String label, required Color color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: AutoTranslateText(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ).merge(AppTypography.label),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _pickReplyAttachment(
    BuildContext context,
    SupportTicketController controller,
  ) async {
    try {
      final file = await ImagePickerHelper.pickDocument(
        context: context,
        title: 'Select Attachment',
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'gif', 'pdf'],
        maxSizeInMB: 5,
      );
      if (file != null) {
        if (controller.replyAttachments.length < 5) {
          controller.replyAttachments.add(file);
        } else {
          Get.snackbar(
            'Limit Reached',
            'Maximum 5 attachments allowed',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.error,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick file: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }
}
