import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/controller/bhakti_chakra_controller.dart';

class BhaktiChakraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BhaktiChakraController());
  }
}
