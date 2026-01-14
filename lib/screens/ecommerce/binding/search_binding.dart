import 'package:astrobharataiuser/screens/ecommerce/controller/search_controller.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EcommerceSearchController>(() => EcommerceSearchController(), fenix: true);
  }
}

