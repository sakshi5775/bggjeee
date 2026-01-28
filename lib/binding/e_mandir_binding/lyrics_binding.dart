import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/lyrics/controller/lyrics_controller.dart';

class LyricsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LyricsController());
  }
}
