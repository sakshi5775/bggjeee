import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/address_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/address_selection/service/puja_address_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressFormController extends BaseController {
  final PujaAddressService _addressService = PujaAddressService();

  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController alternatePhoneController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController labelController = TextEditingController();

  // Address type selection
  final RxString selectedAddressType = 'home'.obs;
  final RxBool isDefault = false.obs;

  // Edit mode
  final RxBool isEditMode = false.obs;
  String? editAddressId;

  // Saving state
  final RxBool isSaving = false.obs;

  // Address types
  final List<String> addressTypes = ['home', 'office', 'other'];

  @override
  void onInit() {
    super.onInit();
    _parseArguments();
  }

  void _parseArguments() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      // Check if editing
      final address = args['address'] as AddressModel?;
      if (address != null) {
        isEditMode.value = true;
        editAddressId = address.id;
        _populateForm(address);
      }
    }
  }

  void _populateForm(AddressModel address) {
    fullNameController.text = address.fullName ?? '';
    phoneController.text = address.phone ?? '';
    alternatePhoneController.text = address.alternatePhone ?? '';
    emailController.text = address.email ?? '';
    addressLine1Controller.text = address.addressLine1 ?? '';
    addressLine2Controller.text = address.addressLine2 ?? '';
    cityController.text = address.city ?? '';
    stateController.text = address.state ?? '';
    pincodeController.text = address.pincode ?? '';
    countryController.text = address.country ?? 'India';
    landmarkController.text = address.landmark ?? '';
    labelController.text = address.label ?? '';
    selectedAddressType.value = address.type ?? 'home';
    isDefault.value = address.isDefault ?? false;
  }

  void selectAddressType(String type) {
    selectedAddressType.value = type;
  }

  void toggleDefault(bool value) {
    isDefault.value = value;
  }

  Future<void> saveAddress() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isSaving.value = true;

    try {
      final address = AddressModel(
        fullName: fullNameController.text.trim(),
        phone: phoneController.text.trim(),
        alternatePhone: alternatePhoneController.text.trim().isNotEmpty
            ? alternatePhoneController.text.trim()
            : null,
        email: emailController.text.trim().isNotEmpty
            ? emailController.text.trim()
            : null,
        addressLine1: addressLine1Controller.text.trim(),
        addressLine2: addressLine2Controller.text.trim().isNotEmpty
            ? addressLine2Controller.text.trim()
            : null,
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        pincode: pincodeController.text.trim(),
        country: countryController.text.trim().isNotEmpty
            ? countryController.text.trim()
            : 'India',
        landmark: landmarkController.text.trim().isNotEmpty
            ? landmarkController.text.trim()
            : null,
        label: labelController.text.trim().isNotEmpty
            ? labelController.text.trim()
            : null,
        type: selectedAddressType.value,
        isDefault: isDefault.value,
      );

      AddressModel? result;
      if (isEditMode.value && editAddressId != null) {
        result = await _addressService.updateAddress(editAddressId!, address);
      } else {
        result = await _addressService.createAddress(address);
      }

      if (result != null) {
        Get.back(result: true);
        Get.snackbar(
          'Success',
          isEditMode.value
              ? 'Address updated successfully'
              : 'Address added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
        // Go back and refresh the address list
      } else {
        Get.snackbar(
          'Error',
          isEditMode.value
              ? 'Failed to update address'
              : 'Failed to add address',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  // Validators
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (value.trim().length < 10) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Email is optional
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePincode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Pincode is required';
    }
    if (value.trim().length != 6) {
      return 'Enter a valid 6-digit pincode';
    }
    return null;
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    alternatePhoneController.dispose();
    emailController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    countryController.dispose();
    landmarkController.dispose();
    labelController.dispose();
    super.onClose();
  }
}

