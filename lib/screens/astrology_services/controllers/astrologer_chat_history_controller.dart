import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/astrologer_chat_model.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_chat_service.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class AstrologerChatHistoryController extends BaseController {
  final AstrologerChatService _chatService = AstrologerChatService();

  final RxList<AstrologerChatSession> historyList =
      <AstrologerChatSession>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;

  // Pagination state
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;
  final int _itemsPerPage = 20;
  bool _hasMore = true;

  // Search state
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void onInit() {
    super.onInit();
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

  // Get filtered list based on search query
  List<AstrologerChatSession> get filteredHistoryList {
    if (searchQuery.value.isEmpty) {
      return historyList.toList();
    }

    final query = searchQuery.value.toLowerCase();
    return historyList.where((session) {
      return session.chatId.toLowerCase().contains(query) ||
          session.status.toLowerCase().contains(query);
    }).toList();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  /// Load chat session history
  Future<void> loadHistory({bool reset = false}) async {
    try {
      if (reset) {
        _currentPage = 1;
        _hasMore = true;
        historyList.clear();
      }

      if (!_hasMore && !reset) {
        return; // No more pages to load
      }

      isLoading.value = true;

      final result = await _chatService.getSessionHistory(
        page: _currentPage,
        limit: _itemsPerPage,
      );

      final raw = result['sessions'];
      
      if (kDebugMode) {
        print('=== Controller: Processing result ===');
        print('Raw sessions type: ${raw.runtimeType}');
        print('Raw sessions is List: ${raw is List}');
        if (raw is List) {
          print('Raw sessions length: ${raw.length}');
          if (raw.isNotEmpty) {
            print('First item type: ${raw.first.runtimeType}');
            print('First item is AstrologerChatSession: ${raw.first is AstrologerChatSession}');
          }
        }
      }

      final sessions = raw is List
          ? raw
              .whereType<AstrologerChatSession>()
              .toList()
          : <AstrologerChatSession>[];
      final pagination = result['pagination'] as Map<String, dynamic>?;

      if (reset) {
        historyList.value = sessions;
      } else {
        historyList.addAll(sessions);
      }

      if (pagination != null) {
        // API returns 'page' not 'currentPage', and 'total' not 'totalItems'
        _currentPage =
            (pagination['page'] as num?)?.toInt() ?? _currentPage;
        _totalPages = (pagination['totalPages'] as num?)?.toInt() ?? 1;
        _totalItems = (pagination['total'] as num?)?.toInt() ?? 0;
        _hasMore = _currentPage < _totalPages;
      } else {
        _hasMore = sessions.length >= _itemsPerPage;
      }

      if (kDebugMode) {
        print('=== Controller: Result ===');
        print('Loaded ${sessions.length} sessions (Page $_currentPage/$_totalPages)');
        if (sessions.isEmpty) {
          print('WARNING: No sessions loaded!');
          if (raw is List && raw.isNotEmpty) {
            print('Raw data has ${raw.length} items but none are AstrologerChatSession');
            print('Raw data types: ${raw.map((e) => e.runtimeType).toList()}');
          }
        } else {
          print('Successfully loaded ${sessions.length} sessions');
          print('First session chatId: ${sessions.first.chatId}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load chat history: $e');
      }
      showErrorMessage(message: 'Failed to load chat history: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more sessions (pagination)
  Future<void> loadMore() async {
    if (isLoadingMore.value || !_hasMore) return;

    try {
      isLoadingMore.value = true;
      _currentPage++;
      await loadHistory();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load more sessions: $e');
      }
      _currentPage--; // Rollback page increment on error
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Download chat transcript
  Future<void> downloadChatTranscript(String chatId) async {
    try {
      isLoading.value = true;

      // Download chat transcript from API
      final transcript = await _chatService.downloadChatHistory(chatId);

      // Convert to JSON string
      final jsonEncoder = const JsonEncoder.withIndent('  ');
      final jsonString = jsonEncoder.convert(transcript);

      if (kDebugMode) {
        print('Chat transcript downloaded: ${jsonString.length} bytes');
      }

      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final fileName = 'chat_${chatId}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.json';
      final filePath = '${directory.path}/$fileName';
      
      // Write file
      final file = File(filePath);
      await file.writeAsString(jsonString);

      // Share the file
      final xFile = XFile(filePath);
      await Share.shareXFiles(
        [xFile],
        text: 'Chat History - $chatId',
        subject: 'Chat History Export',
      );

      showSuccessMessage(message: 'Chat transcript shared successfully!');
    } catch (e) {
      if (kDebugMode) {
        print('Failed to download chat transcript: $e');
      }
      showErrorMessage(
        message: 'Failed to download chat transcript: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate to chat session detail
  void navigateToChat(String chatId, AstrologerModel? astrologer) {
    if (astrologer != null) {
      UserMainController.pushInCurrentTab(
        '/astrologer-chat',
        arguments: {'astrologer': astrologer, 'initialChatId': chatId},
      );
    }
  }

  /// View chat history - shows messages in a dialog
  Future<void> viewChatHistory(String chatId) async {
    try {
      isLoading.value = true;

      // Download chat transcript from API
      final transcript = await _chatService.downloadChatHistory(chatId);

      if (kDebugMode) {
        print('Chat transcript loaded for viewing: $chatId');
      }

      // Show chat history dialog
      Get.dialog(
        _ChatHistoryDialog(
          chatId: chatId,
          transcript: transcript,
        ),
        barrierDismissible: true,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load chat history: $e');
      }
      showErrorMessage(
        message: 'Failed to load chat history: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Format date for display
  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';

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
  }

  /// Get status color
  Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return Colors.green;
      case 'COMPLETED':
        return Colors.blue;
      case 'EXPIRED':
        return Colors.orange;
      case 'CANCELLED':
        return Colors.red;
      case 'CREATED':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}

/// Dialog to display chat history
class _ChatHistoryDialog extends StatelessWidget {
  final String chatId;
  final Map<String, dynamic> transcript;

  const _ChatHistoryDialog({
    required this.chatId,
    required this.transcript,
  });

  @override
  Widget build(BuildContext context) {
    final session = transcript['session'] as Map<String, dynamic>?;
    final messages = transcript['messages'] as List<dynamic>? ?? [];

    // Calculate responsive dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive width: larger on bigger screens, but with max constraint
    final dialogWidth = screenWidth > 600 
        ? (screenWidth * 0.95).clamp(400.0, 800.0)
        : screenWidth * 0.95;
    
    // Responsive height: larger on bigger screens, but with max constraint
    final dialogHeight = screenHeight > 800
        ? (screenHeight * 0.92).clamp(600.0, 900.0)
        : screenHeight * 0.92;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with gradient
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepOrange.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.chat_bubble_rounded,
                                color: Colors.white,
                                size: 24.w,
                              ),
                            ),
                            Spacing.w(12),
                            Expanded(
                              child: AutoTranslateText(
                                'Chat History',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // if (messageStats != null) ...[
                        //   Spacing.h(12),
                        //   Row(
                        //     children: [
                        //       _buildStatChip(
                        //         Icons.message,
                        //         '${messageStats['totalMessages'] ?? 0}',
                        //         Colors.white.withValues(alpha: 0.9),
                        //       ),
                        //       Spacing.w(8),
                        //       _buildStatChip(
                        //         Icons.person,
                        //         '${messageStats['userMessages'] ?? 0}',
                        //         Colors.white.withValues(alpha: 0.9),
                        //       ),
                        //       Spacing.w(8),
                        //       _buildStatChip(
                        //         Icons.star,
                        //         '${messageStats['astrologerMessages'] ?? 0}',
                        //         Colors.white.withValues(alpha: 0.9),
                        //       ),
                        //     ],
                        //   ),
                        // ],
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.close_rounded, color: Colors.white, size: 24.w),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
            // Messages count badge (if session exists)
            if (session != null && messages.isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.orangeGradient.colors.first.withValues(alpha: 0.1),
                      AppColors.orangeGradient.colors.last.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.message_rounded,
                      size: 18.w,
                      color: AppColors.orangeGradient.colors.first,
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      '${messages.length} ${messages.length == 1 ? 'message' : 'messages'}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.orangeGradient.colors.first,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            // Messages list
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(24.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.orangeGradient.colors.first.withValues(alpha: 0.1),
                                  AppColors.orangeGradient.colors.last.withValues(alpha: 0.05),
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 64.w,
                              color: AppColors.orangeGradient.colors.first,
                            ),
                          ),
                          Spacing.h(20),
                          AutoTranslateText(
                            'No messages in this chat',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            AppColors.orangeGradient.colors.first.withValues(alpha: 0.02),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index] as Map<String, dynamic>;
                          final senderType = message['senderType'] as String? ?? 'USER';
                          final content = message['content'] as String? ?? '';
                          final sentAt = message['sentAt'] as String?;
                          final messageType = message['messageType'] as String? ?? 'TEXT';
                          final isUser = senderType == 'USER';

                          DateTime? dateTime;
                          if (sentAt != null) {
                            try {
                              dateTime = DateTime.parse(sentAt);
                            } catch (e) {
                              // Ignore parse errors
                            }
                          }

                          return Container(
                            margin: EdgeInsets.only(bottom: 16.h),
                            child: Row(
                              mainAxisAlignment:
                                  isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isUser) ...[
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: AppColors.orangeGradient,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.orangeGradient.colors.first.withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 20.r,
                                      backgroundColor: Colors.transparent,
                                      child: Icon(
                                        Icons.person_rounded,
                                        size: 20.w,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Spacing.w(10),
                                ],
                                Flexible(
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                                    decoration: BoxDecoration(
                                      gradient: isUser
                                          ? AppColors.orangeGradient
                                          : LinearGradient(
                                              colors: [
                                                Colors.grey.shade100,
                                                Colors.grey.shade50,
                                              ],
                                            ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(18.r),
                                        topRight: Radius.circular(18.r),
                                        bottomLeft: Radius.circular(isUser ? 18.r : 4.r),
                                        bottomRight: Radius.circular(isUser ? 4.r : 18.r),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isUser
                                              ? AppColors.orangeGradient.colors.first.withValues(alpha: 0.2)
                                              : Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (messageType == 'TEXT')
                                          AutoTranslateText(
                                            content,
                                            style: TextStyle(
                                              color: isUser ? Colors.white : Colors.black87,
                                              fontSize: 14.sp,
                                              height: 1.4,
                                            ),
                                          )
                                        else
                                          Container(
                                            padding: EdgeInsets.all(8.w),
                                            decoration: BoxDecoration(
                                              color: isUser
                                                  ? Colors.white.withValues(alpha: 0.2)
                                                  : Colors.grey.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(8.r),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.image_rounded,
                                                  size: 18.w,
                                                  color: isUser ? Colors.white : Colors.black87,
                                                ),
                                                Spacing.w(8),
                                                AutoTranslateText(
                                                  'Image',
                                                  style: TextStyle(
                                                    color: isUser ? Colors.white : Colors.black87,
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (dateTime != null) ...[
                                          Spacing.h(6),
                                          AutoTranslateText(
                                            DateFormat('HH:mm').format(dateTime),
                                            style: TextStyle(
                                              color: isUser
                                                  ? Colors.white.withValues(alpha: 0.8)
                                                  : Colors.black54,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                                if (isUser) ...[
                                  Spacing.w(10),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                    ),
                                    child: CircleAvatar(
                                      radius: 20.r,
                                      backgroundColor: Colors.transparent,
                                      child: Icon(
                                        Icons.person_rounded,
                                        size: 20.w,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
