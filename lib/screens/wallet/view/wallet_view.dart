import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/wallet_model.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/screens/wallet/controller/wallet_controller.dart';
import 'package:astrobharataiuser/screens/wallet/widgets/recharge_dialog.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/error_ui_utils.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WalletView extends StatelessWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WalletController controller = Get.put(WalletController());

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.loadWalletBalance();
                    await controller.loadRechargeHistory(refresh: true);
                  },
                  color: AppColors.orangeGradient.colors.first,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      top: 16.h,
                      bottom:
                          16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => _buildBalanceCard(controller)),
                        Spacing.h(20),
                        _buildFiltersSection(controller),
                        Spacing.h(16),
                        _buildWalletHistorySection(controller),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return CommonHeader(
      title: 'Wallet',
      subtitle: AutoTranslateText(
        'Manage balance and transactions',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11.sp,
          color: AppColors.textColorMaroon.withValues(alpha: 0.85),
        ),
      ),
      showBackButton: true,
      showWallet: false,
    );
  }

  Widget _buildBalanceCard(WalletController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGradient.colors.first.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 20.w,
                ),
              ),
              Spacing.w(8),
              AutoTranslateText(
                'Available Balance',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.sp,
                  color: Colors.white.withValues(alpha: 0.95),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Spacing.h(8),
          AutoTranslateText(
            controller.formatCurrency(controller.walletBalance.value),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
              letterSpacing: 0.3,
            ),
          ),
          Spacing.h(12),
          SizedBox(
            width: double.infinity,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Get.dialog(const RechargeDialog()),
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_rounded, color: Colors.white, size: 20.w),
                      Spacing.w(6),
                      AutoTranslateText(
                        'Add Money',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection(WalletController controller) {
    return Obx(() {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: AppColors.primaryGradient.colors.first.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.tune_rounded, size: 16.w, color: AppColors.primaryGradient.colors.first),
                Spacing.w(6),
                AutoTranslateText(
                  'Filters',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColorMaroon,
                  ),
                ),
                const Spacer(),
                if (controller.hasActiveFilters)
                  GestureDetector(
                    onTap: controller.clearAllFilters,
                    child: AutoTranslateText(
                      'Clear',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.orangeGradient.colors.first,
                      ),
                    ),
                  ),
              ],
            ),
            Spacing.h(8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...WalletController.typeOptions.map((type) {
                    final label = type.isEmpty ? 'All' : type == 'RECHARGE' ? 'Recharge' : 'Deduction';
                    final isSelected = controller.selectedType.value.toLowerCase() == type.toLowerCase();
                    return Padding(
                      padding: EdgeInsets.only(right: 6.w),
                      child: GestureDetector(
                        onTap: () => controller.filterByType(type.isEmpty ? null : type),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            gradient: isSelected ? AppColors.orangeGradient : null,
                            color: isSelected ? null : Colors.grey[100],
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: AutoTranslateText(label, style: TextStyle(
                            fontFamily: 'Poppins', fontSize: 11.sp,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.grey[800],
                          )),
                        ),
                      ),
                    );
                  }),
                  Spacing.w(8),
                  _buildDateChip(controller, isFrom: true),
                  Spacing.w(6),
                  _buildDateChip(controller, isFrom: false),
                  Spacing.w(8),
                  ...controller.statusOptions.map((status) {
                    final label = status.isEmpty ? 'All' : status.substring(0, 1).toUpperCase() + status.substring(1).toLowerCase();
                    final isSelected = controller.selectedStatus.value == status;
                    return Padding(
                      padding: EdgeInsets.only(right: 6.w),
                      child: GestureDetector(
                        onTap: () => controller.filterByStatus(status.isEmpty ? null : status),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            gradient: isSelected ? AppColors.primaryGradient : null,
                            color: isSelected ? null : Colors.grey[100],
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: AutoTranslateText(label, style: TextStyle(
                            fontFamily: 'Poppins', fontSize: 10.sp,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.grey[800],
                          )),
                        ),
                      ),
                    );
                  }),
                  Spacing.w(8),
                  GestureDetector(
                    onTap: () => controller.setSortOrder('NEWEST'),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: controller.sortOrder.value == 'NEWEST' ? AppColors.orangeGradient.colors.first : Colors.grey[100],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: AutoTranslateText('Newest', style: TextStyle(
                        fontFamily: 'Poppins', fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: controller.sortOrder.value == 'NEWEST' ? Colors.white : Colors.grey[800],
                      )),
                    ),
                  ),
                  Spacing.w(4),
                  GestureDetector(
                    onTap: () => controller.setSortOrder('OLDEST'),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: controller.sortOrder.value == 'OLDEST' ? AppColors.orangeGradient.colors.first : Colors.grey[100],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: AutoTranslateText('Oldest', style: TextStyle(
                        fontFamily: 'Poppins', fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: controller.sortOrder.value == 'OLDEST' ? Colors.white : Colors.grey[800],
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDateChip(WalletController controller, {required bool isFrom}) {
    final date = isFrom ? controller.dateFrom.value : controller.dateTo.value;
    final label = isFrom ? 'From' : 'To';
    final display = date == null ? label : '${date.day}/${date.month}/${date.year}';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: Get.context!,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          if (picked == null) return;
          if (isFrom) {
            controller.setDateRange(picked, controller.dateTo.value);
          } else {
            controller.setDateRange(controller.dateFrom.value, picked);
          }
        },
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today_rounded, size: 14.w, color: AppColors.primaryGradient.colors.first),
              Spacing.w(4),
              AutoTranslateText(
                display,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: date == null ? Colors.grey[600] : Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletHistorySection(WalletController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.primaryGradient.colors.first.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
              Icon(Icons.history_rounded, color: AppColors.primaryGradient.colors.first, size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                'Transaction History',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColorMaroon,
                ),
              ),
            ],
          ),
          Spacing.h(12),
          Obx(() {
            if (controller.isLoadingHistory.value &&
                controller.combinedHistory.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 32.h),
                child: Center(
                  child: SizedBox(
                    width: 28.w,
                    height: 28.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.orangeGradient.colors.first,
                    ),
                  ),
                ),
              );
            }

            if (controller.combinedHistory.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      size: 40.w,
                      color: Colors.grey[400],
                    ),
                    Spacing.h(10),
                    AutoTranslateText(
                      'No transactions yet',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    Spacing.h(4),
                    AutoTranslateText(
                      'Your wallet history will appear here',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                ...controller.combinedHistory.map((item) {
                  if (item is WalletTransaction) {
                    return _buildTransactionItem(item, controller);
                  } else if (item is WalletRechargeHistoryItem) {
                    return _buildRechargeItem(item, controller);
                  }
                  return const SizedBox.shrink();
                }),
                if (controller.hasMore.value)
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Obx(
                      () => controller.isLoadingMore.value
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(12.h),
                                child: SizedBox(
                                  width: 24.w,
                                  height: 24.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.orangeGradient.colors.first,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => controller.loadMoreHistory(),
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10.h),
                                    decoration: BoxDecoration(
                                      gradient: AppColors.orangeGradient,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    alignment: Alignment.center,
                                    child: AutoTranslateText(
                                      'Load More',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRechargeItem(
    WalletRechargeHistoryItem recharge,
    WalletController controller,
  ) {
    final isCredit = recharge.status == 'COMPLETED';
    final statusColor = _getStatusColor(recharge.status);
    final date = recharge.initiatedAtDate ?? recharge.createdAtDate;

    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(10.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Row(
              children: [
                Container(
                  width: 4.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: isCredit ? AppColors.success : statusColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                Spacing.w(10),
                Icon(
                  isCredit ? Icons.add_circle_rounded : _getStatusIcon(recharge.status),
                  color: isCredit ? AppColors.success : statusColor,
                  size: 20.w,
                ),
                Spacing.w(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        'Wallet Recharge',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColorMaroon,
                        ),
                      ),
                      if (date != null)
                        AutoTranslateText(
                          _formatTransactionDate(date),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10.sp,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      Spacing.h(2),
                      AutoTranslateText(
                        recharge.status,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AutoTranslateText(
                      '+${_formatAmount(recharge.amount)}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: isCredit ? AppColors.success : statusColor,
                      ),
                    ),
                    if (recharge.canCancel)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: GestureDetector(
                          onTap: () => _showCancelDialog(recharge, controller),
                          child: AutoTranslateText(
                            'Cancel',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
    WalletTransaction transaction,
    WalletController controller,
  ) {
    final isDeduction = transaction.type.toUpperCase() == 'DEDUCTION';
    final isRecharge = transaction.type.toUpperCase() == 'RECHARGE';
    final statusColor = isDeduction ? AppColors.error : AppColors.success;
    final date = transaction.createdAtDate;
    final title = transaction.description ??
        (isDeduction ? 'Consultation' : (isRecharge ? 'Wallet Recharge' : 'Wallet Update'));

    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(10.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Row(
              children: [
                Container(
                  width: 4.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                Spacing.w(10),
                Icon(
                  isDeduction
                      ? Icons.remove_circle_rounded
                      : (isRecharge ? Icons.add_task_rounded : Icons.check_circle_rounded),
                  color: statusColor,
                  size: 20.w,
                ),
                Spacing.w(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        title,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColorMaroon,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (date != null)
                        AutoTranslateText(
                          _formatTransactionDate(date),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10.sp,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      Spacing.h(2),
                      AutoTranslateText(
                        transaction.status,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                AutoTranslateText(
                  '${isDeduction ? '-' : '+'}${_formatAmount(transaction.amount.abs())}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatAmount(int amount) {
    final str = amount.toString();
    if (str.length <= 3) return '\u20B9$str';
    final buffer = StringBuffer('\u20B9');
    var i = str.length % 3;
    if (i == 0) i = 3;
    buffer.write(str.substring(0, i));
    for (; i < str.length; i += 3) {
      buffer.write(',');
      buffer.write(str.substring(i, i + 3));
    }
    return buffer.toString();
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return AppColors.success;
      case 'INITIATED':
      case 'PENDING':
        return AppColors.warning;
      case 'FAILED':
        return AppColors.error;
      case 'CANCELLED':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'INITIATED':
      case 'PENDING':
        return Icons.pending_rounded;
      case 'FAILED':
        return Icons.error_rounded;
      case 'CANCELLED':
        return Icons.cancel_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  void _showCancelDialog(
    WalletRechargeHistoryItem recharge,
    WalletController controller,
  ) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.gradientBackground,
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 12.w, 20.h),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28.r)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: AutoTranslateText(
                        'Cancel Recharge',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Get.back(),
                        borderRadius: BorderRadius.circular(20.r),
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 24.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.warning,
                            size: 26.w,
                          ),
                          Spacing.w(12),
                          Expanded(
                            child: AutoTranslateText(
                              'Are you sure you want to cancel this recharge?',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14.sp,
                                color: AppColors.textColorMaroon,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacing.h(24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.grey.withValues(alpha: 0.5),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                            ),
                            child: AutoTranslateText(
                              'No',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                        Spacing.w(12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.orangeGradient,
                              borderRadius: BorderRadius.circular(14.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.orangeGradient.colors.first
                                      .withValues(alpha: 0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  Get.back();
                                  final success = await controller
                                      .cancelRecharge(recharge.rechargeId);
                                  if (success) {
                                    ErrorUiUtils.showSuccessSnackbar(
                                      'Recharge cancelled successfully',
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(14.r),
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 14.h),
                                  alignment: Alignment.center,
                                  child: AutoTranslateText(
                                    'Yes, Cancel',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTransactionDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final m = date.month - 1;
    final d = date.day;
    final y = date.year;
    final h = date.hour;
    final min = date.minute;
    final period = h >= 12 ? 'PM' : 'AM';
    final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    final minStr = min.toString().padLeft(2, '0');
    return '${months[m]} $d, $y at $hour:$minStr $period';
  }
}
