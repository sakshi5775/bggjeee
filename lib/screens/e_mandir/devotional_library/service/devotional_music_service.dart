import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:get/get.dart';
import '../data_model/devotional_music_model.dart';

class DevotionalMusicService {
  final ApiRepository _apiRepository = Get.find();

  Future<DevotionalMusicResponse?> getTracks(
    String godId,
    String category, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.devotionalMusic(godId, category),
        query: {'page': page.toString(), 'limit': limit.toString()},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DevotionalMusicResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching devotional music: $e');
      return null;
    }
  }
}
