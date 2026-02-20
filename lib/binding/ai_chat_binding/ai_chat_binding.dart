import 'package:astrobharataiuser/screens/ai_chat/controllers/ai_chat_controller.dart';
import 'package:get/get.dart';



class AiChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AiChatController());
  }
}
