import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/order_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersController extends BaseController {
  final EcommerceService _service = EcommerceService();

  final isLoading = false.obs;
  final orders = <OrderModel>[].obs;
  final _allOrders = <OrderModel>[];
  final pagination = Rxn<OrderPagination>();
  final selectedStatus = ''.obs;
  final searchController = TextEditingController();

  final statusOptions = const [
    {'label': 'All statuses', 'value': ''},
    {'label': 'Pending', 'value': 'pending'},
    {'label': 'Payment pending', 'value': 'payment_pending'},
    {'label': 'Payment confirmed', 'value': 'payment_confirmed'},
    {'label': 'Processing', 'value': 'processing'},
    {'label': 'Shipped', 'value': 'shipped'},
    {'label': 'Delivered', 'value': 'delivered'},
    {'label': 'Completed', 'value': 'completed'},
    {'label': 'Cancelled', 'value': 'cancelled'},
  ];

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      final response = await _service.getOrders(
        page: 1,
        limit: 20,
        status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
      );
      if (response != null) {
        pagination.value = response.pagination;
        _allOrders
          ..clear()
          ..addAll(response.items);
        _applyFilters();
      }
    } catch (e) {
      showErrorMessage(title: 'Orders', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void onStatusChanged(String? status) {
    selectedStatus.value = status ?? '';
    loadOrders();
  }

  void onSearchChanged(String value) {
    _applyFilters(query: value);
  }

  void _applyFilters({String? query}) {
    final q = (query ?? searchController.text).trim().toLowerCase();
    final filtered = _allOrders.where((order) {
      final matchesQuery =
          q.isEmpty || (order.orderId?.toLowerCase().contains(q) ?? false);
      return matchesQuery;
    }).toList();
    orders
      ..clear()
      ..addAll(filtered);
    orders.refresh();
  }

  int statusToStep(String? status) {
    switch (status) {
      case 'order_placed':
      case 'pending':
        return 1;
      case 'payment_pending':
      case 'awaiting_payment':
        return 2;
      case 'payment_confirmed':
      case 'processing':
        return 3;
      case 'shipped':
        return 4;
      case 'delivered':
      case 'completed':
        return 5;
      default:
        return 1;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}


