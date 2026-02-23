import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BinnashtakvargaWidget extends StatelessWidget {
  final KundliResultController controller;

  const BinnashtakvargaWidget({super.key, required this.controller});

  static const List<String> planets = [
    'Sun',
    'Moon',
    'Mars',
    'Mercury',
    'Jupiter',
    'Venus',
    'Saturn',
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: "#ed6f30".toColor().withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              _buildNoteBar(),
              Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPlanetGrid(),
                    if (controller.isLoadingBinnashtakvarga.value &&
                        controller.selectedPlanetForBinnashtakvarga.value !=
                            null) ...[
                      Spacing.h(12),
                      _buildLoading(),
                    ] else if (controller.binnashtakvargaData.value !=
                        null) ...[
                      Spacing.h(12),
                      _buildDataTable(controller.binnashtakvargaData.value!),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(gradient: AppColors.orangeGradient),
      child: Row(
        children: [
          Icon(Icons.grid_on_rounded, size: 18.w, color: Colors.white),
          Spacing.w(8),
          AutoTranslateText(
            'Binnashtakvarga',
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

  Widget _buildNoteBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: "#ed6f30".toColor().withValues(alpha: 0.06),
        border: Border(
          bottom: BorderSide(
            color: "#ed6f30".toColor().withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16.w,
            color: "#ed6f30".toColor(),
          ),
          Spacing.w(8),
          Expanded(
            child: AutoTranslateText(
              'Choose a planet to fetch its Binnashtakvarga',
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor(),
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanetGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Select Planet',
          style: MyTextTheme.smallBCB.copyWith(
            color: "#6F221E".toColor(),
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
        Spacing.h(8),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 500 ? 4 : 3;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1.4,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
              ),
              itemCount: planets.length,
              itemBuilder: (context, index) {
                final planet = planets[index];
                final isSelected =
                    controller.selectedPlanetForBinnashtakvarga.value == planet;
                final isLoading =
                    controller.isLoadingBinnashtakvarga.value && isSelected;

                return GestureDetector(
                  onTap: isLoading
                      ? null
                      : () => controller.fetchBinnashtakvargaData(planet),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                "#FF8A3D".toColor(),
                                "#ed6f30".toColor(),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isSelected
                            ? "#ed6f30".toColor()
                            : "#ed6f30".toColor().withValues(alpha: 0.35),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isLoading)
                          SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: isSelected
                                  ? Colors.white
                                  : "#ed6f30".toColor(),
                            ),
                          )
                        else
                          Icon(
                            Icons.star_rounded,
                            color: isSelected
                                ? Colors.white
                                : "#ed6f30".toColor(),
                            size: 22.w,
                          ),
                        Spacing.h(4),
                        AutoTranslateText(
                          planet,
                          textAlign: TextAlign.center,
                          style: MyTextTheme.smallBCB.copyWith(
                            color: isSelected
                                ? Colors.white
                                : "#6F221E".toColor(),
                            fontWeight: FontWeight.w600,
                            fontSize: 10.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 28.w,
            height: 28.w,
            child: CircularProgressIndicator(
              color: "#ed6f30".toColor(),
              strokeWidth: 2,
            ),
          ),
          Spacing.h(8),
          AutoTranslateText(
            'Loading ${controller.selectedPlanetForBinnashtakvarga.value}...',
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withValues(alpha: 0.7),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(Map<String, dynamic> data) {
    final planetKeys = [
      'sun',
      'moon',
      'mars',
      'mercury',
      'jupiter',
      'venus',
      'saturn',
    ];
    final ascendant = data['ascendant'] as List<dynamic>?;
    final total = data['Total'] as List<dynamic>?;

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: "#ed6f30".toColor().withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: "#ed6f30".toColor().withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.selectedPlanetForBinnashtakvarga.value != null) ...[
            AutoTranslateText(
              'Binnashtakvarga for ${controller.selectedPlanetForBinnashtakvarga.value}',
              style: MyTextTheme.smallBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
            Spacing.h(8),
          ],
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: _buildTable(planetKeys, data, ascendant, total),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(
    List<String> planetKeys,
    Map<String, dynamic> data,
    List<dynamic>? ascendant,
    List<dynamic>? total,
  ) {
    return Table(
      border: TableBorder.all(
        color: "#6F221E".toColor().withValues(alpha: 0.15),
        width: 1,
      ),
      columnWidths: {
        0: FixedColumnWidth(52.w),
        for (int i = 1; i <= planetKeys.length; i++) i: FixedColumnWidth(42.w),
        planetKeys.length + 1: FixedColumnWidth(42.w),
        planetKeys.length + 2: FixedColumnWidth(48.w),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: "#ed6f30".toColor().withValues(alpha: 0.12),
          ),
          children: [
            _cell('H', header: true),
            ...planetKeys.map(
              (p) => _cell(p.length >= 2 ? p.substring(0, 2) : p, header: true),
            ),
            _cell('Asc', header: true),
            _cell('Tot', header: true),
          ],
        ),
        ...List.generate(12, (i) {
          return TableRow(
            decoration: BoxDecoration(
              color: i % 2 == 0
                  ? Colors.white
                  : "#ed6f30".toColor().withValues(alpha: 0.04),
            ),
            children: [
              _cell('H${i + 1}'),
              ...planetKeys.map((k) => _cell(_point(k, i, data))),
              _cell(_point('ascendant', i, data, ascendant: ascendant)),
              _cell(
                i < (total?.length ?? 0)
                    ? (total![i]?.toString() ?? '--')
                    : '--',
                bold: true,
              ),
            ],
          );
        }),
      ],
    );
  }

  String _point(
    String key,
    int i,
    Map<String, dynamic> data, {
    List<dynamic>? ascendant,
  }) {
    if (key == 'ascendant') {
      if (ascendant != null && i < ascendant.length) {
        return ascendant[i]?.toString() ?? '--';
      }
      return '--';
    }
    final arr = data[key] as List<dynamic>?;
    if (arr != null && i < arr.length) return arr[i]?.toString() ?? '--';
    return '--';
  }

  Widget _cell(String text, {bool header = false, bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
      child: AutoTranslateText(
        text,
        textAlign: TextAlign.center,
        style: MyTextTheme.smallBCN.copyWith(
          color: "#6F221E".toColor(),
          fontWeight: header || bold ? FontWeight.w600 : FontWeight.normal,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
