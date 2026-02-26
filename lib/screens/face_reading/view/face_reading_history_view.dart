import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/face_reading_model.dart';
import 'package:astrobharataiuser/screens/face_reading/service/face_reading_service.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:intl/intl.dart';

class FaceReadingHistoryView extends StatefulWidget {
  const FaceReadingHistoryView({Key? key}) : super(key: key);

  @override
  State<FaceReadingHistoryView> createState() => _FaceReadingHistoryViewState();
}

class _FaceReadingHistoryViewState extends State<FaceReadingHistoryView> {
  final FaceReadingService _faceReadingService = FaceReadingService();

  List<FaceReadingData> _readings = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _currentPage = 1;
        _readings.clear();
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final response = await _faceReadingService.getFaceReadingHistory(
        page: _currentPage,
        limit: 10,
      );

      if (mounted) {
        setState(() {
          if (refresh || _currentPage == 1) {
            _readings = response.data?.readings ?? [];
          } else {
            _readings.addAll(response.data?.readings ?? []);
          }

          _totalPages = response.data?.pagination?.pages ?? 1;
          _hasMore = _currentPage < _totalPages;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
        Get.snackbar(
          'Error',
          'Failed to load history: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> _loadMore() async {
    if (!_isLoading && _hasMore) {
      setState(() {
        _currentPage++;
        _isLoading = true;
      });
      await _loadHistory();
    }
  }

  Future<void> _deleteReading(String readingId, int index) async {
    try {
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: AutoTranslateText('Delete Reading'),
          content: AutoTranslateText(
            'Are you sure you want to delete this reading?',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: AutoTranslateText('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: AutoTranslateText(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        final success = await _faceReadingService.deleteFaceReading(readingId);

        if (success) {
          setState(() {
            _readings.removeAt(index);
          });
          Get.snackbar(
            'Success',
            'Reading deleted successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to delete reading',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete reading: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _viewReading(String readingId) async {
    try {
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final reading = await _faceReadingService.getFaceReadingById(readingId);

      Get.back(); // Close loading dialog

      UserMainController.pushInCurrentTab(AppRoutes.faceReadingResults, arguments: {'result': reading});
    } catch (e) {
      Get.back(); // Close loading dialog if still open
      Get.snackbar(
        'Error',
        'Failed to load reading: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const CommonHeader(title: 'History'),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading && _readings.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>("#F38B3B".toColor()),
        ),
      );
    }

    if (_errorMessage != null && _readings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.w, color: Colors.red),
            Spacing.h(16),
            AutoTranslateText(
              _errorMessage!,
              style: MyTextTheme.mediumBCN.copyWith(color: '#3E2723'.toColor()),
              textAlign: TextAlign.center,
            ),
            Spacing.h(16),
            ElevatedButton(
              onPressed: () => _loadHistory(refresh: true),
              child: AutoTranslateText('Retry'),
            ),
          ],
        ),
      );
    }

    if (_readings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64.w, color: "#F38B3B".toColor()),
            Spacing.h(16),
            AutoTranslateText(
              'No reading history',
              style: MyTextTheme.largeBCB
                  .copyWith(color: '#3E2723'.toColor())
                  .merge(AppTypography.h2),
            ),
            Spacing.h(8),
            AutoTranslateText(
              'Start your face reading journey',
              style: MyTextTheme.mediumBCN.copyWith(color: '#666666'.toColor()),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadHistory(refresh: true),
      color: "#F38B3B".toColor(),
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: _readings.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _readings.length) {
            // Load more indicator
            _loadMore();
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    "#F38B3B".toColor(),
                  ),
                ),
              ),
            );
          }

          final reading = _readings[index];
          return _buildReadingCard(reading, index);
        },
      ),
    );
  }

  Widget _buildReadingCard(FaceReadingData reading, int index) {
    final score = reading.detailedAnalysis?.overview?.score ?? 0;
    final status =
        reading.status ??
        (reading.detailedAnalysis != null && reading.readings.isNotEmpty
            ? 'COMPLETED'
            : 'FAILED');
    final isCompleted = status == 'COMPLETED';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: '#F5D7B8'.toColor(), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: isCompleted ? () => _viewReading(reading.readingId ?? '') : null,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // Image
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: "#F38B3B".toColor(), width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: reading.imageUrl != null
                      ? Image.network(
                          reading.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: '#FFF2E8'.toColor(),
                            child: Icon(
                              Icons.person,
                              size: 40.w,
                              color: "#F38B3B".toColor(),
                            ),
                          ),
                        )
                      : Container(
                          color: '#FFF2E8'.toColor(),
                          child: Icon(
                            Icons.person,
                            size: 40.w,
                            color: "#F38B3B".toColor(),
                          ),
                        ),
                ),
              ),
              Spacing.w(16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AutoTranslateText(
                            reading.summary ?? 'Face Reading',
                            style: MyTextTheme.mediumBCB
                                .copyWith(
                                  color: '#3E2723'.toColor(),
                                  fontWeight: FontWeight.bold,
                                )
                                .merge(AppTypography.h3),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isCompleted)
                          PopupMenuButton(
                            icon: Icon(
                              Icons.more_vert,
                              color: '#666666'.toColor(),
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 20.w,
                                    ),
                                    Spacing.w(8),
                                    AutoTranslateText(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Future.delayed(Duration.zero, () {
                                    _deleteReading(
                                      reading.readingId ?? '',
                                      index,
                                    );
                                  });
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                    Spacing.h(4),
                    Row(
                      children: [
                        if (isCompleted) ...[
                          Icon(
                            Icons.star,
                            color: "#F38B3B".toColor(),
                            size: 16.w,
                          ),
                          Spacing.w(4),
                          AutoTranslateText(
                            '$score/100',
                            style: MyTextTheme.mediumBCB
                                .copyWith(
                                  color: "#F38B3B".toColor(),
                                  fontWeight: FontWeight.bold,
                                )
                                .merge(AppTypography.body1),
                          ),
                          Spacing.w(8),
                          Container(
                            width: 4.w,
                            height: 4.w,
                            decoration: BoxDecoration(
                              color: '#666666'.toColor(),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Spacing.w(8),
                        ],
                        Expanded(
                          child: AutoTranslateText(
                            _formatDate(reading.createdAt),
                            style: MyTextTheme.smallBCN
                                .copyWith(color: '#666666'.toColor())
                                .merge(AppTypography.body2),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (!isCompleted) ...[
                      Spacing.h(4),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: "#F38B3B".toColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: AutoTranslateText(
                          reading.errorMessage ?? 'Failed',
                          style: MyTextTheme.smallBCN
                              .copyWith(color: "#F38B3B".toColor())
                              .merge(AppTypography.label),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
