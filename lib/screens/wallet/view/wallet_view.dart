import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/utils/error_ui_utils.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/wallet_model.dart';
import 'package:astrobharataiuser/screens/wallet/controller/wallet_controller.dart';
import 'package:astrobharataiuser/screens/wallet/widgets/recharge_dialog.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';

import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app_manager/my_text_theme.dart';
import '../../../theme/app_typography.dart';

class WalletView extends StatelessWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WalletController controller = Get.put(WalletController());

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: UserDashboardView.buildDrawer(context),
        body: SafeArea(
          child: Column(
            children: [
              // Header Section
              _buildHeader(context),

              // Main Scrollable Content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.loadWalletBalance();
                    await controller.loadRechargeHistory(refresh: true);
                  },
                  color: AppColors.templeGold,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Available Balance Card
                        Obx(() => _buildBalanceCard(controller)),

                        Spacing.h(24),

                        // Transaction History Section
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
        'Manage your wallet balance',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          color: '#6F221E'.toColor().withValues(alpha: 0.9),
        ),
      ),
      onMenuTap: null,
    );
  }

  Widget _buildBalanceCard(WalletController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: AppColors.goldenGradient,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.templeGold.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wallet icon and label
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: '#68171E'.toColor(),
                  size: 24.w,
                ),
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Available Balance',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: '#68171E'.toColor().withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          Spacing.h(20),

          // Balance amount
          AutoTranslateText(
            controller.formatCurrency(controller.walletBalance.value),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: '#68171E'.toColor(),
              height: 1.2,
            ),
          ),

          Spacing.h(24),

          // Add Money button
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: '#68171E'.toColor().withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Get.dialog(const RechargeDialog());
                },
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_rounded,
                        color: AppColors.templeGold,
                        size: 24.w,
                      ),
                      Spacing.w(8),
                      AutoTranslateText(
                        'Add Money',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.templeGold,
                          letterSpacing: 0.5,
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

  Widget _buildWalletHistorySection(WalletController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: AutoTranslateText(
                  'Wallet History',
                  style: MyTextTheme.largeBCB
                      .copyWith(color: Colors.white)
                      .merge(AppTypography.h3),
                ),
              ),
              // Sort button
              Container(
                margin: EdgeInsets.only(right: 8.w),
                decoration: BoxDecoration(
                  color: AppColors.templeGold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.templeGold.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.sort_rounded,
                    color: '#68171E'.toColor(),
                    size: 24.w,
                  ),
                  tooltip: 'Sort History',
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  onSelected: (value) {
                    controller.setSortOrder(value);
                  },
                  itemBuilder: (context) {
                    final currentSort = controller.sortOrder.value;
                    return [
                      PopupMenuItem(
                        value: 'NEWEST',
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_downward_rounded,
                              size: 18.w,
                              color: currentSort == 'NEWEST'
                                  ? '#68171E'.toColor()
                                  : Colors.grey,
                            ),
                            Spacing.w(8),
                            AutoTranslateText(
                              'Newest First',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: currentSort == 'NEWEST'
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: currentSort == 'NEWEST'
                                    ? '#68171E'.toColor()
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'OLDEST',
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_upward_rounded,
                              size: 18.w,
                              color: currentSort == 'OLDEST'
                                  ? '#68171E'.toColor()
                                  : Colors.grey,
                            ),
                            Spacing.w(8),
                            AutoTranslateText(
                              'Oldest First',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: currentSort == 'OLDEST'
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: currentSort == 'OLDEST'
                                    ? '#68171E'.toColor()
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ),

              // Filter button
              Container(
                decoration: BoxDecoration(
                  color: AppColors.templeGold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.templeGold.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.filter_list_rounded,
                    color: '#68171E'.toColor(),
                    size: 24.w,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  onSelected: (value) {
                    controller.filterByStatus(value.isEmpty ? null : value);
                  },
                  itemBuilder: (context) {
                    final selectedStatus = controller.selectedStatus.value;
                    return [
                      PopupMenuItem(
                        value: '',
                        child: AutoTranslateText(
                          'All',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: selectedStatus.isEmpty
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: selectedStatus.isEmpty
                                ? '#68171E'.toColor()
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'INITIATED',
                        child: AutoTranslateText(
                          'Initiated',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: selectedStatus == 'INITIATED'
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: selectedStatus == 'INITIATED'
                                ? '#68171E'.toColor()
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'PENDING',
                        child: AutoTranslateText(
                          'Pending',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: selectedStatus == 'PENDING'
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: selectedStatus == 'PENDING'
                                ? '#68171E'.toColor()
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'COMPLETED',
                        child: AutoTranslateText(
                          'Completed',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: selectedStatus == 'COMPLETED'
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: selectedStatus == 'COMPLETED'
                                ? '#68171E'.toColor()
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'FAILED',
                        child: AutoTranslateText(
                          'Failed',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: selectedStatus == 'FAILED'
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: selectedStatus == 'FAILED'
                                ? '#68171E'.toColor()
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'CANCELLED',
                        child: AutoTranslateText(
                          'Cancelled',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: selectedStatus == 'CANCELLED'
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: selectedStatus == 'CANCELLED'
                                ? '#68171E'.toColor()
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                    ];
                  },
                ),
              ),
            ],
          ),

          Spacing.h(16),

          // Transaction List
          Obx(() {
            if (controller.isLoadingHistory.value &&
                controller.combinedHistory.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(40.h),
                  child: const CircularProgressIndicator(),
                ),
              );
            }

            if (controller.combinedHistory.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(40.h),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.templeGold.withValues(alpha: 0.1),
                              AppColors.templeGold.withValues(alpha: 0.05),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.history_rounded,
                          size: 48.w,
                          color: AppColors.templeGold,
                        ),
                      ),
                      Spacing.h(16),
                      AutoTranslateText(
                        'No wallet history',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: [
                ...controller.combinedHistory.map((item) {
                  if (item is WalletTransaction) {
                    return _buildTransactionItem(item, controller);
                  } else if (item is WalletRechargeHistoryItem) {
                    // Fallback for any legacy items if still present
                    return _buildRechargeItem(item, controller);
                  }
                  return const SizedBox.shrink();
                }),
                if (controller.hasMore.value)
                  Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Obx(
                      () => controller.isLoadingMore.value
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.h),
                                child: CircularProgressIndicator(
                                  color: AppColors.templeGold,
                                ),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: AppColors.orangeGradient,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.orangeGradient.colors.first
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => controller.loadMoreHistory(),
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.h,
                                    ),
                                    alignment: Alignment.center,
                                    child: AutoTranslateText(
                                      'Load More',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
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
    final statusBgColor = _getStatusBgColor(recharge.status);
    final date = recharge.initiatedAtDate ?? recharge.createdAtDate;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
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
          Row(
            children: [
              // Status icon
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      statusBgColor,
                      statusBgColor.withValues(alpha: 0.7),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  isCredit
                      ? Icons.check_circle_rounded
                      : _getStatusIcon(recharge.status),
                  color: statusColor,
                  size: 28.w,
                ),
              ),

              Spacing.w(16),

              // Recharge details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      'Wallet Recharge',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: '#68171E'.toColor(),
                      ),
                    ),
                    Spacing.h(6),
                    if (date != null)
                      AutoTranslateText(
                        _formatTransactionDate(date),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    Spacing.h(8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: AutoTranslateText(
                        recharge.status,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AutoTranslateText(
                    '+₹${recharge.amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',

                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isCredit ? const Color(0xFF4CAF50) : statusColor,
                    ),
                  ),
                  if (recharge.rechargeId.isNotEmpty) ...[
                    Spacing.h(4),
                    AutoTranslateText(
                      recharge.rechargeId.substring(
                        0,
                        recharge.rechargeId.length > 12
                            ? 12
                            : recharge.rechargeId.length,
                      ),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),

          // Cancel button for INITIATED/PENDING status
          if (recharge.canCancel)
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showCancelDialog(recharge, controller),
                      borderRadius: BorderRadius.circular(10.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                              size: 16.w,
                            ),
                            Spacing.w(6),
                            AutoTranslateText(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return const Color(0xFF4CAF50);
      case 'INITIATED':
      case 'PENDING':
        return const Color(0xFFFF9800);
      case 'FAILED':
        return const Color(0xFFF44336);
      case 'CANCELLED':
        return const Color(0xFF9E9E9E);
      default:
        return const Color(0xFF666666);
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return const Color(0xFFE8F5E9);
      case 'INITIATED':
      case 'PENDING':
        return const Color(0xFFFFF3E0);
      case 'FAILED':
        return const Color(0xFFFFEBEE);
      case 'CANCELLED':
        return const Color(0xFFF5F5F5);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'INITIATED':
      case 'PENDING':
        return Icons.pending;
      case 'FAILED':
        return Icons.error;
      case 'CANCELLED':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  Widget _buildTransactionItem(
    WalletTransaction transaction,
    WalletController controller,
  ) {
    final isDeduction = transaction.type.toUpperCase() == 'DEDUCTION';
    final isRecharge = transaction.type.toUpperCase() == 'RECHARGE';

    final statusColor = isDeduction ? Colors.red : const Color(0xFF4CAF50);
    final statusBgColor = isDeduction
        ? Colors.red.withValues(alpha: 0.05)
        : const Color(0xFFE8F5E9);
    final date = transaction.createdAtDate;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
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
          Row(
            children: [
              // Status icon
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      statusBgColor,
                      statusBgColor.withValues(alpha: 0.7),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  isDeduction
                      ? Icons.remove_circle_rounded
                      : (isRecharge
                            ? Icons.add_task_rounded
                            : Icons.check_circle_rounded),
                  color: statusColor,
                  size: 28.w,
                ),
              ),

              Spacing.w(16),

              // Transaction details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      transaction.description ??
                          (isDeduction
                              ? 'Consultation'
                              : (isRecharge
                                    ? 'Wallet Recharge'
                                    : 'Wallet Update')),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: '#68171E'.toColor(),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacing.h(6),
                    if (date != null)
                      AutoTranslateText(
                        _formatTransactionDate(date),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    Spacing.h(8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: AutoTranslateText(
                        transaction.status,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AutoTranslateText(
                    '${isDeduction ? '-' : '+'}₹${transaction.amount.abs().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',

                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                  if (transaction.transactionId.isNotEmpty) ...[
                    Spacing.h(4),
                    AutoTranslateText(
                      transaction.transactionId.substring(
                        0,
                        transaction.transactionId.length > 12
                            ? 12
                            : transaction.transactionId.length,
                      ),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(
    WalletRechargeHistoryItem recharge,
    WalletController controller,
  ) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, AppColors.cream],
            ),
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AutoTranslateText(
                        'Cancel Recharge',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
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
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 20.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: '#68171E'.toColor().withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange,
                            size: 24.w,
                          ),
                          Spacing.w(12),
                          Expanded(
                            child: AutoTranslateText(
                              'Are you sure you want to cancel this recharge?',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: '#68171E'.toColor(),
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => Get.back(),
                                borderRadius: BorderRadius.circular(16.r),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  alignment: Alignment.center,
                                  child: AutoTranslateText(
                                    'No',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacing.w(12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.orangeGradient,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.orangeGradient.colors.first
                                      .withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
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
                                borderRadius: BorderRadius.circular(16.r),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  alignment: Alignment.center,
                                  child: AutoTranslateText(
                                    'Yes, Cancel',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
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
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final month = monthNames[date.month - 1];
    final day = date.day;
    final year = date.year;
    final hour = date.hour;
    final minute = date.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');

    return '$month $day, $year • $displayHour:$displayMinute $period';
  }
}
