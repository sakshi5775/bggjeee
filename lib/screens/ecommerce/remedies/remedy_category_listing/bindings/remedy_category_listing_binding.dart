import 'package:astrobharataiuser/screens/ecommerce/remedies/remedy_category_listing/controller/remedy_category_listing_controller.dart';
import 'package:get/get.dart';

class RemedyCategoryListingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RemedyCategoryListingController>(
      () => RemedyCategoryListingController(),
    );
  }
}
