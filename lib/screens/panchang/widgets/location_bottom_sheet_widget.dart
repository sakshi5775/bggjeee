import 'dart:async';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/address_helper.dart';

class LocationBottomSheetWidget extends StatefulWidget {
  final Function(String city, String? state, String? country, [double? latitude, double? longitude, double? timezone]) onCitySelected;
  final String selectedCity;
  final VoidCallback? onUseCurrentLocation;

  const LocationBottomSheetWidget({
    super.key,
    required this.onCitySelected,
    required this.selectedCity,
    this.onUseCurrentLocation,
  });

  @override
  State<LocationBottomSheetWidget> createState() => _LocationBottomSheetWidgetState();
}

class _LocationBottomSheetWidgetState extends State<LocationBottomSheetWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredPlaces = [];
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Debounce API calls to avoid too many requests
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _searchPlaces();
      }
    });
  }

  Future<void> _searchPlaces() async {
    if (!mounted) return;
    
    final query = _searchController.text.trim();
    
    if (query.isEmpty) {
      if (mounted) {
        setState(() {
          _filteredPlaces = [];
          _isLoading = false;
          _errorMessage = null;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      // Get autocomplete suggestions from Google Places API (worldwide, no country restriction)
      final suggestions = await AddressHelper.getAddressSuggestions(
        input: query,
        country: null, // null means search worldwide
      );

      if (mounted) {
        setState(() {
          _filteredPlaces = suggestions;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error loading locations. Please try again.';
          _filteredPlaces = [];
        });
      }
      
    }
  }

  Future<void> _onPlaceSelected(Map<String, dynamic> place) async {
    if (!mounted) return;

    // Get basic info from autocomplete result immediately
    final mainText = place['mainText'] as String? ?? '';
    final secondaryText = place['secondaryText'] as String? ?? '';
    final description = place['description'] as String? ?? '';
    
    // Parse location from description
    String? city, state, country;
    if (description.isNotEmpty) {
      final parts = description.split(',');
      city = parts[0].trim();
      state = parts.length > 1 ? parts[1].trim() : null;
      country = parts.length > 2 ? parts.last.trim() : null;
    } else {
      city = mainText;
      state = secondaryText;
    }
    
    // Call callback immediately with available data
    // The controller will handle fetching coordinates and timezone in the background
    if (mounted && city.isNotEmpty) {
      widget.onCitySelected(
        city,
        state,
        country,
        null, // latitude - controller will fetch
        null, // longitude - controller will fetch
        null, // timezone - controller will fetch
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'Select Location',
                style: MyTextTheme.largeBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.close,
                  color: "#6F221E".toColor(),
                  size: 24.w,
                ),
              ),
            ],
          ),
        ),
        // Search Bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search city, state, or country...',
              prefixIcon: Icon(Icons.search, color: "#6F221E".toColor().withOpacity(0.5)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: "#DFB343".toColor().withOpacity(0.5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: "#DFB343".toColor().withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: "#DFB343".toColor(), width: 2),
              ),
            ),
          ),
        ),
        Spacing.h(16),
        // Use Current Location Button (if callback provided)
        if (widget.onUseCurrentLocation != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: GestureDetector(
              onTap: () {
                Get.back();
                widget.onUseCurrentLocation?.call();
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade600, Colors.red.shade600],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.send, color: Colors.white, size: 20.w),
                    ),
                    Spacing.w(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoTranslateText(
                            'Use Current Location',
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacing.h(2),
                          AutoTranslateText(
                            'Get your current location automatically',
                            style: MyTextTheme.smallBCN.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (widget.onUseCurrentLocation != null) Spacing.h(16),
        // Places List
        Expanded(
          child: _buildPlacesList(),
        ),
      ],
    );
  }

  Widget _buildPlacesList() {
    if (_isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: "#DFB343".toColor(),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Searching locations...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.6),
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48.w,
              ),
              Spacing.h(16),
              AutoTranslateText(
                _errorMessage!,
                style: MyTextTheme.mediumBCN.copyWith(
                  color: Colors.red,
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_searchController.text.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                color: "#6F221E".toColor().withOpacity(0.3),
                size: 64.w,
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Search for any city, state, or country worldwide',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.6),
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredPlaces.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off,
                color: "#6F221E".toColor().withOpacity(0.3),
                size: 64.w,
              ),
              Spacing.h(16),
              AutoTranslateText(
                'No locations found',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.6),
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
              Spacing.h(8),
              AutoTranslateText(
                'Try searching with a different term',
                style: MyTextTheme.smallBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.5),
                  fontSize: 12.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: _filteredPlaces.length,
      itemBuilder: (context, index) {
        final place = _filteredPlaces[index];
        final mainText = place['mainText'] as String? ?? '';
        final secondaryText = place['secondaryText'] as String? ?? '';
        final description = place['description'] as String? ?? '';
        final isSelected = mainText == widget.selectedCity;
        
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isSelected
                ? "#DFB343".toColor().withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? "#DFB343".toColor()
                  : "#DFB343".toColor().withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: InkWell(
            onTap: () => _onPlaceSelected(place),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: "#DFB343".toColor().withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: "#DFB343".toColor(),
                    size: 20.w,
                  ),
                ),
                Spacing.w(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        mainText,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: "#6F221E".toColor(),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (secondaryText.isNotEmpty) ...[
                        Spacing.h(2),
                        AutoTranslateText(
                          secondaryText,
                          style: MyTextTheme.smallBCN.copyWith(
                            color: "#6F221E".toColor().withOpacity(0.6),
                            fontSize: 12.sp,
                          ),
                        ),
                      ] else if (description.isNotEmpty && description != mainText) ...[
                        Spacing.h(2),
                        AutoTranslateText(
                          description,
                          style: MyTextTheme.smallBCN.copyWith(
                            color: "#6F221E".toColor().withOpacity(0.6),
                            fontSize: 12.sp,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: "#6F221E".toColor(),
                    size: 24.w,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

}



