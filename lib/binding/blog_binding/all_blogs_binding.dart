import 'package:astrobharataiuser/screens/blogs/controller/all_blogs_controller.dart';
import 'package:get/get.dart';

class AllBlogsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllBlogsController());
  }
}
