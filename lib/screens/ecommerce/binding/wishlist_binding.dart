import 'package:astrobharataiuser/screens/ecommerce/controller/wishlist_controller.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<WishlistController>()) {
      Get.lazyPut<WishlistController>(() => WishlistController(), fenix: true);
    }
  }
}
