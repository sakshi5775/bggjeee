import 'package:astrobharataiuser/screens/ecommerce/controller/cart_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/product_list_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/wishlist_controller.dart';
import 'package:get/get.dart';

class ProductListBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut(() => CartController(), fenix: true);
    }
    if (!Get.isRegistered<WishlistController>()) {
      Get.lazyPut(() => WishlistController(), fenix: true);
    }
    Get.lazyPut(() => ProductListController());
  }
}

