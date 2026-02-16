import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/wallet_model.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/user_profile_service.dart';
import 'package:astrobharataiuser/screens/wallet/service/wallet_service.dart';
import 'package:astrobharataiuser/screens/wallet/service/wallet_razorpay_service.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WalletController extends BaseController {
  final WalletService _walletService = WalletService();
  final UserProfileService _profileService = UserProfileService();

  final RxDouble walletBalance = 0.0.obs;
  final RxString currency = 'INR'.obs;

  // Recharge history (Kept for compatibility but not used directly for display now)
  final RxList<WalletRechargeHistoryItem> rechargeHistory =
      <WalletRechargeHistoryItem>[].obs;

  // Combined history (Recharges + Missing Deductions from profile)
  final RxList<dynamic> combinedHistory = <dynamic>[].obs;

  // Full history storage for client-side pagination
  List<dynamic> _allTransactions = [];
  List<dynamic> _filteredTransactions = [];

  final RxBool isLoadingHistory = false.obs;
  final RxBool isLoadingMore = false.obs;

  // Pagination
  final RxInt currentOffset = 0.obs;
  final RxInt limit = 10.obs; // Changed to 10 as requested
  final RxBool hasMore = false.obs;
  final RxInt total = 0.obs;

  // Filters
  final RxString selectedStatus = ''.obs; // Empty means all statuses
  final List<String> statusOptions = [
    '',
    'INITIATED',
    'PENDING',
    'COMPLETED',
    'FAILED',
    'CANCELLED',
  ];

  // Recharge process
  final RxBool isInitiatingRecharge = false.obs;
  final RxBool isVerifyingRecharge = false.obs;
  final Rxn<String> currentRechargeId = Rxn<String>();

  // Razorpay Service
  final WalletRazorpayService _razorpayService = WalletRazorpayService();
  String? _pendingRechargeId;

  @override
  void onInit() {
    super.onInit();
    loadWalletBalance();
    // loadRechargeHistory();
    _initializeRazorpay();
  }

  @override
  void onClose() {
    _razorpayService.dispose();
    super.onClose();
  }

  void _initializeRazorpay() {
    _razorpayService.initialize(
      onSuccess: _handlePaymentSuccess,
      onError: (message) {
        showErrorMessage(title: 'Recharge Failed', message: message);
      },
      onFailure: (response) {
        showErrorMessage(
          title: 'Recharge Failed',
          message: '${response.code}: ${response.message}',
        );
      },
    );
  }

  void _handlePaymentSuccess(Map<String, dynamic> data) async {
    final paymentId = data['paymentId']?.toString() ?? '';
    final orderId = data['orderId']?.toString() ?? ''; // Razorpay Order ID
    final signature = data['signature']?.toString() ?? '';

    if (_pendingRechargeId == null) {
      showErrorMessage(
        title: "Error",
        message: "Recharge session lost. Please try again.",
      );
      return;
    }

    final verified = await verifyRecharge(
      rechargeId: _pendingRechargeId!,
      transactionId: paymentId,
      razorpayOrderId: orderId,
      razorpayPaymentId: paymentId,
      razorpaySignature: signature,
    );

    // Close recharge dialog if payment was successful
    if (verified) {
      if (Get.isDialogOpen == true) {
        Get.back(); // Close recharge dialog
      }
      // Show success modal
      _showPaymentSuccessModal();
      // Refresh wallet balance and history
      await loadWalletBalance();
      await loadRechargeHistory(refresh: true);
    }
  }

  void _showPaymentSuccessModal() {
    Get.dialog(
      PopScope(
        canPop: false, // Prevent back button from closing
        child: Dialog(
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
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with gradient
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AutoTranslateText(
                          'Recharge Successful',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Success Icon
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 50.w,
                        ),
                      ),
                      Spacing.h(24),
                      // Success Message
                      AutoTranslateText(
                        'Wallet Recharged Successfully!',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: '#68171E'.toColor(),
                        ),
                      ),
                      Spacing.h(12),
                      AutoTranslateText(
                        'Your wallet has been recharged successfully. You can now use the balance for purchases.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    // Auto-close after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (Get.isDialogOpen == true) {
        Get.back(); // Close success modal
      }
    });
  }

  /// Start Razorpay Recharge Flow
  Future<void> startRazorpayRecharge(int amount) async {
    final response = await initiateRecharge(
      amount: amount,
      paymentMethod: 'online',
      paymentProvider: 'razorpay',
    );

    if (response != null && response.razorpay != null) {
      _pendingRechargeId = response.rechargeId;
      _razorpayService.openCheckout(razorpayData: response.razorpay!);
    } else {
      showErrorMessage(title: "Error", message: "Failed to initiate recharge.");
    }
  }

  /// Load wallet balance from user profile
  Future<void> loadWalletBalance() async {
    final userId = UserData().getLoginData.user?.userId;
    if (userId == null) return;

    await runWithLoading(
      () async {
        // Try new wallet balance API
        final balanceResponse = await _walletService.getWalletBalance(userId);
        if (balanceResponse != null && balanceResponse.data != null) {
          walletBalance.value = balanceResponse.data!.balance.toDouble();
          currency.value = balanceResponse.data!.currency;
        }

        // Fetch profile to get transactions
        final profile = await _profileService.getProfile(userId);
        if (profile?.wallet != null) {
          // If walletBalance wasn't updated by API, use profile one
          if (balanceResponse == null) {
            walletBalance.value = profile!.wallet!.balance ?? 0.0;
            currency.value = profile.wallet!.currency ?? 'INR';
          }

          _updateCombinedHistory(profile!.wallet!.transactions ?? []);
        }
      },
      showBusy: false,
      showError: false,
    );
  }

  /// Merge recharge history with profile transactions
  void _updateCombinedHistory(List<WalletTransaction> transactions) {
    // Start with all recharges
    List<dynamic> merged = List.from(rechargeHistory);

    // Add deductions from profile if they are not already in merged
    // (Recharges are handled by getRechargeHistory API which has more info)
    for (var tx in transactions) {
      // if (tx.type == 'DEDUCTION') {
      // Check if already exists by transactionId or id
      bool exists = merged.any((e) {
        if (e is WalletRechargeHistoryItem)
          return e.transactionId == tx.transactionId;
        if (e is WalletTransaction) return e.transactionId == tx.transactionId;
        return false;
      });

      if (!exists) {
        merged.add(tx);
      }
      // }
    }

    // Sort combined history by date descending
    merged.sort((a, b) {
      DateTime? dateA = (a is WalletRechargeHistoryItem)
          ? (a.initiatedAtDate ?? a.createdAtDate)
          : (a as WalletTransaction).createdAtDate;
      DateTime? dateB = (b is WalletRechargeHistoryItem)
          ? (b.initiatedAtDate ?? b.createdAtDate)
          : (b as WalletTransaction).createdAtDate;

      if (dateA == null) return 1;
      if (dateB == null) return -1;
      return dateB.compareTo(dateA);
    });

    _allTransactions = merged;
    _applyFilterAndPaginate();
  }

  /// Load recharge history
  Future<void> loadRechargeHistory({bool refresh = false}) async {
    // Instead just reload wallet balance to get profile transactions
    if (refresh) {
      await loadWalletBalance();
    }
    isLoadingHistory.value = false;
  }

  /// Load more recharge history (pagination)
  Future<void> loadMoreHistory() async {
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;

    // Simulate a small delay for better UX since it's immediate client-side
    await Future.delayed(const Duration(milliseconds: 300));

    _loadNextPage();

    isLoadingMore.value = false;
  }

  /// Filter by status
  void filterByStatus(String? status) {
    selectedStatus.value = status ?? '';
    _applyFilterAndPaginate();
  }

  /// Apply filter and reset pagination
  void _applyFilterAndPaginate() {
    if (selectedStatus.value.isEmpty) {
      _filteredTransactions = List.from(_allTransactions);
    } else {
      _filteredTransactions = _allTransactions.where((item) {
        String status = '';
        if (item is WalletRechargeHistoryItem) {
          status = item.status;
        } else if (item is WalletTransaction) {
          status = item.status;
        }
        return status.toUpperCase() == selectedStatus.value.toUpperCase();
      }).toList();
    }

    currentOffset.value = 0;
    combinedHistory.clear();
    _loadNextPage();
  }

  /// Load next page of transactions
  void _loadNextPage() {
    int end = currentOffset.value + limit.value;
    if (end > _filteredTransactions.length) {
      end = _filteredTransactions.length;
    }

    if (currentOffset.value < end) {
      List<dynamic> nextBatch = _filteredTransactions.sublist(
        currentOffset.value,
        end,
      );
      combinedHistory.addAll(nextBatch);
      currentOffset.value = end;
    }

    hasMore.value = currentOffset.value < _filteredTransactions.length;
  }

  /// Initiate recharge
  Future<WalletRechargeData?> initiateRecharge({
    required int amount,
    String paymentMethod = 'online',
    String paymentProvider = 'razorpay', // Default changed to razorpay
  }) async {
    return await runWithLoading<WalletRechargeData?>(() async {
      final response = await _walletService.initiateRecharge(
        amount: amount,
        paymentMethod: paymentMethod,
        paymentProvider: paymentProvider,
      );

      if (response?.data != null) {
        currentRechargeId.value = response!.data!.rechargeId;
        return response.data;
      }
      return null;
    }, showBusy: true);
  }

  /// Verify recharge
  Future<bool> verifyRecharge({
    required String rechargeId,
    required String transactionId,
    String? razorpayOrderId,
    String? razorpayPaymentId,
    String? razorpaySignature,
  }) async {
    return await runWithLoading(
          () async {
            final response = await _walletService.verifyRecharge(
              rechargeId: rechargeId,
              transactionId: transactionId,
              razorpayOrderId: razorpayOrderId,
              razorpayPaymentId: razorpayPaymentId,
              razorpaySignature: razorpaySignature,
            );

            if (response?.success == true && response?.data != null) {
              // Update wallet balance
              walletBalance.value = response!.data!.newBalance.toDouble();
              // Refresh history and balance
              await Future.wait([
                loadRechargeHistory(refresh: true),
                loadWalletBalance(),
              ]);

              return true;
            }
            return false;
          },
          showBusy: true,
          successMessage: "Wallet recharged successfully!",
        ) ??
        false;
  }

  /// Cancel recharge
  Future<bool> cancelRecharge(String rechargeId) async {
    return await runWithLoading(() async {
          final response = await _walletService.cancelRecharge(rechargeId);
          if (response?.success == true) {
            await loadRechargeHistory(refresh: true);
            return true;
          }
          return false;
        }, showBusy: true) ??
        false;
  }

  /// Format currency
  String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }
}
