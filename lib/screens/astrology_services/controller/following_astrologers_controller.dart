import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class FollowingAstrologersController extends BaseController {
  final AstrologerService _astrologerService = AstrologerService();

  final RxList<AstrologerModel> followingAstrologers = <AstrologerModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;
  final RxInt totalFollowing = 0.obs;
  final int limit = 20;

  @override
  void onInit() {
    super.onInit();
    loadFollowingAstrologers();
  }

  Future<void> loadFollowingAstrologers({bool refresh = false}) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      if (refresh) {
        currentPage.value = 1;
        followingAstrologers.clear();
      }

      final result = await _astrologerService.getFollowingAstrologers(
        page: currentPage.value,
        limit: limit,
      );

      if (kDebugMode) {
        print('Following result: $result');
        print('Following count: ${result?['following']?.length ?? 0}');
      }

      if (result != null) {
        final newAstrologers =
            result['following'] as List<AstrologerModel>? ?? [];

        if (kDebugMode) {
          print('New astrologers count: ${newAstrologers.length}');
        }

        if (refresh) {
          followingAstrologers.value = newAstrologers;
        } else {
          followingAstrologers.addAll(newAstrologers);
        }

        final pagination = result['pagination'] as Map<String, dynamic>?;
        if (pagination != null) {
          final currentPageNum = pagination['currentPage'] as int? ?? 1;
          final totalPages = pagination['totalPages'] as int? ?? 1;
          totalFollowing.value = pagination['totalFollowing'] as int? ?? 0;
          hasMore.value = currentPageNum < totalPages;

          if (kDebugMode) {
            print(
              'Pagination: page $currentPageNum of $totalPages, total: ${totalFollowing.value}',
            );
          }

          if (hasMore.value) {
            currentPage.value = currentPageNum + 1;
          }
        } else {
          hasMore.value = false;
        }
      } else {
        if (kDebugMode) {
          print('Result is null - no data returned');
        }
      }
    } catch (e) {
      showErrorMessage(
        title: 'Error',
        message: 'Failed to load following astrologers',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshFollowing() async {
    await loadFollowingAstrologers(refresh: true);
  }

  Future<void> loadMore() async {
    if (hasMore.value && !isLoading.value) {
      await loadFollowingAstrologers();
    }
  }
}
