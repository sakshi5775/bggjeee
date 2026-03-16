import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/wallet_model.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/user_profile_service.dart';
import 'package:astrobharataiuser/screens/wallet/service/wallet_service.dart';
import 'package:astrobharataiuser/screens/wallet/service/wallet_razorpay_service.dart';
import 'package:astrobharataiuser/screens/wallet/widgets/wallet_success_dialog.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/core/services/crashlytics_service.dart';
import 'package:astrobharataiuser/core/services/analytics_service.dart';

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
  final RxString selectedStatus = ''.obs;
  final RxString selectedType = ''.obs; // '', 'RECHARGE', 'DEDUCTION'
  final Rx<DateTime?> dateFrom = Rx<DateTime?>(null);
  final Rx<DateTime?> dateTo = Rx<DateTime?>(null);
  final RxString sortOrder = 'NEWEST'.obs;
  final List<String> statusOptions = [
    '',
    'INITIATED',
    'PENDING',
    'COMPLETED',
    'FAILED',
    'CANCELLED',
  ];
  static const List<String> typeOptions = ['', 'RECHARGE', 'DEDUCTION'];

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
        CrashlyticsService.trackAction(
          "PAYMENT",
          "FAIL",
          data: "reason: $message",
        );
        showErrorMessage(title: 'Recharge Failed', message: message);
      },
      onFailure: (response) {
        CrashlyticsService.trackAction(
          "PAYMENT",
          "FAIL_GATEWAY",
          data: "code: ${response.code}, message: ${response.message}",
        );
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

    CrashlyticsService.trackAction(
      "PAYMENT",
      "CALLBACK",
      data: "paymentId:$paymentId, orderId:$orderId",
    );

    if (_pendingRechargeId == null) {
      CrashlyticsService.trackAction("PAYMENT", "SESSION_LOST");
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
      CrashlyticsService.trackAction(
        "PAYMENT",
        "SUCCESS",
        data: "rechargeId:$_pendingRechargeId",
      );

      // Log Analytics
      AnalyticsService().logWalletRecharge(
        amount: walletBalance
            .value, // This is the new balance, but maybe we should log the recharge amount
        transactionId: paymentId,
      );

      // Show success modal
      _showPaymentSuccessModal();
      // Refresh wallet balance and history
      await loadWalletBalance();
      await loadRechargeHistory(refresh: true);
    }
  }

  void _showPaymentSuccessModal() {
    Get.dialog(const WalletRechargeSuccessDialog(), barrierDismissible: false);
    Future.delayed(const Duration(seconds: 3), () {
      if (Get.isDialogOpen == true) Get.back();
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
      CrashlyticsService.trackAction(
        "PAYMENT",
        "INIT",
        data: "amount:$amount, rechargeId:${response.rechargeId}",
      );
      _razorpayService.openCheckout(razorpayData: response.razorpay!);
    } else {
      CrashlyticsService.trackAction(
        "PAYMENT",
        "INIT_FAIL",
        data: "amount:$amount",
      );
      showErrorMessage(title: "Error", message: "Failed to initiate recharge.");
    }
  }

  /// Load wallet balance and transaction history from user profile
  Future<void> loadWalletBalance() async {
    final userId = UserData().getLoginData.user?.userId;
    if (userId == null) return;

    await runWithLoading(
      () async {
        // Fetch Profile Data (PRIMARY SOURCE of balance and transactions)
        try {
          print("DEBUG: Fetching profile for wallet balance, userId: $userId");
          final profile = await _profileService.getProfile(userId);

          if (profile != null && profile.wallet != null) {
            walletBalance.value = profile.wallet!.balance ?? 0.0;
            currency.value = profile.wallet!.currency ?? 'INR';

            // Get.snackbar(
            //   "Debug: Profile OK",
            //   "Bal: ${walletBalance.value} ${currency.value}",
            //   snackPosition: SnackPosition.BOTTOM,
            // );

            // Update history from profile transactions
            _updateHistoryFromProfile(profile.wallet!.transactions ?? []);

            // If profile balance is 0, try fallback just in case profile data is stale/limited
            if (walletBalance.value == 0.0) {
              await _fallbackToBalanceApi(userId);
            }
          } else {
            // Get.snackbar("Debug: Profile/Wallet NULL", "Trying fallback API");
            await _fallbackToBalanceApi(userId);
          }
        } catch (e) {
          ///   Get.snackbar("Debug: Profile Catch", e.toString());
          await _fallbackToBalanceApi(userId);
        }
      },
      showBusy: false,
      showError: true,
    );

    isLoadingHistory.value = false;
  }

  Future<void> _fallbackToBalanceApi(String userId) async {
    try {
      print("DEBUG: Fetching fallback balance for userId: $userId");
      final balanceResponse = await _walletService.getWalletBalance(userId);
      if (balanceResponse != null && balanceResponse.data != null) {
        double newBalance = balanceResponse.data!.balance.toDouble();
        if (walletBalance.value == 0.0 || walletBalance.value != newBalance) {
          walletBalance.value = newBalance;
          currency.value = balanceResponse.data!.currency;

          // Get.snackbar(
          //   "Debug: Fallback Success",
          //   "Bal: ${walletBalance.value} ${currency.value}",
          //   snackPosition: SnackPosition.BOTTOM,
          // );
        }
      } else {
        Get.snackbar("Debug: Fallback FAIL", "No data returned");
      }
    } catch (e) {
      print("DEBUG: Error fetching fallback wallet balance: $e");
      Get.snackbar("Debug: Fallback Exception", e.toString());
    }
  }

  /// Update combined history using only transactions from profile
  void _updateHistoryFromProfile(List<WalletTransaction> transactions) {
    print(
      "DEBUG: Updating history from profile, count: ${transactions.length}",
    );

    // DEBUG SNACKBAR
    // Get.snackbar(
    //   "Debug: History Loaded",
    //   "Found ${transactions.length} transactions in profile",
    //   snackPosition: SnackPosition.BOTTOM,
    //   duration: const Duration(seconds: 5),
    // );

    for (var tx in transactions) {
      print(
        "DEBUG: Transaction - Type: ${tx.type}, Amount: ${tx.amount}, Status: ${tx.status}, Description: ${tx.description}",
      );
    }

    // We use transactions directly from profile as they contain both recharges and deductions
    List<dynamic> list = List.from(transactions);

    // Sort transactions based on sortOrder
    _sortTransactions(list);

    _allTransactions = list;
    _applyFilterAndPaginate();

    print(
      "DEBUG: _allTransactions populated, count: ${_allTransactions.length}",
    );
    print("DEBUG: combinedHistory populated, count: ${combinedHistory.length}");
  }

  void _sortTransactions(List<dynamic> list) {
    list.sort((a, b) {
      DateTime? dateA = (a as WalletTransaction).createdAtDate;
      DateTime? dateB = (b as WalletTransaction).createdAtDate;

      if (dateA == null) return 1;
      if (dateB == null) return -1;

      if (sortOrder.value == 'NEWEST') {
        return dateB.compareTo(dateA); // Descending
      } else {
        return dateA.compareTo(dateB); // Ascending
      }
    });
  }

  void setSortOrder(String order) {
    sortOrder.value = order;
    _sortTransactions(_allTransactions);
    _applyFilterAndPaginate();
  }

  /// Load recharge history (Now just a wrapper for loadWalletBalance)
  Future<void> loadRechargeHistory({bool refresh = false}) async {
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

  void filterByStatus(String? status) {
    selectedStatus.value = status ?? '';
    _applyFilterAndPaginate();
  }

  void filterByType(String? type) {
    selectedType.value = type ?? '';
    _applyFilterAndPaginate();
  }

  void setDateRange(DateTime? from, DateTime? to) {
    dateFrom.value = from;
    dateTo.value = to;
    _applyFilterAndPaginate();
  }

  void clearDateFilter() {
    dateFrom.value = null;
    dateTo.value = null;
    _applyFilterAndPaginate();
  }

  bool get hasActiveFilters =>
      selectedStatus.value.isNotEmpty ||
      selectedType.value.isNotEmpty ||
      dateFrom.value != null ||
      dateTo.value != null;

  void clearAllFilters() {
    selectedStatus.value = '';
    selectedType.value = '';
    dateFrom.value = null;
    dateTo.value = null;
    _applyFilterAndPaginate();
  }

  /// Apply filter and reset pagination
  void _applyFilterAndPaginate() {
    List<dynamic> list = List.from(_allTransactions);

    if (selectedStatus.value.isNotEmpty) {
      list = list.where((item) {
        String status = '';
        if (item is WalletRechargeHistoryItem) {
          status = item.status;
        } else if (item is WalletTransaction) {
          status = item.status;
        }
        return status.toUpperCase() == selectedStatus.value.toUpperCase();
      }).toList();
    }

    if (selectedType.value.isNotEmpty) {
      list = list.where((item) {
        if (item is WalletTransaction) {
          return item.type.toUpperCase() == selectedType.value.toUpperCase();
        }
        if (item is WalletRechargeHistoryItem) {
          return selectedType.value.toUpperCase() == 'RECHARGE';
        }
        return false;
      }).toList();
    }

    final from = dateFrom.value;
    final to = dateTo.value;
    if (from != null || to != null) {
      list = list.where((item) {
        DateTime? dt;
        if (item is WalletTransaction) {
          dt = item.createdAtDate;
        } else if (item is WalletRechargeHistoryItem) {
          dt = item.initiatedAtDate ?? item.createdAtDate;
        }
        if (dt == null) return false;
        if (from != null &&
            dt.isBefore(DateTime(from.year, from.month, from.day)))
          return false;
        if (to != null) {
          final endOfDay = DateTime(to.year, to.month, to.day, 23, 59, 59);
          if (dt.isAfter(endOfDay)) return false;
        }
        return true;
      }).toList();
    }

    _filteredTransactions = list;
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

            CrashlyticsService.trackAction(
              "PAYMENT",
              "VERIFY",
              data: "rechargeId:$rechargeId, success:${response?.success}",
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
