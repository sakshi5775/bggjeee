import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Set User ID after successful login
  Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (e) {
      debugPrint("Analytics Error: $e");
    }
  }

  // Set User Properties
  Future<void> setUserProperty(String name, String value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      debugPrint("Analytics Error: $e");
    }
  }

  // Log Generic Custom Event
  Future<void> logCustomEvent(String name, [Map<String, Object>? parameters]) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      debugPrint("Analytics Error: $e");
    }
  }

  // --- Authentication Events ---

  Future<void> logLogin(String loginMethod) async {
    try {
      await _analytics.logLogin(loginMethod: loginMethod);
    } catch (e) {
      debugPrint("Analytics Error: $e");
    }
  }

  Future<void> logAppOpen() async {
    try {
      await _analytics.logAppOpen();
    } catch (e) {
      debugPrint("Analytics Error: $e");
    }
  }

  Future<void> logSignUp(String signUpMethod) async {
    try {
      await _analytics.logSignUp(signUpMethod: signUpMethod);
    } catch (e) {
      debugPrint("Analytics Error: $e");
    }
  }

  Future<void> logLogout() async {
    try {
      await _analytics.logEvent(name: 'logout');
    } catch (e) {
      debugPrint("Analytics Error: $e");
    }
  }

  // --- E-Commerce Events ---

  Future<void> logViewItem({
    required String itemId,
    required String itemName,
    required String itemCategory,
    double? price,
  }) async {
    try {
      await _analytics.logViewItem(
        currency: 'INR',
        value: price,
        items: [
          AnalyticsEventItem(
            itemId: itemId,
            itemName: itemName,
            itemCategory: itemCategory,
            price: price,
          ),
        ],
      );
    } catch (e) {
      debugPrint("Analytics Error: $e");
    }
  }

  Future<void> logAddToCart({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required int quantity,
    double? price,
  }) async {
    try {
      await _analytics.logAddToCart(
        currency: 'INR',
        value: (price ?? 0) * quantity,
        items: [
          AnalyticsEventItem(
            itemId: itemId,
            itemName: itemName,
            itemCategory: itemCategory,
            price: price,
            quantity: quantity,
          ),
        ],
      );
    } catch (e) {
      debugPrint("Analytics Error: $e");
    }
  }

  Future<void> logRemoveFromCart({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required int quantity,
    double? price,
  }) async {
    try {
      await _analytics.logRemoveFromCart(
        currency: 'INR',
        value: (price ?? 0) * quantity,
        items: [
          AnalyticsEventItem(
            itemId: itemId,
            itemName: itemName,
            itemCategory: itemCategory,
            price: price,
            quantity: quantity,
          ),
        ],
      );
    } catch (e) {
      debugPrint("Analytics Error: $e");
    }
  }

  Future<void> logPurchase({
    required String transactionId,
    required double value,
    List<AnalyticsEventItem>? items,
  }) async {
    try {
      await _analytics.logPurchase(
        currency: 'INR',
        transactionId: transactionId,
        value: value,
        items: items,
      );
    } catch (e) {
      debugPrint("Analytics Error: $e");
    }
  }

  // --- Services Events ---

  Future<void> logServiceClicked(String serviceName) async {
    try {
      await _analytics.logEvent(
        name: 'service_clicked',
        parameters: {
          'service_name': serviceName,
        },
      );
    } catch (e) {
      debugPrint("Analytics Error: $e");
    }
  }

  Future<void> logViewServiceCategory(String categoryName) async {
    try {
      await _analytics.logEvent(
        name: 'view_service_category',
        parameters: {
          'category_name': categoryName,
        },
      );
    } catch (e) {
      debugPrint("Analytics Error: $e");
    }
  }

  Future<void> logBookService({
    required String serviceName,
    double? price,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'book_service',
        parameters: {
          'service_name': serviceName,
          'price': price ?? 0.0,
          'currency': 'INR',
        },
      );
    } catch (e) {
      debugPrint("Analytics Error: $e");
    }
  }

  Future<void> logWalletRecharge({
    required double amount,
    required String transactionId,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'wallet_recharge',
        parameters: {
          'value': amount,
          'currency': 'INR',
          'transaction_id': transactionId,
        },
      );
    } catch (e) {
      debugPrint("Analytics Error: $e");
    }
  }

  Future<void> logSearch(String searchTerm) async {
    try {
      await _analytics.logSearch(searchTerm: searchTerm);
    } catch (e) {
      debugPrint("Analytics Error: $e");
    }
  }

  Future<void> logDeleteAccount() async {
    try {
      await _analytics.logEvent(name: 'delete_account');
    } catch (e) {
      debugPrint("Analytics Error: $e");
    }
  }

  Future<void> logUpdateProfile() async {
    try {
      await _analytics.logEvent(name: 'update_profile');
    } catch (e) {
      debugPrint("Analytics Error: $e");
    }
  }

  Future<void> logVirtualDarshanAction({
    required String actionType,
    required String itemName,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'virtual_darshan_action',
        parameters: {
          'action_type': actionType,
          'item_name': itemName,
        },
      );
    } catch (e) {
      debugPrint("Analytics Error: $e");
    }
  }
}
