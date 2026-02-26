import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_collection/e_mandir_wallpaper/data_model/e_mandir_wallpaper_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_collection/e_mandir_wallpaper/data_model/daily_thought_model.dart';
import 'package:get/get.dart';

class EMandirWallpaperService {
  final ApiRepository _apiRepository = Get.find();

  /// Fetch daily wallpapers from API, using the type parameter to filter by "Astrology", "Rashifal", "Today", etc. if the API supports it.
  Future<DailyWallpaperResponse?> getDailyWallpapers({
    int page = 1,
    int limit = 20,
    String? filter,
  }) async {
    try {
      var queryParameters = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      // If the API supports a filter like 'type' or 'category', we add it here.
      // if (filter != null && filter != 'Today') {
      //   queryParameters['type'] = filter;
      // }

      final response = await _apiRepository.getApi(
        EndPoints.dailyWallpapers,
        query: queryParameters,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DailyWallpaperResponse.fromJson(response.body);
      }

      return null;
    } catch (e) {
      print('Error fetching daily wallpapers: $e');
      return null;
    }
  }

  /// Fetch daily thoughts based on filter (today, morning, evening, night)
  Future<DailyThoughtResponse?> getDailyThoughts(String filter) async {
    try {
      final response = await _apiRepository.getApi(
        '${EndPoints.dailyThoughts}/$filter',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DailyThoughtResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching daily thoughts: $e');
      return null;
    }
  }
}
