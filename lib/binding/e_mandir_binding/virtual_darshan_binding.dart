import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/controller/virtual_darshan_controller.dart';
import 'package:get/get.dart';

class VirtualDarshanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VirtualDarshanController());
  }
}
