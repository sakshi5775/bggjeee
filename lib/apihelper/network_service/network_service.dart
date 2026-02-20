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
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkConnectivity();
    });
  }

  Future<bool> checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));
      final connected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      isConnected.value = connected;
      return connected;
    } catch (_) {
      isConnected.value = false;
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
