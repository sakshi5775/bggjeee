import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/address_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/address_selection/service/puja_address_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class AddressSelectionController extends BaseController {
  final PujaAddressService _addressService = PujaAddressService();

  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final Rx<AddressModel?> selectedAddress = Rx<AddressModel?>(null);
  final RxString errorMessage = ''.obs;
  final RxBool isDeleting = false.obs;

  // Arguments from previous page
  String? pujaId;
  String? pujaTitle;
  String? packageId;
  int packageIndex = 0;
  int personCount = 1;
  double? price;
  String? packageName;

  @override
  void onInit() {
    super.onInit();
    _parseArguments();
    loadAddresses();
  }

  void _parseArguments() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      pujaId = args['pujaId'] as String?;
      pujaTitle = args['pujaTitle'] as String?;
      packageId = args['packageId'] as String?;
      packageIndex = args['packageIndex'] as int? ?? 0;
      personCount = args['personCount'] as int? ?? 1;
      final priceArg = args['price'];
      if (priceArg != null) {
        if (priceArg is int) {
          price = priceArg.toDouble();
        } else if (priceArg is double) {
          price = priceArg;
        } else if (priceArg is num) {
          price = priceArg.toDouble();
        }
      } else {
        price = null;
      }
      packageName = args['packageName'] as String?;
    }
  }

  Future<void> loadAddresses() async {
    setLoadingState(true);
    errorMessage.value = '';

    try {
      final result = await _addressService.getAddresses();
      if (result != null) {
        addresses.value = result;
        // Auto-select default address if available
        final defaultAddress = result.firstWhereOrNull(
          (a) => a.isDefault == true,
        );
        if (defaultAddress != null) {
          selectedAddress.value = defaultAddress;
        } else if (result.isNotEmpty) {
          selectedAddress.value = result.first;
        }
      } else {
        errorMessage.value = 'Failed to load addresses';
      }
    } catch (e) {
      errorMessage.value = 'Error loading addresses: ${e.toString()}';
    } finally {
      setLoadingState(false);
    }
  }

  void selectAddress(AddressModel address) {
    selectedAddress.value = address;
  }

  Future<void> deleteAddress(String addressId) async {
    isDeleting.value = true;

    try {
      final success = await _addressService.deleteAddress(addressId);
      if (success) {
        addresses.removeWhere((a) => a.id == addressId);
        if (selectedAddress.value?.id == addressId) {
          selectedAddress.value = addresses.isNotEmpty ? addresses.first : null;
        }
        Get.snackbar(
          'Success',
          'Address deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete address',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error deleting address: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } finally {
      isDeleting.value = false;
    }
  }

  Future<void> onEditAddress(AddressModel address) async {
    // Navigate to edit address page and wait for result
    final result = await UserMainController.pushInCurrentTab(
      AppRoutes.addressForm,
      arguments: {'address': address},
    );

    // Refresh list if address was updated
    if (result == true) {
      loadAddresses();
    }
  }

  Future<void> onAddNewAddress() async {
    // Navigate to add new address page and wait for result
    final result = await UserMainController.pushInCurrentTab(AppRoutes.addressForm);

    // Refresh list if new address was added
    if (result == true) {
      loadAddresses();
    }
  }

  void onProceedToPayment() {
    if (selectedAddress.value == null) {
      Get.snackbar(
        'Select Address',
        'Please select a delivery address to continue',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
      return;
    }

    // Navigate to booking form with all required data
    UserMainController.pushInCurrentTab(
      AppRoutes.pujaBookingForm,
      arguments: {
        'pujaId': pujaId,
        'pujaTitle': pujaTitle,
        'packageId': packageId,
        'packageIndex': packageIndex,
        'personCount': personCount,
        'price': price,
        'packageName': packageName,
        'address': selectedAddress.value,
      },
    );
  }

  /// Set an address as default
  Future<void> setAsDefaultAddress(AddressModel address) async {
    if (address.id == null) return;

    // If already default, no action needed
    if (address.isDefault == true) return;

    try {
      final success = await _addressService.setDefaultAddress(address.id!);
      if (success) {
        // Update local state - set all addresses as non-default except the selected one
        for (var addr in addresses) {
          addr.isDefault = addr.id == address.id;
        }
        addresses.refresh();

        Get.snackbar(
          'Success',
          'Default address updated',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to set default address',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error setting default address: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    }
  }

  String getAddressTypeIcon(String? addressType) {
    switch (addressType?.toLowerCase()) {
      case 'home':
        return '🏠';
      case 'office':
        return '🏢';
      case 'other':
        return '📍';
      default:
        return '📍';
    }
  }
}
