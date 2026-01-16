import 'dart:math' as math;
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KundliChartWidget extends StatelessWidget {
  final Map<String, dynamic> boyPlanetaryDetails;
  final Map<String, dynamic> girlPlanetaryDetails;
  final Map<String, dynamic>? boyAstroDetails;
  final Map<String, dynamic>? girlAstroDetails;

  const KundliChartWidget({
    super.key,
    required this.boyPlanetaryDetails,
    required this.girlPlanetaryDetails,
    this.boyAstroDetails,
    this.girlAstroDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Kundli Charts',
          style: MyTextTheme.largeBCB.copyWith(
            color: '#68171E'.toColor(),
            fontWeight: FontWeight.bold,
          ).merge(AppTypography.h2),
        ),
        Spacing.h(16),
        
        // Boy Kundli
        _buildKundliChart(
          planetaryDetails: boyPlanetaryDetails,
          astroDetails: boyAstroDetails,
          personName: boyAstroDetails?['name'] as String? ?? 'Person 1',
          isBoy: true,
        ),
        
        Spacing.h(20),
        
        // Girl Kundli
        _buildKundliChart(
          planetaryDetails: girlPlanetaryDetails,
          astroDetails: girlAstroDetails,
          personName: girlAstroDetails?['name'] as String? ?? 'Person 2',
          isBoy: false,
        ),
      ],
    );
  }

  Widget _buildKundliChart({
    required Map<String, dynamic> planetaryDetails,
    Map<String, dynamic>? astroDetails,
    required String personName,
    required bool isBoy,
  }) {
    // Extract planets and organize by house
    final houses = <int, List<_PlanetData>>{};
    
    for (int i = 0; i <= 9; i++) {
      final planetKey = i.toString();
      final planetData = planetaryDetails[planetKey] as Map<String, dynamic>?;
      if (planetData != null) {
        final house = planetData['house'] as int?;
        if (house != null && house >= 1 && house <= 12) {
          final localDegree = (planetData['local_degree'] as num? ?? 0).toDouble();
          final name = planetData['name'] as String? ?? '';
          final fullName = planetData['full_name'] as String? ?? '';
          final retro = planetData['retro'] as bool? ?? false;
          final isCombust = planetData['is_combust'] as bool? ?? false;
          final isAscendant = i == 0;
          
          houses.putIfAbsent(house, () => []).add(_PlanetData(
            name: name,
            fullName: fullName,
            localDegree: localDegree,
            retro: retro,
            isCombust: isCombust,
            isAscendant: isAscendant,
          ));
        }
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Use available width but ensure minimum size and maintain aspect ratio
            final maxWidth = constraints.maxWidth > 0 ? constraints.maxWidth : 350.w;
            final chartSize = math.min(maxWidth - 32.w, 400.w); // Leave padding
            
            return SizedBox(
              width: chartSize,
              height: chartSize,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Base Kundli Image (Kundli-Image.png)
                  Center(
                    child: Image.asset(
                      'assets/app/Kundli-Image.png',
                      width: chartSize,
                      height: chartSize,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: chartSize,
                          height: chartSize,
                          color: Colors.grey.withOpacity(0.1),
                          child: Center(
                            child: AutoTranslateText(
                              'Kundli Image',
                              style: MyTextTheme.smallBCN.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Profile image overlay (top-left for girl, top-right for boy)
                  Positioned(
                    left: isBoy ? null : 8.w,
                    right: isBoy ? 8.w : null,
                    top: 8.h,
                    child: ClipOval(
                      child: Image.asset(
                        isBoy ? 'assets/app/kundliBoy.png' : 'assets/app/kundliGirl.png',
                        width: 50.w,
                        height: 50.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50.w,
                            height: 50.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.deepOrange.withOpacity(0.2),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 25.w,
                            color: '#68171E'.toColor(),
                          ),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  // Place planets on houses based on API house numbers
                  ..._buildPlanetPlacements(houses, chartSize),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildPlanetPlacements(Map<int, List<_PlanetData>> houses, double size) {
    final widgets = <Widget>[];
    
    // House positions in kundli chart (anti-clockwise from top)
    // Each house has a center position and angle
    // Using percentage-based positioning to ensure planets stay within house boundaries
    final housePositions = _getHousePositions(size);
    
    houses.forEach((house, planets) {
      final position = housePositions[house];
      if (position == null) return;
      
      final houseCenterX = position['x']!;
      final houseCenterY = position['y']!;
      
      // Place planets within the house
      // If multiple planets, arrange them in a grid or stack
      final planetCount = planets.length;
      final spacing = 35.w; // Space between planets
      
      for (int i = 0; i < planets.length; i++) {
        final planet = planets[i];
        
        // Calculate offset for multiple planets in same house
        double offsetX = 0;
        double offsetY = 0;
        
        if (planetCount == 1) {
          // Single planet - center it
          offsetX = 0;
          offsetY = 0;
        } else if (planetCount == 2) {
          // Two planets - place side by side
          offsetX = (i == 0 ? -spacing / 2 : spacing / 2);
          offsetY = 0;
        } else {
          // Multiple planets - arrange in a grid
          final sqrtValue = math.sqrt(planetCount);
          final cols = sqrtValue.ceil().toInt();
          final row = i ~/ cols;
          final col = i % cols;
          offsetX = (col - (cols - 1) / 2) * spacing * 0.7;
          offsetY = (row - (planetCount / cols - 1) / 2) * spacing * 0.6;
        }
        
        widgets.add(
          Positioned(
            left: houseCenterX - 20.w + offsetX,
            top: houseCenterY - 15.h + offsetY,
            child: _buildPlanetWidget(planet),
          ),
        );
      }
    });
    
    return widgets;
  }

  Map<int, Map<String, double>> _getHousePositions(double size) {
    final center = size / 2;
    // Outer houses (1-8) are on the perimeter
    // Inner houses (9-12) are in the center area
    final outerRadius = size * 0.32; // Distance from center to outer houses
    final innerRadius = size * 0.15; // Distance from center to inner houses
    
    // House positions (anti-clockwise, starting from top - House 1)
    // Using precise angles for 12 houses: 360/12 = 30 degrees per house
    return {
      // Outer houses (1-8) - arranged in a circle
      1: {
        'x': center + outerRadius * math.cos(270 * math.pi / 180), // Top
        'y': center + outerRadius * math.sin(270 * math.pi / 180),
      },
      2: {
        'x': center + outerRadius * math.cos(300 * math.pi / 180), // Top-right
        'y': center + outerRadius * math.sin(300 * math.pi / 180),
      },
      3: {
        'x': center + outerRadius * math.cos(330 * math.pi / 180), // Right-top
        'y': center + outerRadius * math.sin(330 * math.pi / 180),
      },
      4: {
        'x': center + outerRadius * math.cos(0 * math.pi / 180), // Right
        'y': center + outerRadius * math.sin(0 * math.pi / 180),
      },
      5: {
        'x': center + outerRadius * math.cos(30 * math.pi / 180), // Right-bottom
        'y': center + outerRadius * math.sin(30 * math.pi / 180),
      },
      6: {
        'x': center + outerRadius * math.cos(60 * math.pi / 180), // Bottom-right
        'y': center + outerRadius * math.sin(60 * math.pi / 180),
      },
      7: {
        'x': center + outerRadius * math.cos(90 * math.pi / 180), // Bottom
        'y': center + outerRadius * math.sin(90 * math.pi / 180),
      },
      8: {
        'x': center + outerRadius * math.cos(120 * math.pi / 180), // Bottom-left
        'y': center + outerRadius * math.sin(120 * math.pi / 180),
      },
      // Inner houses (9-12) - arranged in center area
      9: {
        'x': center + innerRadius * math.cos(180 * math.pi / 180), // Left-center
        'y': center + innerRadius * math.sin(180 * math.pi / 180),
      },
      10: {
        'x': center + innerRadius * math.cos(270 * math.pi / 180), // Top-center
        'y': center + innerRadius * math.sin(270 * math.pi / 180),
      },
      11: {
        'x': center + innerRadius * math.cos(0 * math.pi / 180), // Right-center
        'y': center + innerRadius * math.sin(0 * math.pi / 180),
      },
      12: {
        'x': center + innerRadius * math.cos(90 * math.pi / 180), // Bottom-center
        'y': center + innerRadius * math.sin(90 * math.pi / 180),
      },
    };
  }

  Widget _buildPlanetWidget(_PlanetData planet) {
    final degreeText = planet.localDegree.round().toString();
    final planetSymbol = _getPlanetSymbol(planet.name, planet.retro, planet.isCombust, planet.isAscendant);
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AutoTranslateText(
            '$degreeText°',
            style: TextStyle(
              color: '#68171E'.toColor(),
              fontWeight: FontWeight.w500,
              height: 1.0,
            ).merge(AppTypography.label),
          ),
          AutoTranslateText(
            planetSymbol,
            style: TextStyle(
              color: '#68171E'.toColor(),
              fontWeight: FontWeight.bold,
              height: 1.0,
            ).merge(AppTypography.label),
          ),
        ],
      ),
    );
  }

  String _getPlanetSymbol(String name, bool retro, bool isCombust, bool isAscendant) {
    final symbols = {
      'As': 'La',
      'Su': 'Su',
      'Mo': 'Mo',
      'Ma': 'Ma',
      'Me': 'Me',
      'Ju': 'Ju',
      'Ve': 'Ve',
      'Sa': 'Sa',
      'Ra': 'Ra',
      'Ke': 'Ke',
    };
    
    var symbol = symbols[name] ?? name;
    if (retro) symbol += '*';
    if (isCombust) symbol += '^';
    
    return symbol;
  }

}

class _PlanetData {
  final String name;
  final String fullName;
  final double localDegree;
  final bool retro;
  final bool isCombust;
  final bool isAscendant;

  _PlanetData({
    required this.name,
    required this.fullName,
    required this.localDegree,
    required this.retro,
    required this.isCombust,
    required this.isAscendant,
  });
}


