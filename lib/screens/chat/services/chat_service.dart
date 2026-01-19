
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/data_model/chat_model.dart';
import 'package:astrobharataiuser/data_model/user_profile_model.dart';
import 'package:astrobharataiuser/utils/language_detector.dart';
import 'package:get/get.dart';

class ChatService {
  final ApiRepository _apiRepository;

  ChatService({ApiRepository? apiRepository})
      : _apiRepository = apiRepository ?? Get.find<ApiRepository>();


  /// Format profile data as context string prepended to the persona request.
  String _formatProfileContext(UserProfileModel profile, String? language) {
    final parts = <String>[];

    final personalInfo = profile.personalInfo;
    if (personalInfo != null) {
      if (personalInfo.fullName != null && personalInfo.fullName!.isNotEmpty) {
        parts.add('Name: ${personalInfo.fullName}');
      }
      if (personalInfo.gender != null && personalInfo.gender!.isNotEmpty) {
        parts.add('Gender: ${personalInfo.gender}');
      }
      if (personalInfo.maritalStatus != null && personalInfo.maritalStatus!.isNotEmpty) {
        parts.add('Marital Status: ${personalInfo.maritalStatus}');
      }
      if (personalInfo.occupation != null && personalInfo.occupation!.isNotEmpty) {
        parts.add('Occupation: ${personalInfo.occupation}');
      }
    }

    final birthChart = profile.birthChart;
    if (birthChart != null) {
      final birthPlace = birthChart.birthPlace;
      if (birthPlace != null) {
        final birthPlaceParts = <String>[];
        if (birthPlace.city != null) birthPlaceParts.add(birthPlace.city!);
        if (birthPlace.state != null) birthPlaceParts.add(birthPlace.state!);
        if (birthPlace.country != null) birthPlaceParts.add(birthPlace.country!);
        if (birthPlaceParts.isNotEmpty) {
          parts.add('Birth Place: ${birthPlaceParts.join(", ")}');
        }
      }
      final birthTime = birthChart.birthTime;
      if (birthTime != null && birthTime.hour != null && birthTime.minute != null) {
        final hour = birthTime.hour!.toString().padLeft(2, '0');
        final minute = birthTime.minute!.toString().padLeft(2, '0');
        final second = (birthTime.second ?? 0).toString().padLeft(2, '0');
        parts.add('Birth Time: $hour:$minute:$second');
      }
      if (birthChart.generatedAt != null && birthChart.generatedAt!.isNotEmpty) {
        parts.add('Birth Date: ${birthChart.generatedAt}');
      }
    }

    // Add language to the context if provided
    if (language != null && language.isNotEmpty) {
      parts.add('Language: $language');
    }

    if (parts.isEmpty) {
      return '';
    }
    return '[User Profile Context: ${parts.join("; ")}]';
  }

  /// Build structured profile payload to send alongside message.
  /// Only includes data from dialog form - no existing user data.
  Map<String, dynamic> _buildProfilePayload(UserProfileModel profile) {
    final data = <String, dynamic>{};
    final personalInfo = profile.personalInfo;
    if (personalInfo != null) {
      data['personalInfo'] = personalInfo.toJson();
    }
    final birthChart = profile.birthChart;
    if (birthChart != null) {
      data['birthChart'] = birthChart.toJson();
    }
    // Include preferences to override user's stored language preference
    final preferences = profile.preferences;
    if (preferences != null) {
      data['preferences'] = preferences.toJson();
    }
    return data;
  }

  Future<SendMessageResponse> sendMessage(
    String personaId,
    String message,
    String? conversationId, {
    UserProfileModel? userProfile,
    String? preferredLanguage,
  }) async {
    try {
      // Only use the profile from dialog form, never fetch existing user info
      final profileForContext = userProfile;
      final language = preferredLanguage ?? LanguageDetector.detectLanguage(message);
      var messageToSend = message;

      // Only prepend profile context for the first message (new conversation)
      // For existing conversations, profile is already known to the AI
      if (profileForContext != null && (conversationId == null || conversationId.isEmpty)) {
        // Include language in the context string
        final context = _formatProfileContext(profileForContext, language);
        if (context.isNotEmpty) {
          messageToSend = '$context\n\n$message';
        }
      }

      final body = <String, dynamic>{
        'message': messageToSend,
        // Only send language for new conversations (when conversationId is null/empty)
        // For existing conversations, language is already set and cannot be changed
        if (conversationId == null || conversationId.isEmpty) 'language': language,
        if (conversationId != null && conversationId.isNotEmpty) 'conversationId': conversationId,
      };

      // Only send userProfile for new conversations (first message)
      // For existing conversations, profile is already set
      if (profileForContext != null && (conversationId == null || conversationId.isEmpty)) {
        final payload = _buildProfilePayload(profileForContext);
        if (payload.isNotEmpty) {
          body['userProfile'] = payload;
        }
      }

      final response = await _apiRepository.postApi(
        EndPoints.chatSendMessage(personaId),
        body,
        useAuthHeader: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SendMessageResponse.fromJson(response.body);
      }
      throw Exception('Failed to send message: ${response.statusText}');
    } catch (e) {
      rethrow;
    }
  }

  Future<Conversation> getConversation(String personaId, String conversationId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.chatGetConversation(personaId, conversationId),
        useAuthHeader: true,
      );
      if (response.statusCode == 200) {
        return Conversation.fromJson(response.body);
      }
      throw Exception('Failed to get conversation: ${response.statusText}');
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteConversation(String personaId, String conversationId) async {
    try {
      final response = await _apiRepository.deleteReq(
        EndPoints.chatDeleteConversation(personaId, conversationId),
        useAuthHeader: true,
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      rethrow;
    }
  }
}

