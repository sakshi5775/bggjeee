import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/puja_item_category_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/coin_action_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/special_bhog_model.dart';
import 'package:get/get.dart';

import '../../../../data_model/e_mandir_dataModels/e_mandir_home_model.dart';

class PujaItemCategoryService {
  final ApiRepository _apiRepository = Get.find();

  /// Fetch all puja item categories
  Future<PujaItemCategoriesResponse?> getCategories() async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.pujaItemCategories,
        query: {'page': '1', 'limit': '20'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PujaItemCategoriesResponse.fromJson(response.body);
      }

      return null;
    } catch (e) {
      print('Error fetching puja item categories: $e');
      return null;
    }
  }

  /// Fetch category details with items by category ID
  Future<PujaItemCategoryDetailResponse?> getCategoryById(
    String categoryId,
  ) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.pujaItemCategoryById(categoryId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PujaItemCategoryDetailResponse.fromJson(response.body);
      }

      return null;
    } catch (e) {
      print('Error fetching category detail: $e');
      return null;
    }
  }

  /// daily checkin api .
  Future<bool> dailyCheckIn() async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.sriMandirDailyCheckIn,
        {},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<EMandirHomeDataModel?> punyaWallet() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.sriMandirPunya);

      final data = response.body['data'];

      return EMandirHomeDataModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<bool> useItem(String itemId) async {
    try {
      final response = await _apiRepository.postApi(EndPoints.useCoinItem, {
        "itemId": itemId,
        "quantity": 1,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get all coin actions (how to earn punya)
  Future<CoinActionsResponse?> getCoinActions() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.coinActions);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CoinActionsResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching coin actions: $e');
      return null;
    }
  }

  /// Earn punya coins via action key
  Future<bool> earnWalletCoin(String actionKey) async {
    try {
      final response = await _apiRepository.postApi(EndPoints.walletEarn, {
        "actionKey": actionKey,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error earning wallet coin: $e');
      return false;
    }
  }

  /// Get special bhog data for the day
  Future<SpecialBhogResponse?> getSpecialBhog() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.specialBhog);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return SpecialBhogResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching special bhog: $e');
      return null;
    }
  }
}
