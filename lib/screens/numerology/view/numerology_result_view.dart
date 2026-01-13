                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/astrology_services/widgets/astrology_header_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NumerologyResultView extends StatelessWidget {
  const NumerologyResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;
    final type = arguments?['type'] as String? ?? '';
    final data = arguments?['data'] as Map<String, dynamic>? ?? {};

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: _buildContent(type, data),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AstrologyHeaderWidget(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 24.h, bottom: 20.h),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacing.h(8),
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.arrow_back,
                  color: const Color(0xFFDFB343),
                  size: 24.w,
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: AutoTranslateText(
                  _getTitle(Get.arguments?['type'] as String? ?? ''),
                  style: MyTextTheme.largeBCB.copyWith(
                    color: const Color(0xFFDFB343),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTitle(String type) {
    final titles = {
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
      'key_points': 'Key Points',
    };
    return titles[type] ?? 'Numerology Result';
  }

  Widget _buildContent(String type, Map<String, dynamic> data) {
    switch (type) {
      case 'number_analysis':
        return _buildNumberAnalysis(data);
      case 'missing_numbers':
        return _buildMissingNumbers(data);
      case 'available_numbers':
        return _buildAvailableNumbers(data);
      case 'mobile_analysis':
        return _buildMobileAnalysis(data);
      case 'numerology_suggestion':
        return _buildNumerologySuggestion(data);
      case 'name_analysis':
        return _buildNameAnalysis(data);
      case 'vehicle_analysis':
        return _buildVehicleAnalysis(data);
      case 'lucky_things':
        return _buildLuckyThings(data);
      case 'personal_year':
        return _buildPersonalYear(data);
      case 'karmic_number':
        return _buildKarmicNumber(data);
      case 'master_numbers':
        return _buildMasterNumbers(data);
      case 'key_points':
        return _buildKeyPoints(data);
      default:
        return _buildGeneric(data);
    }
  }

  Widget _buildNumberAnalysis(Map<String, dynamic> data) {
    final sections = <Widget>[];
    
    // Core Numbers Section
    final coreNumbers = <Widget>[];
    if (_hasValue(data['radicalNumber'])) {
      coreNumbers.add(_buildNumberCard('Radical Number', _getValue(data['radicalNumber']), AppColors.saffron));
    }
    if (_hasValue(data['destinyNumber'])) {
      coreNumbers.add(_buildNumberCard('Destiny Number', _getValue(data['destinyNumber']), AppColors.deepOrange));
    }
    if (_hasValue(data['nameNumber'])) {
      coreNumbers.add(_buildNumberCard('Name Number', _getValue(data['nameNumber']), AppColors.templeGold));
    }
    if (_hasValue(data['nameCompoundNumber'])) {
      coreNumbers.add(_buildNumberCard('Name Compound Number', _getValue(data['nameCompoundNumber']), AppColors.turmericYellow));
    }
    if (_hasValue(data['monthNumber'])) {
      coreNumbers.add(_buildNumberCard('Month Number', _getValue(data['monthNumber']), AppColors.sacredRed));
    }
    if (_hasValue(data['yearNumber'])) {
      coreNumbers.add(_buildNumberCard('Year Number', _getValue(data['yearNumber']), AppColors.peacockBlue));
    }
    if (_hasValue(data['mobileNumber'])) {
      coreNumbers.add(_buildNumberCard('Mobile Number', _getValue(data['mobileNumber']), AppColors.green));
    }
    
    if (coreNumbers.isNotEmpty) {
      sections.add(_buildSection('Core Numbers', Icons.numbers, coreNumbers, AppColors.saffron));
    }
    
    // Additional Information
    final additionalInfo = <Widget>[];
    if (_hasValue(data['westernZodiacSign'])) {
      additionalInfo.add(_buildInfoRow('Zodiac Sign', _getValue(data['westernZodiacSign'])));
    }
    
    if (additionalInfo.isNotEmpty) {
      sections.add(_buildSection('Additional Information', Icons.info, additionalInfo, AppColors.deepOrange));
    }
    
    return sections.isEmpty 
        ? _buildEmptyState('No number analysis data available')
        : Column(children: sections);
  }

  Widget _buildMissingNumbers(Map<String, dynamic> data) {
    final sections = <Widget>[];
    
    // Missing Numbers
    if (_hasValue(data['missingNumbers'])) {
      sections.add(_buildSection(
        'Missing Numbers',
        Icons.remove_circle,
        [
          _buildNumberInfoCard('Missing Numbers', _getValue(data['missingNumbers']), AppColors.error),
        ],
        AppColors.error,
      ));
    }
    
    // Missing Number Details
    if (data['missingNumberDetails'] != null && data['missingNumberDetails'] is List) {
      final details = <Widget>[];
      for (final item in data['missingNumberDetails'] as List) {
        if (item is Map) {
          item.forEach((key, value) {
            if (value is List) {
              details.add(_buildDescriptionCard(
                key.toString(),
                value.join('\n• '),
                AppColors.error,
              ));
            }
          });
        }
      }
      if (details.isNotEmpty) {
        sections.add(_buildSection('Missing Number Details', Icons.info, details, AppColors.error));
      }
    }
    
    // Remedies
    if (data['missingNumberRemedies'] != null && data['missingNumberRemedies'] is List) {
      final remedies = <Widget>[];
      for (final item in data['missingNumberRemedies'] as List) {
        if (item is Map) {
          item.forEach((key, value) {
            if (value is List) {
              remedies.add(_buildDescriptionCard(
                'Remedies for $key',
                value.join('\n• '),
                AppColors.green,
              ));
            }
          });
        }
      }
      if (remedies.isNotEmpty) {
        sections.add(_buildSection('Remedies', Icons.healing, remedies, AppColors.green));
      }
    }
    
    return sections.isEmpty 
        ? _buildEmptyState('No missing numbers data available')
        : Column(children: sections);
  }

  Widget _buildAvailableNumbers(Map<String, dynamic> data) {
    final sections = <Widget>[];
    
    // Available Numbers
    if (_hasValue(data['availableNumbers'])) {
      sections.add(_buildSection(
        'Available Numbers',
        Icons.check_circle,
        [
          _buildNumberInfoCard('Available Numbers', _getValue(data['availableNumbers']), AppColors.green),
        ],
        AppColors.green,
      ));
    }
    
    // Available Number Details
    if (data['availableNumberDitails'] != null && data['availableNumberDitails'] is List) {
      final details = <Widget>[];
      for (final item in data['availableNumberDitails'] as List) {
        if (item is Map) {
          final number = _getValue(item['number']);
          final description = _getValue(item['description']);
          if (number != 'N/A' && description != 'N/A') {
            details.add(_buildDescriptionCard(
              number,
              description,
              AppColors.green,
            ));
          }
        }
      }
      if (details.isNotEmpty) {
        sections.add(_buildSection('Number Details', Icons.info, details, AppColors.green));
      }
    }
    
    return sections.isEmpty 
        ? _buildEmptyState('No available numbers data available')
        : Column(children: sections);
  }

  Widget _buildMobileAnalysis(Map<String, dynamic> data) {
    final sections = <Widget>[];
    
    // Mobile Number Info
    final mobileInfo = <Widget>[];
    if (_hasValue(data['mobileNumber'])) {
      mobileInfo.add(_buildInfoRow('Mobile Number', _getValue(data['mobileNumber'])));
    }
    if (_hasValue(data['mobileNumberSum'])) {
      mobileInfo.add(_buildInfoRow('Mobile Number Sum', _getValue(data['mobileNumberSum'])));
    }
    if (_hasValue(data['mobileNumberDescriptions'])) {
      mobileInfo.add(_buildDescriptionCard('Mobile Number Analysis', _getValue(data['mobileNumberDescriptions']), AppColors.peacockBlue));
    }
    if (_hasValue(data['negativeNumbers'])) {
      mobileInfo.add(_buildInfoRow('Negative Numbers', _getValue(data['negativeNumbers'])));
    }
    if (_hasValue(data['pairsOfThree'])) {
      mobileInfo.add(_buildInfoRow('Pairs of Three', _getValue(data['pairsOfThree'])));
    }
    
    if (mobileInfo.isNotEmpty) {
      sections.add(_buildSection('Mobile Number Analysis', Icons.phone_android, mobileInfo, AppColors.peacockBlue));
    }
    
    // Individual Digit Analysis
    if (data['individualDigitAnalysis'] != null && data['individualDigitAnalysis'] is List) {
      final digits = <Widget>[];
      for (final item in data['individualDigitAnalysis'] as List) {
        if (item is Map) {
          final digit = _getValue(item['digit']);
          final meaning = _getValue(item['meaning']);
          if (digit != 'N/A' && meaning != 'N/A') {
            digits.add(_buildLuckyCard(digit, meaning, AppColors.templeGold));
          }
        }
      }
      if (digits.isNotEmpty) {
        sections.add(_buildSection('Digit Analysis', Icons.numbers, digits, AppColors.templeGold));
      }
    }
    
    // Mobile Number Sum Result
    if (data['mobileNumberSumResult'] != null && data['mobileNumberSumResult'] is List) {
      final results = <Widget>[];
      for (final item in data['mobileNumberSumResult'] as List) {
        results.add(_buildDescriptionCard('Sum Result', item.toString(), AppColors.green));
      }
      if (results.isNotEmpty) {
        sections.add(_buildSection('Sum Analysis', Icons.calculate, results, AppColors.green));
      }
    }
    
    return sections.isEmpty 
        ? _buildEmptyState('No mobile analysis data available')
        : Column(children: sections);
  }

  Widget _buildNumerologySuggestion(Map<String, dynamic> data) {
    final sections = <Widget>[];
    
    // Rudraksha
    if (data['rudraksha'] != null) {
      final rudraksha = data['rudraksha'] as Map<String, dynamic>;
      final suggestions = <Widget>[];
      
      if (_hasValue(rudraksha['rudraksha_suggestion'])) {
        final description = rudraksha['rudraksha_description'] is List
            ? (rudraksha['rudraksha_description'] as List).join('\n\n')
            : '';
        suggestions.add(_buildSuggestionCard(
          'Rudraksha',
          _getValue(rudraksha['rudraksha_suggestion']),
          description,
          Icons.auto_awesome,
          AppColors.templeGold,
        ));
      }
      if (_hasValue(rudraksha['zodiac'])) {
        suggestions.add(_buildInfoRow('Your Zodiac', _getValue(rudraksha['zodiac'])));
      }
      
      if (suggestions.isNotEmpty) {
        sections.add(_buildSection('Rudraksha Suggestion', Icons.auto_awesome, suggestions, AppColors.templeGold));
      }
    }
    
    // Cloth Color
    if (data['cloth'] != null) {
      final cloth = data['cloth'] as Map<String, dynamic>;
      final suggestions = <Widget>[];
      
      if (_hasValue(cloth['clothColour'])) {
        final colorValue = cloth['clothColour'].toString().contains(':') 
            ? cloth['clothColour'].toString().split(':').last.trim() 
            : cloth['clothColour'].toString();
        final description = _hasValue(cloth['cloth_colour_description']) 
            ? cloth['cloth_colour_description'].toString()
            : '';
        suggestions.add(_buildSuggestionCard(
          'Cloth Color',
          colorValue,
          description,
          Icons.checkroom,
          AppColors.deepOrange,
        ));
      }
      
      if (suggestions.isNotEmpty) {
        sections.add(_buildSection('Cloth Color Suggestion', Icons.checkroom, suggestions, AppColors.deepOrange));
      }
    }
    
    // Watch
    if (data['watch'] != null) {
      final watch = data['watch'] as Map<String, dynamic>;
      final suggestions = <Widget>[];
      
      if (_hasValue(watch['watchColour']) || _hasValue(watch['wristWatch'])) {
        final watchValue = _hasValue(watch['watchColour']) 
            ? _getValue(watch['watchColour'])
            : _getValue(watch['wristWatch']);
        final description = _hasValue(watch['wristWatch']) 
            ? _getValue(watch['wristWatch'])
            : '';
        suggestions.add(_buildSuggestionCard(
          'Watch Suggestion',
          watchValue,
          description,
          Icons.watch,
          AppColors.turmericYellow,
        ));
      }
      
      if (suggestions.isNotEmpty) {
        sections.add(_buildSection('Watch Suggestion', Icons.watch, suggestions, AppColors.turmericYellow));
      }
    }
    
    // Oil
    if (data['oil'] != null) {
      final oil = data['oil'] as Map<String, dynamic>;
      final suggestions = <Widget>[];
      
      if (_hasValue(oil['oil_suggestion'])) {
        final description = _hasValue(oil['oil_suggestion_description']) 
            ? oil['oil_suggestion_description'].toString()
            : '';
        suggestions.add(_buildSuggestionCard(
          _getValue(oil['oil_suggestion_title'], defaultValue: 'Oil Suggestion'),
          _getValue(oil['oil_suggestion']),
          description,
          Icons.water_drop,
          AppColors.sacredRed,
        ));
      }
      
      // Planet Image
      if (_hasValue(oil['planet_image'])) {
        final imagePath = _getValue(oil['planet_image']);
        final imageUrl = _buildImageUrl(imagePath);
        suggestions.add(_buildPlanetImageCard(imageUrl));
      }
      
      if (suggestions.isNotEmpty) {
        sections.add(_buildSection('Oil Suggestion', Icons.water_drop, suggestions, AppColors.sacredRed));
      }
    }
    
    return sections.isEmpty 
        ? _buildEmptyState('No numerology suggestions available')
        : Column(children: sections);
  }

  Widget _buildNameAnalysis(Map<String, dynamic> data) {
    final sections = <Widget>[];
    
    // Name Numbers
    final nameNumbers = <Widget>[];
    if (_hasValue(data['nameNumber'])) {
      nameNumbers.add(_buildNumberCard('Name Number (Chaldean)', _getValue(data['nameNumber']), AppColors.saffron));
    }
    if (_hasValue(data['firstNameNumber'])) {
      nameNumbers.add(_buildNumberCard('First Name Number', _getValue(data['firstNameNumber']), AppColors.deepOrange));
    }
    
    if (nameNumbers.isNotEmpty) {
      sections.add(_buildSection('Name Numbers', Icons.numbers, nameNumbers, AppColors.saffron));
    }
    
    // Compatibility
    final compatibility = <Widget>[];
    if (_hasValue(data['nameCompatibilityAsPerMoolank'])) {
      compatibility.add(_buildInfoRow('Compatibility (Moolank)', _getValue(data['nameCompatibilityAsPerMoolank'])));
    }
    if (_hasValue(data['nameCompatibilityAsPerBhagyank'])) {
      compatibility.add(_buildInfoRow('Compatibility (Bhagyank)', _getValue(data['nameCompatibilityAsPerBhagyank'])));
    }
    if (_hasValue(data['overallNameCompatibilityAsPerMoolankBhagyank'])) {
      compatibility.add(_buildDescriptionCard('Overall Compatibility', _getValue(data['overallNameCompatibilityAsPerMoolankBhagyank']), AppColors.templeGold));
    }
    if (_hasValue(data['firstNameCompatibilityAsPerMoolank'])) {
      compatibility.add(_buildInfoRow('First Name (Moolank)', _getValue(data['firstNameCompatibilityAsPerMoolank'])));
    }
    if (_hasValue(data['firstNameCompatibilityAsPerBhagyank'])) {
      compatibility.add(_buildInfoRow('First Name (Bhagyank)', _getValue(data['firstNameCompatibilityAsPerBhagyank'])));
    }
    if (_hasValue(data['overallFirstNameCompatibilityAsPerMoolankBhagyank'])) {
      compatibility.add(_buildDescriptionCard('First Name Overall', _getValue(data['overallFirstNameCompatibilityAsPerMoolankBhagyank']), AppColors.templeGold));
    }
    
    if (compatibility.isNotEmpty) {
      sections.add(_buildSection('Name Compatibility', Icons.verified, compatibility, AppColors.templeGold));
    }
    
    // Suggested Numbers
    final suggestedNumbers = <Widget>[];
    if (_hasValue(data['suggestedNameNumber'])) {
      suggestedNumbers.add(_buildNumberInfoCard('Suggested Name Number', _getValue(data['suggestedNameNumber']), AppColors.saffron));
    }
    if (_hasValue(data['luckyNumbers'])) {
      suggestedNumbers.add(_buildNumberInfoCard('Lucky Numbers', _getValue(data['luckyNumbers']), AppColors.green));
    }
    if (_hasValue(data['neutralNumbers'])) {
      suggestedNumbers.add(_buildNumberInfoCard('Neutral Numbers', _getValue(data['neutralNumbers']), AppColors.gray));
    }
    if (_hasValue(data['unluckyNumbers'])) {
      suggestedNumbers.add(_buildNumberInfoCard('Unlucky Numbers', _getValue(data['unluckyNumbers']), AppColors.error));
    }
    if (_hasValue(data['suggestedTotal'])) {
      suggestedNumbers.add(_buildNumberInfoCard('Suggested Total', _getValue(data['suggestedTotal']), AppColors.templeGold));
    }
    
    if (suggestedNumbers.isNotEmpty) {
      sections.add(_buildSection('Suggested Numbers', Icons.star, suggestedNumbers, AppColors.templeGold));
    }
    
    // Suggested Name Spellings
    if (data['suggestedNameSpellings'] != null && data['suggestedNameSpellings'] is List) {
      final spellings = <Widget>[];
      for (final item in data['suggestedNameSpellings'] as List) {
        if (item is Map) {
          item.forEach((key, value) {
            if (value is List) {
              spellings.add(_buildDescriptionCard(
                key.toString(),
                value.join('\n• '),
                AppColors.deepOrange,
              ));
            }
          });
        }
      }
      if (spellings.isNotEmpty) {
        sections.add(_buildSection('Suggested Name Spellings', Icons.text_fields, spellings, AppColors.deepOrange));
      }
    }
    
    // Description
    if (_hasValue(data['description'])) {
      sections.insert(0, _buildDescriptionCard('About Name Analysis', _getValue(data['description']), AppColors.saffron));
    }
    
    return sections.isEmpty 
        ? _buildEmptyState('No name analysis data available')
        : Column(children: sections);
  }

  Widget _buildVehicleAnalysis(Map<String, dynamic> data) {
    final sections = <Widget>[];
    
    // Vehicle Number Info
    final vehicleInfo = <Widget>[];
    if (_hasValue(data['vehicleNumber'])) {
      vehicleInfo.add(_buildInfoRow('Vehicle Number', _getValue(data['vehicleNumber'])));
    }
    if (_hasValue(data['vehicleNumberSum'])) {
      vehicleInfo.add(_buildInfoRow('Vehicle Number Sum', _getValue(data['vehicleNumberSum'])));
    }
    if (_hasValue(data['vehicleNumberDescriptions'])) {
      vehicleInfo.add(_buildDescriptionCard('Vehicle Number Analysis', _getValue(data['vehicleNumberDescriptions']), AppColors.peacockBlue));
    }
    if (_hasValue(data['negativeNumbers'])) {
      vehicleInfo.add(_buildInfoRow('Negative Numbers', _getValue(data['negativeNumbers'])));
    }
    if (_hasValue(data['pairsOfThree'])) {
      vehicleInfo.add(_buildInfoRow('Pairs of Three', _getValue(data['pairsOfThree'])));
    }
    
    if (vehicleInfo.isNotEmpty) {
      sections.add(_buildSection('Vehicle Number Analysis', Icons.directions_car, vehicleInfo, AppColors.peacockBlue));
    }
    
    // Individual Digit Analysis
    if (data['individualDigitAnalysis'] != null && data['individualDigitAnalysis'] is List) {
      final digits = <Widget>[];
      for (final item in data['individualDigitAnalysis'] as List) {
        if (item is Map) {
          final digit = _getValue(item['digit']);
          final meaning = _getValue(item['meaning']);
          if (digit != 'N/A' && meaning != 'N/A') {
            digits.add(_buildLuckyCard(digit, meaning, AppColors.templeGold));
          }
        }
      }
      if (digits.isNotEmpty) {
        sections.add(_buildSection('Digit Analysis', Icons.numbers, digits, AppColors.templeGold));
      }
    }
    
    // Vehicle Number Sum Result
    if (data['vehicleNumberSumResult'] != null && data['vehicleNumberSumResult'] is List) {
      final results = <Widget>[];
      for (final item in data['vehicleNumberSumResult'] as List) {
        results.add(_buildDescriptionCard('Sum Result', item.toString(), AppColors.green));
      }
      if (results.isNotEmpty) {
        sections.add(_buildSection('Sum Analysis', Icons.calculate, results, AppColors.green));
      }
    }
    
    return sections.isEmpty 
        ? _buildEmptyState('No vehicle analysis data available')
        : Column(children: sections);
  }

  Widget _buildLuckyThings(Map<String, dynamic> data) {
    final sections = <Widget>[];
    
    if (data['luckyThings'] == null) {
      return _buildEmptyState('No lucky things data available');
    }
    
    final lt = data['luckyThings'] as Map<String, dynamic>;
    
    // Description
    if (_hasValue(data['description'])) {
      sections.add(_buildDescriptionCard('About Lucky Things', _getValue(data['description']), AppColors.saffron));
    }
    
    // Numbers
    if (lt['numbers'] != null) {
      final numbers = lt['numbers'] as Map<String, dynamic>;
      final numberCards = <Widget>[];
      
      if (numbers['lucky'] != null && _hasValue(numbers['lucky']['value'])) {
        numberCards.add(_buildLuckyCard('Lucky Numbers', _getValue(numbers['lucky']['value']), AppColors.green));
      }
      if (numbers['unlucky'] != null && _hasValue(numbers['unlucky']['value'])) {
        numberCards.add(_buildLuckyCard('Unlucky Numbers', _getValue(numbers['unlucky']['value']), AppColors.error));
      }
      if (numbers['neutral'] != null && _hasValue(numbers['neutral']['value'])) {
        numberCards.add(_buildLuckyCard('Neutral Numbers', _getValue(numbers['neutral']['value']), AppColors.gray));
      }
      
      if (numberCards.isNotEmpty) {
        sections.add(_buildSection('Numbers', Icons.numbers, numberCards, AppColors.saffron));
      }
    }
    
    // Dates and Days
    if (lt['dates_days'] != null) {
      final datesDays = lt['dates_days'] as Map<String, dynamic>;
      final dateCards = <Widget>[];
      
      if (datesDays['lucky_dates'] != null && _hasValue(datesDays['lucky_dates']['value'])) {
        dateCards.add(_buildLuckyCard('Lucky Dates', _getValue(datesDays['lucky_dates']['value']), AppColors.templeGold));
      }
      if (datesDays['lucky_days'] != null && _hasValue(datesDays['lucky_days']['value'])) {
        dateCards.add(_buildLuckyCard('Lucky Days', _getValue(datesDays['lucky_days']['value']), AppColors.deepOrange));
      }
      
      if (dateCards.isNotEmpty) {
        sections.add(_buildSection('Dates & Days', Icons.calendar_today, dateCards, AppColors.templeGold));
      }
    }
    
    // Colors and Directions
    if (lt['colors_directions'] != null) {
      final colorsDirs = lt['colors_directions'] as Map<String, dynamic>;
      final colorCards = <Widget>[];
      
      if (colorsDirs['colors'] != null && _hasValue(colorsDirs['colors']['value'])) {
        colorCards.add(_buildLuckyCard('Lucky Colors', _getValue(colorsDirs['colors']['value']), AppColors.peacockBlue));
      }
      if (colorsDirs['lucky_direction'] != null && _hasValue(colorsDirs['lucky_direction']['value'])) {
        colorCards.add(_buildLuckyCard('Lucky Direction', _getValue(colorsDirs['lucky_direction']['value']), AppColors.spiritualPurple));
      }
      if (colorsDirs['main_gate_direction'] != null && _hasValue(colorsDirs['main_gate_direction']['value'])) {
        colorCards.add(_buildLuckyCard('Main Gate Direction', _getValue(colorsDirs['main_gate_direction']['value']), AppColors.turmericYellow));
      }
      
      if (colorCards.isNotEmpty) {
        sections.add(_buildSection('Colors & Directions', Icons.palette, colorCards, AppColors.peacockBlue));
      }
    }
    
    // Other Information
    final otherInfo = <Widget>[];
    if (_hasValue(lt['ruler'])) {
      otherInfo.add(_buildInfoRow('Ruler Planet', _getValue(lt['ruler'])));
    }
    if (_hasValue(lt['element'])) {
      otherInfo.add(_buildInfoRow('Element', _getValue(lt['element'])));
    }
    if (_hasValue(lt['sunSign'])) {
      otherInfo.add(_buildInfoRow('Sun Sign', _getValue(lt['sunSign'])));
    }
    if (_hasValue(lt['best_time_of_the_day'])) {
      otherInfo.add(_buildInfoRow('Best Time of Day', _getValue(lt['best_time_of_the_day'])));
    }
    if (lt['traits'] != null && lt['traits'] is List && (lt['traits'] as List).isNotEmpty) {
      otherInfo.add(_buildDescriptionCard('Traits', (lt['traits'] as List).join(', '), AppColors.peacockBlue));
    }
    if (lt['favourable_periods'] != null && lt['favourable_periods'] is List && (lt['favourable_periods'] as List).isNotEmpty) {
      otherInfo.add(_buildDescriptionCard('Favourable Periods', (lt['favourable_periods'] as List).join(', '), AppColors.green));
    }
    
    if (otherInfo.isNotEmpty) {
      sections.add(_buildSection('Additional Information', Icons.info, otherInfo, AppColors.deepOrange));
    }
    
    return sections.isEmpty 
        ? _buildEmptyState('No lucky things data available')
        : Column(children: sections);
  }

  Widget _buildPersonalYear(Map<String, dynamic> data) {
    final sections = <Widget>[];
    
    // Personal Year
    if (_hasValue(data['personalYear'])) {
      sections.add(_buildSection(
        'Personal Year',
        Icons.calendar_today,
        [
          _buildInsightCard('Your Personal Year', _getValue(data['personalYear']), AppColors.templeGold),
        ],
        AppColors.templeGold,
      ));
    }
    
    // Description
    if (data['description'] != null) {
      final desc = data['description'] as Map<String, dynamic>;
      final descriptionCards = <Widget>[];
      
      if (_hasValue(desc['title'])) {
        descriptionCards.add(_buildInsightCard('Year Theme', _getValue(desc['title']), AppColors.deepOrange));
      }
      if (_hasValue(desc['description'])) {
        descriptionCards.add(_buildDescriptionCard('Year Description', _getValue(desc['description']), AppColors.saffron));
      }
      
      if (descriptionCards.isNotEmpty) {
        sections.add(_buildSection('Year Analysis', Icons.insights, descriptionCards, AppColors.deepOrange));
      }
    }
    
    // Luck Factor
    if (data['luckFactorDetails'] != null) {
      final luck = data['luckFactorDetails'] as Map<String, dynamic>;
      final luckCards = <Widget>[];
      
      if (_hasValue(luck['title'])) {
        luckCards.add(_buildInsightCard('Luck Factor', _getValue(luck['title']), AppColors.templeGold));
      }
      if (luck['descriptions'] != null && luck['descriptions'] is List && (luck['descriptions'] as List).isNotEmpty) {
        final luckDesc = (luck['descriptions'] as List).join('\n');
        luckCards.add(_buildDescriptionCard('Luck Details', luckDesc, AppColors.templeGold));
      }
      
      if (luckCards.isNotEmpty) {
        sections.add(_buildSection('Luck Factor', Icons.stars, luckCards, AppColors.templeGold));
      }
    }
    
    return sections.isEmpty 
        ? _buildEmptyState('No personal year data available')
        : Column(children: sections);
  }

  Widget _buildKarmicNumber(Map<String, dynamic> data) {
    final sections = <Widget>[];
    
    // Karmic Numbers
    if (_hasValue(data['karmicNumbers'])) {
      sections.add(_buildSection(
        'Karmic Numbers',
        Icons.auto_awesome,
        [
          _buildNumberInfoCard('Karmic Numbers', _getValue(data['karmicNumbers']), AppColors.spiritualPurple),
        ],
        AppColors.spiritualPurple,
      ));
    }
    
    // Karmic Number Details
    if (data['karmicNumber'] != null) {
      final kn = data['karmicNumber'] as Map<String, dynamic>;
      final karmicCards = <Widget>[];
      
      if (_hasValue(kn['title'])) {
        karmicCards.add(_buildInsightCard('Your Karmic Number', _getValue(kn['title']), AppColors.spiritualPurple));
      }
      if (_hasValue(kn['summary'])) {
        karmicCards.add(_buildDescriptionCard('Summary', _getValue(kn['summary']), AppColors.spiritualPurple));
      }
      if (kn['descriptions'] != null && kn['descriptions'] is List && (kn['descriptions'] as List).isNotEmpty) {
        final karmicDesc = (kn['descriptions'] as List).join('\n• ');
        karmicCards.add(_buildDescriptionCard('Details', '• $karmicDesc', AppColors.spiritualPurple));
      }
      
      if (karmicCards.isNotEmpty) {
        sections.add(_buildSection('Karmic Number Analysis', Icons.insights, karmicCards, AppColors.spiritualPurple));
      }
    }
    
    return sections.isEmpty 
        ? _buildEmptyState('No karmic number data available')
        : Column(children: sections);
  }

  Widget _buildMasterNumbers(Map<String, dynamic> data) {
    final sections = <Widget>[];
    
    // Master Driver
    if (data['master_driver'] != null) {
      final md = data['master_driver'] as Map<String, dynamic>;
      final driverCards = <Widget>[];
      
      if (_hasValue(md['title'])) {
        driverCards.add(_buildInsightCard('Master Driver Number', _getValue(md['title']), AppColors.saffron));
      }
      if (_hasValue(md['summary'])) {
        driverCards.add(_buildDescriptionCard('Summary', _getValue(md['summary']), AppColors.saffron));
      }
      if (_hasValue(md['descriptionTitle'])) {
        driverCards.add(_buildInsightCard('Description', _getValue(md['descriptionTitle']), AppColors.saffron));
      }
      if (md['descriptions'] != null && md['descriptions'] is List && (md['descriptions'] as List).isNotEmpty) {
        final masterDesc = (md['descriptions'] as List).join('\n• ');
        driverCards.add(_buildDescriptionCard('Characteristics', '• $masterDesc', AppColors.saffron));
      }
      
      if (driverCards.isNotEmpty) {
        sections.add(_buildSection('Master Driver Number', Icons.star, driverCards, AppColors.saffron));
      }
    }
    
    // Master Conductor
    if (data['master_conductor'] != null) {
      final mc = data['master_conductor'] as Map<String, dynamic>;
      if (_hasValue(mc['message'])) {
        sections.add(_buildSection(
          'Master Conductor',
          Icons.auto_awesome,
          [
            _buildDescriptionCard('Master Conductor', _getValue(mc['message']), AppColors.deepOrange),
          ],
          AppColors.deepOrange,
        ));
      }
    }
    
    return sections.isEmpty 
        ? _buildEmptyState('No master numbers data available')
        : Column(children: sections);
  }

  // Helper methods
  bool _hasValue(dynamic value) {
    return value != null && value.toString().isNotEmpty && 
           value.toString() != 'null' && value.toString() != 'N/A';
  }

  String _getValue(dynamic value, {String defaultValue = 'N/A'}) {
    if (_hasValue(value)) {
      return value.toString();
    }
    return defaultValue;
  }

  String _formatFieldName(String key) {
    // Convert camelCase to Title Case
    return key
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
        .split(' ')
        .map((word) => word.isEmpty
            ? ''
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ')
        .trim();
  }

  String _buildImageUrl(String imagePath) {
    if (imagePath.isEmpty || imagePath == 'N/A') {
      return '';
    }
    
    // If already a full URL, return as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }
    
    // If starts with '/', prepend base URL
    if (imagePath.startsWith('/')) {
      return 'https://api.jyotishamastroapi.com$imagePath';
    }
    
    // Otherwise, assume it's a relative path and prepend base URL with '/'
    return 'https://api.jyotishamastroapi.com/$imagePath';
  }

  Widget _buildPlanetImageCard(String imageUrl) {
    if (imageUrl.isEmpty) {
      return SizedBox.shrink();
    }
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.sacredRed.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.sacredRed.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.sacredRed.withOpacity(0.15),
                  AppColors.sacredRed.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.sacredRed.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.image, color: AppColors.sacredRed, size: 24.w),
                ),
                Spacing.w(12),
                Expanded(
                  child: AutoTranslateText(
                    'Planet Image',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Center(
              child: NetworkImageWithLoader(
                url: imageUrl,
                height: 200.h,
                width: 200.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 64.w,
              color: AppColors.textSecondary,
            ),
            Spacing.h(16),
            AutoTranslateText(
              message,
              style: MyTextTheme.mediumBCN.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyPoints(Map<String, dynamic> data) {
    final formData = data['_formData'] as Map<String, dynamic>?;
    
    // Extract data from all APIs
    final numberAnalysis = data['radicalNumber'] != null ? data : (data['numberAnalysisData'] as Map<String, dynamic>? ?? {});
    final numerologySuggestion = data['numerologySuggestionData'] as Map<String, dynamic>? ?? {};
    final nameAnalysis = data['nameAnalysisData'] as Map<String, dynamic>? ?? {};
    final luckyThings = data['luckyThingsData'] as Map<String, dynamic>? ?? {};
    final missingNumbers = data['missingNumbersData'] as Map<String, dynamic>? ?? {};
    final availableNumbers = data['availableNumbersData'] as Map<String, dynamic>? ?? {};
    final mobileAnalysis = data['mobileAnalysisData'] as Map<String, dynamic>? ?? {};
    final personalYear = data['personalYearData'] as Map<String, dynamic>? ?? {};
    final karmicNumber = data['karmicNumberData'] as Map<String, dynamic>? ?? {};
    final masterNumbers = data['masterNumbersData'] as Map<String, dynamic>? ?? {};

    final List<Widget> sections = [];

    // Helper to check if value exists
    bool hasValue(dynamic value) {
      return value != null && value.toString().isNotEmpty && 
             value.toString() != 'null' && value.toString() != 'N/A';
    }

    // Helper to get value safely
    String getValue(dynamic value, {String defaultValue = 'N/A'}) {
      if (hasValue(value)) {
        return value.toString();
      }
      return defaultValue;
    }

    // Section 1: Basic Information
    if (formData != null) {
      final basicInfo = <Widget>[];
      if (hasValue(formData['name'])) {
        basicInfo.add(_buildInfoRow('Name', getValue(formData['name'])));
      }
      if (hasValue(formData['date'])) {
        basicInfo.add(_buildInfoRow('Date of Birth', getValue(formData['date'])));
      }
      if (hasValue(formData['gender'])) {
        basicInfo.add(_buildInfoRow('Gender', getValue(formData['gender'])));
      }
      
      if (basicInfo.isNotEmpty) {
        sections.add(_buildSection(
          'Basic Information',
          Icons.person,
          basicInfo,
          AppColors.saffron,
        ));
      }
    }

    // Section 2: Core Numbers
    final coreNumbers = <Widget>[];
    if (hasValue(numberAnalysis['radicalNumber'])) {
      coreNumbers.add(_buildNumberCard('Radical Number', getValue(numberAnalysis['radicalNumber']), AppColors.saffron));
    }
    if (hasValue(numberAnalysis['destinyNumber'])) {
      coreNumbers.add(_buildNumberCard('Destiny Number', getValue(numberAnalysis['destinyNumber']), AppColors.deepOrange));
    }
    if (hasValue(numberAnalysis['nameNumber'])) {
      coreNumbers.add(_buildNumberCard('Name Number', getValue(numberAnalysis['nameNumber']), AppColors.templeGold));
    }
    // Check nameAnalysis for Chaldean name number - try multiple possible keys
  
    // Zodiac Sign - use special card design for better visibility
    if (hasValue(numberAnalysis['westernZodiacSign'])) {
      coreNumbers.add(_buildZodiacCard('Zodiac Sign', getValue(numberAnalysis['westernZodiacSign']), AppColors.sacredRed));
    }
    
    if (coreNumbers.isNotEmpty) {
      sections.add(_buildSection(
        'Core Numbers',
        Icons.numbers,
        coreNumbers,
        AppColors.saffron,
      ));
    }

    // Section 3: Numerology Suggestions (with descriptions)
    if (numerologySuggestion.isNotEmpty) {
      final suggestions = <Widget>[];
      
      // Rudraksha
      if (numerologySuggestion['rudraksha'] != null) {
        final rudraksha = numerologySuggestion['rudraksha'] as Map<String, dynamic>;
        if (rudraksha['rudraksha_suggestion'] != null) {
          final description = rudraksha['rudraksha_description'] is List
              ? (rudraksha['rudraksha_description'] as List).join('\n\n')
              : '';
          suggestions.add(_buildSuggestionCard(
            'Rudraksha',
            getValue(rudraksha['rudraksha_suggestion']),
            description,
            Icons.auto_awesome,
            AppColors.templeGold,
          ));
        }
      }
      
      // Cloth Color
      if (numerologySuggestion['cloth'] != null) {
        final cloth = numerologySuggestion['cloth'] as Map<String, dynamic>;
        if (hasValue(cloth['clothColour'])) {
          final colorValue = cloth['clothColour'].toString().contains(':') 
              ? cloth['clothColour'].toString().split(':').last.trim() 
              : cloth['clothColour'].toString();
          final description = hasValue(cloth['cloth_colour_description']) 
              ? cloth['cloth_colour_description'].toString()
              : '';
          suggestions.add(_buildSuggestionCard(
            'Cloth Color',
            colorValue,
            description,
            Icons.checkroom,
            AppColors.deepOrange,
          ));
        }
      }
      
      // Watch
      if (numerologySuggestion['watch'] != null) {
        final watch = numerologySuggestion['watch'] as Map<String, dynamic>;
        if (hasValue(watch['watchColour']) || hasValue(watch['wristWatch'])) {
          final watchValue = hasValue(watch['watchColour']) 
              ? getValue(watch['watchColour'])
              : getValue(watch['wristWatch']);
          final description = hasValue(watch['wristWatch']) 
              ? getValue(watch['wristWatch'])
              : '';
          suggestions.add(_buildSuggestionCard(
            'Watch Suggestion',
            watchValue,
            description,
            Icons.watch,
            AppColors.turmericYellow,
          ));
        }
      }
      
      // Oil
      if (numerologySuggestion['oil'] != null) {
        final oil = numerologySuggestion['oil'] as Map<String, dynamic>;
        if (hasValue(oil['oil_suggestion'])) {
          final description = hasValue(oil['oil_suggestion_description']) 
              ? oil['oil_suggestion_description'].toString()
              : '';
          suggestions.add(_buildSuggestionCard(
            getValue(oil['oil_suggestion_title'], defaultValue: 'Oil Suggestion'),
            getValue(oil['oil_suggestion']),
            description,
            Icons.water_drop,
            AppColors.sacredRed,
          ));
        }
        // Planet Image
        if (hasValue(oil['planet_image'])) {
          final imagePath = getValue(oil['planet_image']);
          final imageUrl = _buildImageUrl(imagePath);
          suggestions.add(_buildPlanetImageCard(imageUrl));
        }
      }
      
      if (suggestions.isNotEmpty) {
        sections.add(_buildSection(
          'Numerology Suggestions',
          Icons.lightbulb,
          suggestions,
          AppColors.templeGold,
        ));
      }
    }

    // Section 4: Lucky Things
    if (luckyThings.isNotEmpty && luckyThings['luckyThings'] != null) {
      final lt = luckyThings['luckyThings'] as Map<String, dynamic>;
      final luckyItems = <Widget>[];
      
      // Numbers
      if (lt['numbers'] != null) {
        final numbers = lt['numbers'] as Map<String, dynamic>;
        if (numbers['lucky'] != null && hasValue(numbers['lucky']['value'])) {
          luckyItems.add(_buildLuckyCard('Lucky Numbers', getValue(numbers['lucky']['value']), AppColors.green));
        }
        if (numbers['unlucky'] != null && hasValue(numbers['unlucky']['value'])) {
          luckyItems.add(_buildLuckyCard('Unlucky Numbers', getValue(numbers['unlucky']['value']), AppColors.error));
        }
        if (numbers['neutral'] != null && hasValue(numbers['neutral']['value'])) {
          luckyItems.add(_buildLuckyCard('Neutral Numbers', getValue(numbers['neutral']['value']), AppColors.gray));
        }
      }
      
      // Dates and Days
      if (lt['dates_days'] != null) {
        final datesDays = lt['dates_days'] as Map<String, dynamic>;
        if (datesDays['lucky_dates'] != null && hasValue(datesDays['lucky_dates']['value'])) {
          luckyItems.add(_buildLuckyCard('Lucky Dates', getValue(datesDays['lucky_dates']['value']), AppColors.templeGold));
        }
        if (datesDays['lucky_days'] != null && hasValue(datesDays['lucky_days']['value'])) {
          luckyItems.add(_buildLuckyCard('Lucky Days', getValue(datesDays['lucky_days']['value']), AppColors.deepOrange));
        }
      }
      
      // Colors and Directions
      if (lt['colors_directions'] != null) {
        final colorsDirs = lt['colors_directions'] as Map<String, dynamic>;
        if (colorsDirs['colors'] != null && hasValue(colorsDirs['colors']['value'])) {
          luckyItems.add(_buildLuckyCard('Lucky Colors', getValue(colorsDirs['colors']['value']), AppColors.peacockBlue));
        }
        if (colorsDirs['lucky_direction'] != null && hasValue(colorsDirs['lucky_direction']['value'])) {
          luckyItems.add(_buildLuckyCard('Lucky Direction', getValue(colorsDirs['lucky_direction']['value']), AppColors.spiritualPurple));
        }
        if (colorsDirs['main_gate_direction'] != null && hasValue(colorsDirs['main_gate_direction']['value'])) {
          luckyItems.add(_buildLuckyCard('Main Gate Direction', getValue(colorsDirs['main_gate_direction']['value']), AppColors.turmericYellow));
        }
      }
      
      if (hasValue(lt['ruler'])) {
        luckyItems.add(_buildLuckyCard('Ruler Planet', getValue(lt['ruler']), AppColors.saffron));
      }
      if (hasValue(lt['element'])) {
        luckyItems.add(_buildLuckyCard('Element', getValue(lt['element']), AppColors.deepOrange));
      }
      if (hasValue(lt['sunSign'])) {
        luckyItems.add(_buildLuckyCard('Sun Sign', getValue(lt['sunSign']), AppColors.templeGold));
      }
      if (hasValue(lt['best_time_of_the_day'])) {
        luckyItems.add(_buildLuckyCard('Best Time of Day', getValue(lt['best_time_of_the_day']), AppColors.sacredRed));
      }
      
      if (lt['traits'] != null && lt['traits'] is List && (lt['traits'] as List).isNotEmpty) {
        final traits = (lt['traits'] as List).join(', ');
        luckyItems.add(_buildLuckyCard('Traits', traits, AppColors.peacockBlue));
      }
      
      if (lt['favourable_periods'] != null && lt['favourable_periods'] is List && (lt['favourable_periods'] as List).isNotEmpty) {
        final periods = (lt['favourable_periods'] as List).join(', ');
        luckyItems.add(_buildLuckyCard('Favourable Periods', periods, AppColors.green));
      }
      
      if (luckyItems.isNotEmpty) {
        sections.add(_buildSection(
          'Lucky Elements',
          Icons.stars,
          luckyItems,
          AppColors.templeGold,
        ));
      }
    }

    // Section 5: Numbers Analysis
    final numbersAnalysis = <Widget>[];
    if (missingNumbers.isNotEmpty && hasValue(missingNumbers['missingNumbers'])) {
      numbersAnalysis.add(_buildNumberInfoCard('Missing Numbers', getValue(missingNumbers['missingNumbers']), AppColors.error));
    }
    if (availableNumbers.isNotEmpty && hasValue(availableNumbers['availableNumbers'])) {
      numbersAnalysis.add(_buildNumberInfoCard('Available Numbers', getValue(availableNumbers['availableNumbers']), AppColors.green));
    }
    if (nameAnalysis.isNotEmpty) {
      if (hasValue(nameAnalysis['luckyNumbers'])) {
        numbersAnalysis.add(_buildNumberInfoCard('Lucky Numbers', getValue(nameAnalysis['luckyNumbers']), AppColors.green));
      }
      if (hasValue(nameAnalysis['neutralNumbers'])) {
        numbersAnalysis.add(_buildNumberInfoCard('Neutral Numbers', getValue(nameAnalysis['neutralNumbers']), AppColors.gray));
      }
      if (hasValue(nameAnalysis['unluckyNumbers'])) {
        numbersAnalysis.add(_buildNumberInfoCard('Unlucky Numbers', getValue(nameAnalysis['unluckyNumbers']), AppColors.error));
      }
    }
    
    if (numbersAnalysis.isNotEmpty) {
      sections.add(_buildSection(
        'Numbers Analysis',
        Icons.calculate,
        numbersAnalysis,
        AppColors.saffron,
      ));
    }

    // Section 6: Personal Insights
    final insights = <Widget>[];
    if (personalYear.isNotEmpty) {
      if (hasValue(personalYear['personalYear'])) {
        insights.add(_buildInsightCard('Personal Year', getValue(personalYear['personalYear']), AppColors.templeGold));
      }
      if (personalYear['description'] != null) {
        final desc = personalYear['description'] as Map<String, dynamic>;
        if (hasValue(desc['title'])) {
          insights.add(_buildInsightCard('Year Theme', getValue(desc['title']), AppColors.deepOrange));
        }
        if (hasValue(desc['description'])) {
          insights.add(_buildDescriptionCard('Year Description', getValue(desc['description']), AppColors.saffron));
        }
      }
      if (personalYear['luckFactorDetails'] != null) {
        final luck = personalYear['luckFactorDetails'] as Map<String, dynamic>;
        if (luck['descriptions'] != null && luck['descriptions'] is List && (luck['descriptions'] as List).isNotEmpty) {
          final luckDesc = (luck['descriptions'] as List).join('\n');
          insights.add(_buildDescriptionCard('Luck Factor', luckDesc, AppColors.templeGold));
        }
      }
    }
    
    if (karmicNumber.isNotEmpty && karmicNumber['karmicNumber'] != null) {
      final kn = karmicNumber['karmicNumber'] as Map<String, dynamic>;
      if (hasValue(kn['title'])) {
        insights.add(_buildInsightCard('Karmic Number', getValue(kn['title']), AppColors.spiritualPurple));
      }
      if (hasValue(kn['summary'])) {
        insights.add(_buildDescriptionCard('Karmic Summary', getValue(kn['summary']), AppColors.spiritualPurple));
      }
      if (kn['descriptions'] != null && kn['descriptions'] is List && (kn['descriptions'] as List).isNotEmpty) {
        final karmicDesc = (kn['descriptions'] as List).join('\n• ');
        insights.add(_buildDescriptionCard('Karmic Details', '• $karmicDesc', AppColors.spiritualPurple));
      }
    }
    
    if (masterNumbers.isNotEmpty) {
      if (masterNumbers['master_driver'] != null) {
        final md = masterNumbers['master_driver'] as Map<String, dynamic>;
        if (hasValue(md['title'])) {
          insights.add(_buildInsightCard('Master Driver', getValue(md['title']), AppColors.saffron));
        }
        if (hasValue(md['summary'])) {
          insights.add(_buildDescriptionCard('Master Driver Summary', getValue(md['summary']), AppColors.saffron));
        }
        if (md['descriptions'] != null && md['descriptions'] is List && (md['descriptions'] as List).isNotEmpty) {
          final masterDesc = (md['descriptions'] as List).join('\n• ');
          insights.add(_buildDescriptionCard('Master Driver Details', '• $masterDesc', AppColors.saffron));
        }
      }
      if (masterNumbers['master_conductor'] != null) {
        final mc = masterNumbers['master_conductor'] as Map<String, dynamic>;
        if (hasValue(mc['message'])) {
          insights.add(_buildDescriptionCard('Master Conductor', getValue(mc['message']), AppColors.deepOrange));
        }
      }
    }
    
    if (insights.isNotEmpty) {
      sections.add(_buildSection(
        'Personal Insights',
        Icons.insights,
        insights,
        AppColors.deepOrange,
      ));
    }

    // Section 7: Mobile Analysis
    if (mobileAnalysis.isNotEmpty) {
      final mobileItems = <Widget>[];
      if (hasValue(mobileAnalysis['mobileNumber'])) {
        mobileItems.add(_buildInfoRow('Mobile Number', getValue(mobileAnalysis['mobileNumber'])));
      }
      if (hasValue(mobileAnalysis['mobileNumberSum'])) {
        mobileItems.add(_buildInfoRow('Mobile Number Sum', getValue(mobileAnalysis['mobileNumberSum'])));
      }
      if (hasValue(mobileAnalysis['mobileNumberDescriptions'])) {
        mobileItems.add(_buildDescriptionCard('Mobile Number Analysis', getValue(mobileAnalysis['mobileNumberDescriptions']), AppColors.peacockBlue));
      }
      if (hasValue(mobileAnalysis['negativeNumbers'])) {
        mobileItems.add(_buildInfoRow('Negative Numbers', getValue(mobileAnalysis['negativeNumbers'])));
      }
      if (hasValue(mobileAnalysis['pairsOfThree'])) {
        mobileItems.add(_buildInfoRow('Pairs of Three', getValue(mobileAnalysis['pairsOfThree'])));
      }
      
      if (mobileItems.isNotEmpty) {
        sections.add(_buildSection(
          'Mobile Analysis',
          Icons.phone_android,
          mobileItems,
          AppColors.peacockBlue,
        ));
      }
    }

    // Section 8: Name Compatibility
    if (nameAnalysis.isNotEmpty) {
      final compatibility = <Widget>[];
      if (hasValue(nameAnalysis['nameCompatibilityAsPerMoolank'])) {
        compatibility.add(_buildInfoRow('Compatibility (Moolank)', getValue(nameAnalysis['nameCompatibilityAsPerMoolank'])));
      }
      if (hasValue(nameAnalysis['nameCompatibilityAsPerBhagyank'])) {
        compatibility.add(_buildInfoRow('Compatibility (Bhagyank)', getValue(nameAnalysis['nameCompatibilityAsPerBhagyank'])));
      }
      if (hasValue(nameAnalysis['overallNameCompatibilityAsPerMoolankBhagyank'])) {
        compatibility.add(_buildDescriptionCard('Overall Compatibility', getValue(nameAnalysis['overallNameCompatibilityAsPerMoolankBhagyank']), AppColors.templeGold));
      }
      if (hasValue(nameAnalysis['firstNameCompatibilityAsPerMoolank'])) {
        compatibility.add(_buildInfoRow('First Name (Moolank)', getValue(nameAnalysis['firstNameCompatibilityAsPerMoolank'])));
      }
      if (hasValue(nameAnalysis['firstNameCompatibilityAsPerBhagyank'])) {
        compatibility.add(_buildInfoRow('First Name (Bhagyank)', getValue(nameAnalysis['firstNameCompatibilityAsPerBhagyank'])));
      }
      if (hasValue(nameAnalysis['overallFirstNameCompatibilityAsPerMoolankBhagyank'])) {
        compatibility.add(_buildDescriptionCard('First Name Overall', getValue(nameAnalysis['overallFirstNameCompatibilityAsPerMoolankBhagyank']), AppColors.templeGold));
      }
      
      if (compatibility.isNotEmpty) {
        sections.add(_buildSection(
          'Name Compatibility',
          Icons.verified,
          compatibility,
          AppColors.templeGold,
        ));
      }
    }

    if (sections.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: AutoTranslateText(
            'No key points data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections,
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children, Color accentColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor,
                  accentColor.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.white, size: 24.w),
                Spacing.w(12),
                Expanded(
                  child: AutoTranslateText(
                    title,
                    style: MyTextTheme.largeBCB.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildNumberCard(String title, String value, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AutoTranslateText(
                value,
                style: MyTextTheme.largeBCB.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Spacing.w(16),
          Expanded(
            child: AutoTranslateText(
              title,
              style: MyTextTheme.mediumBCN.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZodiacCard(String title, String value, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.star,
                    color: color,
                    size: 24.w,
                  ),
                ),
              ),
              Spacing.w(16),
              Expanded(
                child: AutoTranslateText(
                  title,
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: AutoTranslateText(
              value,
              style: MyTextTheme.largeBCB.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(String title, String value, String description, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.15),
                  color.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icon, color: color, size: 24.w),
                ),
                Spacing.w(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        title,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacing.h(4),
                      AutoTranslateText(
                        value,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (description.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.all(16.w),
              child: AutoTranslateText(
                description,
                style: MyTextTheme.mediumBCN.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLuckyCard(String title, String value, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.star, color: color, size: 20.w),
          ),
          Spacing.w(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  title,
                  style: MyTextTheme.smallBCB.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  value,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberInfoCard(String title, String value, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Spacing.w(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  title,
                  style: MyTextTheme.smallBCB.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  value,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String value, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            title,
            style: MyTextTheme.smallBCB.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Spacing.h(8),
          AutoTranslateText(
            value,
            style: MyTextTheme.mediumBCB.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(String title, String description, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(12),
          AutoTranslateText(
            description,
            style: MyTextTheme.mediumBCN.copyWith(
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.mediumBCB.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Spacing.w(12),
          Expanded(
            flex: 3,
            child: AutoTranslateText(
              value,
              style: MyTextTheme.mediumBCN.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildGeneric(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildAllFields(data),
    );
  }
  
  List<Widget> _buildAllFields(Map<String, dynamic> data, {String prefix = ''}) {
    final List<Widget> widgets = [];
    
    for (final entry in data.entries) {
      if (entry.value == null) continue;
      
      final key = prefix.isEmpty ? entry.key : '$prefix.${entry.key}';
      
      if (entry.value is Map) {
        widgets.add(
          _buildSectionTitle(_formatFieldName(entry.key)),
        );
        widgets.add(Spacing.h(12));
        widgets.addAll(_buildAllFields(
          entry.value as Map<String, dynamic>,
          prefix: key,
        ));
        widgets.add(Spacing.h(16));
      } else if (entry.value is List) {
        final list = entry.value as List;
        widgets.add(
          _buildSectionTitle(_formatFieldName(entry.key)),
        );
        widgets.add(Spacing.h(12));
        for (int i = 0; i < list.length; i++) {
          final item = list[i];
          if (item is Map) {
            widgets.addAll(_buildAllFields(
              item as Map<String, dynamic>,
              prefix: '$key[$i]',
            ));
          } else {
            widgets.add(_buildInfoCard('', item.toString()));
          }
          if (i < list.length - 1) widgets.add(Spacing.h(8));
        }
        widgets.add(Spacing.h(16));
      } else {
        widgets.add(
          _buildInfoCard(
            _formatFieldName(entry.key),
            entry.value.toString(),
          ),
        );
        widgets.add(Spacing.h(12));
      }
    }
    
    return widgets;
  }

  Widget _buildInfoCard(String label, String value) {
    if (value.isEmpty && label.isEmpty) return SizedBox.shrink();
    
    return Container(
      padding: EdgeInsets.all(18.w),
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            "#DFB343".toColor().withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: "#DFB343".toColor().withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: "#DFB343".toColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    size: 16.w,
                    color: "#DFB343".toColor(),
                  ),
                ),
                Spacing.w(10),
                Expanded(
                  child: AutoTranslateText(
                    label,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: "#DFB343".toColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          if (label.isNotEmpty && value.isNotEmpty) Spacing.h(12),
          if (value.isNotEmpty)
            AutoTranslateText(
              value,
              style: MyTextTheme.mediumBCN.copyWith(
                color: "#6F221E".toColor(),
                height: 1.6,
                letterSpacing: 0.2,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, String description) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
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
          AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#DFB343".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(8),
          AutoTranslateText(
            description,
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor(),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h, top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            "#DFB343".toColor().withOpacity(0.15),
            "#DFB343".toColor().withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: "#DFB343".toColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.category,
            color: "#DFB343".toColor(),
            size: 20.w,
          ),
          Spacing.w(10),
          AutoTranslateText(
            title,
            style: MyTextTheme.largeBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildListSection(dynamic data) {
    if (data is! List) return [];
    
    final List<Widget> widgets = [];
    
    for (final item in data) {
      if (item is Map) {
        for (final entry in item.entries) {
          final key = entry.key.toString();
          final value = entry.value;
          
          if (value is List) {
            widgets.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(key),
                  Spacing.h(12),
                  ...value.map((v) => _buildInfoCard('', v.toString())).toList(),
                ],
              ),
            );
          } else {
            widgets.add(_buildInfoCard(key, value?.toString() ?? ''));
          }
        }
      } else {
        widgets.add(_buildInfoCard('', item.toString()));
      }
    }
    
    return widgets;
  }
}

