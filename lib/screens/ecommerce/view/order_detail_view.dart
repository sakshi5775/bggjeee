import 'package:astrobharataiuser/app_manager/my_appbar.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/data_model/order_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/order_detail_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:intl/intl.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: const MyAppbar(
        title: 'Order Details',
        showLeading: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.order.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final order = controller.order.value;
        if (order == null) {
          return Center(
            child: AutoTranslateText(
              'Unable to load order detail.',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(order, controller, context),
              SizedBox(height: 24.h),
              _buildItemsSection(order),
              SizedBox(height: 24.h),
              _buildAddressSection(
                title: 'Billing Address',
                address: order.billingAddress,
              ),
              if (order.shippingAddress != null) ...[
                SizedBox(height: 24.h),
                _buildAddressSection(
                  title: 'Shipping Address',
                  address: order.shippingAddress,
                ),
              ],
              SizedBox(height: 24.h),
              _buildPaymentSection(order),
              SizedBox(height: 24.h),
              _buildTimelineSection(controller),
              SizedBox(height: 24.h),
              _buildHistorySection(controller),
            ],
          ),
        );
      }),
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
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    AutoTranslateText(
                      'Placed on $createdAt',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Flexible(
                child: Align(
                  alignment: Alignment.topRight,
                  child: _StatusChip(status: order.status),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      'Order Summary',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _AmountRow(label: 'Subtotal', value: order.subtotal),
                    _AmountRow(label: 'Discount', value: order.pricing?.couponDiscount ?? 0),
                    _AmountRow(label: 'Tax', value: order.tax),
                    _AmountRow(label: 'Shipping', value: order.pricing?.shipping ?? 0),
                    Divider(height: 20.h),
                    _AmountRow(
                      label: 'Total',
                      value: order.totalAmount,
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          _buildActionButtons(order, controller, context),
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
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: AutoTranslateText(
              'Items',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Divider(height: 0),
          ...items.map((item) => _OrderItemTile(item: item)).toList(),
        ],
      ),
    );
  }

  Widget _buildAddressSection({required String title, OrderAddress? address}) {
    if (address == null) return const SizedBox();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: AppColors.saffron),
              SizedBox(width: 8.w),
              AutoTranslateText(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          AutoTranslateText(
            address.fullName ?? '',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          if (address.phone != null)
            AutoTranslateText(
              address.phone!,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          SizedBox(height: 4.h),
          AutoTranslateText(
            address.formattedAddress,
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          if (address.email != null && address.email!.isNotEmpty) ...[
            SizedBox(height: 6.h),
            AutoTranslateText(
              'Email: ${address.email}',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
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
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Payment Information',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          _InfoRow(
            label: 'Payment method',
            value: payment?.method?.toUpperCase() ?? '—',
          ),
          _InfoRow(
            label: 'Payment status',
            value: payment?.status?.toUpperCase() ?? '—',
          ),
          if (payment?.transactionId != null)
            _InfoRow(
              label: 'Transaction ID',
              value: payment!.transactionId!,
            ),
          if (payment?.gatewayOrderId != null)
            _InfoRow(
              label: 'Gateway order',
              value: payment!.gatewayOrderId!,
            ),
          if (payment?.gatewayPaymentId != null && payment!.gatewayPaymentId!.isNotEmpty)
            _InfoRow(
              label: 'Gateway payment',
              value: payment.gatewayPaymentId!,
            ),
          if (payment?.paidAt != null)
            _InfoRow(
              label: 'Paid at',
              value: _formatDate(payment!.paidAt),
            ),
          if (payment?.failureReason != null && payment!.failureReason!.isNotEmpty)
            _InfoRow(
              label: 'Failure reason',
              value: payment.failureReason!,
            ),
          if (coupon?.code != null && coupon!.code!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            AutoTranslateText(
              'Coupon applied: ${coupon.code}',
              style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
            ),
          ],
          if (invoice?.invoiceUrl != null && invoice!.invoiceUrl!.isNotEmpty) ...[
            SizedBox(height: 16.h),
            OutlinedButton.icon(
              onPressed: () {
                Get.snackbar(
                  'Invoice',
                  'Use the provided link to download your invoice.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: const Icon(Icons.receipt_long_outlined),
              label: const AutoTranslateText('Download Invoice'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineSection(OrderDetailController controller) {
    return Obx(() {
      final order = controller.order.value;
      final isCancelled = order?.status?.toLowerCase() == 'cancelled' || 
                         order?.status?.toLowerCase() == 'canceled';
      
      if (isCancelled) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.cancel_outlined, color: AppColors.error, size: 24.sp),
                  SizedBox(width: 12.w),
                  AutoTranslateText(
                    'Order Cancelled',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
              if (order?.cancellationReason != null && order!.cancellationReason!.isNotEmpty) ...[
                SizedBox(height: 12.h),
                AutoTranslateText(
                  'Reason: ${order.cancellationReason}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        );
      }

      final isLoading = controller.isLoadingTimeline.value;
      final entries = controller.timeline.toList();

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    'Order Progress',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: controller.refreshOrder,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh status',
                    color: AppColors.saffron,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            if (isLoading && entries.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (entries.isEmpty)
              Padding(
                padding: EdgeInsets.all(12.w),
                child: AutoTranslateText(
                  'Tracking information will appear here once available.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            else
              Column(
                children: entries
                    .map(
                      (entry) => _TimelineEntryTile(
                        entry: entry,
                        formattedStatus: controller.formatStatus(entry.status),
                        date: _formatDate(entry.date),
                      ),
                    )
                    .toList(),
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
        return const Center(child: CircularProgressIndicator());
      }
      if (history.isEmpty) {
        return const SizedBox();
      }
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: AutoTranslateText(
                'Order History',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            ...history.map(
              (entry) => _HistoryTile(
                title: controller.formatStatus(entry.status),
                subtitle: entry.note ?? 'Status updated',
                date: _formatDate(entry.updatedAt ?? entry.createdAt),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _promptCancelOrder(BuildContext context, OrderDetailController controller) async {
    final reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String? errorMessage;
    
    final shouldCancel = await Get.dialog<bool>(
      StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const AutoTranslateText('Cancel order'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AutoTranslateText(
                  'Please provide a reason for cancellation (required)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    hintText: 'Enter cancellation reason (10-500 characters)',
                    border: const OutlineInputBorder(),
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
                      style: AppTypography.body2.copyWith(color: AppColors.error),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const AutoTranslateText('Keep order'),
            ),
            Obx(
              () => TextButton(
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
                            errorMessage = 'Reason must be at least 10 characters';
                          });
                          return;
                        }
                        if (reason.length > 500) {
                          setState(() {
                            errorMessage = 'Reason must not exceed 500 characters';
                          });
                          return;
                        }
                        Get.back(result: true);
                      },
                child: controller.isCancelling.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const AutoTranslateText('Cancel order'),
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
        runSpacing: 8.h,
        children: [
          ElevatedButton.icon(
            onPressed: controller.refreshOrder,
            icon: const Icon(Icons.refresh),
            label: const AutoTranslateText('Refresh'),
          ),
          if (controller.canCancelOrder)
            OutlinedButton.icon(
              onPressed: isCancelling
                  ? null
                  : () => _promptCancelOrder(context, controller),
              icon: isCancelling
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cancel_outlined),
              label: AutoTranslateText(isCancelling ? 'Cancelling...' : 'Cancel order'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
            ),
          if (order.cancellationReason != null && order.cancellationReason!.isNotEmpty)
            Chip(
              backgroundColor: AppColors.error.withOpacity(0.08),
              label: AutoTranslateText(
                'Cancelled: ${order.cancellationReason}',
                style: AppTypography.label.copyWith(color: AppColors.error),
              ),
            ),
        ],
      );
    });
  }

  String _formatDate(String? date) {
    if (date == null) return '—';
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
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoTranslateText(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          AutoTranslateText(
            '₹${value.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: isBold ? 16.sp : 13.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: AppColors.textPrimary,
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: AutoTranslateText(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: AutoTranslateText(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: imageUrl != null
                ? NetworkImageWithLoader(
                    url: imageUrl,
                    height: 50.h,
                    width: 50.w,
                  )
                : Container(
                    height: 50.h,
                    width: 50.w,
                    color: AppColors.textSecondary.withOpacity(0.1),
                    child: Icon(Icons.image, size: 18.sp, color: AppColors.textSecondary),
                  ),
          ),
          SizedBox(width: 6.w),
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
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3.h),
                if (item.productSnapshot?.sku != null)
                  AutoTranslateText(
                    'SKU: ${item.productSnapshot!.sku}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.label.copyWith(color: AppColors.textSecondary),
                  ),
                SizedBox(height: 3.h),
                AutoTranslateText(
                  'Qty: ${item.quantity ?? 0}',
                  style: TextStyle(color: AppColors.textSecondary).merge(AppTypography.label),
                ),
              ],
            ),
          ),
          SizedBox(width: 4.w),
          SizedBox(
            width: 60.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: AutoTranslateText(
                    '₹${(item.discountedPrice ?? item.price ?? 0).toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 3.h),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: AutoTranslateText(
                    '₹${(item.total ?? 0).toStringAsFixed(0)}',
                    style: AppTypography.label.copyWith(color: AppColors.textSecondary),
                    maxLines: 1,
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final label = (status ?? 'unknown').replaceAll('_', ' ');
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.saffron.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: AutoTranslateText(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.saffron,
          ),
        ),
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
    final color = entry.completed ? AppColors.saffron : AppColors.textSecondary.withOpacity(0.4);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                height: 18.w,
                width: 18.w,
                decoration: BoxDecoration(
                  color: entry.completed ? AppColors.saffron : Colors.transparent,
                  border: Border.all(color: color, width: 2),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 40.h,
                color: color,
              ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  formattedStatus,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                AutoTranslateText(
                  date,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ).merge(AppTypography.label),
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.event_note_outlined, color: AppColors.saffron, size: 18.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                AutoTranslateText(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ).merge(AppTypography.label),
                ),
                SizedBox(height: 4.h),
                AutoTranslateText(
                  date,
                  style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.7),
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

