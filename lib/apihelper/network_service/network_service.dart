import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';

class NetworkService extends GetxService {
  static NetworkService get instance => Get.find();

  final RxBool isConnected = true.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    checkConnectivity();
    _startPolling();
  }

  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      checkConnectivity();
    });
  }

  int _failedAttempts = 0;
  static const int _maxFailedAttempts =
      3; // Tolerate 2-3 drops before showing offline screen

  Future<bool> checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup(
        'dns.google', // Use a highly reliable DNS
      ).timeout(const Duration(seconds: 4));

      final connected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      if (connected) {
        _failedAttempts = 0; // Reset on success
        if (!isConnected.value) {
          isConnected.value = true;
        }
      }
      return connected;
    } catch (_) {
      _failedAttempts++;
      if (_failedAttempts >= _maxFailedAttempts) {
        isConnected.value = false;
      }
      return false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  static Future<bool> isOnline() async {
    if (Get.isRegistered<NetworkService>()) {
      return instance.isConnected.value;
    }
    return true; // Default to true if service not yet ready
  }
}
