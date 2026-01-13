import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/address_model.dart';
import 'package:astrobharataiuser/data_model/cart_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/cart_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/widgets/address_form_sheet.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum _AddressAction { edit, setDefault, delete }

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 20.sp,
          ),
          onPressed: () => Get.back(),
        ),
        title: AutoTranslateText(
          'Shopping Cart',
          style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite_border,
              color: AppColors.textPrimary,
              size: 22.sp,
            ),
            tooltip: 'Wishlist',
            onPressed: () => Get.toNamed(AppRoutes.wishlist),
          ),
          IconButton(
            icon: Icon(
              Icons.bookmark_outline,
              color: AppColors.textPrimary,
              size: 22.sp,
            ),
            tooltip: 'Saved items',
            onPressed: () => Get.toNamed(AppRoutes.savedItems),
          ),
          Obx(() {
            final count = controller.itemCount;
            return Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: AppColors.textPrimary,
                    size: 24.sp,
                  ),
                  if (count > 0)
                    Positioned(
                      right: -4,
                      top: -6,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.sacredRed,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: AutoTranslateText(
                          count > 99 ? '99+' : count.toString(),
                          style: AppTypography.label.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.cart.value == null) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.saffron),
          );
        }

        final cart = controller.cart.value;
        final items = cart?.items ?? [];

        if (items.isEmpty) {
          return _EmptyCartWidget(onShopNow: () => Get.back());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AddressSection(controller: controller),
                SizedBox(height: 20.h),
                AutoTranslateText(
                  'Items (${items.length})',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                ...List.generate(items.length, (index) {
                  final item = items[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _CartItemTile(
                      item: item,
                      currencyFormat: currencyFormat,
                      controller: controller,
                    ),
                  );
                }),
                if (controller.savedItems.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.savedItems),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.bookmark_outline,
                            color: AppColors.saffron,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: AutoTranslateText(
                              'Saved for later (${controller.savedItems.length})',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 16.h),
                _CouponSection(controller: controller),
                SizedBox(height: 16.h),
                _PaymentMethodSection(controller: controller),
                SizedBox(height: 16.h),
                _PriceSummary(
                  currencyFormat: currencyFormat,
                  subtotal: controller.subtotal,
                  discount: controller.discount,
                  delivery: controller.deliveryFee,
                  tax: controller.tax,
                  total: controller.total,
                ),
                SizedBox(height: 16.h),
                _CheckoutButton(controller: controller),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({
    required this.item,
    required this.currencyFormat,
    required this.controller,
  });

  final CartItem item;
  final NumberFormat currencyFormat;
  final CartController controller;

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final name = product?.name ?? item.productSnapshot?.name ?? 'Product';
    final subtitle = product?.shortDescription ?? item.productSnapshot?.sku;
    final price =
        item.discountedPrice ??
        item.price ??
        product?.currentPrice ??
        product?.discountedPrice ??
        0;
    final quantity = item.quantity ?? 0;
    final isProcessing = controller.isCartItemProcessing(item);

    String? imageUrl;
    if (product?.images != null && product!.images!.isNotEmpty) {
      try {
        final primary = product.images!.firstWhere(
          (img) => img.isPrimary == true,
          orElse: () => product.images!.first,
        );
        imageUrl = primary.url;
      } catch (_) {
        imageUrl = product.images!.first.url;
      }
    }
    if (imageUrl != null && imageUrl.startsWith('/')) {
      imageUrl = 'http://65.1.131.197:8000$imageUrl';
    }

    final canIncrement = !isProcessing && quantity < CartController.maxQuantity;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: imageUrl != null
                  ? NetworkImageWithLoader(
                      url: imageUrl,
                      height: 80.h,
                      width: 80.w,
                    )
                  : Container(
                      height: 80.h,
                      width: 80.w,
                      color: AppColors.textSecondary.withOpacity(0.1),
                      child: Icon(
                        Icons.image,
                        color: AppColors.textSecondary,
                        size: 32.sp,
                      ),
                    ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AutoTranslateText(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: AppColors.sacredRed,
                          size: 20.sp,
                        ),
                        onPressed: isProcessing
                            ? null
                            : () => controller.removeItem(item),
                      ),
                    ],
                  ),
                  if (subtitle != null && subtitle.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    AutoTranslateText(
                      subtitle,
                      style: AppTypography.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 8.h),
                  AutoTranslateText(
                    currencyFormat.format(price),
                    style: AppTypography.h2.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    height: 36.h,
                    width: 140.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: AppColors.saffron),
                      color: AppColors.saffron.withOpacity(0.08),
                    ),
                    child: isProcessing
                        ? Center(
                            child: SizedBox(
                              width: 18.w,
                              height: 18.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.saffron,
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              _CartQuantityButton(
                                icon: Icons.remove,
                                onTap: quantity <= 1
                                    ? () => controller.removeItem(item)
                                    : () => controller.decrementItem(item),
                              ),
                              Expanded(
                                child: AutoTranslateText(
                                  quantity.toString(),
                                  textAlign: TextAlign.center,
                                  style: AppTypography.h3.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              _CartQuantityButton(
                                icon: Icons.add,
                                onTap: canIncrement
                                    ? () => controller.incrementItem(item)
                                    : null,
                                enabled: canIncrement,
                              ),
                            ],
                          ),
                  ),
                  SizedBox(height: 8.h),
                  TextButton(
                    onPressed: isProcessing || product == null
                        ? null
                        : () => controller.saveForLater(item),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: AutoTranslateText(
                      'Save for later',
                      style: AppTypography.body2.copyWith(
                        color: AppColors.saffron,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CouponSection extends StatelessWidget {
  const _CouponSection({required this.controller});

  final CartController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final appliedCoupon = controller.cart.value?.appliedCoupon;
      final couponCode = appliedCoupon?.code ?? '';
      final isApplied = couponCode.isNotEmpty;
      final coupon = appliedCoupon;

      return Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(
                  'Apply Coupon',
                  style: AppTypography.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.coupons),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: AutoTranslateText(
                    'Browse offers',
                    style: AppTypography.body2.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.saffron,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.couponController,
                    enabled: !isApplied,
                    decoration: InputDecoration(
                      hintText: 'Enter coupon code',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.08),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.08),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: AppColors.saffron),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                SizedBox(
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: controller.isApplyingCoupon.value
                        ? null
                        : isApplied
                        ? controller.removeCoupon
                        : controller.applyCoupon,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isApplied
                          ? AppColors.sacredRed
                          : AppColors.saffron.withOpacity(0.9),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: controller.isApplyingCoupon.value
                        ? SizedBox(
                            width: 18.w,
                            height: 18.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : AutoTranslateText(
                            isApplied ? 'Remove' : 'Apply',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            if (isApplied && coupon != null && coupon.discount != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.saffron.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_offer_outlined,
                      color: AppColors.saffron,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: AutoTranslateText(
                        'Coupon $couponCode applied • Saved ₹${(coupon.discount ?? 0).toStringAsFixed(0)}',
                        style: TextStyle(
                          color: AppColors.saffron,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }
}

class _AddressSection extends StatelessWidget {
  const _AddressSection({required this.controller});

  final CartController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final address = controller.selectedAddress.value;
      final hasAddress = address != null;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(
                  'Delivery Address',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showAddressSheet(context),
                  icon: Icon(
                    Icons.edit_location_alt,
                    size: 18.sp,
                    color: AppColors.saffron,
                  ),
                  label: AutoTranslateText(
                    hasAddress ? 'Change Address' : 'Add Address',
                    style: AppTypography.body2.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.saffron,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            if (hasAddress)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    address.fullName ?? '',
                    style: AppTypography.body1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  AutoTranslateText(
                    '${address.addressLine1 ?? ''}${address.addressLine2 != null ? ', ${address.addressLine2}' : ''}',
                    style: AppTypography.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AutoTranslateText(
                    '${address.city ?? ''}, ${address.state ?? ''} - ${address.pincode ?? ''}',
                    style: AppTypography.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AutoTranslateText(
                    address.country ?? '',
                    style: AppTypography.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  AutoTranslateText(
                    'Contact: ${address.phone ?? ''}',
                    style: AppTypography.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (address.isDefault == true)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.saffron.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: AutoTranslateText(
                          'DEFAULT',
                          style: AppTypography.label.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.saffron,
                          ),
                        ),
                      ),
                    ),
                ],
              )
            else
              AutoTranslateText(
                'No delivery address selected. Please add an address to proceed.',
                style: AppTypography.body2.copyWith(color: AppColors.sacredRed),
              ),
          ],
        ),
      );
    });
  }

  void _showAddressSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16.w,
              12.h,
              16.w,
              MediaQuery.of(context).viewInsets.bottom + 16.h,
            ),
            child: Obx(() {
              final addresses = controller.addresses;
              final selectedId = controller.selectedAddress.value?.id;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  AutoTranslateText(
                    'Select Delivery Address',
                    style: AppTypography.h2.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  if (addresses.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: AutoTranslateText(
                        'No addresses saved yet. Add a new address to continue.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: addresses.length,
                        itemBuilder: (_, index) {
                          final address = addresses[index];
                          final isSelected = address.id == selectedId;
                          final isDefault = address.isDefault == true;
                          return Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.saffron
                                    : AppColors.textSecondary.withOpacity(0.12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 12.h,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Radio<String>(
                                    value: address.id ?? '',
                                    groupValue: selectedId,
                                    onChanged: (value) {
                                      controller.selectAddress(address);
                                      Navigator.of(context).pop();
                                    },
                                    activeColor: AppColors.saffron,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: AutoTranslateText(
                                                address.fullName ?? '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            PopupMenuButton<_AddressAction>(
                                              icon: Icon(
                                                Icons.more_vert,
                                                size: 18.sp,
                                              ),
                                              onSelected: (action) async {
                                                switch (action) {
                                                  case _AddressAction.edit:
                                                    Navigator.of(context).pop();
                                                    _showAddressForm(
                                                      context,
                                                      existing: address,
                                                    );
                                                    break;
                                                  case _AddressAction
                                                      .setDefault:
                                                    await controller
                                                        .markDefault(address);
                                                    break;
                                                  case _AddressAction.delete:
                                                    final confirm =
                                                        await showDialog<bool>(
                                                          context: context,
                                                          builder: (ctx) => AlertDialog(
                                                            title: const AutoTranslateText(
                                                              'Remove address',
                                                            ),
                                                            content:
                                                                const AutoTranslateText(
                                                                  'Are you sure you want to delete this address?',
                                                                ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.of(
                                                                      ctx,
                                                                    ).pop(
                                                                      false,
                                                                    ),
                                                                child:
                                                                    const AutoTranslateText(
                                                                      'Cancel',
                                                                    ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.of(
                                                                      ctx,
                                                                    ).pop(true),
                                                                child: AutoTranslateText(
                                                                  'Delete',
                                                                  style: TextStyle(
                                                                    color: AppColors
                                                                        .sacredRed,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ) ??
                                                        false;
                                                    if (confirm) {
                                                      await controller
                                                          .deleteAddress(
                                                            address,
                                                          );
                                                    }
                                                    break;
                                                }
                                              },
                                              itemBuilder: (_) => [
                                                const PopupMenuItem(
                                                  value: _AddressAction.edit,
                                                  child: AutoTranslateText(
                                                    'Edit',
                                                  ),
                                                ),
                                                if (!isDefault)
                                                  const PopupMenuItem(
                                                    value: _AddressAction
                                                        .setDefault,
                                                    child: AutoTranslateText(
                                                      'Set as default',
                                                    ),
                                                  ),
                                                const PopupMenuItem(
                                                  value: _AddressAction.delete,
                                                  child: AutoTranslateText(
                                                    'Delete',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4.h),
                                        AutoTranslateText(
                                          '${address.addressLine1 ?? ''}${address.addressLine2 != null ? ', ${address.addressLine2}' : ''}',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        AutoTranslateText(
                                          '${address.city ?? ''}, ${address.state ?? ''} - ${address.pincode ?? ''}',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        AutoTranslateText(
                                          address.phone ?? '',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        if (isDefault) ...[
                                          SizedBox(height: 6.h),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.saffron
                                                  .withOpacity(0.12),
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                            ),
                                            child: AutoTranslateText(
                                              'DEFAULT',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.saffron,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showAddressForm(context);
                      },
                      icon: Icon(Icons.add, color: AppColors.saffron),
                      label: AutoTranslateText(
                        'Add New Address',
                        style: TextStyle(
                          color: AppColors.saffron,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.saffron),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Future<void> _showAddressForm(
    BuildContext context, {
    AddressModel? existing,
  }) async {
    final result = await showAddressFormSheet(
      context: context,
      initial: existing,
      showDefaultToggle: true,
    );
    if (result != null) {
      await controller.saveAddress(
        result.address,
        setAsDefault: result.setAsDefault,
      );
    }
  }
}

class _CheckoutButton extends StatelessWidget {
  const _CheckoutButton({required this.controller});

  final CartController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isProcessing = controller.isPlacingOrder.value;
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isProcessing
              ? null
              : () => _showAddressSelectionDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.saffron,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
          child: isProcessing
              ? SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : AutoTranslateText(
                  'Proceed to Checkout',
                  style: AppTypography.h2.copyWith(),
                ),
        ),
      );
    });
  }

  void _showAddressSelectionDialog(BuildContext context) {
    final selectedAddress = controller.selectedAddress.value;

    // Always show address selection dialog to allow user to choose or add address
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AutoTranslateText(
          'Select Delivery Address',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Obx(() {
            if (controller.isLoadingAddresses.value) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(20.h),
                  child: CircularProgressIndicator(color: AppColors.saffron),
                ),
              );
            }

            final addresses = controller.addresses;
            if (addresses.isEmpty) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoTranslateText(
                    'No addresses found. Please add an address to continue.',
                    style: AppTypography.body1,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      final addressSection = _AddressSection(
                        controller: controller,
                      );
                      addressSection._showAddressForm(context);
                    },
                    icon: Icon(Icons.add, size: 18.sp),
                    label: AutoTranslateText('Add Address'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.saffron,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              );
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...addresses.map((address) {
                    final isSelected = selectedAddress?.id == address.id;
                    final isDefault = address.isDefault == true;
                    return InkWell(
                      onTap: () {
                        controller.selectAddress(address);
                        Navigator.of(context).pop();
                        controller.placeOrder();
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? AppColors.saffron
                                : AppColors.textSecondary.withOpacity(0.3),
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          color: isSelected
                              ? AppColors.saffron.withOpacity(0.05)
                              : Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: AutoTranslateText(
                                    address.fullName ?? 'Address',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                if (isDefault)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.saffron.withOpacity(
                                        0.12,
                                      ),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: AutoTranslateText(
                                      'DEFAULT',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.saffron,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            AutoTranslateText(
                              '${address.addressLine1 ?? ''}${address.addressLine2 != null ? ', ${address.addressLine2}' : ''}',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            AutoTranslateText(
                              '${address.city ?? ''}, ${address.state ?? ''} - ${address.pincode ?? ''}',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            AutoTranslateText(
                              address.phone ?? '',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        final addressSection = _AddressSection(
                          controller: controller,
                        );
                        addressSection._showAddressForm(context);
                      },
                      icon: Icon(Icons.add, color: AppColors.saffron),
                      label: AutoTranslateText(
                        'Add New Address',
                        style: TextStyle(
                          color: AppColors.saffron,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.saffron),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: AutoTranslateText(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceSummary extends StatelessWidget {
  const _PriceSummary({
    required this.currencyFormat,
    required this.subtotal,
    required this.discount,
    required this.delivery,
    required this.tax,
    required this.total,
  });

  final NumberFormat currencyFormat;
  final double subtotal;
  final double discount;
  final double delivery;
  final double tax;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              'Price Details',
              style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
            ),
            SizedBox(height: 12.h),
            _SummaryRow(
              label: 'Subtotal',
              value: currencyFormat.format(subtotal),
            ),
            _SummaryRow(
              label: 'Discount',
              value: '- ${currencyFormat.format(discount)}',
              valueColor: Colors.green,
            ),
            _SummaryRow(label: 'Tax', value: currencyFormat.format(tax)),
            _SummaryRow(
              label: 'Delivery Fee',
              value: delivery == 0 ? 'Free' : currencyFormat.format(delivery),
            ),
            Divider(
              height: 24.h,
              thickness: 1,
              color: Colors.black.withOpacity(0.05),
            ),
            _SummaryRow(
              label: 'Total',
              value: currencyFormat.format(total),
              labelStyle: AppTypography.h2.copyWith(
                color: AppColors.textPrimary,
              ),
              valueStyle: AppTypography.h2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.labelStyle,
    this.valueStyle,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoTranslateText(
            label,
            style:
                labelStyle ??
                AppTypography.body1.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
          ),
          AutoTranslateText(
            value,
            style:
                valueStyle ??
                AppTypography.body1.copyWith(
                  color: valueColor ?? AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCartWidget extends StatelessWidget {
  const _EmptyCartWidget({required this.onShopNow});

  final VoidCallback onShopNow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 140.h,
            width: 140.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(70.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.saffron,
              size: 60.sp,
            ),
          ),
          SizedBox(height: 24.h),
          AutoTranslateText(
            'Your cart is empty',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          AutoTranslateText(
            'Looks like you haven’t added anything yet.\nStart exploring our products.',
            textAlign: TextAlign.center,
            style: AppTypography.body1.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: onShopNow,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.saffron,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
            child: AutoTranslateText(
              'Shop Now',
              style: AppTypography.h3.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartQuantityButton extends StatelessWidget {
  const _CartQuantityButton({
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled && onTap != null ? onTap : null,
      borderRadius: BorderRadius.circular(18.r),
      child: SizedBox(
        width: 36.w,
        height: double.infinity,
        child: Icon(
          icon,
          size: 18.sp,
          color: enabled
              ? AppColors.saffron
              : AppColors.textSecondary.withOpacity(0.4),
        ),
      ),
    );
  }
}

class _PaymentMethodSection extends StatelessWidget {
  const _PaymentMethodSection({required this.controller});

  final CartController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Payment Method',
            style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
          ),
          SizedBox(height: 12.h),
          Obx(
            () => Column(
              children: [
                _PaymentOptionTile(
                  title: 'Online Payment',
                  value: 'online',
                  groupValue: controller.selectedPaymentMethod.value,
                  onChanged: (val) =>
                      controller.selectedPaymentMethod.value = val!,
                  icon: Icons.credit_card,
                ),
                SizedBox(height: 8.h),
                _PaymentOptionTile(
                  title: 'Cash on Delivery',
                  value: 'cod',
                  groupValue: controller.selectedPaymentMethod.value,
                  onChanged: (val) =>
                      controller.selectedPaymentMethod.value = val!,
                  icon: Icons.money,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentOptionTile extends StatelessWidget {
  const _PaymentOptionTile({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.icon,
  });

  final String title;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? AppColors.saffron
                : AppColors.textSecondary.withOpacity(0.2),
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
          color: isSelected
              ? AppColors.saffron.withOpacity(0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.saffron : AppColors.textSecondary,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AutoTranslateText(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: AppColors.saffron,
            ),
          ],
        ),
      ),
    );
  }
}
