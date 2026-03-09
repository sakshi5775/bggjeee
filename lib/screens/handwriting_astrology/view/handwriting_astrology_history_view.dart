import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/handwriting_astrology_model.dart';
import 'package:astrobharataiuser/screens/handwriting_astrology/service/handwriting_astrology_service.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:intl/intl.dart';

import '../../../app_manager/network_image.dart';

class HandwritingAstrologyHistoryView extends StatefulWidget {
  const HandwritingAstrologyHistoryView({Key? key}) : super(key: key);

  @override
  State<HandwritingAstrologyHistoryView> createState() =>
      _HandwritingAstrologyHistoryViewState();
}

class _HandwritingAstrologyHistoryViewState
    extends State<HandwritingAstrologyHistoryView> {
  final HandwritingAstrologyService _handwritingService =
      HandwritingAstrologyService();

  List<HandwritingData> _readings = [];
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
      final response = await _handwritingService.getHandwritingHistory(
        page: _currentPage,
        limit: 10,
      );

      if (mounted) {
        setState(() {
          if (refresh || _currentPage == 1) {
            _readings = response.data ?? [];
          } else {
            _readings.addAll(response.data ?? []);
          }

          _totalPages = response.pagination?.totalPages ?? 1;
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
        // Show loading indicator
        Get.dialog(
          Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        try {
          final success = await _handwritingService.deleteHandwriting(
            readingId,
          );

          // Close loading dialog
          Get.back();

          if (success) {
            // Remove from list and refresh
            if (mounted) {
              setState(() {
                if (index >= 0 && index < _readings.length) {
                  _readings.removeAt(index);
                }
              });
            }

            // Refresh the list to ensure consistency
            await _loadHistory(refresh: true);

            // Show success message with proper error handling
            if (mounted && Get.isSnackbarOpen == false) {
              try {
                Get.snackbar(
                  'Success',
                  'Reading deleted successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.all(16),
                );
              } catch (e) {
                // Ignore snackbar errors
              }
            }
          } else {
            if (mounted && Get.isSnackbarOpen == false) {
              try {
                Get.snackbar(
                  'Error',
                  'Failed to delete reading',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.all(16),
                );
              } catch (e) {
                // Ignore snackbar errors
              }
            }
          }
        } catch (e) {
          // Close loading dialog if still open
          if (Get.isDialogOpen ?? false) {
            try {
              Get.back();
            } catch (e) {
              // Ignore dialog close errors
            }
          }

          // Check if error is because item was already deleted
          final errorString = e.toString().toLowerCase();
          if (errorString.contains('not_found') ||
              errorString.contains('not found') ||
              errorString.contains('404')) {
            // Item was already deleted, just refresh the list
            if (mounted) {
              setState(() {
                if (index >= 0 && index < _readings.length) {
                  _readings.removeAt(index);
                }
              });
            }
            await _loadHistory(refresh: true);

            if (mounted && Get.isSnackbarOpen == false) {
              try {
                Get.snackbar(
                  'Success',
                  'Reading deleted successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.all(16),
                );
              } catch (e) {
                // Ignore snackbar errors
              }
            }
          } else {
            if (mounted && Get.isSnackbarOpen == false) {
              try {
                Get.snackbar(
                  'Error',
                  'Failed to delete reading',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.all(16),
                );
              } catch (e) {
                // Ignore snackbar errors
              }
            }
          }
        }
      }
    } catch (e) {
      // Close any open dialogs
      if (Get.isDialogOpen ?? false) {
        try {
          Get.back();
        } catch (e) {
          // Ignore dialog close errors
        }
      }

      if (mounted && Get.isSnackbarOpen == false) {
        try {
          Get.snackbar(
            'Error',
            'Failed to delete reading',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(16),
          );
        } catch (e) {
          // Ignore snackbar errors
        }
      }
    }
  }

  Future<void> _viewReading(String readingId) async {
    try {
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final reading = await _handwritingService.getHandwritingById(readingId);

      Get.back(); // Close loading dialog

      UserMainController.pushInCurrentTab(
        AppRoutes.handwritingAstrologyResults,
        arguments: {'result': reading},
      );
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Check if reading was deleted
      if (e.toString().contains('NOT_FOUND') ||
          e.toString().contains('not found')) {
        // Refresh the list to remove deleted items
        await _loadHistory(refresh: true);
        Get.snackbar(
          'Error',
          'This reading is no longer available. It may have been deleted.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.orangeGradient.colors.first,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to load reading: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
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
            const CommonHeader(
              title: 'Handwriting History',
              subtitle: AutoTranslateText(
                'Your past readings',
                style: TextStyle(fontSize: 12, color: Color(0xFFF7EFBD)),
              ),
            ),
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
          valueColor: AlwaysStoppedAnimation<Color>('#EA632B'.toColor()),
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
            Icon(Icons.history, size: 64.w, color: '#EA632B'.toColor()),
            Spacing.h(16),
            AutoTranslateText(
              'No reading history',
              style: MyTextTheme.largeBCB
                  .copyWith(color: '#3E2723'.toColor())
                  .merge(AppTypography.h2),
            ),
            Spacing.h(8),
            AutoTranslateText(
              'Start your handwriting analysis journey',
              style: MyTextTheme.mediumBCN.copyWith(color: '#666666'.toColor()),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadHistory(refresh: true),
      color: '#EA632B'.toColor(),
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
                    '#EA632B'.toColor(),
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

  Widget _buildReadingCard(HandwritingData reading, int index) {
    final score = reading.overview?.score ?? 0;
    final status =
        reading.status ?? (reading.overview != null ? 'COMPLETED' : 'FAILED');
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
                  border: Border.all(color: '#EA632B'.toColor(), width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: NetworkImageWithLoader(
                    url: reading.imageUrls!.first,
                    fit: BoxFit.cover,
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
                            reading.summary ?? 'Handwriting Analysis',
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: '#3E2723'.toColor(),
                              fontWeight: FontWeight.bold,
                            ),
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
                            color: '#EA632B'.toColor(),
                            size: 16.w,
                          ),
                          Spacing.w(4),
                          AutoTranslateText(
                            '$score/100',
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: '#EA632B'.toColor(),
                              fontWeight: FontWeight.bold,
                            ),
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
                            style: MyTextTheme.smallBCN.copyWith(
                              color: '#666666'.toColor(),
                            ),
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
