import 'package:astrobharataiuser/screens/ecommerce/controller/cart_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/product_detail_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/wishlist_controller.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut(() => CartController(), fenix: true);
    }
    if (!Get.isRegistered<WishlistController>()) {
      Get.lazyPut(() => WishlistController(), fenix: true);
    }
    // Always create a fresh controller instance
    if (Get.isRegistered<ProductDetailController>()) {
      Get.delete<ProductDetailController>(force: true);
    }
    Get.lazyPut(() => ProductDetailController(), fenix: false);
  }
}

