import 'package:astrobharataiuser/screens/ecommerce/controller/search_controller.dart';
import 'package:get/get.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EcommerceSearchController>(() => EcommerceSearchController(), fenix: true);
  }
}

