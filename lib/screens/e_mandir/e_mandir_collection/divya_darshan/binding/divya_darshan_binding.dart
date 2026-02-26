import 'package:astrobharataiuser/screens/e_mandir/e_mandir_collection/divya_darshan/controller/divya_darshan_controller.dart';
import 'package:get/get.dart';

class DivyaDarshanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DivyaDarshanController>(() => DivyaDarshanController());
  }
}
