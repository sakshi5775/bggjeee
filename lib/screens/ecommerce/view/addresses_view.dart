import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/data_model/address_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/address_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/widgets/address_form_sheet.dart';
import 'package:astrobharataiuser/screens/ecommerce/widgets/address_widget/add_address_fab_widget.dart';
import 'package:astrobharataiuser/screens/ecommerce/widgets/address_widget/address_card_widget.dart';
import 'package:astrobharataiuser/screens/ecommerce/widgets/address_widget/empty_addresses_widget.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddressesView extends GetView<AddressController> {
  final bool showBackButton;
  const AddressesView({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            CommonHeader(
              title: 'My Addresses',
              showBackButton: showBackButton,
              subtitle: AutoTranslateText(
                'Manage your delivery addresses',
                style: TextStyle(
                  color: '#6F221E'.toColor().withValues(alpha: 0.7),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => RefreshIndicator(
                  onRefresh: controller.loadAddresses,
                  color: AppColors.saffron,
                  child: controller.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.saffron,
                          ),
                        )
                      : controller.addresses.isEmpty
                      ? EmptyAddressesWidget(
                          onAddAddress: () => _openForm(context),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 100.h),
                          itemBuilder: (_, index) {
                            final address = controller.addresses[index];
                            final isDefault =
                                address.isDefault == true ||
                                controller.defaultAddressId.value == address.id;
                            return AddressCardWidget(
                              address: address,
                              isDefault: isDefault,
                              dateFormat: dateFormat,
                              onAction: (action, addr) =>
                                  _handleAction(context, action, addr),
                            );
                          },
                          separatorBuilder: (_, __) => SizedBox(height: 16.h),
                          itemCount: controller.addresses.length,
                        ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: AddAddressFabWidget(onPressed: () => _openForm(context)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Future<void> _openForm(BuildContext context, {AddressModel? address}) async {
    final result = await showAddressFormSheet(
      context: context,
      initial: address,
      showDefaultToggle: true,
    );
    if (result != null) {
      await controller.saveAddress(
        result.address,
        setAsDefault: result.setAsDefault,
      );
    }
  }

  Future<void> _handleAction(
    BuildContext context,
    AddressListAction action,
    AddressModel address,
  ) async {
    switch (action) {
      case AddressListAction.edit:
        await _openForm(context, address: address);
        break;
      case AddressListAction.setDefault:
        await controller.setDefault(address);
        break;
      case AddressListAction.delete:
        final confirm =
            await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                title: AutoTranslateText(
                  'Remove address',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                    color: '#68171E'.toColor(),
                  ),
                ),
                content: AutoTranslateText(
                  'Are you sure you want to delete this address?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: AutoTranslateText(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.of(ctx).pop(true),
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          child: AutoTranslateText(
                            'Delete',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ) ??
            false;
        if (confirm) {
          await controller.deleteAddress(address);
        }
        break;
    }
  }
}
