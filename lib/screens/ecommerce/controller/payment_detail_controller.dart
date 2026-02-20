import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/payment_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';
import 'package:get/get.dart';

class PaymentDetailController extends BaseController {
  final EcommerceService _service = EcommerceService();

  final isLoading = false.obs;
  final payment = Rxn<PaymentModel>();

  String? _paymentId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['payment'] is PaymentModel) {
      payment.value = args['payment'] as PaymentModel;
    }
    if (args is Map && args['paymentId'] is String) {
      _paymentId = args['paymentId'] as String;
    } else if (payment.value?.id != null) {
      _paymentId = payment.value!.id;
    }

    if (_paymentId != null) {
      loadPayment(_paymentId!);
    }
  }

  Future<void> loadPayment(String id) async {
    try {
      isLoading.value = true;
      final result = await _service.getPaymentById(id);
      if (result != null) {
        payment.value = result;
        payment.refresh();
      }
    } catch (e) {
      showErrorMessage(title: 'Payment details', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  String formatStatus(String? status) {
    if (status == null || status.isEmpty) return 'UNKNOWN';
    return status.replaceAll('_', ' ').toUpperCase();
  }
}


