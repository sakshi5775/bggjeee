import 'package:astrobharataiuser/app_manager/common/global_header/global_header_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/services/remedies_service.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/controllers/remedies_controller.dart';
import 'package:get/get.dart';

class RemediesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RemediesService>(() => RemediesService());
    Get.lazyPut<RemediesController>(() => RemediesController());
    Get.lazyPut<GlobalHeaderController>(() => GlobalHeaderController());
  }
}
