import 'package:astrobharataiuser/screens/global_search/controller/global_search_controller.dart';
import 'package:get/get.dart';

class GlobalSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GlobalSearchController>(
      () => GlobalSearchController(),
      fenix: true,
    );
  }
}
