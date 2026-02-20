import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DailyPanchangWidget extends StatelessWidget {
  final KundliResultController controller;

  const DailyPanchangWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingPanchang.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 28.w,
                height: 28.w,
                child: CircularProgressIndicator(
                  color: AppColors.orangeGradient.colors.first,
                  strokeWidth: 2,
                ),
              ),
              Spacing.h(10),
              AutoTranslateText(
                'Loading...',
                style: MyTextTheme.smallBCN.copyWith(
                  color: "#6F221E".toColor().withValues(alpha: 0.7),
                  fontSize: 12.sp,
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
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withValues(alpha: 0.7),
              fontSize: 12.sp,
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        child: _buildPanchangDataCard(data),
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
    final dateStr = controller.formData.value?['date']?.toString() ?? '';
    final formattedDate = _formatDateForDisplay(dateStr);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.deepOrange.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateLocationHeader(formattedDate),
                Spacing.h(10),
                _buildCelestialTimes(advancedDetails),
                Spacing.h(10),
                _buildDivider(),
                Spacing.h(10),
                _buildAstrologicalDetails(tithi, nakshatra, yoga, karana, data),
                Spacing.h(10),
                _buildDivider(),
                Spacing.h(10),
                _buildVaarDetails(data, masa, years, advancedDetails),
                Spacing.h(10),
                _buildDivider(),
                Spacing.h(10),
                _buildMuhurtaTimings(advancedDetails, data),
                Spacing.h(10),
                _buildDivider(),
                Spacing.h(10),
                _buildAdditionalDetails(data, advancedDetails, masa),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(gradient: AppColors.orangeGradient),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 16.w, color: Colors.white),
          Spacing.w(8),
          AutoTranslateText(
            'Daily Panchang',
            style: MyTextTheme.mediumBCB.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
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
          style: MyTextTheme.mediumBCB.copyWith(
            color: "#6F221E".toColor(),
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
        ),
        if (place != '-') ...[
          Spacing.h(4),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 14.w,
                color: AppColors.orangeGradient.colors.first,
              ),
              Spacing.w(4),
              Expanded(
                child: AutoTranslateText(
                  place,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: "#6F221E".toColor().withValues(alpha: 0.7),
                    fontSize: 11.sp,
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
    final oc = AppColors.orangeGradient.colors.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Celestial Times'),
        Spacing.h(8),
        Row(
          children: [
            Expanded(
              child: _buildTimeItem(
                Icons.wb_sunny,
                'Sunrise',
                advancedDetails?['sun_rise']?.toString() ?? '--',
                oc,
              ),
            ),
            Spacing.w(6),
            Expanded(
              child: _buildTimeItem(
                Icons.wb_twilight,
                'Sunset',
                advancedDetails?['sun_set']?.toString() ?? '--',
                oc,
              ),
            ),
          ],
        ),
        Spacing.h(6),
        Row(
          children: [
            Expanded(
              child: _buildTimeItem(
                Icons.nightlight_round,
                'Moonrise',
                advancedDetails?['moon_rise']?.toString() ?? '--',
                oc,
              ),
            ),
            Spacing.w(6),
            Expanded(
              child: _buildTimeItem(
                Icons.brightness_2,
                'Moonset',
                advancedDetails?['moon_set']?.toString() ?? '--',
                oc,
              ),
            ),
          ],
        ),
        if (advancedDetails?['solar_noon'] != null) ...[
          Spacing.h(6),
          _buildTimeItem(
            Icons.access_time,
            'Solar Noon',
            advancedDetails?['solar_noon']?.toString() ?? '--',
            oc,
          ),
        ],
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return AutoTranslateText(
      text,
      style: MyTextTheme.smallBCB.copyWith(
        color: "#6F221E".toColor(),
        fontWeight: FontWeight.w600,
        fontSize: 12.sp,
      ),
    );
  }

  Widget _buildTimeItem(
    IconData icon,
    String label,
    String value,
    Color accent,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16.w, color: accent),
          Spacing.w(6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  label,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: "#6F221E".toColor().withValues(alpha: 0.7),
                    fontSize: 10.sp,
                  ),
                ),
                Spacing.h(2),
                AutoTranslateText(
                  value,
                  style: MyTextTheme.smallBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
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
    final oc = AppColors.orangeGradient.colors.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Astrological Details'),
        Spacing.h(8),
        if (tithi != null) ...[
          _buildAstroItem(
            Icons.access_time,
            'Tithi',
            tithi['name']?.toString() ?? '--',
            '${_formatDateTime(tithi['start'])} â†’ ${_formatDateTime(tithi['end'])}',
            oc,
            details: {
              'Type': tithi['type']?.toString(),
              'Number': tithi['number']?.toString(),
              'Diety': tithi['diety']?.toString(),
              'Next Tithi': tithi['next_tithi']?.toString(),
              'Meaning': tithi['meaning']?.toString(),
              'Special': tithi['special']?.toString(),
            },
          ),
          Spacing.h(6),
        ],
        if (nakshatra != null) ...[
          _buildAstroItem(
            Icons.star,
            'Nakshatra',
            nakshatra['name']?.toString() ?? '--',
            '${_formatDateTime(nakshatra['start'])} â†’ ${_formatDateTime(nakshatra['end'])}',
            oc,
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
          Spacing.h(6),
        ],
        if (yoga != null) ...[
          _buildAstroItem(
            Icons.my_location,
            'Yoga',
            yoga['name']?.toString() ?? '--',
            '${_formatDateTime(yoga['start'])} â†’ ${_formatDateTime(yoga['end'])}',
            oc,
            details: {
              'Number': yoga['number']?.toString(),
              'Next Yoga': yoga['next_yoga']?.toString(),
              'Meaning': yoga['meaning']?.toString(),
              'Special': yoga['special']?.toString(),
            },
          ),
          Spacing.h(6),
        ],
        if (karana != null)
          _buildAstroItem(
            Icons.grid_view,
            'Karana',
            karana['name']?.toString() ?? '--',
            '${_formatDateTime(karana['start'])} â†’ ${_formatDateTime(karana['end'])}',
            oc,
            details: {
              'Type': karana['type']?.toString(),
              'Lord': karana['lord']?.toString(),
              'Diety': karana['diety']?.toString(),
              'Number': karana['number']?.toString(),
              'Next Karana': karana['next_karana']?.toString(),
              'Special': karana['special']?.toString(),
            },
          ),
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
    String timeRange,
    Color accent, {
    Map<String, String?>? details,
  }) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.w, color: accent),
              Spacing.w(6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      label,
                      style: MyTextTheme.smallBCB.copyWith(
                        color: "#6F221E".toColor().withValues(alpha: 0.7),
                        fontSize: 10.sp,
                      ),
                    ),
                    Spacing.h(2),
                    AutoTranslateText(
                      value,
                      style: MyTextTheme.smallBCB.copyWith(
                        color: "#6F221E".toColor(),
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                    ),
                    Spacing.h(2),
                    AutoTranslateText(
                      timeRange,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: "#6F221E".toColor().withValues(alpha: 0.6),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (details != null && details.isNotEmpty) ...[
            Spacing.h(6),
            ...details.entries
                .where((e) => e.value != null && e.value!.isNotEmpty)
                .map(
                  (entry) => Padding(
                    padding: EdgeInsets.only(top: 3.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoTranslateText(
                          entry.key,
                          style: MyTextTheme.smallBCN.copyWith(
                            color: "#6F221E".toColor().withValues(alpha: 0.6),
                            fontSize: 10.sp,
                          ),
                        ),
                        Expanded(
                          child: AutoTranslateText(
                            entry.value ?? '',
                            style: MyTextTheme.smallBCB.copyWith(
                              color: "#6F221E".toColor(),
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor().withValues(alpha: 0.7),
                fontSize: 10.sp,
              ),
            ),
          ),
          Spacing.w(8),
          Flexible(
            flex: 3,
            child: AutoTranslateText(
              value,
              style: MyTextTheme.smallBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
              ),
              textAlign: TextAlign.right,
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
    final oc = AppColors.orangeGradient.colors.first;
    final rows = <Widget>[
      _buildVaarRow(
        'Day of Week',
        data['day']?['name']?.toString() ?? data['day']?.toString() ?? '--',
      ),
    ];
    if (masa?['paksha'] != null) {
      rows.add(Spacing.h(6));
      rows.add(
        Row(
          children: [
            Expanded(
              child: _buildVaarRow(
                'Paksha',
                masa!['paksha']?.toString() ?? '--',
              ),
            ),
            Spacing.w(6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: AutoTranslateText(
                masa['paksha']?.toString() ?? '',
                style: MyTextTheme.smallBCB.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),
      );
    }
    void add(String k, String v) {
      rows.add(Spacing.h(6));
      rows.add(_buildVaarRow(k, v));
    }

    if (masa?['amanta_name'] != null)
      add('Lunar Month', masa!['amanta_name']?.toString() ?? '--');
    if (masa?['name'] != null) add('Masa', masa!['name']?.toString() ?? '--');
    if (years?['vikram_samvaat_name'] != null)
      add('Lunar Year', years!['vikram_samvaat_name']?.toString() ?? '--');
    if (years?['vikram_samvaat'] != null)
      add('Vikram Samvat', years!['vikram_samvaat']?.toString() ?? '--');
    if (years?['saka'] != null)
      add('Shaka Samvat', years!['saka']?.toString() ?? '--');
    if (years?['kali'] != null)
      add('Kali Yuga', years!['kali']?.toString() ?? '--');
    if (masa?['ritu'] != null) add('Ritu', masa!['ritu']?.toString() ?? '--');
    if (masa?['ayana'] != null)
      add('Ayana', masa!['ayana']?.toString() ?? '--');
    if (data['ayanamsa']?['name'] != null)
      add('Ayanamsa', data['ayanamsa']!['name']?.toString() ?? '--');
    if (data['rasi']?['name'] != null)
      add('Moon Sign', data['rasi']!['name']?.toString() ?? '--');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Vaar Details'),
        Spacing.h(8),
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: oc.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: oc.withValues(alpha: 0.2)),
          ),
          child: Column(children: rows),
        ),
      ],
    );
  }

  Widget _buildVaarRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor().withValues(alpha: 0.7),
                fontSize: 10.sp,
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
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
              ),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMuhurtaTimings(
    Map<String, dynamic>? advancedDetails,
    Map<String, dynamic> data,
  ) {
    final oc = AppColors.orangeGradient.colors.first;
    final hasInauspicious =
        (data['rahukaal'] != null && data['rahukaal'].toString().isNotEmpty) ||
        (data['gulika'] != null && data['gulika'].toString().isNotEmpty) ||
        (data['yamakanta'] != null &&
            data['yamakanta'].toString().isNotEmpty) ||
        (data['bhadrakaal'] != null &&
            data['bhadrakaal'].toString().isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Muhurta Timings'),
        Spacing.h(8),
        if (advancedDetails?['abhijitMuhurta'] != null) ...[
          _muhurtaChip(
            Icons.check_circle,
            'Abhijit Muhurta',
            '${advancedDetails?['abhijitMuhurta']?['start']} - ${advancedDetails?['abhijitMuhurta']?['end']}',
            Colors.green,
          ),
          Spacing.h(6),
        ],
        if (hasInauspicious) ...[
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.red.withValues(alpha: 0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning, size: 16.w, color: Colors.red),
                    Spacing.w(6),
                    AutoTranslateText(
                      'Inauspicious Timings',
                      style: MyTextTheme.smallBCB.copyWith(
                        color: "#6F221E".toColor(),
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
                Spacing.h(6),
                if (data['rahukaal'] != null &&
                    data['rahukaal'].toString().isNotEmpty)
                  _buildTimingRow(
                    'Rahu Kaal',
                    data['rahukaal']?.toString() ?? '',
                  ),
                if (data['gulika'] != null &&
                    data['gulika'].toString().isNotEmpty) ...[
                  Spacing.h(4),
                  _buildTimingRow(
                    'Gulika Kaal',
                    data['gulika']?.toString() ?? '',
                  ),
                ],
                if (data['yamakanta'] != null &&
                    data['yamakanta'].toString().isNotEmpty) ...[
                  Spacing.h(4),
                  _buildTimingRow(
                    'Yamakanta',
                    data['yamakanta']?.toString() ?? '',
                  ),
                ],
                if (data['bhadrakaal'] != null &&
                    data['bhadrakaal'].toString().isNotEmpty) ...[
                  Spacing.h(4),
                  _buildTimingRow(
                    'Bhadrakaal',
                    data['bhadrakaal']?.toString() ?? '',
                  ),
                ],
              ],
            ),
          ),
          Spacing.h(6),
        ],
        if (advancedDetails?['disha_shool'] != null)
          _muhurtaChip(
            Icons.compass_calibration,
            'Disha Shoola',
            advancedDetails!['disha_shool']?.toString() ?? '--',
            oc,
          ),
      ],
    );
  }

  Widget _muhurtaChip(
    IconData icon,
    String title,
    String subtitle,
    Color accent,
  ) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16.w, color: accent),
          Spacing.w(6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  title,
                  style: MyTextTheme.smallBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
                ),
                Spacing.h(2),
                AutoTranslateText(
                  subtitle,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: "#6F221E".toColor().withValues(alpha: 0.7),
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimingRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor().withValues(alpha: 0.7),
                fontSize: 10.sp,
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
                fontSize: 10.sp,
              ),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
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

    final oc = AppColors.orangeGradient.colors.first;
    final rows = <Widget>[];
    void add(String k, String v) {
      if (rows.isNotEmpty) rows.add(Spacing.h(6));
      rows.add(_buildVaarRow(k, v));
    }

    if (masa?['moon_phase'] != null)
      add('Moon Phase', masa!['moon_phase']?.toString() ?? '--');
    if (advancedDetails?['moon_yogini_nivas'] != null)
      add(
        'Moon Yogini Nivas',
        advancedDetails!['moon_yogini_nivas']?.toString() ?? '--',
      );
    if (advancedDetails?['ahargana'] != null)
      add('Ahargana', advancedDetails!['ahargana']?.toString() ?? '--');
    if (advancedDetails?['next_full_moon'] != null)
      add(
        'Next Full Moon',
        advancedDetails!['next_full_moon']?.toString() ?? '--',
      );
    if (advancedDetails?['next_new_moon'] != null)
      add(
        'Next New Moon',
        advancedDetails!['next_new_moon']?.toString() ?? '--',
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Additional Details'),
        Spacing.h(8),
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: oc.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: oc.withValues(alpha: 0.2)),
          ),
          child: Column(children: rows),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: "#6F221E".toColor().withValues(alpha: 0.1),
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

