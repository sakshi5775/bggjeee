import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class YearlyPredictionWidget extends StatefulWidget {
  final HoroscopeMainController controller;

  const YearlyPredictionWidget({
    super.key,
    required this.controller,
  });

  @override
  State<YearlyPredictionWidget> createState() => _YearlyPredictionWidgetState();
}

class _YearlyPredictionWidgetState extends State<YearlyPredictionWidget> {
  // Gradient definitions
  static final LinearGradient gradientBackground = LinearGradient(
    colors: ["#FCE5AA".toColor(), "#FFFCF3".toColor(), "#FFFFFF".toColor()],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final LinearGradient primaryGradient = LinearGradient(
    colors: ["#820B17".toColor(), "#68171E".toColor(), "#5D1C21".toColor()],
  );

  static LinearGradient orangeGradient = LinearGradient(
    colors: ["#F38B3B".toColor(), "#DD2914".toColor()],
  );

  // Selected phase index
  int selectedPhaseIndex = 0;
  
  // Selected category index for each phase
  final Map<int, int> selectedCategoryIndex = {};
  
  // PageController for category swiping
  final Map<int, PageController> categoryPageControllers = {};

  List<String> _getCategoriesForPhase(Map<String, dynamic> phase) {
    final categories = <String>[];
    // Extract all keys from phase that are not metadata
    // Exclude keys that are not category data (like phase number, etc.)
    final excludedKeys = ['phase', 'phase_number', 'phase_no', 'id', '_id'];
    
    phase.forEach((key, value) {
      // Only include keys that have Map or String values (category data)
      // Exclude excluded keys and keys that are clearly metadata
      if (!excludedKeys.contains(key.toLowerCase()) && 
          value != null && 
          (value is Map || value is String || value is List)) {
        // Capitalize first letter and format the key name
        final formattedName = _formatCategoryName(key);
        if (!categories.contains(formattedName)) {
          categories.add(formattedName);
        }
      }
    });
    
    return categories;
  }

  String _formatCategoryName(String key) {
    // Convert snake_case or camelCase to Title Case
    return key
        .split(RegExp(r'[_\s]+'))
        .map((word) => word.isEmpty 
            ? '' 
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  Map<String, dynamic>? _getCategoryData(Map<String, dynamic> phase, String category) {
    // Find the original key that matches the formatted category name
    String? originalKey;
    phase.forEach((key, value) {
      if (_formatCategoryName(key) == category) {
        originalKey = key;
      }
    });
    
    if (originalKey != null && phase[originalKey] != null) {
      final value = phase[originalKey];
      if (value is Map<String, dynamic>) {
        return value;
      } else if (value is String || value is List) {
        // If it's a string or list, wrap it in a map
        return {'content': value};
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.controller.isLoadingYearly.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(orangeGradient.colors.first),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Loading Yearly Prediction...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: primaryGradient.colors.first.withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }

      final data = widget.controller.yearlyPredictionData.value;
      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No Yearly Prediction data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: primaryGradient.colors.first.withOpacity(0.7),
            ),
          ),
        );
      }

      final response = data['response'] as Map<String, dynamic>?;
      if (response == null || response.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: primaryGradient.colors.first.withOpacity(0.6),
            ),
          ),
        );
      }

      // Extract phases dynamically from response
      final validPhases = <Map<String, dynamic>>[];
      final phaseKeys = <String>[];
      
      // Get all keys that start with 'phase_' or are phase-related
      response.forEach((key, value) {
        if (value is Map<String, dynamic> && 
            (key.toLowerCase().startsWith('phase') || 
             key.toLowerCase().contains('phase'))) {
          phaseKeys.add(key);
        }
      });
      
      // Sort phase keys to maintain order (phase_1, phase_2, etc.)
      phaseKeys.sort((a, b) {
        // Extract numbers from keys for sorting
        final aNum = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        final bNum = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        return aNum.compareTo(bNum);
      });
      
      // Add phases in sorted order
      for (final key in phaseKeys) {
        final phase = response[key] as Map<String, dynamic>?;
        if (phase != null) {
          validPhases.add(phase);
        }
      }
      
      if (validPhases.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No phase data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: primaryGradient.colors.first.withOpacity(0.6),
            ),
          ),
        );
      }

      // Ensure selectedPhaseIndex is valid
      if (selectedPhaseIndex >= validPhases.length) {
        selectedPhaseIndex = 0;
      }

      final currentPhase = validPhases[selectedPhaseIndex];
      final categories = _getCategoriesForPhase(currentPhase);
      
      // Initialize category index if not set
      if (!selectedCategoryIndex.containsKey(selectedPhaseIndex)) {
        selectedCategoryIndex[selectedPhaseIndex] = 0;
      }
      
      final currentCategoryIndex = selectedCategoryIndex[selectedPhaseIndex] ?? 0;
      if (currentCategoryIndex >= categories.length && categories.isNotEmpty) {
        selectedCategoryIndex[selectedPhaseIndex] = 0;
      }

      return Container(
        decoration: BoxDecoration(
          gradient: gradientBackground,
        ),
        child: Column(
          children: [
            // Title Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: _buildTitleSection(),
            ),
            
            // Phase Selector
            _buildPhaseSelector(validPhases),
            
            // Category Sub-tabs
            if (categories.isNotEmpty) ...[
              _buildCategoryTabs(categories, currentCategoryIndex),
              Spacing.h(8),
            ],
            
            // Content Area with PageView for swiping
            Expanded(
              child: categories.isNotEmpty
                  ? _buildCategoryPageView(currentPhase, categories, currentCategoryIndex)
                  : _buildPhaseContent(currentPhase),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTitleSection() {
    final currentYear = DateTime.now().year;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: primaryGradient.colors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.event_rounded,
              color: const Color(0xFFDFB343),
              size: 28.w,
            ),
          ),
          Spacing.w(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Yearly Prediction',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: const Color(0xFFDFB343),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  'Year $currentYear',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: const Color(0xFFDFB343).withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseSelector(List<Map<String, dynamic>> phases) {
    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        itemCount: phases.length,
        itemBuilder: (context, index) {
          final isSelected = selectedPhaseIndex == index;
          return GestureDetector(
            onTap: () {
              // Dispose previous phase's page controller
              final prevController = categoryPageControllers[selectedPhaseIndex];
              if (prevController != null && prevController.hasClients) {
                prevController.dispose();
                categoryPageControllers.remove(selectedPhaseIndex);
              }
              
              setState(() {
                selectedPhaseIndex = index;
                if (!selectedCategoryIndex.containsKey(index)) {
                  selectedCategoryIndex[index] = 0;
                }
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: isSelected ? primaryGradient : null,
                color: isSelected ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : primaryGradient.colors.first.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: AutoTranslateText(
                  'Phase ${index + 1}',
                  style: MyTextTheme.smallBCB.copyWith(
                    color: isSelected
                        ? const Color(0xFFDFB343)
                        : primaryGradient.colors.first,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryTabs(List<String> categories, int currentIndex) {
    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = currentIndex == index;
          return GestureDetector(
            onTap: () {
              final pageController = categoryPageControllers[selectedPhaseIndex];
              if (pageController != null && pageController.hasClients) {
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                setState(() {
                  selectedCategoryIndex[selectedPhaseIndex] = index;
                });
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: isSelected ? orangeGradient : null,
                color: isSelected ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : orangeGradient.colors.first.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: orangeGradient.colors.first.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: AutoTranslateText(
                  categories[index],
                  style: MyTextTheme.smallBCB.copyWith(
                    color: isSelected
                        ? Colors.white
                        : orangeGradient.colors.first,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryPageView(Map<String, dynamic> phase, List<String> categories, int currentIndex) {
    // Initialize PageController for this phase if not exists
    if (!categoryPageControllers.containsKey(selectedPhaseIndex)) {
      categoryPageControllers[selectedPhaseIndex] = PageController(initialPage: currentIndex);
    }
    
    final pageController = categoryPageControllers[selectedPhaseIndex]!;
    
    return PageView.builder(
      controller: pageController,
      onPageChanged: (index) {
        setState(() {
          selectedCategoryIndex[selectedPhaseIndex] = index;
        });
      },
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final categoryData = _getCategoryData(phase, category);
        
        if (categoryData == null) {
          return Center(
            child: AutoTranslateText(
              'No data available for $category',
              style: MyTextTheme.mediumBCN.copyWith(
                color: primaryGradient.colors.first.withOpacity(0.6),
              ),
            ),
          );
        }

        return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phase Info Card
              _buildPhaseInfoCard(phase),
              Spacing.h(16),
              
              // Category Prediction Card
              _buildCategoryPredictionCard(category, categoryData),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhaseContent(Map<String, dynamic> phase) {
    return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: _buildPhaseInfoCard(phase),
    );
  }

  Widget _buildPhaseInfoCard(Map<String, dynamic> phase) {
    final period = phase['period'] as String? ?? '';
    final score = phase['score'] as String? ?? '';
    final prediction = phase['prediction'] as String? ?? '';

    return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryGradient.colors.first.withOpacity(0.1),
            primaryGradient.colors.last.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: primaryGradient.colors.first.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Score Badge
          if (score.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                gradient: orangeGradient,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: AutoTranslateText(
                'Score: $score',
                style: MyTextTheme.smallBCB.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (score.isNotEmpty) Spacing.h(12),
          
          // Period
          if (period.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: primaryGradient.colors.first,
                  size: 18.w,
                ),
                Spacing.w(8),
                Expanded(
                  child: AutoTranslateText(
                    period,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: primaryGradient.colors.first,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Spacing.h(12),
          ],
          
          // Main Prediction
          if (prediction.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: primaryGradient.colors.first.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: AutoTranslateText(
                prediction,
                style: MyTextTheme.mediumBCN.copyWith(
                  color: primaryGradient.colors.first,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryPredictionCard(String category, Map<String, dynamic> data) {
    final score = data['score'] as String? ?? '';
    final prediction = data['prediction'] as String? ?? '';
    
    return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            orangeGradient.colors.first.withOpacity(0.1),
            orangeGradient.colors.last.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: orangeGradient.colors.first.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: orangeGradient.colors.first.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: orangeGradient,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  _getCategoryIcon(category),
                  color: Colors.white,
                  size: 24.w,
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: AutoTranslateText(
                  category,
                  style: MyTextTheme.largeBCB.copyWith(
                    color: primaryGradient.colors.first,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (score.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _getScoreColorFromString(score).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: _getScoreColorFromString(score),
                      width: 1.5,
                    ),
                  ),
                  child: AutoTranslateText(
                    score,
                    style: MyTextTheme.smallBCB.copyWith(
                      color: _getScoreColorFromString(score),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          if (prediction.isNotEmpty) ...[
            Spacing.h(16),
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: AutoTranslateText(
                prediction,
                style: MyTextTheme.mediumBCN.copyWith(
                  color: primaryGradient.colors.first,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return Icons.favorite;
      case 'career':
        return Icons.work;
      case 'relationship':
        return Icons.favorite_border;
      case 'travel':
        return Icons.flight;
      case 'family':
        return Icons.family_restroom;
      case 'friends':
        return Icons.people;
      case 'finances':
        return Icons.account_balance_wallet;
      case 'status':
        return Icons.star;
      case 'education':
        return Icons.school;
      default:
        return Icons.info;
    }
  }

  Color _getScoreColorFromString(String score) {
    final scoreValue = int.tryParse(score.replaceAll('%', '')) ?? 0;
    if (scoreValue >= 80) return Colors.green;
    if (scoreValue >= 60) return Colors.orange;
    return Colors.red;
  }
}
