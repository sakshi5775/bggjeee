import 'package:astrobharataiuser/app_manager/my_appbar.dart';
import 'package:astrobharataiuser/data_model/payment_model.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/payments_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class PaymentsView extends GetView<PaymentsController> {
  const PaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: const MyAppbar(
        title: 'Payments',
        showLeading: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildFilters(),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.payments.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.payments.isEmpty) {
                  return Center(
                    child: AutoTranslateText(
                      'No payments found for the selected filters.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ).merge(AppTypography.body2),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: controller.refreshList,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.payments.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final payment = controller.payments[index];
                      return _PaymentTile(
                        payment: payment,
                        controller: controller,
                      );
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
    return Column(
      children: [
        TextField(
          controller: controller.searchController,
          onChanged: controller.onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search by payment, order or transaction ID',
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12.h),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 44.h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: DropdownButtonHideUnderline(
              child: Obx(
                () => DropdownButton<String>(
                  value: controller.selectedStatus.value,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: controller.statusOptions
                      .map(
                        (option) => DropdownMenuItem<String>(
                          value: option['value']!,
                          child: AutoTranslateText(option['label']!),
                        ),
                      )
                      .toList(),
                  onChanged: controller.onStatusChanged,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.payment,
    required this.controller,
  });

  final PaymentModel payment;
  final PaymentsController controller;

  @override
  Widget build(BuildContext context) {
    final order = payment.order;
    final statusLabel = controller.formatStatus(payment.status);

    return InkWell(
      onTap: () {
        Get.toNamed(
          AppRoutes.paymentDetail,
          arguments: {'paymentId': payment.id, 'payment': payment},
        );
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
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
                Expanded(
                  child: AutoTranslateText(
                    payment.id ?? 'Payment',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ).merge(AppTypography.body1),
                  ),
                ),
                _StatusPill(label: statusLabel),
              ],
            ),
            SizedBox(height: 10.h),
            AutoTranslateText(
              'Amount: ₹${payment.amount.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ).merge(AppTypography.body2),
            ),
            SizedBox(height: 6.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 4.h,
              children: [
                _InfoChip(
                  icon: Icons.account_balance_wallet_outlined,
                  text: payment.paymentMethod?.toUpperCase() ?? '—',
                ),
                if (order?.orderId != null)
                  _InfoChip(
                    icon: Icons.receipt_outlined,
                    text: order!.orderId!,
                  ),
                if (payment.transactionId != null)
                  _InfoChip(
                    icon: Icons.confirmation_number_outlined,
                    text: payment.transactionId!,
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            AutoTranslateText(
              'Updated: ${controller.formatDate(payment.updatedAt ?? payment.completedAt ?? payment.initiatedAt)}',
              style: TextStyle(
                color: AppColors.textSecondary,
              ).merge(AppTypography.label),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.saffron.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: AutoTranslateText(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.saffron,
        ).merge(AppTypography.label),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16.sp, color: AppColors.saffron),
      label: AutoTranslateText(
        text,
        style: TextStyle(color: AppColors.textPrimary).merge(AppTypography.label),
      ),
      backgroundColor: AppColors.saffron.withOpacity(0.08),
      visualDensity: VisualDensity.compact,
    );
  }
}

