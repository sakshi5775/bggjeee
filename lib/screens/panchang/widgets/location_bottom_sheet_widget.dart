import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class LocationBottomSheetWidget extends StatefulWidget {
  final Function(String city, String? state, String? country) onCitySelected;
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
  final List<Map<String, String>> _cities = [
    {'name': 'Mumbai', 'state': 'Maharashtra', 'country': 'India'},
    {'name': 'Delhi', 'state': 'Delhi', 'country': 'India'},
    {'name': 'Bangalore', 'state': 'Karnataka', 'country': 'India'},
    {'name': 'Kolkata', 'state': 'West Bengal', 'country': 'India'},
    {'name': 'Chennai', 'state': 'Tamil Nadu', 'country': 'India'},
    {'name': 'Hyderabad', 'state': 'Telangana', 'country': 'India'},
    {'name': 'Pune', 'state': 'Maharashtra', 'country': 'India'},
    {'name': 'Ahmedabad', 'state': 'Gujarat', 'country': 'India'},
    {'name': 'Jaipur', 'state': 'Rajasthan', 'country': 'India'},
    {'name': 'Lucknow', 'state': 'Uttar Pradesh', 'country': 'India'},
    {'name': 'Kanpur', 'state': 'Uttar Pradesh', 'country': 'India'},
    {'name': 'Nagpur', 'state': 'Maharashtra', 'country': 'India'},
    {'name': 'Indore', 'state': 'Madhya Pradesh', 'country': 'India'},
    {'name': 'Thane', 'state': 'Maharashtra', 'country': 'India'},
    {'name': 'Bhopal', 'state': 'Madhya Pradesh', 'country': 'India'},
    {'name': 'Visakhapatnam', 'state': 'Andhra Pradesh', 'country': 'India'},
    {'name': 'Patna', 'state': 'Bihar', 'country': 'India'},
    {'name': 'Vadodara', 'state': 'Gujarat', 'country': 'India'},
    {'name': 'Ghaziabad', 'state': 'Uttar Pradesh', 'country': 'India'},
    {'name': 'Ludhiana', 'state': 'Punjab', 'country': 'India'},
    {'name': 'Agra', 'state': 'Uttar Pradesh', 'country': 'India'},
    {'name': 'Nashik', 'state': 'Maharashtra', 'country': 'India'},
    {'name': 'Faridabad', 'state': 'Haryana', 'country': 'India'},
    {'name': 'Meerut', 'state': 'Uttar Pradesh', 'country': 'India'},
    {'name': 'Rajkot', 'state': 'Gujarat', 'country': 'India'},
    {'name': 'Varanasi', 'state': 'Uttar Pradesh', 'country': 'India'},
    {'name': 'Srinagar', 'state': 'Jammu and Kashmir', 'country': 'India'},
    {'name': 'Amritsar', 'state': 'Punjab', 'country': 'India'},
    {'name': 'Chandigarh', 'state': 'Chandigarh', 'country': 'India'},
    {'name': 'New York', 'state': 'New York', 'country': 'United States'},
    {'name': 'London', 'state': 'England', 'country': 'United Kingdom'},
    {'name': 'Dubai', 'state': 'Dubai', 'country': 'United Arab Emirates'},
    {'name': 'Singapore', 'state': 'Singapore', 'country': 'Singapore'},
    {'name': 'Sydney', 'state': 'New South Wales', 'country': 'Australia'},
    {'name': 'Toronto', 'state': 'Ontario', 'country': 'Canada'},
  ];
  List<Map<String, String>> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _filteredCities = _cities;
    _searchController.addListener(_filterCities);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCities() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCities = _cities;
      } else {
        _filteredCities = _cities.where((city) {
          return city['name']!.toLowerCase().contains(query) ||
              city['state']!.toLowerCase().contains(query) ||
              city['country']!.toLowerCase().contains(query);
        }).toList();
      }
    });
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
              hintText: 'Search city...',
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
                        color: Colors.white.withOpacity(0.2),
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
                              color: Colors.white.withOpacity(0.9),
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
        // City List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: _filteredCities.length,
            itemBuilder: (context, index) {
              final city = _filteredCities[index];
              final isSelected = city['name'] == widget.selectedCity;
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
                  onTap: () {
                    widget.onCitySelected(
                      city['name']!,
                      city['state'],
                      city['country'],
                    );
                  },
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
                              city['name']!,
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: "#6F221E".toColor(),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacing.h(2),
                            AutoTranslateText(
                              '${city['state']}, ${city['country']}',
                              style: MyTextTheme.smallBCN.copyWith(
                                color: "#6F221E".toColor().withOpacity(0.6),
                                fontSize: 12.sp,
                              ),
                            ),
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
          ),
        ),
      ],
    );
  }
}



