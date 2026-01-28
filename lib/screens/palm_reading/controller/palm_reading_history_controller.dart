import 'dart:async';
import 'dart:convert';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/data_model/palm_reading_model.dart';
import 'package:astrobharataiuser/screens/palm_reading/controller/palm_reading_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PalmReadingHistoryController extends GetxController {
  final RxList<PalmReadingData> historyList = <PalmReadingData>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;
  final ApiRepository _apiRepository = Get.find();
  
  // Pagination state
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;
  final int _itemsPerPage = 10;
  bool _hasMore = true;
  
  // Search and filter state
  final RxString searchQuery = ''.obs;
  final RxString selectedStatus = ''.obs; // Empty means all, or 'PROCESSING', 'COMPLETED', 'FAILED'
  final TextEditingController searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void onInit() {
    super.onInit();
    // Sync search controller with search query
    ever(searchQuery, (value) {
      if (searchController.text != value) {
        searchController.text = value;
      }
    });
    loadHistory();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    super.onClose();
  }

  bool get hasMore => _hasMore;
  int get totalItems => _totalItems;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  
  // Status filter options
  List<String> get statusOptions => ['', 'PROCESSING', 'COMPLETED', 'FAILED'];
  String get statusDisplayText {
    switch (selectedStatus.value) {
      case 'PROCESSING':
        return 'Processing';
      case 'COMPLETED':
        return 'Completed';
      case 'FAILED':
        return 'Failed';
      default:
        return 'All Status';
    }
  }
  
  void onSearchChanged(String query) {
    searchQuery.value = query;
    // Search is client-side, so we just trigger a rebuild
    // No need to reload from API
  }
  
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }
  
  // Get filtered list based on search query
  List<PalmReadingData> get filteredHistoryList {
    if (searchQuery.value.isEmpty) {
      return historyList;
    }
    
    final query = searchQuery.value.toLowerCase();
    return historyList.where((item) {
      final name = item.userInput?.name?.toLowerCase() ?? '';
      final summary = item.summary.toLowerCase();
      final overallReading = item.overallReading.toLowerCase();
      return name.contains(query) ||
          summary.contains(query) ||
          overallReading.contains(query);
    }).toList();
  }
  
  void onStatusFilterChanged(String? status) {
    selectedStatus.value = status ?? '';
    loadHistory(reset: true);
  }
  
  void clearFilters() {
    clearSearch();
    selectedStatus.value = '';
    loadHistory(reset: true);
  }

  Future<void> loadHistory({bool reset = true}) async {
    if (reset) {
      isLoading.value = true;
      _currentPage = 1;
      _hasMore = true;
      historyList.clear();
    } else {
      isLoadingMore.value = true;
    }
    
    errorMessage.value = '';
    try {
      // Build query parameters
      final queryParams = <String, String>{
        'page': _currentPage.toString(),
        'limit': _itemsPerPage.toString(),
      };
      
      // Add status filter if selected
      if (selectedStatus.value.isNotEmpty) {
        queryParams['status'] = selectedStatus.value;
      }
      
      final response = await _apiRepository.getApi(
        EndPoints.palmistryHistory,
        query: queryParams,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // response.body is already a Map from GetX Response
        final responseBody = response.body;
        Map<String, dynamic> jsonData;
        
        // Handle both string and Map responses
        if (responseBody is String) {
          jsonData = json.decode(responseBody);
        } else {
          jsonData = responseBody as Map<String, dynamic>;
        }
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final readings = jsonData['data']['readings'] as List<dynamic>?;
          
          // Parse pagination info
          if (jsonData['data']['pagination'] != null) {
            final pagination = jsonData['data']['pagination'] as Map<String, dynamic>;
            _currentPage = pagination['page'] ?? 1;
            _totalPages = pagination['pages'] ?? 1;
            _totalItems = pagination['total'] ?? 0;
            _hasMore = _currentPage < _totalPages;
          }
          
          if (readings != null && readings.isNotEmpty) {
            final newItems = readings
                .map((item) {
                  try {
                    return PalmReadingData.fromJson(item as Map<String, dynamic>);
                  } catch (e) {
                    print('Error parsing reading item: $e');
                    print('Item data: $item');
                    return null;
                  }
                })
                .whereType<PalmReadingData>()
                .toList();
            
            if (reset) {
              historyList.value = newItems;
            } else {
              historyList.addAll(newItems);
            }
            
            print('Loaded ${newItems.length} history items (Page $_currentPage/$_totalPages, Total: $_totalItems)');
          } else {
            if (reset) {
              historyList.value = [];
            }
            _hasMore = false;
            print('No readings found in response');
          }
        } else {
          final message = jsonData['message']?.toString() ?? 'Failed to load history';
          errorMessage.value = message;
          print('API returned error: $message');
          if (reset) {
            historyList.value = [];
          }
        }
      } else {
        errorMessage.value = 'Failed to load history (Status: ${response.statusCode})';
        if (reset) {
          historyList.value = [];
        }
      }
    } catch (e, stackTrace) {
      errorMessage.value = 'Error loading history: $e';
      if (reset) {
        historyList.value = [];
      }
      print('Error loading history: $e');
      print('Stack trace: $stackTrace');
      Get.snackbar(
        'Error',
        'Failed to load history: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || isLoadingMore.value || isLoading.value) {
      return;
    }
    
    _currentPage++;
    await loadHistory(reset: false);
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Unknown date';
    
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return 'Unknown date';
    }
  }

  void onHistoryItemTap(PalmReadingData reading) {
    // Load reading data into controller and navigate to detail
    final controller = Get.find<PalmReadingController>();
    controller.palmReadingData.value = reading;
    controller.currentReadingId.value = reading.readingId ?? '';
    Get.toNamed('/palm-reading-detail');
  }
}

