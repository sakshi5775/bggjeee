import 'package:astrobharataiuser/data_model/address_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/address_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/widgets/address_form_sheet.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum _AddressListAction { edit, setDefault, delete }

class AddressesView extends GetView<AddressController> {
  const AddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        centerTitle: true,
        title: AutoTranslateText(
          'My Addresses',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 18.sp),
          onPressed: Get.back,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        backgroundColor: AppColors.saffron,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const AutoTranslateText(
          'Add Address',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: controller.loadAddresses,
          color: AppColors.saffron,
          child: controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.addresses.isEmpty
                  ? ListView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
                      children: [
                        Icon(Icons.location_off_outlined,
                            size: 72.sp, color: AppColors.textSecondary.withOpacity(0.4)),
                        SizedBox(height: 16.h),
                        AutoTranslateText(
                          'No addresses saved yet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        AutoTranslateText(
                          'Save your delivery addresses here for a faster checkout experience.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ).merge(AppTypography.body2),
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton.icon(
                          onPressed: () => _openForm(context),
                          icon: const Icon(Icons.add_location_alt_outlined),
                          label: const AutoTranslateText('Add Address'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.saffron,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 120.h),
                      itemBuilder: (_, index) {
                        final address = controller.addresses[index];
                        final isDefault = address.isDefault == true ||
                            controller.defaultAddressId.value == address.id;
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: AutoTranslateText(
                                                address.fullName ?? '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ),
                                            PopupMenuButton<_AddressListAction>(
                                              icon: Icon(Icons.more_vert, color: AppColors.textSecondary),
                                              onSelected: (action) => _handleAction(context, action, address),
                                              itemBuilder: (_) => [
                                                const PopupMenuItem(
                                                  value: _AddressListAction.edit,
                                                  child: AutoTranslateText('Edit'),
                                                ),
                                                if (!isDefault)
                                                  const PopupMenuItem(
                                                    value: _AddressListAction.setDefault,
                                                    child: AutoTranslateText('Set as default'),
                                                  ),
                                                const PopupMenuItem(
                                                  value: _AddressListAction.delete,
                                                  child: AutoTranslateText('Delete'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6.h),
                                        AutoTranslateText(
                                          '${address.addressLine1 ?? ''}${address.addressLine2 != null ? ', ${address.addressLine2}' : ''}',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                          ).merge(AppTypography.body2),
                                        ),
                                        AutoTranslateText(
                                          '${address.city ?? ''}, ${address.state ?? ''}${address.pincode != null ? ' - ${address.pincode}' : ''}',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                          ).merge(AppTypography.body2),
                                        ),
                                        if (address.landmark != null && address.landmark!.isNotEmpty)
                                          AutoTranslateText(
                                            'Landmark: ${address.landmark}',
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        SizedBox(height: 6.h),
                                        Row(
                                          children: [
                                            Icon(Icons.phone, size: 14.sp, color: AppColors.textSecondary),
                                            SizedBox(width: 6.w),
                                            AutoTranslateText(
                                              address.phone ?? '',
                                              style: TextStyle(
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (address.email != null && address.email!.isNotEmpty) ...[
                                          SizedBox(height: 4.h),
                                          Row(
                                            children: [
                                              Icon(Icons.mail_outline,
                                                  size: 14.sp, color: AppColors.textSecondary),
                                              SizedBox(width: 6.w),
                                              Expanded(
                                                child: AutoTranslateText(
                                                  address.email!,
                                                  style: TextStyle(
                                                    color: AppColors.textSecondary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                        SizedBox(height: 10.h),
                                        Wrap(
                                          spacing: 8.w,
                                          runSpacing: 4.h,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                              decoration: BoxDecoration(
                                                color: AppColors.saffron.withOpacity(0.12),
                                                borderRadius: BorderRadius.circular(20.r),
                                              ),
                                              child: AutoTranslateText(
                                                (address.type ?? 'home').toUpperCase(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.saffron,
                                                ).merge(AppTypography.label),
                                              ),
                                            ),
                                            if (isDefault)
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 4.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.peacockBlue.withOpacity(0.12),
                                                  borderRadius: BorderRadius.circular(20.r),
                                                ),
                                                child: AutoTranslateText(
                                                  'DEFAULT',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.peacockBlue,
                                                  ).merge(AppTypography.label),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              AutoTranslateText(
                                'Updated on ${dateFormat.format(DateTime.parse(address.updatedAt ?? address.createdAt ?? DateTime.now().toIso8601String()))}',
                                style: TextStyle(
                                  color: AppColors.textSecondary.withOpacity(0.7),
                                ).merge(AppTypography.label),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemCount: controller.addresses.length,
                    ),
        ),
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
    _AddressListAction action,
    AddressModel address,
  ) async {
    switch (action) {
      case _AddressListAction.edit:
        await _openForm(context, address: address);
        break;
      case _AddressListAction.setDefault:
        await controller.setDefault(address);
        break;
      case _AddressListAction.delete:
        final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const AutoTranslateText('Remove address'),
                content: const AutoTranslateText('Are you sure you want to delete this address?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const AutoTranslateText('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: AutoTranslateText(
                      'Delete',
                      style: TextStyle(color: AppColors.sacredRed),
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

