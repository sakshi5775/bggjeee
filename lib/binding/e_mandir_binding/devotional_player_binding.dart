import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/controller/devotional_player_controller.dart';

class DevotionalPlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DevotionalPlayerController());
  }
}
