import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/address_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';
import 'package:get/get.dart';

class AddressController extends BaseController {
  final EcommerceService _service = EcommerceService();

  final addresses = <AddressModel>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final defaultAddressId = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    try {
      isLoading.value = true;
      final list = await _service.getAddresses();
      final defaultAddress = await _service.getDefaultAddress();
      defaultAddressId.value = defaultAddress?.id;
      final sorted = List<AddressModel>.from(list);
      sorted.sort((a, b) {
        final aDefault = a.isDefault == true;
        final bDefault = b.isDefault == true;
        if (aDefault == bDefault) return 0;
        return aDefault ? -1 : 1;
      });
      addresses
        ..clear()
        ..addAll(sorted);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveAddress(
    AddressModel address, {
    bool setAsDefault = false,
  }) async {
    try {
      isSaving.value = true;
      final saved = await _service.upsertAddress(address);
      if (saved != null) {
        if (setAsDefault || address.isDefault == true) {
          if (saved.id != null) {
            await _service.setDefaultAddress(saved.id!);
            defaultAddressId.value = saved.id;
          }
        }
        showSuccessMessage(
          title: 'Address saved',
          message: 'Your address has been saved successfully.',
        );
        await loadAddresses();
      }
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteAddress(AddressModel address) async {
    if (address.id == null) return;
    final success = await _service.deleteAddress(address.id!);
    if (success) {
      showSuccessMessage(
        title: 'Address removed',
        message: 'The address has been removed from your list.',
      );
      await loadAddresses();
    }
  }

  Future<void> setDefault(AddressModel address) async {
    if (address.id == null) return;
    final updated = await _service.setDefaultAddress(address.id!);
    if (updated != null) {
      defaultAddressId.value = updated.id;
      showSuccessMessage(
        title: 'Default updated',
        message: '${updated.fullName ?? 'Address'} set as default.',
      );
      await loadAddresses();
    }
  }
}
