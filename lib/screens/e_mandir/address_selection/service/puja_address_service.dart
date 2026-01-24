import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/data_model/address_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class PujaAddressService {
  final ApiRepository _apiRepository = Get.find();

  /// Get all addresses for puja booking
  Future<List<AddressModel>?> getAddresses() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.pujaAddresses);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true && response.body['data'] != null) {
          final List<dynamic> addressList = response.body['data'];
          return addressList
              .map((json) => AddressModel.fromJson(json))
              .toList();
        }
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching addresses: $e');
      }
      return null;
    }
  }

  /// Delete an address
  Future<bool> deleteAddress(String addressId) async {
    try {
      final response = await _apiRepository.deleteReq(
        EndPoints.pujaAddressById(addressId),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting address: $e');
      }
      return false;
    }
  }

  /// Update an address
  Future<AddressModel?> updateAddress(
    String addressId,
    AddressModel address,
  ) async {
    try {
      final response = await _apiRepository.putApiCall(
        EndPoints.pujaAddressById(addressId),
        address.toRequestBody(forUpdate: true),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true && response.body['data'] != null) {
          return AddressModel.fromJson(response.body['data']);
        }
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating address: $e');
      }
      return null;
    }
  }

  /// Create a new address
  Future<AddressModel?> createAddress(AddressModel address) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.pujaAddresses,
        address.toRequestBody(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true && response.body['data'] != null) {
          return AddressModel.fromJson(response.body['data']);
        }
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating address: $e');
      }
      return null;
    }
  }

  /// Set an address as default
  Future<bool> setDefaultAddress(String addressId) async {
    try {
      final response = await _apiRepository.putApiCall(
        EndPoints.pujaAddressSetDefault(addressId),
        {},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body['success'] == true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error setting default address: $e');
      }
      return false;
    }
  }
}
