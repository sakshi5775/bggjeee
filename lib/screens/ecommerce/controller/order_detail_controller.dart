import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/order_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';
import 'package:get/get.dart';

class OrderDetailController extends BaseController {
  final EcommerceService _service = EcommerceService();

  final isLoading = false.obs;
  final order = Rxn<OrderModel>();
  final timeline = <OrderTimelineEntry>[].obs;
  final orderHistory = <OrderHistoryEntry>[].obs;
  final isLoadingTimeline = false.obs;
  final isLoadingHistory = false.obs;
  final isCancelling = false.obs;

  String? get orderId => order.value?.id ?? _orderInternalId;
  String? get orderNumber => order.value?.orderId ?? _orderNumber;

  String? _orderInternalId;
  String? _orderNumber;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['order'] is OrderModel) {
      order.value = args['order'] as OrderModel;
    }
    if (args is Map && args['orderId'] is String) {
      _orderInternalId = args['orderId'] as String;
    }
    if (args is Map && args['orderNumber'] is String) {
      _orderNumber = args['orderNumber'] as String;
    }
    _orderInternalId ??= order.value?.id;
    _orderNumber ??= order.value?.orderId;

    final identifier = _orderInternalId ?? _orderNumber;
    if (identifier != null) {
      loadOrder(identifier);
    } else if (order.value != null) {
      _hydrateMetaFromOrder(order.value!);
      _loadSupplementaryData();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadOrder(String identifier) async {
    try {
      isLoading.value = true;
      OrderModel? result;
      if (_looksLikeObjectId(identifier)) {
        result = await _service.getOrderById(identifier);
      }
      result ??= await _service.getOrderByOrderNumber(identifier);
      if (result == null && !_looksLikeObjectId(identifier) && _orderInternalId != null) {
        result = await _service.getOrderById(_orderInternalId!);
      }
      if (result != null) {
        order.value = result;
        order.refresh();
        _hydrateMetaFromOrder(result);
        await _loadSupplementaryData();
      }
    } catch (e) {
      showErrorMessage(title: 'Order details', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOrder() async {
    final identifier = _orderInternalId ?? _orderNumber;
    if (identifier != null) {
      await loadOrder(identifier);
    }
  }

  Future<void> _loadSupplementaryData() async {
    final id = order.value?.id;
    if (id == null) return;
    await Future.wait([
      _loadTracking(id),
      _loadHistory(id),
    ]);
  }

  Future<void> _loadTracking(String orderId) async {
    try {
      isLoadingTimeline.value = true;
      timeline.clear();
      timeline.refresh();
      final tracking = await _service.getOrderTracking(orderId);
      if (tracking != null && tracking.timeline.isNotEmpty) {
        timeline
          ..clear()
          ..addAll(tracking.timeline);
      } else {
        _populateFallbackTimeline();
      }
      timeline.refresh();
    } finally {
      isLoadingTimeline.value = false;
    }
  }

  Future<void> _loadHistory(String orderId) async {
    try {
      isLoadingHistory.value = true;
      orderHistory.clear();
      orderHistory.refresh();
      final result = await _service.getOrderHistory(orderId);
      orderHistory
        ..clear()
        ..addAll(result);
      orderHistory.refresh();
    } finally {
      isLoadingHistory.value = false;
    }
  }

  Future<void> cancelOrder({required String reason}) async {
    final current = order.value;
    if (current == null || current.id == null || !canCancelOrder) return;
    try {
      isCancelling.value = true;
      final result = await _service.cancelOrder(current.id!, reason: reason);
      if (result != null) {
        order.value = result;
        order.refresh();
        _hydrateMetaFromOrder(result);
        await _loadSupplementaryData();
        showSuccessMessage(title: 'Order cancelled', message: 'Your order has been cancelled.');
      }
    } catch (e) {
      showErrorMessage(title: 'Cancel order', message: e.toString());
    } finally {
      isCancelling.value = false;
    }
  }

  bool get canCancelOrder {
    final status = order.value?.status ?? '';
    return [
      'pending',
      'order_placed',
      'payment_pending',
      'awaiting_payment',
      'payment_confirmed',
      'processing',
    ].contains(status);
  }

  String formatStatus(String? status) {
    if (status == null || status.isEmpty) return 'Unknown';
    return status.replaceAll('_', ' ').toUpperCase();
  }

  void _populateFallbackTimeline() {
    final currentStatus = order.value?.status;
    final fallbackStatuses = [
      'pending',
      'payment_confirmed',
      'processing',
      'shipped',
      'delivered',
      'completed',
      'cancelled',
    ];

    final completedUntil = fallbackStatuses.indexWhere((element) => element == currentStatus);
    timeline.clear();
    for (var index = 0; index < fallbackStatuses.length; index++) {
      final status = fallbackStatuses[index];
      final isCompleted = completedUntil >= 0 ? index <= completedUntil : false;
      timeline.add(
        OrderTimelineEntry(
          status: status,
          date: isCompleted ? order.value?.updatedAt : null,
          completed: isCompleted,
        ),
      );
    }
  }

  void _hydrateMetaFromOrder(OrderModel order) {
    _orderInternalId = order.id;
    _orderNumber = order.orderId;
  }

  bool _looksLikeObjectId(String value) {
    final hexRegex = RegExp(r'^[0-9a-fA-F]{24}$');
    return hexRegex.hasMatch(value);
  }
}


