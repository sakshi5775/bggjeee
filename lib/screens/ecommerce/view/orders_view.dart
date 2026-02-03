import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/order_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/orders_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              CommonHeader(
                title: 'My Orders',
                customActions: [_filterDialog()],
              ),
              Padding(padding: EdgeInsets.all(16.w), child: _buildFilters()),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.deepOrange,
                      ),
                    );
                  }
                  if (controller.orders.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
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
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search by order ID',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.6),
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.deepOrange),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.deepOrange, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _filterDialog() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.textSecondary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedStatus.value,
            dropdownColor: Colors.white,
            icon: Icon(
              Icons.filter_list,
              color: AppColors.deepOrange,
              size: 20.w,
            ),
            style: TextStyle(
              color: AppColors.textColorMaroon,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
            items: controller.statusOptions
                .map(
                  (option) => DropdownMenuItem<String>(
                    value: option['value']!,
                    child: AutoTranslateText(
                      option['label']!,
                      style: TextStyle(
                        color: AppColors.textColorMaroon,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: controller.onStatusChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 64.w,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24.h),
            AutoTranslateText(
              'No Orders Yet',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textColorMaroon,
              ),
            ),
            SizedBox(height: 12.h),
            AutoTranslateText(
              'Start shopping to place your first order!',
              style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
      onTap: () =>
          Get.toNamed(AppRoutes.orderDetail, arguments: {'order': order}),
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOrange.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoTranslateText(
                          order.orderId ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14.w,
                              color: AppColors.templeGold,
                            ),
                            SizedBox(width: 6.w),
                            Flexible(
                              child: AutoTranslateText(
                                orderDate,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.templeGold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _StatusChip(status: order.status),
                ],
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
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
                              decoration: BoxDecoration(
                                gradient: AppColors.orangeGradient,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.image,
                                size: 32.sp,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  // Product Details
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
                            fontWeight: FontWeight.w700,
                            fontSize: 15.sp,
                            color: AppColors.textColorMaroon,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),
                        if (firstItem?.productSnapshot?.sku != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.orangeGradient.colors.first
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: AutoTranslateText(
                              'SKU: ${firstItem!.productSnapshot!.sku}',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.deepOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppColors.orangeGradient,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: AutoTranslateText(
                                'Qty: ${order.itemCount ?? firstItem?.quantity ?? 0}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Price and Timeline
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.gradientBackground.colors.first.withOpacity(
                  0.5,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoTranslateText(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          AutoTranslateText(
                            '₹${order.totalAmount.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColorMaroon,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.orangeGradient,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: AutoTranslateText(
                          '${order.itemCount ?? 0} Item${(order.itemCount ?? 0) > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // Timeline
                  AutoTranslateText(
                    'Order Status',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _OrderTimeline(
                      currentStep: controller.statusToStep(order.status),
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
    final label = (status ?? 'unknown').replaceAll('_', ' ').toUpperCase();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AutoTranslateText(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10.sp,
          color: Colors.white,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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
      _TimelineStep('1', 'Placed'),
      _TimelineStep('2', 'Payment'),
      _TimelineStep('3', 'Process'),
      _TimelineStep('4', 'Ship'),
      _TimelineStep('5', 'Deliver'),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: steps
          .asMap()
          .entries
          .map(
            (entry) => _TimelineNode(
              step: entry.value,
              isCompleted: entry.key + 1 <= currentStep,
              isLast: entry.key == steps.length - 1,
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
  const _TimelineNode({
    required this.step,
    required this.isCompleted,
    this.isLast = false,
  });

  final _TimelineStep step;
  final bool isCompleted;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = isCompleted
        ? AppColors.deepOrange
        : AppColors.textSecondary.withOpacity(0.3);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 20.w,
              width: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isCompleted
                    ? AppColors.orangeGradient
                    : LinearGradient(
                        colors: [Colors.transparent, Colors.transparent],
                      ),
                border: Border.all(color: color, width: 2),
                boxShadow: isCompleted
                    ? [
                        BoxShadow(
                          color: AppColors.deepOrange.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: isCompleted
                  ? Icon(Icons.check, size: 12.w, color: Colors.white)
                  : AutoTranslateText(
                      step.number,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 9.sp,
                        color: color,
                      ),
                    ),
            ),
            SizedBox(height: 4.h),
            SizedBox(
              width: 35.w,
              child: AutoTranslateText(
                step.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 8.sp,
                  color: color,
                  fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          SizedBox(width: 3.w),
          Container(
            width: 15.w,
            height: 2,
            decoration: BoxDecoration(
              gradient: isCompleted
                  ? AppColors.orangeGradient
                  : LinearGradient(
                      colors: [
                        AppColors.textSecondary.withOpacity(0.3),
                        AppColors.textSecondary.withOpacity(0.3),
                      ],
                    ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          SizedBox(width: 3.w),
        ],
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
