import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/data_model/cart_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/cart_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CartItemsListWidget extends StatelessWidget {
  final List<CartItem> items;
  final CartController controller;
  final NumberFormat currencyFormat;

  const CartItemsListWidget({
    super.key,
    required this.items,
    required this.controller,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _CartItemCard(
                item: item,
                controller: controller,
                currencyFormat: currencyFormat,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final CartController controller;
  final NumberFormat currencyFormat;

  const _CartItemCard({
    required this.item,
    required this.controller,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final name = product?.name ?? item.productSnapshot?.name ?? 'Product';
    final basePrice = product?.basePrice ?? 0.0;
    final price =
        item.discountedPrice ??
        item.price ??
        product?.currentPrice ??
        product?.discountedPrice ??
        0;
    final quantity = item.quantity ?? 0;
    final isProcessing = controller.isCartItemProcessing(item);
    final hasDiscount = basePrice > 0 && basePrice > price;
    final discountPercent = hasDiscount
        ? ((basePrice - price) / basePrice * 100).round()
        : 0;

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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.white,
            '#FEF6C3'.toColor().withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: '#68171E'.toColor().withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: '#68171E'.toColor().withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image with Badge
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: imageUrl != null
                            ? NetworkImageWithLoader(
                                url: imageUrl,
                                height: 110.h,
                                width: 110.w,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 110.h,
                                width: 110.w,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.textSecondary.withValues(
                                        alpha: 0.1,
                                      ),
                                      AppColors.textSecondary.withValues(
                                        alpha: 0.05,
                                      ),
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  Icons.image_outlined,
                                  color: AppColors.textSecondary.withOpacity(
                                    0.5,
                                  ),
                                  size: 40.h,
                                ),
                              ),
                      ),
                    ),
                    if (hasDiscount)
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                '#F38B3B'.toColor(),
                                '#DD2914'.toColor(),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: '#DD2914'.toColor().withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: AutoTranslateText(
                            '$discountPercent% OFF',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 16.w),
                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      AutoTranslateText(
                        name,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: '#68171E'.toColor(),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      // Price Section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          AutoTranslateText(
                            currencyFormat.format(price),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: '#68171E'.toColor(),
                              height: 1,
                            ),
                          ),
                          if (hasDiscount) ...[
                            SizedBox(width: 8.w),
                            AutoTranslateText(
                              currencyFormat.format(basePrice),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                decoration: TextDecoration.lineThrough,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Quantity Selector
                      Container(
                        height: 40.h,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: '#68171E'.toColor().withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: isProcessing
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                                  child: SizedBox(
                                    width: 18.w,
                                    height: 18.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.saffron,
                                    ),
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _QuantityButton(
                                    icon: quantity <= 1
                                        ? Icons.delete_outline_rounded
                                        : Icons.remove_rounded,
                                    onTap: quantity <= 1
                                        ? () => controller.removeItem(item)
                                        : () => controller.decrementItem(item),
                                    isRemove: quantity <= 1,
                                  ),
                                  GestureDetector(
                                    onTap: isProcessing
                                        ? null
                                        : () => _showQuantityDialog(
                                            context,
                                            quantity,
                                            (val) =>
                                                controller.setProductQuantity(
                                                  product: item.product!,
                                                  targetQuantity: val,
                                                  variantId: item.variantId,
                                                ),
                                          ),
                                    child: Container(
                                      constraints: BoxConstraints(minWidth: 40.w),
                                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                                      alignment: Alignment.center,
                                      child: AutoTranslateText(
                                        quantity.toString(),
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: '#68171E'.toColor(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  _QuantityButton(
                                    icon: Icons.add_rounded,
                                    onTap: canIncrement
                                        ? () => controller.incrementItem(item)
                                        : null,
                                    enabled: canIncrement,
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Delete Button
          Positioned(
            top: 12.h,
            right: 12.w,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isProcessing ? null : () => controller.removeItem(item),
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.sacredRed.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.sacredRed.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.sacredRed,
                    size: 20.h,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;
  final bool isRemove;

  const _QuantityButton({
    required this.icon,
    this.onTap,
    this.enabled = true,
    this.isRemove = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled && onTap != null ? onTap : null,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: enabled
                ? (isRemove
                    ? AppColors.sacredRed.withValues(alpha: 0.1)
                    : '#68171E'.toColor().withValues(alpha: 0.05))
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18.w,
            color: enabled
                ? (isRemove ? AppColors.sacredRed : '#68171E'.toColor())
                : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}

Future<void> _showQuantityDialog(
  BuildContext context,
  int currentQuantity,
  Function(int) onConfirm,
) async {
  final textController = TextEditingController(
    text: currentQuantity.toString(),
  );
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const AutoTranslateText(
        'Update Quantity',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: TextField(
        controller: textController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'Enter quantity',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const AutoTranslateText(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final val = int.tryParse(textController.text);
            if (val != null && val > 0) {
              Navigator.of(context).pop();
              onConfirm(val);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.saffron,
            foregroundColor: Colors.white,
          ),
          child: const AutoTranslateText('Update'),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
