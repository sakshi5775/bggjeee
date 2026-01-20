import 'package:astrobharataiuser/screens/e_mandir/devotional_player/controller/devotional_player_controller.dart';
import 'package:get/get.dart';

class DevotionalPlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DevotionalPlayerController>(() => DevotionalPlayerController());
  }
}
