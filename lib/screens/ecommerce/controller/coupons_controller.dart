import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/coupon_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/cart_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';
import 'package:get/get.dart';

class CouponsController extends BaseController {
  final EcommerceService _service = EcommerceService();

  final coupons = <CouponModel>[].obs;
  final isLoading = false.obs;
  final validationResult = Rxn<CouponValidationResult>();
  final isValidating = false.obs;

  CartController? get _cartController =>
      Get.isRegistered<CartController>() ? Get.find<CartController>() : null;

  @override
  void onInit() {
    super.onInit();
    loadCoupons();
  }

  Future<void> loadCoupons() async {
    try {
      isLoading.value = true;
      final list = await _service.getAvailableCoupons();
      coupons
        ..clear()
        ..addAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> validateCoupon(CouponModel coupon) async {
    try {
      isValidating.value = true;
      final cartTotal = _cartController?.total;
      final result = await _service.validateCoupon(
        code: coupon.code ?? '',
        cartTotal: cartTotal == 0 ? null : cartTotal,
      );
      validationResult.value = result;
      if (result?.isValid == true) {
        showSuccessMessage(
          title: 'Coupon valid',
          message: 'You can apply this coupon to your cart.',
        );
      } else {
        showErrorMessage(
          title: 'Coupon invalid',
          message: 'This coupon is not applicable at the moment.',
        );
      }
    } finally {
      isValidating.value = false;
    }
  }

  Future<void> applyCoupon(CouponModel coupon) async {
    final cartController = _cartController;
    if (cartController == null) {
      Get.snackbar(
        'Coupon code',
        'Login to your account to apply this coupon in cart.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    cartController.couponController.text = coupon.code ?? '';
    await cartController.applyCoupon();
  }
}

