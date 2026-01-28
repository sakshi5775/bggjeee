import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/controller/devotional_library_controller.dart';

class DevotionalLibraryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DevotionalLibraryController());
  }
}
