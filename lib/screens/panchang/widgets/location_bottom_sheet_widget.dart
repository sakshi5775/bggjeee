import 'dart:async';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/address_helper.dart';
import 'package:astrobharataiuser/utils/location_prompt_helper.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  LocationBottomSheetWidget  —  3-Tab Location Picker
//  Tab 1 │ City Search   → Google Places autocomplete  → API timezone
//  Tab 2 │ Custom City   → Manual lat/lng              → API timezone (auto)
//  Tab 3 │ G.P.S.        → Device GPS                  → API timezone (auto)
//  ZERO static timezone data. All TZ via Google Timezone API.
// ─────────────────────────────────────────────────────────────────────────────

// ── Helpers ──────────────────────────────────────────────────────────────────
final List<double> _kOffsets = List.generate(53, (i) => -12.0 + i * 0.5);

String _fmtOffset(double tz) {
  final neg = tz < 0;
  final abs = tz.abs();
  final h = abs.truncate();
  final m = ((abs - h) * 60).round();
  final sgn = neg ? '−' : '+';
  return 'UTC $sgn${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

double _snapToGrid(double v) {
  var best = _kOffsets.first;
  var bestDist = double.infinity;
  for (final o in _kOffsets) {
    final d = (o - v).abs();
    if (d < bestDist) {
      bestDist = d;
      best = o;
    }
  }
  return best;
}

// ─────────────────────────────────────────────────────────────────────────────

class LocationBottomSheetWidget extends StatefulWidget {
  final Function(
    String city,
    String? state,
    String? country, [
    double? latitude,
    double? longitude,
    double? timezone,
  ])
  onCitySelected;

  final String selectedCity;
  final VoidCallback? onUseCurrentLocation;

  const LocationBottomSheetWidget({
    super.key,
    required this.onCitySelected,
    required this.selectedCity,
    this.onUseCurrentLocation,
  });

  @override
  State<LocationBottomSheetWidget> createState() =>
      _LocationBottomSheetWidgetState();
}

class _LocationBottomSheetWidgetState extends State<LocationBottomSheetWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Color get _maroon => '#6F221E'.toColor();
  Color get _accent => AppColors.deepOrange; // orange accent for borders/icons

  // Tab 1
  final _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _places = [];
  bool _searching = false;
  String? _searchErr;
  Timer? _searchDebounce;
  bool _t1Default = false;

  // Tab 2
  final _cLatDeg = TextEditingController(text: '0');
  final _cLatMin = TextEditingController(text: '0');
  final _cLngDeg = TextEditingController(text: '0');
  final _cLngMin = TextEditingController(text: '0');
  bool _cLatN = true, _cLngE = true;
  double? _cTzOff;
  String? _cTzId, _cTzErr;
  bool _cTzLoading = false, _cDefault = false;
  Timer? _cDebounce;

  // Tab 3
  final _gLatDeg = TextEditingController(text: '0');
  final _gLatMin = TextEditingController(text: '0');
  final _gLngDeg = TextEditingController(text: '0');
  final _gLngMin = TextEditingController(text: '0');
  bool _gLatN = true, _gLngE = true;
  double? _gTzOff;
  String? _gTzId, _gErr;
  bool _gLoading = false, _gDefault = false;
  String? _gCity, _gState, _gCountry;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        if (_tabController.index == 2 && !_gLoading && _gTzOff == null) {
          _fetchGps();
        }
      });
    _searchCtrl.addListener(_onSearchType);
    for (final c in [_cLatDeg, _cLatMin, _cLngDeg, _cLngMin]) {
      c.addListener(_scheduleCTz);
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _cDebounce?.cancel();
    _tabController.dispose();
    _searchCtrl.dispose();
    for (final c in [
      _cLatDeg,
      _cLatMin,
      _cLngDeg,
      _cLngMin,
      _gLatDeg,
      _gLatMin,
      _gLngDeg,
      _gLngMin,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  TAB 1 — City Search
  // ═══════════════════════════════════════════════════════════════════════════
  void _onSearchType() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) _doSearch();
    });
  }

  Future<void> _doSearch() async {
    if (!mounted) return;
    final q = _searchCtrl.text.trim();
    if (q.isEmpty) {
      setState(() {
        _places = [];
        _searching = false;
        _searchErr = null;
      });
      return;
    }
    setState(() {
      _searching = true;
      _searchErr = null;
    });
    try {
      final r = await AddressHelper.getAddressSuggestions(
        input: q,
        country: null,
      );
      if (mounted) {
        setState(() {
          _places = r;
          _searching = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _searching = false;
          _searchErr = 'Error loading.';
          _places = [];
        });
      }
    }
  }

  Future<void> _onPlaceSelected(Map<String, dynamic> place) async {
    if (!mounted) return;
    final pid = place['placeId'] as String? ?? '';
    final main = place['mainText'] as String? ?? '';
    final sec = place['secondaryText'] as String? ?? '';
    final desc = place['description'] as String? ?? '';
    String? city, state, country;
    double? lat, lng, tz;

    if (pid.isNotEmpty) {
      final d = await AddressHelper.getPlaceDetails(placeId: pid);
      if (d != null) {
        city = d['city'] as String?;
        state = d['state'] as String?;
        country = d['country'] as String?;
        lat = d['latitude'] as double?;
        lng = d['longitude'] as double?;
        if (lat != null && lng != null) {
          tz = await AddressHelper.getTimezoneOffsetFromCoordinates(lat, lng);
        }
      }
    }
    city ??= main;
    if (state == null && desc.isNotEmpty) {
      final p = desc.split(',');
      state = p.length > 1 ? p[1].trim() : sec;
      country ??= p.length > 2 ? p.last.trim() : null;
    }
    if (mounted && city.isNotEmpty) {
      widget.onCitySelected(city, state, country, lat, lng, tz);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  TAB 2 — Custom City
  // ═══════════════════════════════════════════════════════════════════════════
  void _scheduleCTz() {
    _cDebounce?.cancel();
    _cDebounce = Timer(const Duration(milliseconds: 900), () {
      if (mounted) _fetchCTz();
    });
  }

  double _cDecLat() =>
      (_cLatN ? 1 : -1) *
      ((double.tryParse(_cLatDeg.text) ?? 0) +
          (double.tryParse(_cLatMin.text) ?? 0) / 60);
  double _cDecLng() =>
      (_cLngE ? 1 : -1) *
      ((double.tryParse(_cLngDeg.text) ?? 0) +
          (double.tryParse(_cLngMin.text) ?? 0) / 60);

  Future<void> _fetchCTz() async {
    final lat = _cDecLat(), lng = _cDecLng();
    if (lat == 0 && lng == 0) return;
    if (!mounted) return;
    setState(() {
      _cTzLoading = true;
      _cTzErr = null;
    });
    try {
      final res = await Future.wait([
        AddressHelper.getTimezoneOffsetFromCoordinates(lat, lng),
        AddressHelper.getTimezoneFromCoordinates(lat, lng),
      ]);
      if (mounted) {
        setState(() {
          _cTzOff = res[0] as double?;
          _cTzId = res[1] as String?;
          _cTzLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _cTzLoading = false;
          _cTzErr = 'Could not fetch timezone.';
        });
      }
    }
  }

  void _submitCustom() => widget.onCitySelected(
    'Custom Location',
    null,
    null,
    _cDecLat(),
    _cDecLng(),
    _cTzOff,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  //  TAB 3 — GPS
  // ═══════════════════════════════════════════════════════════════════════════
  Future<void> _fetchGps() async {
    if (!mounted) return;
    setState(() {
      _gLoading = true;
      _gErr = null;
    });
    try {
      final pos = await LocationPromptHelper.checkAndGetLocation();
      if (pos == null) {
        if (mounted) {
          setState(() {
            _gLoading = false;
            // No error message here as the prompt handled it
          });
        }
        return;
      }
      _setDM(pos.latitude, _gLatDeg, _gLatMin);
      _setDM(pos.longitude, _gLngDeg, _gLngMin);

      final res = await Future.wait([
        AddressHelper.getTimezoneOffsetFromCoordinates(
          pos.latitude,
          pos.longitude,
        ),
        AddressHelper.getTimezoneFromCoordinates(pos.latitude, pos.longitude),
        AddressHelper.reverseGeocode(pos.latitude, pos.longitude),
      ]);
      if (mounted) {
        final geo = res[2] as Map<String, dynamic>?;
        setState(() {
          _gLatN = pos.latitude >= 0;
          _gLngE = pos.longitude >= 0;
          _gTzOff = res[0] as double?;
          _gTzId = res[1] as String?;
          _gCity = geo?['city'] as String?;
          _gState = geo?['state'] as String?;
          _gCountry = geo?['country'] as String?;
          _gLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _gLoading = false;
          _gErr = 'Unable to get location.';
        });
      }
    }
  }

  void _setDM(double v, TextEditingController d, TextEditingController m) {
    final a = v.abs();
    d.text = a.floor().toString();
    m.text = ((a - a.floor()) * 60).round().toString();
  }

  void _submitGps() {
    final lat =
        (_gLatN ? 1 : -1) *
        ((double.tryParse(_gLatDeg.text) ?? 0) +
            (double.tryParse(_gLatMin.text) ?? 0) / 60);
    final lng =
        (_gLngE ? 1 : -1) *
        ((double.tryParse(_gLngDeg.text) ?? 0) +
            (double.tryParse(_gLngMin.text) ?? 0) / 60);
    widget.onCitySelected(
      _gCity ?? 'GPS Location',
      _gState,
      _gCountry,
      lat,
      lng,
      _gTzOff,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  TIMEZONE OVERRIDE PICKER
  // ═══════════════════════════════════════════════════════════════════════════
  void _showTzPicker({
    required double? current,
    required ValueChanged<double> onSel,
  }) {
    final snapped = current != null ? _snapToGrid(current) : null;
    final sc = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (snapped != null && sc.hasClients) {
        final idx = _kOffsets.indexOf(snapped);
        if (idx >= 0) {
          sc.animateTo(
            idx * 48.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      }
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10.h, bottom: 4.h),
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Timezone',
                    style: MyTextTheme.largeBCB.copyWith(
                      color: _maroon,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Icon(Icons.close, color: _maroon, size: 20.w),
                  ),
                ],
              ),
            ),
            Divider(color: _accent.withValues(alpha: 0.15), height: 1),
            Expanded(
              child: ListView.builder(
                controller: sc,
                itemCount: _kOffsets.length,
                itemBuilder: (_, i) {
                  final off = _kOffsets[i];
                  final isSel = snapped != null && (off - snapped).abs() < 0.01;
                  return InkWell(
                    onTap: () {
                      Navigator.pop(ctx);
                      onSel(off);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      color: isSel
                          ? _accent.withValues(alpha: 0.08)
                          : Colors.transparent,
                      child: Row(
                        children: [
                          if (isSel)
                            Container(
                              width: 6.w,
                              height: 6.w,
                              margin: EdgeInsets.only(right: 10.w),
                              decoration: BoxDecoration(
                                color: _accent,
                                shape: BoxShape.circle,
                              ),
                            )
                          else
                            SizedBox(width: 16.w),
                          Expanded(
                            child: Text(
                              _fmtOffset(off),
                              style: MyTextTheme.mediumBCN.copyWith(
                                color: isSel
                                    ? _maroon
                                    : _maroon.withValues(alpha: 0.6),
                                fontSize: 13.sp,
                                fontWeight: isSel
                                    ? FontWeight.w700
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isSel)
                            Icon(
                              Icons.check_rounded,
                              color: _accent,
                              size: 16.w,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 12.w, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'Select Location',
                style: MyTextTheme.largeBCB.copyWith(
                  color: _maroon,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: _maroon.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: _maroon, size: 18.w),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),

        // Tab Bar — pill style with orangeGradient
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: _maroon.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: _maroon.withValues(alpha: 0.55),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              gradient: AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(10.r),
            ),
            dividerColor: Colors.transparent,
            labelStyle: MyTextTheme.mediumBCB.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12.5.sp,
            ),
            unselectedLabelStyle: MyTextTheme.mediumBCN.copyWith(
              fontSize: 12.5.sp,
            ),
            labelPadding: EdgeInsets.zero,
            padding: EdgeInsets.all(3.w),
            tabs: const [
              Tab(text: 'City Search'),
              Tab(text: 'Custom City'),
              Tab(text: 'G.P.S.'),
            ],
          ),
        ),
        SizedBox(height: 4.h),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [_buildTab1(), _buildTab2(), _buildTab3()],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  TAB 1 UI
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildTab1() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: TextField(
            controller: _searchCtrl,
            style: MyTextTheme.mediumBCN.copyWith(
              color: _maroon,
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              hintText: 'Search city, state, or country...',
              hintStyle: MyTextTheme.mediumBCN.copyWith(
                color: _maroon.withValues(alpha: 0.38),
                fontSize: 13.sp,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: _maroon.withValues(alpha: 0.4),
                size: 20.w,
              ),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: _accent.withValues(alpha: 0.4)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: _accent.withValues(alpha: 0.4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: _accent, width: 1.5),
              ),
            ),
          ),
        ),

        // Use Current Location
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
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
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
                      child: Icon(Icons.send, color: Colors.white, size: 18.w),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoTranslateText(
                            'Use Current Location',
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          AutoTranslateText(
                            'Get your current location automatically',
                            style: MyTextTheme.smallBCN.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 11.sp,
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
        if (widget.onUseCurrentLocation != null) SizedBox(height: 6.h),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: _checkRow(
            _t1Default,
            (v) => setState(() => _t1Default = v ?? false),
          ),
        ),
        Expanded(child: _buildPlaces()),
      ],
    );
  }

  Widget _buildPlaces() {
    if (_searching) {
      return Center(child: CircularProgressIndicator(color: _accent));
    }
    if (_searchErr != null) {
      return Center(
        child: Text(
          _searchErr!,
          style: MyTextTheme.mediumBCN.copyWith(
            color: Colors.red,
            fontSize: 13.sp,
          ),
        ),
      );
    }
    if (_searchCtrl.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              color: _maroon.withValues(alpha: 0.2),
              size: 56.w,
            ),
            SizedBox(height: 12.h),
            AutoTranslateText(
              'Search for any city, state, or country worldwide',
              style: MyTextTheme.mediumBCN.copyWith(
                color: _maroon.withValues(alpha: 0.45),
                fontSize: 13.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    if (_places.isEmpty) {
      return Center(
        child: AutoTranslateText(
          'No locations found',
          style: MyTextTheme.mediumBCN.copyWith(
            color: _maroon.withValues(alpha: 0.5),
            fontSize: 13.sp,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      itemCount: _places.length,
      itemBuilder: (_, i) {
        final p = _places[i];
        final main = p['mainText'] as String? ?? '';
        final sec = p['secondaryText'] as String? ?? '';
        final desc = p['description'] as String? ?? '';
        final sel = main == widget.selectedCity;
        return InkWell(
          onTap: () => _onPlaceSelected(p),
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: sel ? _accent.withValues(alpha: 0.06) : Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: sel ? _accent : _accent.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: _accent.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.location_on, color: _accent, size: 18.w),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        main,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: _maroon,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (sec.isNotEmpty) ...[
                        SizedBox(height: 1.h),
                        Text(
                          sec,
                          style: MyTextTheme.smallBCN.copyWith(
                            color: _maroon.withValues(alpha: 0.5),
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                      if (sec.isEmpty && desc.isNotEmpty && desc != main) ...[
                        SizedBox(height: 1.h),
                        Text(
                          desc,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: MyTextTheme.smallBCN.copyWith(
                            color: _maroon.withValues(alpha: 0.5),
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (sel) Icon(Icons.check_circle, color: _maroon, size: 20.w),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  TAB 2 UI — Custom City (compact)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildTab2() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Time Zone'),
          SizedBox(height: 6.h),
          _tzCard(
            offset: _cTzOff,
            tzId: _cTzId,
            loading: _cTzLoading,
            error: _cTzErr,
            onOverride: () => _showTzPicker(
              current: _cTzOff,
              onSel: (v) => setState(() {
                _cTzOff = v;
                _cTzId = null;
              }),
            ),
          ),
          SizedBox(height: 16.h),

          _label('Latitude'),
          SizedBox(height: 6.h),
          _dirRow(_cLatN, 'North', 'South', (v) => setState(() => _cLatN = v)),
          SizedBox(height: 6.h),
          _dmRow(_cLatDeg, _cLatMin),
          SizedBox(height: 16.h),

          _label('Longitude'),
          SizedBox(height: 6.h),
          _dirRow(_cLngE, 'East', 'West', (v) => setState(() => _cLngE = v)),
          SizedBox(height: 6.h),
          _dmRow(_cLngDeg, _cLngMin),
          SizedBox(height: 10.h),

          _checkRow(_cDefault, (v) => setState(() => _cDefault = v ?? false)),
          SizedBox(height: 16.h),
          _gradBtn('OK', () async {
            if (_cTzOff == null) {
              await _fetchCTz();
            }
            _submitCustom();
          }),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  TAB 3 UI — GPS (compact)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildTab3() {
    if (_gLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 44.w,
              height: 44.w,
              child: CircularProgressIndicator(color: _accent, strokeWidth: 3),
            ),
            SizedBox(height: 14.h),
            AutoTranslateText(
              'Getting your location...',
              style: MyTextTheme.mediumBCN.copyWith(
                color: _maroon.withValues(alpha: 0.6),
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      );
    }
    if (_gErr != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off_rounded,
                color: Colors.red.shade400,
                size: 40.w,
              ),
              SizedBox(height: 14.h),
              AutoTranslateText(
                _gErr!,
                style: MyTextTheme.mediumBCN.copyWith(
                  color: _maroon.withValues(alpha: 0.65),
                  fontSize: 13.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              _gradBtn('Retry', _fetchGps),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_gCity != null) ...[_detectedBanner(), SizedBox(height: 12.h)],

          _label('Time Zone'),
          SizedBox(height: 6.h),
          _tzCard(
            offset: _gTzOff,
            tzId: _gTzId,
            loading: false,
            error: null,
            onOverride: () => _showTzPicker(
              current: _gTzOff,
              onSel: (v) => setState(() {
                _gTzOff = v;
                _gTzId = null;
              }),
            ),
          ),
          SizedBox(height: 16.h),

          _label('Latitude'),
          SizedBox(height: 6.h),
          _dirRow(_gLatN, 'North', 'South', (v) => setState(() => _gLatN = v)),
          SizedBox(height: 6.h),
          _dmRow(_gLatDeg, _gLatMin),
          SizedBox(height: 16.h),

          _label('Longitude'),
          SizedBox(height: 6.h),
          _dirRow(_gLngE, 'East', 'West', (v) => setState(() => _gLngE = v)),
          SizedBox(height: 6.h),
          _dmRow(_gLngDeg, _gLngMin),
          SizedBox(height: 10.h),

          _checkRow(_gDefault, (v) => setState(() => _gDefault = v ?? false)),
          SizedBox(height: 16.h),
          _gradBtn('OK', _submitGps),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  SHARED WIDGETS — compact, single border, orangeGradient accent
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _label(String t) => Text(
    t,
    style: MyTextTheme.mediumBCB.copyWith(
      color: _maroon,
      fontSize: 13.5.sp,
      fontWeight: FontWeight.w700,
    ),
  );

  // Timezone card — compact
  Widget _tzCard({
    required double? offset,
    required String? tzId,
    required bool loading,
    required String? error,
    required VoidCallback onOverride,
  }) {
    if (loading) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: Border.all(color: _accent.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 16.w,
              height: 16.w,
              child: CircularProgressIndicator(strokeWidth: 2, color: _accent),
            ),
            SizedBox(width: 10.w),
            Text(
              'Fetching timezone...',
              style: MyTextTheme.mediumBCN.copyWith(
                color: _maroon.withValues(alpha: 0.5),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      );
    }
    if (offset != null) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: Border.all(color: _accent, width: 1.2),
          borderRadius: BorderRadius.circular(10.r),
          color: _accent.withValues(alpha: 0.04),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_rounded, color: _accent, size: 18.w),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _fmtOffset(offset),
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: _maroon,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (tzId != null && tzId.isNotEmpty && tzId != 'UTC')
                    Text(
                      tzId,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: _maroon.withValues(alpha: 0.55),
                        fontSize: 11.sp,
                      ),
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onOverride,
              child: Text(
                'Change',
                style: MyTextTheme.smallBCN.copyWith(
                  color: _accent,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: onOverride,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: error != null
                ? Colors.red.withValues(alpha: 0.4)
                : _accent.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              color: _accent.withValues(alpha: 0.4),
              size: 18.w,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                error ?? 'Auto-detects from coordinates',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: error != null
                      ? Colors.red.shade600
                      : _maroon.withValues(alpha: 0.38),
                  fontSize: 12.sp,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: _accent.withValues(alpha: 0.4),
              size: 20.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _detectedBanner() {
    final parts = [
      _gCity,
      _gState,
      _gCountry,
    ].where((s) => s != null && s.isNotEmpty).join(', ');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.my_location, color: Colors.white, size: 16.w),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detected Location',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 10.sp,
                  ),
                ),
                Text(
                  parts,
                  overflow: TextOverflow.ellipsis,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: Colors.white, size: 18.w),
        ],
      ),
    );
  }

  Widget _dirRow(bool isPos, String p, String n, ValueChanged<bool> onC) => Row(
    children: [
      _radio(p, isPos, () => onC(true)),
      SizedBox(width: 28.w),
      _radio(n, !isPos, () => onC(false)),
    ],
  );

  Widget _radio(String lbl, bool sel, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18.w,
          height: 18.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: sel ? _accent : _maroon.withValues(alpha: 0.28),
              width: 2,
            ),
          ),
          child: sel
              ? Center(
                  child: Container(
                    width: 9.w,
                    height: 9.w,
                    decoration: BoxDecoration(
                      color: _accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
        ),
        SizedBox(width: 6.w),
        Text(
          lbl,
          style: MyTextTheme.mediumBCN.copyWith(
            color: sel ? _maroon : _maroon.withValues(alpha: 0.55),
            fontSize: 13.sp,
            fontWeight: sel ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    ),
  );

  // Number field — single border only, compact
  Widget _dmRow(TextEditingController d, TextEditingController m) => Row(
    children: [
      Expanded(child: _numField(d, 'Deg')),
      SizedBox(width: 12.w),
      Expanded(child: _numField(m, 'Min')),
    ],
  );

  Widget _numField(TextEditingController c, String lbl) => TextField(
    controller: c,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
    textAlign: TextAlign.center,
    style: MyTextTheme.mediumBCB.copyWith(
      color: _maroon,
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
    ),
    decoration: InputDecoration(
      labelText: lbl,
      labelStyle: MyTextTheme.smallBCN.copyWith(
        color: _maroon.withValues(alpha: 0.45),
        fontSize: 11.sp,
      ),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: _accent.withValues(alpha: 0.4)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: _accent.withValues(alpha: 0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: _accent, width: 1.5),
      ),
    ),
  );

  Widget _checkRow(bool val, ValueChanged<bool?> onC) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      SizedBox(
        width: 18.w,
        height: 18.w,
        child: Checkbox(
          value: val,
          onChanged: onC,
          activeColor: _accent,
          side: BorderSide(color: _maroon.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
      ),
      SizedBox(width: 6.w),
      Text(
        'Make it default city',
        style: MyTextTheme.mediumBCN.copyWith(color: _maroon, fontSize: 12.sp),
      ),
    ],
  );

  Widget _gradBtn(String lbl, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 46.h,
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Text(
          lbl,
          style: MyTextTheme.largeBCB.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
    ),
  );
}
