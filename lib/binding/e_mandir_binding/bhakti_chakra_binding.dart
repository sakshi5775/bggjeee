import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/controller/bhakti_chakra_controller.dart';
import 'package:get/get.dart';

class BhaktiChakraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BhaktiChakraController>(() => BhaktiChakraController());
  }
}
