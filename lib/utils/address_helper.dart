import 'dart:convert';
import 'package:http/http.dart' as http;
import 'app_constant.dart';

/// Helper class for address autofetch functionality
/// Uses Google Maps Geocoding API, Places API, and Time Zone API
/// Provides accurate address details including city, state, country, pincode, coordinates, timezone, and autocomplete suggestions
class AddressHelper {
  /// Google Maps API Key
  static const String _apiKey = AppConstant.googleMapsApiKey;

  /// Google Maps Geocoding API base URL
  static const String _geocodingBaseUrl =
      'https://maps.googleapis.com/maps/api/geocode/json';

  /// Google Maps Time Zone API base URL
  static const String _timezoneBaseUrl =
      'https://maps.googleapis.com/maps/api/timezone/json';

  /// Google Maps Places Autocomplete API base URL
  static const String _placesAutocompleteBaseUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';

  /// Google Maps Place Details API base URL
  static const String _placeDetailsBaseUrl =
      'https://maps.googleapis.com/maps/api/place/details/json';

  /// Fetches coordinates (latitude, longitude) and timezone from a city name
  ///
  /// [city] - City name (e.g., "Lucknow")
  /// [state] - Optional state name (e.g., "Uttar Pradesh")
  /// [country] - Optional country name (default: "India")
  ///
  /// Returns a Map with 'latitude', 'longitude', and 'timezone' keys, or null if not found
  static Future<Map<String, dynamic>?> fetchCoordinatesFromCity({
    required String city,
    String? state,
    String country = 'India',
  }) async {
    if (city.trim().isEmpty) return null;

    try {
      // Build search query
      String query = city.trim();
      if (state != null && state.trim().isNotEmpty) {
        query += ', ${state.trim()}';
      }
      if (country.trim().isNotEmpty) {
        query += ', ${country.trim()}';
      }

      // Use Google Geocoding API
      final uri = Uri.parse(
        '$_geocodingBaseUrl?address=${Uri.encodeComponent(query)}&key=$_apiKey',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        if (data['status'] == 'OK' && data['results'] != null) {
          final results = data['results'] as List<dynamic>;
          if (results.isNotEmpty) {
            final result = results[0] as Map<String, dynamic>;
            final geometry = result['geometry'] as Map<String, dynamic>?;
            final location = geometry?['location'] as Map<String, dynamic>?;

            if (location != null) {
              final lat = (location['lat'] as num).toDouble();
              final lon = (location['lng'] as num).toDouble();

              // Get timezone from coordinates
              String? timezone = await getTimezoneFromCoordinates(lat, lon);

              return {
                'latitude': lat,
                'longitude': lon,
                'timezone': timezone ?? 'UTC',
                'displayName': result['formatted_address']?.toString(),
              };
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching coordinates: $e');
    }
    return null;
  }

  /// Cache for timezone offsets to avoid repeated API calls
  static final Map<String, double> _timezoneCache = {};

  /// Gets numeric timezone offset (e.g. 5.5) from coordinates using Google Timezone API
  /// Results are cached by rounded lat/lng to reduce API calls
  static Future<double?> getTimezoneOffsetFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    final key =
        '${latitude.toStringAsFixed(2)},${longitude.toStringAsFixed(2)}';
    if (_timezoneCache.containsKey(key)) {
      return _timezoneCache[key];
    }

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final uri = Uri.parse(
        '$_timezoneBaseUrl?location=$latitude,$longitude&timestamp=$timestamp&key=$_apiKey',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        if (data['status'] == 'OK') {
          final rawOffset = (data['rawOffset'] as num?)?.toDouble() ?? 0;
          final dstOffset = (data['dstOffset'] as num?)?.toDouble() ?? 0;
          final totalOffset = (rawOffset + dstOffset) / 3600;
          _timezoneCache[key] = totalOffset;
          return totalOffset;
        }
      }
    } catch (e) {
      print('Error getting timezone offset: $e');
    }
    return null;
  }

  /// Gets timezone ID from latitude and longitude coordinates using Google Time Zone API
  static Future<String?> getTimezoneFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      // Get current timestamp for timezone API
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final uri = Uri.parse(
        '$_timezoneBaseUrl?location=$latitude,$longitude&timestamp=$timestamp&key=$_apiKey',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        if (data['status'] == 'OK' && data['timeZoneId'] != null) {
          return data['timeZoneId'] as String;
        }
      }
    } catch (e) {
      print('Error getting timezone: $e');
    }

    // Fallback to UTC if API fails
    return 'UTC';
  }

  /// Fetches full address details including coordinates, city, state, country, pincode
  /// This is a comprehensive search that returns accurate structured address data
  static Future<Map<String, dynamic>?> fetchAddressDetails({
    required String city,
    String? state,
    String? country,
    String? pincode,
  }) async {
    if (city.trim().isEmpty) return null;

    try {
      // Build search query with priority order
      String query = city.trim();

      if (state != null && state.trim().isNotEmpty) {
        query += ', ${state.trim()}';
      }

      if (country != null && country.trim().isNotEmpty) {
        query += ', ${country.trim()}';
      }

      if (pincode != null && pincode.trim().isNotEmpty) {
        query += ' ${pincode.trim()}';
      }

      // Use Google Geocoding API
      final uri = Uri.parse(
        '$_geocodingBaseUrl?address=${Uri.encodeComponent(query)}&key=$_apiKey',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        if (data['status'] == 'OK' && data['results'] != null) {
          final results = data['results'] as List<dynamic>;
          if (results.isNotEmpty) {
            final result = results[0] as Map<String, dynamic>;
            final geometry = result['geometry'] as Map<String, dynamic>?;
            final location = geometry?['location'] as Map<String, dynamic>?;

            if (location != null) {
              final lat = (location['lat'] as num).toDouble();
              final lon = (location['lng'] as num).toDouble();

              // Parse address components
              final addressComponents =
                  result['address_components'] as List<dynamic>?;

              String? extractedCity;
              String? extractedState;
              String? extractedCountry;
              String? extractedPincode;

              if (addressComponents != null) {
                for (var component in addressComponents) {
                  final comp = component as Map<String, dynamic>;
                  final types = comp['types'] as List<dynamic>?;

                  if (types != null) {
                    if (types.contains('locality')) {
                      extractedCity = comp['long_name']?.toString();
                    } else if (types.contains('administrative_area_level_2') &&
                        extractedCity == null) {
                      extractedCity = comp['long_name']?.toString();
                    }

                    if (types.contains('administrative_area_level_1')) {
                      extractedState = comp['long_name']?.toString();
                    }

                    if (types.contains('country')) {
                      extractedCountry = comp['long_name']?.toString();
                    }

                    if (types.contains('postal_code')) {
                      extractedPincode = comp['long_name']?.toString();
                    }
                  }
                }
              }

              // Get accurate timezone
              String? timezone = await getTimezoneFromCoordinates(lat, lon);

              return {
                'latitude': lat,
                'longitude': lon,
                'timezone': timezone ?? 'UTC',
                'city': extractedCity ?? city,
                'state': extractedState ?? state,
                'country': extractedCountry ?? country ?? 'Unknown',
                'pincode': extractedPincode ?? pincode,
                'displayName': result['formatted_address']?.toString(),
              };
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching address details: $e');
    }
    return null;
  }

  /// Reverse geocoding to get accurate address from coordinates
  static Future<Map<String, dynamic>?> reverseGeocode(
    double lat,
    double lon,
  ) async {
    try {
      // Use Google Geocoding API for reverse geocoding
      final uri = Uri.parse('$_geocodingBaseUrl?latlng=$lat,$lon&key=$_apiKey');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        if (data['status'] == 'OK' && data['results'] != null) {
          final results = data['results'] as List<dynamic>;
          if (results.isNotEmpty) {
            final result = results[0] as Map<String, dynamic>;

            // Parse address components
            final addressComponents =
                result['address_components'] as List<dynamic>?;

            String? city;
            String? state;
            String? country;
            String? pincode;

            if (addressComponents != null) {
              for (var component in addressComponents) {
                final comp = component as Map<String, dynamic>;
                final types = comp['types'] as List<dynamic>?;

                if (types != null) {
                  if (types.contains('locality')) {
                    city = comp['long_name']?.toString();
                  } else if (types.contains('administrative_area_level_2') &&
                      city == null) {
                    city = comp['long_name']?.toString();
                  }

                  if (types.contains('administrative_area_level_1')) {
                    state = comp['long_name']?.toString();
                  }

                  if (types.contains('country')) {
                    country = comp['long_name']?.toString();
                  }

                  if (types.contains('postal_code')) {
                    pincode = comp['long_name']?.toString();
                  }
                }
              }
            }

            return {
              'city': city,
              'state': state,
              'country': country,
              'pincode': pincode,
              'displayName': result['formatted_address']?.toString(),
            };
          }
        }
      }
    } catch (e) {
      print('Error in reverse geocoding: $e');
    }
    return null;
  }

  /// Get autocomplete address suggestions as user types
  ///
  /// [input] - The text input from the user
  /// [country] - Optional country code to restrict results (e.g., 'in' for India)
  ///
  /// Returns a list of address suggestions with place_id and description
  static Future<List<Map<String, dynamic>>> getAddressSuggestions({
    required String input,
    String? country,
  }) async {
    if (input.trim().isEmpty) return [];

    try {
      // Build autocomplete request
      final uri = Uri.parse(
        '$_placesAutocompleteBaseUrl?input=${Uri.encodeComponent(input)}&key=$_apiKey${country != null ? '&components=country:$country' : ''}',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        if (data['status'] == 'OK' && data['predictions'] != null) {
          final predictions = data['predictions'] as List<dynamic>;

          return predictions.map((prediction) {
            final pred = prediction as Map<String, dynamic>;
            return {
              'placeId': pred['place_id']?.toString(),
              'description': pred['description']?.toString(),
              'mainText': pred['structured_formatting']?['main_text']
                  ?.toString(),
              'secondaryText': pred['structured_formatting']?['secondary_text']
                  ?.toString(),
            };
          }).toList();
        }
      }
    } catch (e) {
      print('Error getting address suggestions: $e');
    }
    return [];
  }

  /// Get detailed address information from a place ID
  ///
  /// [placeId] - The place ID from autocomplete suggestion
  ///
  /// Returns full address details including coordinates
  static Future<Map<String, dynamic>?> getPlaceDetails({
    required String placeId,
  }) async {
    try {
      final uri = Uri.parse(
        '$_placeDetailsBaseUrl?place_id=$placeId&key=$_apiKey&fields=geometry,address_components,formatted_address',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        if (data['status'] == 'OK' && data['result'] != null) {
          final result = data['result'] as Map<String, dynamic>;
          final geometry = result['geometry'] as Map<String, dynamic>?;
          final location = geometry?['location'] as Map<String, dynamic>?;

          if (location != null) {
            final lat = (location['lat'] as num).toDouble();
            final lon = (location['lng'] as num).toDouble();

            // Parse address components
            final addressComponents =
                result['address_components'] as List<dynamic>?;

            String? city;
            String? state;
            String? country;
            String? pincode;

            if (addressComponents != null) {
              for (var component in addressComponents) {
                final comp = component as Map<String, dynamic>;
                final types = comp['types'] as List<dynamic>?;

                if (types != null) {
                  if (types.contains('locality')) {
                    city = comp['long_name']?.toString();
                  } else if (types.contains('administrative_area_level_2') &&
                      city == null) {
                    city = comp['long_name']?.toString();
                  }

                  if (types.contains('administrative_area_level_1')) {
                    state = comp['long_name']?.toString();
                  }

                  if (types.contains('country')) {
                    country = comp['long_name']?.toString();
                  }

                  if (types.contains('postal_code')) {
                    pincode = comp['long_name']?.toString();
                  }
                }
              }
            }

            // Get timezone
            String? timezone = await getTimezoneFromCoordinates(lat, lon);

            return {
              'latitude': lat,
              'longitude': lon,
              'timezone': timezone ?? 'UTC',
              'city': city,
              'state': state,
              'country': country,
              'pincode': pincode,
              'displayName': result['formatted_address']?.toString(),
            };
          }
        }
      }
    } catch (e) {
      print('Error getting place details: $e');
    }
    return null;
  }
}
