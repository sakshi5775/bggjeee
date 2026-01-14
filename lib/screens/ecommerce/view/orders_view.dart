import 'package:astrobharataiuser/app_manager/my_appbar.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/order_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/orders_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:intl/intl.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: const MyAppbar(
        title: 'My Orders',
        showLeading: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildFilters(),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.orders.isEmpty) {
                  return Center(
                    child: AutoTranslateText(
                      'No orders found. Start shopping to place your first order!',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: controller.orders.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemBuilder: (_, index) {
                    final order = controller.orders[index];
                    return _OrderCard(order: order);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.searchController,
            onChanged: controller.onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search by order ID',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.textSecondary.withOpacity(0.15)),
          ),
          child: Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedStatus.value,
                items: controller.statusOptions
                    .map(
                      (option) => DropdownMenuItem<String>(
                        value: option['value']!,
                        child: AutoTranslateText(option['label']!),
                      ),
                    )
                    .toList(),
                onChanged: controller.onStatusChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();
    final orderDate = _formatDate(order.createdAt);
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final imageUrl = _resolveOrderImage(firstItem);

    return InkWell(
      onTap: () => Get.toNamed(
        AppRoutes.orderDetail,
        arguments: {'order': order},
      ),
      borderRadius: BorderRadius.circular(16.r),
      child: Ink(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
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
                      AutoTranslateText(
                        order.orderId ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      AutoTranslateText(
                        'Placed on $orderDate',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusChip(status: order.status),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: imageUrl != null
                      ? NetworkImageWithLoader(
                          url: imageUrl,
                          height: 50.h,
                          width: 50.w,
                        )
                      : Container(
                          height: 50.h,
                          width: 50.w,
                          color: AppColors.textSecondary.withOpacity(0.1),
                          child: Icon(Icons.image, size: 20.sp, color: AppColors.textSecondary),
                        ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        firstItem?.productSnapshot?.name ??
                            firstItem?.product?.name ??
                            '${order.itemCount ?? 0} items',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      if (firstItem?.productSnapshot?.sku != null)
                        AutoTranslateText(
                          'SKU: ${firstItem!.productSnapshot!.sku}',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      SizedBox(height: 4.h),
                      AutoTranslateText(
                        'Qty: ${order.itemCount ?? firstItem?.quantity ?? 0}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                SizedBox(
                  width: 70.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        'Subtotal',
                        style: AppTypography.label.copyWith(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: AutoTranslateText(
                          '₹${order.subtotal.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      AutoTranslateText(
                        'Total',
                        style: AppTypography.label.copyWith(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: AutoTranslateText(
                          '₹${order.totalAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _OrderTimeline(currentStep: controller.statusToStep(order.status)),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null) return '';
    try {
      final dt = DateTime.parse(date).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (_) {
      return date;
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final label = (status ?? 'unknown').replaceAll('_', ' ');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.saffron.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: AutoTranslateText(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.saffron,
        ),
      ),
    );
  }
}

class _OrderTimeline extends StatelessWidget {
  const _OrderTimeline({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final steps = [
      _TimelineStep('1', 'Order placed'),
      _TimelineStep('2', 'Awaiting payment'),
      _TimelineStep('3', 'Processing'),
      _TimelineStep('4', 'Shipped'),
      _TimelineStep('5', 'Delivered'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: steps
          .asMap()
          .entries
          .map(
            (entry) => _TimelineNode(
              step: entry.value,
              isCompleted: entry.key + 1 <= currentStep,
            ),
          )
          .toList(),
    );
  }
}

class _TimelineStep {
  const _TimelineStep(this.number, this.label);

  final String number;
  final String label;
}

class _TimelineNode extends StatelessWidget {
  const _TimelineNode({required this.step, required this.isCompleted});

  final _TimelineStep step;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final color = isCompleted ? AppColors.saffron : AppColors.textSecondary.withOpacity(0.3);
    return Column(
      children: [
        Container(
          height: 30.w,
          width: 30.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
            color: isCompleted ? AppColors.saffron.withOpacity(0.15) : Colors.transparent,
          ),
          alignment: Alignment.center,
          child: AutoTranslateText(
            step.number,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: 60.w,
          child: AutoTranslateText(
            step.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

String? _resolveOrderImage(OrderItem? item) {
  if (item == null) return null;
  final product = item.product;
  if (product?.images != null && product!.images!.isNotEmpty) {
    try {
      final primary = product.images!.firstWhere(
        (img) => img.isPrimary == true,
        orElse: () => product.images!.first,
      );
      if (primary.url != null && primary.url!.isNotEmpty) {
        final url = primary.url!;
        return url.startsWith('http') ? url : 'http://65.1.131.197:8000$url';
      }
    } catch (_) {}
  }
  final snapshotUrl = item.productSnapshot?.image;
  if (snapshotUrl != null && snapshotUrl.isNotEmpty) {
    return snapshotUrl.startsWith('http')
        ? snapshotUrl
        : 'http://65.1.131.197:8000$snapshotUrl';
  }
  return null;
}

