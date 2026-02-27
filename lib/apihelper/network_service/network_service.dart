import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkService extends GetxService {
  static NetworkService get instance => Get.find();

  final RxBool isConnected = true.obs;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  Future<void> _initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await Connectivity().checkConnectivity();
    } catch (e) {
      print('Couldn\'t check connectivity status: $e');
      return;
    }
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none) && result.length == 1) {
      isConnected.value = false;
    } else {
      isConnected.value = true;
    }
  }

  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none) &&
        connectivityResult.length == 1) {
      isConnected.value = false;
      return false;
    } else {
      isConnected.value = true;
      return true;
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  static Future<bool> isOnline() async {
    if (Get.isRegistered<NetworkService>()) {
      return instance.isConnected.value;
    }
    return true; // Default to true if service not yet ready
  }
}
