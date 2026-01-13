import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/data_model/user_profile_model.dart';
import 'package:astrobharataiuser/screens/chat/controllers/chat_controller.dart';
import 'package:get/get.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;
    PersonaModel persona;
    UserProfileModel? chatProfile;
    String? languageCode;

    if (args is Map<String, dynamic>) {
      persona = args['persona'] as PersonaModel;
      chatProfile = args['chatProfile'] as UserProfileModel?;
      languageCode = args['languageCode'] as String?;
    } else {
      persona = args as PersonaModel;
    }

    Get.lazyPut(() => ChatController(
          persona: persona,
          chatProfile: chatProfile,
          preferredLanguage: languageCode,
        ));
  }
}





