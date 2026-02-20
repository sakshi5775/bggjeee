import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/data_model/order_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/order_detail_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value && controller.order.value == null) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.deepOrange),
              );
            }

            final order = controller.order.value;
            if (order == null) {
              return Column(
                children: [
                  CommonHeader(title: 'Order Details'),
                  Expanded(
                    child: Center(
                      child: AutoTranslateText(
                        'Unable to load order detail.',
                        style: TextStyle(
                          color: AppColors.textColorMaroon,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                CommonHeader(title: 'Order Details'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryCard(order, controller, context),
                        SizedBox(height: 20.h),
                        _buildItemsSection(order),
                        SizedBox(height: 20.h),
                        _buildAddressSection(
                          title: 'Billing Address',
                          address: order.billingAddress,
                        ),
                        if (order.shippingAddress != null) ...[
                          SizedBox(height: 20.h),
                          _buildAddressSection(
                            title: 'Shipping Address',
                            address: order.shippingAddress,
                          ),
                        ],
                        SizedBox(height: 20.h),
                        _buildPaymentSection(order),
                        SizedBox(height: 20.h),
                        _buildTimelineSection(controller),
                        SizedBox(height: 20.h),
                        _buildHistorySection(controller),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    OrderModel order,
    OrderDetailController controller,
    BuildContext context,
  ) {
    final createdAt = _formatDate(order.createdAt);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        order.orderId ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14.w,
                            color: AppColors.templeGold,
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: AutoTranslateText(
                              'Placed on $createdAt',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.templeGold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Flexible(child: _StatusChip(status: order.status)),
              ],
            ),
          ),
          // Order Summary
          Padding(
            padding: EdgeInsets.all(18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Order Summary',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textColorMaroon,
                  ),
                ),
                SizedBox(height: 16.h),
                _AmountRow(label: 'Subtotal', value: order.subtotal),
                _AmountRow(
                  label: 'Discount',
                  value: order.pricing?.couponDiscount ?? 0,
                ),
                _AmountRow(label: 'Tax', value: order.tax),
                _AmountRow(
                  label: 'Shipping',
                  value: order.pricing?.shipping ?? 0,
                ),
                Divider(
                  height: 24.h,
                  thickness: 1,
                  color: AppColors.textSecondary.withValues(alpha: 0.2),
                ),
                _AmountRow(
                  label: 'Total',
                  value: order.totalAmount,
                  isBold: true,
                ),
              ],
            ),
          ),
          // Action Buttons
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 18.w),
            child: _buildActionButtons(order, controller, context),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(OrderModel order) {
    final items = order.items;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_bag,
                  color: AppColors.templeGold,
                  size: 20.w,
                ),
                SizedBox(width: 8.w),
                AutoTranslateText(
                  'Order Items',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ...items.map((item) => _OrderItemTile(item: item)).toList(),
        ],
      ),
    );
  }

  Widget _buildAddressSection({required String title, OrderAddress? address}) {
    if (address == null) return const SizedBox();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.templeGold,
                  size: 20.w,
                ),
                SizedBox(width: 8.w),
                AutoTranslateText(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  address.fullName ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textColorMaroon,
                  ),
                ),
                SizedBox(height: 8.h),
                if (address.phone != null)
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 16.w,
                        color: AppColors.deepOrange,
                      ),
                      SizedBox(width: 8.w),
                      AutoTranslateText(
                        address.phone!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColorMaroon,
                        ),
                      ),
                    ],
                  ),
                if (address.phone != null) SizedBox(height: 8.h),
                AutoTranslateText(
                  address.formattedAddress,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                if (address.email != null && address.email!.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(
                        Icons.email,
                        size: 16.w,
                        color: AppColors.deepOrange,
                      ),
                      SizedBox(width: 8.w),
                      AutoTranslateText(
                        address.email!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColorMaroon,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(OrderModel order) {
    final payment = order.payment;
    final coupon = order.appliedCoupon;
    final invoice = order.invoice;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.payment, color: AppColors.templeGold, size: 20.w),
                SizedBox(width: 8.w),
                AutoTranslateText(
                  'Payment Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  label: 'Payment method',
                  value: payment?.method?.toUpperCase() ?? 'â€”',
                ),
                SizedBox(height: 12.h),
                _InfoRow(
                  label: 'Payment status',
                  value: payment?.status?.toUpperCase() ?? 'â€”',
                ),
                if (payment?.transactionId != null) ...[
                  SizedBox(height: 12.h),
                  _InfoRow(
                    label: 'Transaction ID',
                    value: payment!.transactionId!,
                  ),
                ],
                if (payment?.gatewayOrderId != null) ...[
                  SizedBox(height: 12.h),
                  _InfoRow(
                    label: 'Gateway order',
                    value: payment!.gatewayOrderId!,
                  ),
                ],
                if (payment?.gatewayPaymentId != null &&
                    payment!.gatewayPaymentId!.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  _InfoRow(
                    label: 'Gateway payment',
                    value: payment.gatewayPaymentId!,
                  ),
                ],
                if (payment?.paidAt != null) ...[
                  SizedBox(height: 12.h),
                  _InfoRow(
                    label: 'Paid at',
                    value: _formatDate(payment!.paidAt),
                  ),
                ],
                if (payment?.failureReason != null &&
                    payment!.failureReason!.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 18.w,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: AutoTranslateText(
                            payment.failureReason!,
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (coupon?.code != null && coupon!.code!.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_offer,
                          color: Colors.white,
                          size: 18.w,
                        ),
                        SizedBox(width: 8.w),
                        AutoTranslateText(
                          'Coupon: ${coupon.code}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (invoice?.invoiceUrl != null &&
                    invoice!.invoiceUrl!.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.deepOrange.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.snackbar(
                          'Invoice',
                          'Use the provided link to download your invoice.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.deepOrange,
                          colorText: Colors.white,
                        );
                      },
                      icon: const Icon(Icons.receipt_long),
                      label: const AutoTranslateText('Download Invoice'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(OrderDetailController controller) {
    return Obx(() {
      final order = controller.order.value;
      final isCancelled =
          order?.status?.toLowerCase() == 'cancelled' ||
          order?.status?.toLowerCase() == 'canceled';

      if (isCancelled) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.error.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cancel_outlined,
                  color: AppColors.error,
                  size: 24,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      'Order Cancelled',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.error,
                      ),
                    ),
                    if (order?.cancellationReason != null &&
                        order!.cancellationReason!.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      AutoTranslateText(
                        order.cancellationReason!,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }

      final isLoading = controller.isLoadingTimeline.value;
      final entries = controller.timeline.toList();

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOrange.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.timeline,
                        color: AppColors.templeGold,
                        size: 20.w,
                      ),
                      SizedBox(width: 8.w),
                      AutoTranslateText(
                        'Order Progress',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: controller.refreshOrder,
                    icon: Icon(Icons.refresh, color: AppColors.templeGold),
                    tooltip: 'Refresh status',
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(18.w),
              child: isLoading && entries.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.deepOrange,
                      ),
                    )
                  : entries.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: AutoTranslateText(
                          'Tracking information will appear here once available.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Column(
                      children: entries
                          .map(
                            (entry) => _TimelineEntryTile(
                              entry: entry,
                              formattedStatus: controller.formatStatus(
                                entry.status,
                              ),
                              date: _formatDate(entry.date),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHistorySection(OrderDetailController controller) {
    return Obx(() {
      final isLoading = controller.isLoadingHistory.value;
      final history = controller.orderHistory.toList();
      if (isLoading && history.isEmpty) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.deepOrange),
        );
      }
      if (history.isEmpty) {
        return const SizedBox();
      }
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOrange.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.history, color: AppColors.templeGold, size: 20.w),
                  SizedBox(width: 8.w),
                  AutoTranslateText(
                    'Order History',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(18.w),
              child: Column(
                children: history
                    .map(
                      (entry) => _HistoryTile(
                        title: controller.formatStatus(entry.status),
                        subtitle: entry.note ?? 'Status updated',
                        date: _formatDate(entry.updatedAt ?? entry.createdAt),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _promptCancelOrder(
    BuildContext context,
    OrderDetailController controller,
  ) async {
    final reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String? errorMessage;

    final shouldCancel = await Get.dialog<bool>(
      StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: AutoTranslateText(
            'Cancel Order',
            style: TextStyle(
              color: AppColors.textColorMaroon,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Please provide a reason for cancellation (required)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColorMaroon,
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    hintText: 'Enter cancellation reason (10-500 characters)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppColors.deepOrange,
                        width: 2,
                      ),
                    ),
                    errorText: errorMessage,
                  ),
                  maxLines: 4,
                  minLines: 3,
                  onChanged: (value) {
                    if (errorMessage != null) {
                      setState(() => errorMessage = null);
                    }
                  },
                ),
                if (errorMessage != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: AutoTranslateText(
                      errorMessage!,
                      style: TextStyle(color: AppColors.error, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: AutoTranslateText(
                'Keep Order',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            Obx(
              () => Container(
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: TextButton(
                  onPressed: controller.isCancelling.value
                      ? null
                      : () {
                          final reason = reasonController.text.trim();
                          if (reason.isEmpty) {
                            setState(() {
                              errorMessage = 'Cancellation reason is required';
                            });
                            return;
                          }
                          if (reason.length < 10) {
                            setState(() {
                              errorMessage =
                                  'Reason must be at least 10 characters';
                            });
                            return;
                          }
                          if (reason.length > 500) {
                            setState(() {
                              errorMessage =
                                  'Reason must not exceed 500 characters';
                            });
                            return;
                          }
                          Get.back(result: true);
                        },
                  child: controller.isCancelling.value
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : AutoTranslateText(
                          'Cancel Order',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (shouldCancel == true) {
      final reason = reasonController.text.trim();
      if (reason.isNotEmpty && reason.length >= 10 && reason.length <= 500) {
        await controller.cancelOrder(reason: reason);
      }
    }
    reasonController.dispose();
  }

  Widget _buildActionButtons(
    OrderModel order,
    OrderDetailController controller,
    BuildContext context,
  ) {
    return Obx(() {
      final isCancelling = controller.isCancelling.value;
      return Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepOrange.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: controller.refreshOrder,
              icon: const Icon(Icons.refresh),
              label: const AutoTranslateText('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              ),
            ),
          ),
          if (controller.canCancelOrder)
            OutlinedButton.icon(
              onPressed: isCancelling
                  ? null
                  : () => _promptCancelOrder(context, controller),
              icon: isCancelling
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.error,
                      ),
                    )
                  : const Icon(Icons.cancel_outlined),
              label: AutoTranslateText(
                isCancelling ? 'Cancelling...' : 'Cancel Order',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error, width: 2),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          if (order.cancellationReason != null &&
              order.cancellationReason!.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, color: AppColors.error, size: 18.w),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: AutoTranslateText(
                      'Cancelled: ${order.cancellationReason}',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }

  String _formatDate(String? date) {
    if (date == null) return 'â€”';
    try {
      final dt = DateTime.parse(date).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (_) {
      return date;
    }
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  final String label;
  final double value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoTranslateText(
            label,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          AutoTranslateText(
            '₹${value.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: isBold ? 20 : 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold
                  ? AppColors.textColorMaroon
                  : AppColors.textColorMaroon,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120.w,
          child: AutoTranslateText(
            label,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
        Expanded(
          child: AutoTranslateText(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.textColorMaroon,
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  const _OrderItemTile({required this.item});

  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    final imageUrl = _resolveOrderImage(item);

    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.textSecondary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: imageUrl != null
                  ? NetworkImageWithLoader(
                      url: imageUrl,
                      height: 70.h,
                      width: 70.w,
                    )
                  : Container(
                      height: 70.h,
                      width: 70.w,
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(Icons.image, size: 28, color: Colors.white),
                    ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoTranslateText(
                  item.productSnapshot?.name ?? item.product?.name ?? 'Product',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.textColorMaroon,
                  ),
                ),
                SizedBox(height: 6.h),
                if (item.productSnapshot?.sku != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.orangeGradient.colors.first.withOpacity(
                        0.1,
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: AutoTranslateText(
                      'SKU: ${item.productSnapshot!.sku}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.deepOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: AutoTranslateText(
                    'Qty: ${item.quantity ?? 0}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoTranslateText(
                '₹${(item.discountedPrice ?? item.price ?? 0).toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textColorMaroon,
                ),
              ),
              SizedBox(height: 4.h),
              AutoTranslateText(
                'Total: ₹${(item.total ?? 0).toStringAsFixed(0)}',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final label = (status ?? 'unknown').replaceAll('_', ' ').toUpperCase();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AutoTranslateText(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10,
          color: Colors.white,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

String? _resolveOrderImage(OrderItem? item) {
  if (item == null) return null;
  final product = item.product;
  if (product?.images != null && product!.images!.isNotEmpty) {
    try {
      final primary = product.images!.firstWhere(
        (img) => img.isPrimary == true,
        orElse: () => product.images!.first,
      );
      if (primary.url != null && primary.url!.isNotEmpty) {
        final url = primary.url!;
        return url.startsWith('http') ? url : 'http://65.1.131.197:8000$url';
      }
    } catch (_) {}
  }
  final snapshotUrl = item.productSnapshot?.image;
  if (snapshotUrl != null && snapshotUrl.isNotEmpty) {
    return snapshotUrl.startsWith('http')
        ? snapshotUrl
        : 'http://65.1.131.197:8000$snapshotUrl';
  }
  return null;
}

class _TimelineEntryTile extends StatelessWidget {
  const _TimelineEntryTile({
    required this.entry,
    required this.formattedStatus,
    required this.date,
  });

  final OrderTimelineEntry entry;
  final String formattedStatus;
  final String date;

  @override
  Widget build(BuildContext context) {
    final color = entry.completed
        ? AppColors.deepOrange
        : AppColors.textSecondary.withValues(alpha: 0.4);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                height: 20.w,
                width: 20.w,
                decoration: BoxDecoration(
                  gradient: entry.completed
                      ? AppColors.orangeGradient
                      : LinearGradient(
                          colors: [Colors.transparent, Colors.transparent],
                        ),
                  border: Border.all(color: color, width: 2),
                  shape: BoxShape.circle,
                  boxShadow: entry.completed
                      ? [
                          BoxShadow(
                            color: AppColors.deepOrange.withValues(alpha: 0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: entry.completed
                    ? Icon(Icons.check, size: 12.w, color: Colors.white)
                    : null,
              ),
              if (!entry.completed)
                Container(
                  width: 2,
                  height: 50.h,
                  decoration: BoxDecoration(
                    gradient: entry.completed
                        ? AppColors.orangeGradient
                        : LinearGradient(
                            colors: [
                              AppColors.textSecondary.withValues(alpha: 0.3),
                              AppColors.textSecondary.withValues(alpha: 0.3),
                            ],
                          ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  formattedStatus,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textColorMaroon,
                  ),
                ),
                SizedBox(height: 4.h),
                AutoTranslateText(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.title,
    required this.subtitle,
    required this.date,
  });

  final String title;
  final String subtitle;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: AppColors.gradientBackground.colors.first.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.deepOrange.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.event_note, color: Colors.white, size: 16.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textColorMaroon,
                  ),
                ),
                SizedBox(height: 4.h),
                AutoTranslateText(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 4.h),
                AutoTranslateText(
                  date,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

