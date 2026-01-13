import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DailyPanchangWidget extends StatelessWidget {
  final KundliResultController controller;

  const DailyPanchangWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading if fetching data
      if (controller.isLoadingPanchang.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: "#ed6f30".toColor(),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Loading panchang data...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }

      final data = controller.panchangData.value;
      if (data == null) {
        return Center(
          child: AutoTranslateText(
            'No panchang data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            AutoTranslateText(
              'Daily Panchang',
              style: MyTextTheme.largeBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            
            Spacing.h(16),
            
            // Panchang Data Card
            _buildPanchangDataCard(data),
          ],
        ),
      );
    });
  }

  Widget _buildPanchangDataCard(Map<String, dynamic> data) {
    final advancedDetails = data['advanced_details'] as Map<String, dynamic>?;
    final masa = advancedDetails?['masa'] as Map<String, dynamic>?;
    final years = advancedDetails?['years'] as Map<String, dynamic>?;
    final tithi = data['tithi'] as Map<String, dynamic>?;
    final nakshatra = data['nakshatra'] as Map<String, dynamic>?;
    final karana = data['karana'] as Map<String, dynamic>?;
    final yoga = data['yoga'] as Map<String, dynamic>?;

    // Format date
    final dateStr = controller.formData.value?['date']?.toString() ?? '';
    final formattedDate = _formatDateForDisplay(dateStr);

    return Container(
      padding: EdgeInsets.all(16.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and Location Header
          _buildDateLocationHeader(formattedDate),
          Spacing.h(20),
          
          // Celestial Times Section
          _buildCelestialTimes(advancedDetails),
          Spacing.h(20),
          _buildDivider(),
          Spacing.h(20),
          
          // Tithi, Nakshatra, Yoga, Karana Section
          _buildAstrologicalDetails(tithi, nakshatra, yoga, karana, data),
          Spacing.h(20),
          _buildDivider(),
          Spacing.h(20),
          
          // Vaar Details Section
          _buildVaarDetails(data, masa, years, advancedDetails),
          Spacing.h(20),
          _buildDivider(),
          Spacing.h(20),
          
          // Muhurta Timings Section
          _buildMuhurtaTimings(advancedDetails, data),
          Spacing.h(20),
          _buildDivider(),
          Spacing.h(20),
          
          // Additional Details Section
          _buildAdditionalDetails(data, advancedDetails, masa),
        ],
      ),
    );
  }

  Widget _buildDateLocationHeader(String formattedDate) {
    final place = controller.getPlace();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          formattedDate,
          style: MyTextTheme.largeBCB.copyWith(
            color: "#6F221E".toColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        if (place != '-') ...[
          Spacing.h(4),
          Row(
            children: [
              Icon(Icons.location_on, size: 16.w, color: "#DFB343".toColor()),
              Spacing.w(4),
              Expanded(
                child: AutoTranslateText(
                  place,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: "#6F221E".toColor().withOpacity(0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCelestialTimes(Map<String, dynamic>? advancedDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Celestial Times',
          style: MyTextTheme.mediumBCB.copyWith(
            color: "#6F221E".toColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.h(12),
        Row(
          children: [
            Expanded(
              child: _buildTimeItem(
                Icons.wb_sunny,
                'Sunrise',
                advancedDetails?['sun_rise']?.toString() ?? '--',
              ),
            ),
            Spacing.w(12),
            Expanded(
              child: _buildTimeItem(
                Icons.wb_twilight,
                'Sunset',
                advancedDetails?['sun_set']?.toString() ?? '--',
              ),
            ),
          ],
        ),
        Spacing.h(12),
        Row(
          children: [
            Expanded(
              child: _buildTimeItem(
                Icons.nightlight_round,
                'Moonrise',
                advancedDetails?['moon_rise']?.toString() ?? '--',
              ),
            ),
            Spacing.w(12),
            Expanded(
              child: _buildTimeItem(
                Icons.brightness_2,
                'Moonset',
                advancedDetails?['moon_set']?.toString() ?? '--',
              ),
            ),
          ],
        ),
        if (advancedDetails?['solar_noon'] != null) ...[
          Spacing.h(12),
          _buildTimeItem(
            Icons.access_time,
            'Solar Noon',
            advancedDetails?['solar_noon']?.toString() ?? '--',
          ),
        ],
      ],
    );
  }

  Widget _buildTimeItem(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: "#DFB343".toColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20.w, color: "#DFB343".toColor()),
          Spacing.w(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  label,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: "#6F221E".toColor().withOpacity(0.7),
                  ),
                ),
                Spacing.h(2),
                AutoTranslateText(
                  value,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAstrologicalDetails(
    Map<String, dynamic>? tithi,
    Map<String, dynamic>? nakshatra,
    Map<String, dynamic>? yoga,
    Map<String, dynamic>? karana,
    Map<String, dynamic> data,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Astrological Details',
          style: MyTextTheme.mediumBCB.copyWith(
            color: "#6F221E".toColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.h(12),
        // Tithi
        if (tithi != null) ...[
          _buildAstroItem(
            Icons.access_time,
            'Tithi',
            tithi['name']?.toString() ?? '--',
            '${_formatDateTime(tithi['start'])} → ${_formatDateTime(tithi['end'])}',
            details: {
              'Type': tithi['type']?.toString(),
              'Number': tithi['number']?.toString(),
              'Diety': tithi['diety']?.toString(),
              'Next Tithi': tithi['next_tithi']?.toString(),
              'Meaning': tithi['meaning']?.toString(),
              'Special': tithi['special']?.toString(),
            },
          ),
          Spacing.h(12),
        ],
        // Nakshatra
        if (nakshatra != null) ...[
          _buildAstroItem(
            Icons.star,
            'Nakshatra',
            nakshatra['name']?.toString() ?? '--',
            '${_formatDateTime(nakshatra['start'])} → ${_formatDateTime(nakshatra['end'])}',
            details: {
              'Lord': nakshatra['lord']?.toString(),
              'Diety': nakshatra['diety']?.toString(),
              'Number': nakshatra['number']?.toString(),
              'Pada': nakshatra['pada']?.toString(),
              'Next Nakshatra': nakshatra['next_nakshatra']?.toString(),
              'Meaning': nakshatra['meaning']?.toString(),
              'Special': nakshatra['special']?.toString(),
              'Summary': nakshatra['summary']?.toString(),
              'Words': nakshatra['words']?.toString(),
            },
          ),
          Spacing.h(12),
        ],
        // Yoga
        if (yoga != null) ...[
          _buildAstroItem(
            Icons.my_location,
            'Yoga',
            yoga['name']?.toString() ?? '--',
            '${_formatDateTime(yoga['start'])} → ${_formatDateTime(yoga['end'])}',
            details: {
              'Number': yoga['number']?.toString(),
              'Next Yoga': yoga['next_yoga']?.toString(),
              'Meaning': yoga['meaning']?.toString(),
              'Special': yoga['special']?.toString(),
            },
          ),
          Spacing.h(12),
        ],
        // Karana
        if (karana != null) ...[
          _buildAstroItem(
            Icons.grid_view,
            'Karana',
            karana['name']?.toString() ?? '--',
            '${_formatDateTime(karana['start'])} → ${_formatDateTime(karana['end'])}',
            details: {
              'Type': karana['type']?.toString(),
              'Lord': karana['lord']?.toString(),
              'Diety': karana['diety']?.toString(),
              'Number': karana['number']?.toString(),
              'Next Karana': karana['next_karana']?.toString(),
              'Special': karana['special']?.toString(),
            },
          ),
        ],
        if (data['day'] != null)
          _buildDetailRow('Day', data['day']?.toString() ?? '--'),
        if (data['day_lord'] != null)
          _buildDetailRow('Day Lord', data['day_lord']?.toString() ?? '--'),
      ],
    );
  }
  
  Widget _buildAstroItem(
    IconData icon,
    String label,
    String value,
    String timeRange, {
    Map<String, String?>? details,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: "#DFB343".toColor().withOpacity(0.05),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: "#DFB343".toColor().withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.w, color: "#DFB343".toColor()),
              Spacing.w(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      label,
                      style: MyTextTheme.smallBCB.copyWith(
                        color: "#6F221E".toColor().withOpacity(0.7),
                      ),
                    ),
                    Spacing.h(2),
                    AutoTranslateText(
                      value,
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: "#6F221E".toColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacing.h(4),
                    AutoTranslateText(
                      timeRange,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: "#6F221E".toColor().withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (details != null && details.isNotEmpty) ...[
            Spacing.h(8),
            ...details.entries.where((e) => e.value != null && e.value!.isNotEmpty).map((entry) {
              return Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoTranslateText(
                      entry.key,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: "#6F221E".toColor().withOpacity(0.6),
                      ),
                    ),
                    Expanded(
                      child: AutoTranslateText(
                        entry.value ?? '',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: "#6F221E".toColor(),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
  
  String _formatDateTime(dynamic dateTime) {
    if (dateTime == null) return '--';
    try {
      if (dateTime is String) {
        return dateTime;
      }
      return dateTime.toString();
    } catch (e) {
      return '--';
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoTranslateText(
            label,
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
            ),
          ),
          AutoTranslateText(
            value,
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaarDetails(
    Map<String, dynamic> data,
    Map<String, dynamic>? masa,
    Map<String, dynamic>? years,
    Map<String, dynamic>? advancedDetails,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today, size: 20.w, color: "#DFB343".toColor()),
            Spacing.w(8),
            AutoTranslateText(
              'Vaar Details',
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Spacing.h(16),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: "#DFB343".toColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              _buildVaarRow('Day of Week', data['day']?['name']?.toString() ?? data['day']?.toString() ?? '--'),
              if (masa?['paksha'] != null) ...[
                Spacing.h(12),
                Row(
                  children: [
                    Expanded(
                      child: _buildVaarRow('Paksha', masa?['paksha']?.toString() ?? '--'),
                    ),
                    Spacing.w(8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: "#DFB343".toColor(),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: AutoTranslateText(
                        masa?['paksha']?.toString() ?? '',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (masa?['amanta_name'] != null) ...[
                Spacing.h(12),
                _buildVaarRow('Lunar Month', masa?['amanta_name']?.toString() ?? '--'),
              ],
              if (masa?['name'] != null) ...[
                Spacing.h(12),
                _buildVaarRow('Masa', masa?['name']?.toString() ?? '--'),
              ],
              if (years?['vikram_samvaat_name'] != null) ...[
                Spacing.h(12),
                _buildVaarRow('Lunar Year', years?['vikram_samvaat_name']?.toString() ?? '--'),
              ],
              if (years?['vikram_samvaat'] != null) ...[
                Spacing.h(12),
                _buildVaarRow('Vikram Samvat', years?['vikram_samvaat']?.toString() ?? '--'),
              ],
              if (years?['saka'] != null) ...[
                Spacing.h(12),
                _buildVaarRow('Shaka Samvat', years?['saka']?.toString() ?? '--'),
              ],
              if (years?['kali'] != null) ...[
                Spacing.h(12),
                _buildVaarRow('Kali Yuga', years?['kali']?.toString() ?? '--'),
              ],
              if (masa?['ritu'] != null) ...[
                Spacing.h(12),
                _buildVaarRow('Ritu', masa?['ritu']?.toString() ?? '--'),
              ],
              if (masa?['ayana'] != null) ...[
                Spacing.h(12),
                _buildVaarRow('Ayana', masa?['ayana']?.toString() ?? '--'),
              ],
              if (data['ayanamsa']?['name'] != null) ...[
                Spacing.h(12),
                _buildVaarRow('Ayanamsa', data['ayanamsa']?['name']?.toString() ?? '--'),
              ],
              if (data['rasi']?['name'] != null) ...[
                Spacing.h(12),
                _buildVaarRow('Moon Sign', data['rasi']?['name']?.toString() ?? '--'),
              ],
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildVaarRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: AutoTranslateText(
            label,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Spacing.w(8),
        Flexible(
          flex: 3,
          child: AutoTranslateText(
            value,
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
  
  Widget _buildMuhurtaTimings(
    Map<String, dynamic>? advancedDetails,
    Map<String, dynamic> data,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Muhurta Timings',
          style: MyTextTheme.mediumBCB.copyWith(
            color: "#6F221E".toColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.h(12),
        // Auspicious Timings
        if (advancedDetails?['abhijitMuhurta'] != null) ...[
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, size: 18.w, color: Colors.green),
                Spacing.w(8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        'Abhijit Muhurta',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: "#6F221E".toColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacing.h(2),
                      AutoTranslateText(
                        '${advancedDetails?['abhijitMuhurta']?['start']} - ${advancedDetails?['abhijitMuhurta']?['end']}',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: "#6F221E".toColor().withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(12),
        ],
        // Inauspicious Timings
        if (data['rahukaal'] != null && data['rahukaal'].toString().isNotEmpty ||
            data['gulika'] != null && data['gulika'].toString().isNotEmpty ||
            data['yamakanta'] != null && data['yamakanta'].toString().isNotEmpty ||
            data['bhadrakaal'] != null && data['bhadrakaal'].toString().isNotEmpty) ...[
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning, size: 18.w, color: Colors.red),
                    Spacing.w(8),
                    AutoTranslateText(
                      'Inauspicious Timings',
                      style: MyTextTheme.smallBCB.copyWith(
                        color: "#6F221E".toColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Spacing.h(8),
                if (data['rahukaal'] != null && data['rahukaal'].toString().isNotEmpty)
                  _buildTimingRow('Rahu Kaal', data['rahukaal']?.toString() ?? ''),
                if (data['gulika'] != null && data['gulika'].toString().isNotEmpty) ...[
                  Spacing.h(6),
                  _buildTimingRow('Gulika Kaal', data['gulika']?.toString() ?? ''),
                ],
                if (data['yamakanta'] != null && data['yamakanta'].toString().isNotEmpty) ...[
                  Spacing.h(6),
                  _buildTimingRow('Yamakanta', data['yamakanta']?.toString() ?? ''),
                ],
                if (data['bhadrakaal'] != null && data['bhadrakaal'].toString().isNotEmpty) ...[
                  Spacing.h(6),
                  _buildTimingRow('Bhadrakaal', data['bhadrakaal']?.toString() ?? ''),
                ],
              ],
            ),
          ),
        ],
        if (advancedDetails?['disha_shool'] != null) ...[
          Spacing.h(12),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.compass_calibration, size: 18.w, color: Colors.orange),
                Spacing.w(8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        'Disha Shoola',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: "#6F221E".toColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacing.h(2),
                      AutoTranslateText(
                        advancedDetails?['disha_shool']?.toString() ?? '--',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: "#6F221E".toColor().withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
  
  Widget _buildTimingRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: AutoTranslateText(
            label,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Spacing.w(8),
        Flexible(
          flex: 3,
          child: AutoTranslateText(
            value,
            style: MyTextTheme.smallBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
  
  Widget _buildAdditionalDetails(
    Map<String, dynamic> data,
    Map<String, dynamic>? advancedDetails,
    Map<String, dynamic>? masa,
  ) {
    final hasAdditionalData = 
        advancedDetails?['moon_yogini_nivas'] != null ||
        advancedDetails?['ahargana'] != null ||
        masa?['moon_phase'] != null ||
        advancedDetails?['next_full_moon'] != null ||
        advancedDetails?['next_new_moon'] != null;

    if (!hasAdditionalData) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Additional Details',
          style: MyTextTheme.mediumBCB.copyWith(
            color: "#6F221E".toColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.h(12),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: "#DFB343".toColor().withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              if (masa?['moon_phase'] != null)
                _buildVaarRow('Moon Phase', masa?['moon_phase']?.toString() ?? '--'),
              if (advancedDetails?['moon_yogini_nivas'] != null) ...[
                Spacing.h(12),
                _buildVaarRow('Moon Yogini Nivas', advancedDetails?['moon_yogini_nivas']?.toString() ?? '--'),
              ],
              if (advancedDetails?['ahargana'] != null) ...[
                Spacing.h(12),
                _buildVaarRow('Ahargana', advancedDetails?['ahargana']?.toString() ?? '--'),
              ],
              if (advancedDetails?['next_full_moon'] != null) ...[
                Spacing.h(12),
                _buildVaarRow('Next Full Moon', advancedDetails?['next_full_moon']?.toString() ?? '--'),
              ],
              if (advancedDetails?['next_new_moon'] != null) ...[
                Spacing.h(12),
                _buildVaarRow('Next New Moon', advancedDetails?['next_new_moon']?.toString() ?? '--'),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: "#6F221E".toColor().withOpacity(0.1),
    );
  }

  String _formatDateForDisplay(String dateStr) {
    if (dateStr.isEmpty) return '--';
    try {
      // Parse date in dd/MM/yyyy format
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final date = DateTime(year, month, day);
        return DateFormat('EEEE, MMMM dd, yyyy').format(date);
      }
    } catch (e) {
      debugPrint('Error formatting date: $e');
    }
    return dateStr;
  }
}

