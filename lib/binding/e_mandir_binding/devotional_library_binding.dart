import 'package:astrobharataiuser/screens/e_mandir/devotional_library/controller/devotional_library_controller.dart';
import 'package:get/get.dart';

class DevotionalLibraryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DevotionalLibraryController>(() => DevotionalLibraryController());
  }
}
