import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/payment_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentsController extends BaseController {
  final EcommerceService _service = EcommerceService();

  final isLoading = false.obs;
  final payments = <PaymentModel>[].obs;
  final pagination = Rxn<PaymentPagination>();
  final selectedStatus = ''.obs;
  final searchController = TextEditingController();
  final _allPayments = <PaymentModel>[];

  final statusOptions = const [
    {'label': 'All statuses', 'value': ''},
    {'label': 'Initiated', 'value': 'initiated'},
    {'label': 'Pending', 'value': 'pending'},
    {'label': 'Completed', 'value': 'completed'},
    {'label': 'Failed', 'value': 'failed'},
    {'label': 'Refunded', 'value': 'refunded'},
  ];

  @override
  void onInit() {
    super.onInit();
    loadPayments();
  }

  Future<void> loadPayments() async {
    try {
      isLoading.value = true;
      final response = await _service.getPayments(
        page: 1,
        limit: 25,
        status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
      );
      if (response != null) {
        pagination.value = response.pagination;
        _allPayments
          ..clear()
          ..addAll(response.items);
        _applyFilters();
      }
    } catch (e) {
      showErrorMessage(title: 'Payments', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void onStatusChanged(String? status) {
    selectedStatus.value = status ?? '';
    loadPayments();
  }

  void onSearchChanged(String value) {
    _applyFilters();
  }

  Future<void> refreshList() async {
    await loadPayments();
  }

  void _applyFilters() {
    final query = searchController.text.trim().toLowerCase();
    final filtered = _allPayments.where((payment) {
      if (query.isEmpty) return true;
      final matchesPaymentId = payment.id?.toLowerCase().contains(query) ?? false;
      final matchesOrderId = payment.order?.orderId?.toLowerCase().contains(query) ?? false;
      final matchesTransaction = payment.transactionId?.toLowerCase().contains(query) ?? false;
      return matchesPaymentId || matchesOrderId || matchesTransaction;
    }).toList();
    payments
      ..clear()
      ..addAll(filtered);
    payments.refresh();
  }

  String formatStatus(String? status) {
    if (status == null || status.isEmpty) return 'UNKNOWN';
    return status.replaceAll('_', ' ').toUpperCase();
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return '--';
    try {
      final parsed = DateTime.parse(date).toLocal();
      return '${parsed.day.toString().padLeft(2, '0')} '
          '${_monthAbbr(parsed.month)} '
          '${parsed.year}, '
          '${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return date;
    }
  }

  String _monthAbbr(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}


