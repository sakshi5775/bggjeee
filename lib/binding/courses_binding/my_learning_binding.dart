import 'package:astrobharataiuser/screens/courses/controllers/my_learning_controller.dart';
import 'package:get/get.dart';

class MyLearningBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<MyLearningController>()) {
      Get.put(MyLearningController());
    }
  }
}

