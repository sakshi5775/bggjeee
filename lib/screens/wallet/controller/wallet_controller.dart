import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/wallet_model.dart';
import 'package:astrobharataiuser/screens/wallet/service/wallet_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/user_profile_service.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/wallet/service/wallet_razorpay_service.dart';

class WalletController extends BaseController {
  final WalletService _walletService = WalletService();
  final UserProfileService _profileService = UserProfileService();

  // Wallet balance
  final RxDouble walletBalance = 0.0.obs;
  final RxString currency = 'INR'.obs;

  // Recharge history
  final RxList<WalletRechargeHistoryItem> rechargeHistory =
      <WalletRechargeHistoryItem>[].obs;
  final RxBool isLoadingHistory = false.obs;
  final RxBool isLoadingMore = false.obs;

  // Pagination
  final RxInt currentOffset = 0.obs;
  final RxInt limit = 20.obs;
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
    loadRechargeHistory();
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

    await verifyRecharge(
      rechargeId: _pendingRechargeId!,
      transactionId: paymentId,
      razorpayOrderId: orderId,
      razorpayPaymentId: paymentId,
      razorpaySignature: signature,
    );
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
    try {
      final userId = UserData().getLoginData.user?.userId;
      if (userId != null) {
        // Use the new specific wallet balance API if available,
        // or fall back to profile.
        // Let's use the new API I added to WalletService
        final balanceResponse = await _walletService.getWalletBalance(userId);
        if (balanceResponse != null && balanceResponse.data != null) {
          walletBalance.value = balanceResponse.data!.balance.toDouble();
          currency.value = balanceResponse.data!.currency;
        } else {
          // Fallback to profile
          final profile = await _profileService.getProfile(userId);
          if (profile?.wallet != null) {
            walletBalance.value = profile!.wallet!.balance ?? 0.0;
            currency.value = profile.wallet!.currency ?? 'INR';
          }
        }
      }
    } catch (e) {
      print('Error loading wallet balance: $e');
    }
  }

  /// Load recharge history
  Future<void> loadRechargeHistory({bool refresh = false}) async {
    try {
      if (refresh) {
        currentOffset.value = 0;
        rechargeHistory.clear();
      }

      isLoadingHistory.value = true;
      final response = await _walletService.getRechargeHistory(
        limit: limit.value,
        offset: currentOffset.value,
        status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
      );

      if (response?.data != null) {
        if (refresh) {
          rechargeHistory.value = response!.data!.recharges;
        } else {
          rechargeHistory.addAll(response!.data!.recharges);
        }
        hasMore.value = response.data!.pagination.hasMore;
        total.value = response.data!.pagination.total;
        currentOffset.value =
            response.data!.pagination.offset + response.data!.recharges.length;
      }
    } catch (e) {
      print('Error loading recharge history: $e');
    } finally {
      isLoadingHistory.value = false;
    }
  }

  /// Load more recharge history (pagination)
  Future<void> loadMoreHistory() async {
    if (isLoadingMore.value || !hasMore.value) return;

    try {
      isLoadingMore.value = true;
      final response = await _walletService.getRechargeHistory(
        limit: limit.value,
        offset: currentOffset.value,
        status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
      );

      if (response?.data != null) {
        rechargeHistory.addAll(response!.data!.recharges);
        hasMore.value = response.data!.pagination.hasMore;
        currentOffset.value =
            response.data!.pagination.offset + response.data!.recharges.length;
      }
    } catch (e) {
      print('Error loading more history: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Filter by status
  void filterByStatus(String? status) {
    selectedStatus.value = status ?? '';
    loadRechargeHistory(refresh: true);
  }

  /// Initiate recharge
  Future<WalletRechargeData?> initiateRecharge({
    required int amount,
    String paymentMethod = 'online',
    String paymentProvider = 'razorpay', // Default changed to razorpay
  }) async {
    try {
      isInitiatingRecharge.value = true;
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
    } catch (e) {
      print('Error initiating recharge: $e');
      return null;
    } finally {
      isInitiatingRecharge.value = false;
    }
  }

  /// Verify recharge
  Future<bool> verifyRecharge({
    required String rechargeId,
    required String transactionId,
    String? razorpayOrderId,
    String? razorpayPaymentId,
    String? razorpaySignature,
  }) async {
    try {
      isVerifyingRecharge.value = true;
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
        // Refresh history
        await loadRechargeHistory(refresh: true);
        // Refresh wallet balance from API
        await loadWalletBalance();

        showSuccessMessage(
          title: "Success",
          message: "Wallet recharged successfully!",
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Error verifying recharge: $e');
      showErrorMessage(title: "Verification Failed", message: e.toString());
      return false;
    } finally {
      isVerifyingRecharge.value = false;
    }
  }

  /// Cancel recharge
  Future<bool> cancelRecharge(String rechargeId) async {
    try {
      final response = await _walletService.cancelRecharge(rechargeId);
      if (response?.success == true) {
        // Refresh history
        await loadRechargeHistory(refresh: true);
        return true;
      }
      return false;
    } catch (e) {
      print('Error cancelling recharge: $e');
      return false;
    }
  }

  /// Format currency
  String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }
}
