import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/numerology/service/numerology_service.dart';
import 'package:get/get.dart';

class NumerologyReportsController extends BaseController {
  final NumerologyService _numerologyService = NumerologyService();

  // Reports list
  final reports = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  // Pagination
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  Future<void> loadReports({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      reports.clear();
      hasMore.value = true;
    }

    if (!hasMore.value || isLoading.value) return;

    isLoading.value = true;

    try {
      final response = await _numerologyService.getReports(
        page: currentPage.value,
        limit: 10,
      );

      if (response != null) {
        // Response structure: {success: true, data: [...], pagination: {...}}
        final data = response['data'];
        final pagination = response['pagination'] as Map<String, dynamic>?;

        if (data != null) {
          List<dynamic> dataList = [];
          if (data is List) {
            dataList = data;
          } else if (data is Map) {
            dataList = [data];
          }

          if (refresh) {
            reports.clear();
          }
          reports.addAll(dataList.map((e) {
            if (e is Map) {
              return Map<String, dynamic>.from(e);
            }
            return <String, dynamic>{};
          }));
        }

        if (pagination != null) {
          currentPage.value = pagination['page'] as int? ?? 1;
          totalPages.value = pagination['pages'] as int? ?? 1;
          hasMore.value = currentPage.value < totalPages.value;
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load reports: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value) return;

    isLoadingMore.value = true;
    currentPage.value++;

    try {
      final response = await _numerologyService.getReports(
        page: currentPage.value,
        limit: 10,
      );

      if (response != null) {
        final data = response['data'];
        final pagination = response['pagination'] as Map<String, dynamic>?;

        List<dynamic> dataList = [];
        if (data is List) {
          dataList = data;
        } else if (data is Map) {
          dataList = [data];
        }

        if (dataList.isNotEmpty) {
          reports.addAll(dataList.map((e) {
            if (e is Map) {
              return Map<String, dynamic>.from(e);
            }
            return <String, dynamic>{};
          }));
        }

        if (pagination != null) {
          totalPages.value = pagination['pages'] as int? ?? 1;
          hasMore.value = currentPage.value < totalPages.value;
        } else {
          hasMore.value = false;
        }
      } else {
        hasMore.value = false;
      }
    } catch (e) {
      currentPage.value--;
      Get.snackbar(
        'Error',
        'Failed to load more reports: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> viewReport(String reportId) async {
    try {
      final response = await _numerologyService.getReportById(reportId);

      // _makeNumerologyApiCall returns responseData?['data'], so response is already the data object
      if (response != null) {
        final reportData = response;
        final reportType = reportData['reportType'] as String? ?? '';
        
        // API response structure: data.response.response contains the actual data
        Map<String, dynamic>? actualResponseData;
        if (reportData['response'] != null) {
          final responseWrapper = reportData['response'] as Map<String, dynamic>;
          // The actual data is nested in response.response
          actualResponseData = responseWrapper['response'] as Map<String, dynamic>?;
          // If not found, use the wrapper itself
          if (actualResponseData == null) {
            actualResponseData = responseWrapper;
          }
        }
        
        // If still null, try to use reportData directly (but exclude metadata)
        if (actualResponseData == null) {
          actualResponseData = <String, dynamic>{};
          // Copy only the response-related fields, not metadata
          reportData.forEach((key, value) {
            if (key != '_id' && key != 'userId' && key != 'reportType' && 
                key != 'createdAt' && key != 'updatedAt' && key != '__v' && 
                key != 'formattedCreatedAt' && key != 'id' && key != 'inputData') {
              actualResponseData![key] = value;
            }
          });
        }

        if (actualResponseData.isNotEmpty) {
          // Map report type to result type
          String resultType = '';
          switch (reportType) {
            case 'number_analysis':
              resultType = 'number_analysis';
              break;
            case 'missing_numbers':
              resultType = 'missing_numbers';
              break;
            case 'available_numbers':
              resultType = 'available_numbers';
              break;
            case 'mobile_analysis':
              resultType = 'mobile_analysis';
              break;
            case 'numerology_suggestion':
              resultType = 'numerology_suggestion';
              break;
            case 'name_analysis':
              resultType = 'name_analysis';
              break;
            case 'vehicle_analysis':
              resultType = 'vehicle_analysis';
              break;
            case 'lucky_things':
              resultType = 'lucky_things';
              break;
            case 'personal_year':
              resultType = 'personal_year';
              break;
            case 'karmic_number':
              resultType = 'karmic_number';
              break;
            case 'master_numbers':
              resultType = 'master_numbers';
              break;
            case 'loshu_grid':
              // Navigate to Lo Shu Grid result
              Get.toNamed('/loshu-grid-result', arguments: {
                ...actualResponseData,
                '_formData': reportData['inputData'],
              });
              return;
            default:
              resultType = 'generic';
          }

          if (resultType.isNotEmpty) {
            Get.toNamed('/numerology-result', arguments: {
              'type': resultType,
              'data': actualResponseData,
            });
          }
        } else {
          Get.snackbar(
            'Error',
            'No data found in report',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
            colorText: Get.theme.colorScheme.onError,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to load report details',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  String getReportTypeDisplayName(String reportType) {
    final names = {
      'number_analysis': 'Number Analysis',
      'missing_numbers': 'Missing Numbers',
      'available_numbers': 'Available Numbers',
      'mobile_analysis': 'Mobile Analysis',
      'numerology_suggestion': 'Numerology Suggestion',
      'name_analysis': 'Name Analysis',
      'vehicle_analysis': 'Vehicle Analysis',
      'lucky_things': 'Lucky Things',
      'personal_year': 'Personal Year',
      'karmic_number': 'Karmic Numbers',
      'master_numbers': 'Master Numbers',
      'loshu_grid': 'Lo Shu Grid',
    };
    return names[reportType] ?? reportType;
  }
}

