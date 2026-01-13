import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/wallet_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/widgets/astrology_header_widget.dart';
import 'package:astrobharataiuser/screens/wallet/controller/wallet_controller.dart';
import 'package:astrobharataiuser/screens/wallet/widgets/recharge_dialog.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WalletView extends StatelessWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WalletController controller = Get.put(WalletController());
    
    // Refresh wallet balance when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadWalletBalance();
      controller.loadRechargeHistory(refresh: true);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC), // Light cream background
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
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Available Balance Card
                      Obx(() => _buildBalanceCard(controller)),
                      
                      Spacing.h(24),
                      
                      // Transaction History Section
                      _buildTransactionHistorySection(controller),
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

  Widget _buildHeader(BuildContext context) {
    return AstrologyHeaderWidget(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h, bottom: 24.h),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.arrow_back,
                  color: Color(0xFFE3B341),
                  size: 24.w,
                ),
              ),
              Expanded(
                child: AutoTranslateText(
                  'Wallet',
                  style: AppTypography.h2.copyWith(
                    color: Color(0xFFE3B341),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 24.w), // Balance the back button
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(WalletController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE3B341), // Golden yellow
            Color(0xFFC9A033), // Amber
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              Icon(
                Icons.account_balance_wallet,
                color: const Color(0xFF333333),
                size: 20.w,
              ),
              Spacing.w(8),
              AutoTranslateText(
                'Available Balance',
                style: AppTypography.body1.copyWith(
                  color: const Color(0xFF333333),
                ),
              ),
            ],
          ),
          
          Spacing.h(16),
          
          // Balance amount
          AutoTranslateText(
            controller.formatCurrency(controller.walletBalance.value),
            style: AppTypography.h1.copyWith(
              color: const Color(0xFF333333),
            ),
          ),
          
          Spacing.h(24),
          
          // Add Money button
          Center(
            child: GestureDetector(
              onTap: () {
                Get.dialog(const RechargeDialog());
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D0C11), // Dark maroon
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Color(0xFFE3B341),
                      size: 20.w,
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      'Add Money',
                      style: AppTypography.h2.copyWith(
                        color: Color(0xFFE3B341),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHistorySection(WalletController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6F0), // Warm off-white background
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
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
              Expanded(
                child: AutoTranslateText(
                  'Recharge History',
                  style: AppTypography.h2.copyWith(
                    color: const Color(0xFFC9A033), // Orange-gold color
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              // Filter button
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.filter_list,
                  color: const Color(0xFFC9A033),
                  size: 24.w,
                ),
                onSelected: (value) {
                  controller.filterByStatus(value.isEmpty ? null : value);
                },
                itemBuilder: (context) {
                  // Access observable directly - menu rebuilds when opened
                  final selectedStatus = controller.selectedStatus.value;
                  return [
                    PopupMenuItem(
                      value: '',
                      child: AutoTranslateText(
                        'All',
                        style: TextStyle(
                          fontWeight: selectedStatus.isEmpty
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'INITIATED',
                      child: AutoTranslateText(
                        'Initiated',
                        style: TextStyle(
                          fontWeight: selectedStatus == 'INITIATED'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'PENDING',
                      child: AutoTranslateText(
                        'Pending',
                        style: TextStyle(
                          fontWeight: selectedStatus == 'PENDING'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'COMPLETED',
                      child: AutoTranslateText(
                        'Completed',
                        style: TextStyle(
                          fontWeight: selectedStatus == 'COMPLETED'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'FAILED',
                      child: AutoTranslateText(
                        'Failed',
                        style: TextStyle(
                          fontWeight: selectedStatus == 'FAILED'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'CANCELLED',
                      child: AutoTranslateText(
                        'Cancelled',
                        style: TextStyle(
                          fontWeight: selectedStatus == 'CANCELLED'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          
          Spacing.h(16),
          
          // Transaction List
          Obx(() {
            if (controller.isLoadingHistory.value && controller.rechargeHistory.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(40.h),
                  child: const CircularProgressIndicator(),
                ),
              );
            }

            if (controller.rechargeHistory.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(40.h),
                  child: Column(
                    children: [
                      Icon(
                        Icons.history,
                        size: 48.w,
                        color: Colors.grey,
                      ),
                      Spacing.h(16),
                      AutoTranslateText(
                        'No recharge history',
                        style: AppTypography.body1.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: [
                ...controller.rechargeHistory.map((recharge) => _buildRechargeItem(recharge, controller)),
                if (controller.hasMore.value)
                  Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Obx(() => controller.isLoadingMore.value
                        ? const Center(child: CircularProgressIndicator())
                        : TextButton(
                            onPressed: () => controller.loadMoreHistory(),
                            child: AutoTranslateText(
                              'Load More',
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: const Color(0xFFE3B341),
                              ),
                            ),
                          )),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRechargeItem(WalletRechargeHistoryItem recharge, WalletController controller) {
    final isCredit = recharge.status == 'COMPLETED';
    final statusColor = _getStatusColor(recharge.status);
    final statusBgColor = _getStatusBgColor(recharge.status);
    final date = recharge.initiatedAtDate ?? recharge.createdAtDate;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Status icon
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: statusBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCredit ? Icons.check_circle : _getStatusIcon(recharge.status),
                  color: statusColor,
                  size: 24.w,
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
                      style: AppTypography.h3.copyWith(
                        color: const Color(0xFF333333),
                      ),
                    ),
                    Spacing.h(4),
                    if (date != null)
                      AutoTranslateText(
                        _formatTransactionDate(date),
                        style: AppTypography.body2.copyWith(
                          color: const Color(0xFF666666),
                        ),
                      ),
                    Spacing.h(4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: AutoTranslateText(
                        recharge.status,
                        style: AppTypography.label.copyWith(
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
                    '+₹${recharge.amount.toString().replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]},',
                    )}',
                    style: AppTypography.h2.copyWith(
                      color: isCredit ? const Color(0xFF4CAF50) : statusColor,
                    ),
                  ),
                  if (recharge.rechargeId.isNotEmpty)
                    AutoTranslateText(
                      recharge.rechargeId.substring(0, recharge.rechargeId.length > 12 
                          ? 12 
                          : recharge.rechargeId.length),
                      style: AppTypography.label.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ],
          ),
          
          // Cancel button for INITIATED/PENDING status
          if (recharge.canCancel)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showCancelDialog(recharge, controller),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    backgroundColor: Colors.red.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: AutoTranslateText(
                    'Cancel',
                    style: AppTypography.body2.copyWith(
                      color: Colors.red,
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

  void _showCancelDialog(WalletRechargeHistoryItem recharge, WalletController controller) {
    Get.dialog(
      AlertDialog(
        title: AutoTranslateText(
          'Cancel Recharge',
          style: AppTypography.h2.copyWith(
          ),
        ),
        content: AutoTranslateText(
          'Are you sure you want to cancel this recharge?',
          style: AppTypography.body1,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: AutoTranslateText(
              'No',
              style: MyTextTheme.mediumBCB.copyWith(
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              final success = await controller.cancelRecharge(recharge.rechargeId);
              if (success) {
                Get.showSnackbar(
                  GetSnackBar(
                    message: 'Recharge cancelled successfully',
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: AutoTranslateText(
              'Yes, Cancel',
              style: MyTextTheme.mediumBCB.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTransactionDate(DateTime date) {
    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
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
