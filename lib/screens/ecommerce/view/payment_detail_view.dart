import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/data_model/payment_model.dart';
import 'package:astrobharataiuser/data_model/order_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/payment_detail_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PaymentDetailView extends GetView<PaymentDetailController> {
  const PaymentDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Column(
        children: [
          CommonHeader(title: 'Payment Details'),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.payment.value == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final payment = controller.payment.value;
              if (payment == null) {
                return Center(
                  child: AutoTranslateText(
                    'Unable to load payment details.',
                    style: AppTypography.body2.copyWith(
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
                    _buildSummary(payment),
                    SizedBox(height: 20.h),
                    _buildAdditionalInfo(payment),
                    SizedBox(height: 20.h),
                    if (payment.order != null)
                      _buildOrderSnapshot(payment.order!),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(PaymentModel payment) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AutoTranslateText(
                  payment.id ?? 'Payment',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _StatusChip(label: controller.formatStatus(payment.status)),
            ],
          ),
          SizedBox(height: 16.h),
          AutoTranslateText(
            '₹${payment.amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.saffron,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 18.sp,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 6.w),
              AutoTranslateText(
                payment.paymentMethod?.toUpperCase() ?? 'â€”',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _InfoRow(
            label: 'Payment provider',
            value: payment.paymentProvider ?? 'â€”',
          ),
          _InfoRow(
            label: 'Transaction ID',
            value: payment.transactionId ?? 'â€”',
          ),
          _InfoRow(
            label: 'Gateway order ID',
            value: payment.gatewayOrderId ?? 'â€”',
          ),
          _InfoRow(
            label: 'Completed at',
            value: _formatDate(payment.completedAt ?? payment.updatedAt),
          ),
          if (payment.failedAt != null)
            _InfoRow(label: 'Failed at', value: _formatDate(payment.failedAt)),
          if (payment.failureReason != null &&
              payment.failureReason!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: AutoTranslateText(
                  'Failure reason: ${payment.failureReason}',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(PaymentModel payment) {
    final details = payment.paymentDetails;
    final refund = payment.refund;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Payment details',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          if (details != null) ...[
            if (details.cardLast4 != null)
              _InfoRow(label: 'Card last 4 digits', value: details.cardLast4!),
            if (details.cardNetwork != null)
              _InfoRow(label: 'Card network', value: details.cardNetwork!),
            if (details.bankName != null)
              _InfoRow(label: 'Bank name', value: details.bankName!),
            if (details.upiId != null)
              _InfoRow(label: 'UPI ID', value: details.upiId!),
            if (details.walletName != null)
              _InfoRow(label: 'Wallet name', value: details.walletName!),
            if (details.emiTenure != null)
              _InfoRow(label: 'EMI tenure', value: details.emiTenure!),
          ] else
            AutoTranslateText(
              'No additional payment details provided.',
              style: AppTypography.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          SizedBox(height: 18.h),
          AutoTranslateText(
            'Refund information',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          if (refund != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(label: 'Refund status', value: refund.status ?? 'â€”'),
                _InfoRow(
                  label: 'Refund amount',
                  value: refund.amount > 0
                      ? '₹${refund.amount.toStringAsFixed(0)}'
                      : 'â€”',
                ),
                _InfoRow(label: 'Refund ID', value: refund.refundId ?? 'â€”'),
                _InfoRow(
                  label: 'Initiated at',
                  value: _formatDate(refund.initiatedAt),
                ),
                _InfoRow(
                  label: 'Completed at',
                  value: _formatDate(refund.completedAt),
                ),
                _InfoRow(label: 'Reason', value: refund.reason ?? 'â€”'),
              ],
            )
          else
            AutoTranslateText(
              'No refund initiated for this payment.',
              style: AppTypography.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderSnapshot(OrderModel order) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Linked order',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          _InfoRow(label: 'Order ID', value: order.orderId ?? 'â€”'),
          _InfoRow(label: 'Status', value: order.status ?? 'â€”'),
          _InfoRow(
            label: 'Order total',
            value: '₹${order.totalAmount.toStringAsFixed(0)}',
          ),
          if (order.createdAt != null)
            _InfoRow(label: 'Order date', value: _formatDate(order.createdAt)),
          SizedBox(height: 12.h),
          if (order.items.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: order.items
                  .map(
                    (item) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AutoTranslateText(
                              item.productSnapshot?.name ??
                                  item.product?.name ??
                                  'Product',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          AutoTranslateText(
                            '₹${(item.total ?? 0).toStringAsFixed(0)}',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return 'â€”';
    try {
      final date = DateTime.parse(value).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (_) {
      return value;
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.saffron.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: AutoTranslateText(
        label,
        style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.saffron),
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
            width: 140.w,
            child: AutoTranslateText(
              label,
              style: TextStyle(color: AppColors.textSecondary),
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

