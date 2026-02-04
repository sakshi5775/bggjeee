import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/data_model/puja_model.dart';
import 'package:get/get.dart';

class PujaService {
  final ApiRepository _apiRepository = Get.find();

  /// Get all pujas with filters
  Future<PujaResponse?> getPujas({
    int page = 1,
    int limit = 10,
    String? search,
    String? templeId,
    bool? featured,
    bool? popular,
  }) async {
    final query = <String, dynamic>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (search != null && search.isNotEmpty) {
      query['search'] = search;
    }

    if (templeId != null && templeId.isNotEmpty) {
      query['templeId'] = templeId;
    }

    // Only add featured filter if explicitly provided (not null)
    if (featured != null) {
      query['featured'] = featured.toString();
    }

    // Only add popular filter if explicitly provided (not null)
    if (popular != null) {
      query['popular'] = popular.toString();
    }

    final response = await _apiRepository.getApi(EndPoints.pujas, query: query);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body['success'] == true) {
        return PujaResponse.fromJson(response.body);
      }
    }

    throw response.body?['message']?.toString() ?? 'Failed to load pujas';
  }

  /// Get puja by ID
  Future<PujaModel?> getPujaById(String pujaId) async {
    final response = await _apiRepository.getApi(EndPoints.pujaById(pujaId));

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body['success'] == true && response.body['data'] != null) {
        return PujaModel.fromJson(response.body['data']);
      }
    }

    throw response.body?['message']?.toString() ??
        'Failed to load puja details';
  }
}
