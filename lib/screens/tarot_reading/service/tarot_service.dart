import 'dart:async';
import 'dart:convert';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/data_model/tarot_card_model.dart';
import 'package:astrobharataiuser/data_model/tarot_reading_models.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TarotService {
  /// Base URL for tarot API (port 8010 based on pattern)
  static const String _tarotBaseUrl =
      'http://3.109.91.254:8000/api/numerology/api';

  /// Shuffle tarot cards
  /// [shuffleType] can be 'minor', 'major', or 'both'
  /// [language] is optional and comes from API header
  Future<TarotShuffleResponse> shuffleCards({
    required String shuffleType, // 'minor', 'major', or 'both'
    String? language,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{'shuffleType': shuffleType};

      if (language != null && language.isNotEmpty) {
        queryParams['lang'] = language;
      }

      // Build URI with query parameters
      final uri = Uri.parse(
        '$_tarotBaseUrl/${EndPoints.tarotShuffle}',
      ).replace(queryParameters: queryParams);

      // Get authorization token from UserData
      final currentToken = UserData().accessToken?.trim();

      // Make HTTP GET request
      final response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': '*/*',
              if (currentToken != null && currentToken.isNotEmpty)
                'Authorization': 'Bearer $currentToken',
              if (language != null && language.isNotEmpty)
                'Accept-Language': language,
            },
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Request timeout');
            },
          );

      if (kDebugMode) {
        debugPrint('Tarot Shuffle API URL: ${uri.toString()}');
        debugPrint('Tarot Shuffle API Status: ${response.statusCode}');
        debugPrint('Tarot Shuffle API Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = response.body;
        final jsonData = json.decode(responseBody) as Map<String, dynamic>;

        // API returns: { "status": 200, "response": [...], "remaining_api_calls": ... }
        return TarotShuffleResponse.fromJson(jsonData);
      } else {
        if (kDebugMode) {
          debugPrint(
            'Tarot Shuffle API Error: ${response.statusCode} - ${response.body}',
          );
        }
        throw Exception('Failed to shuffle cards: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timeout. Please try again.');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}. Please try again.');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Tarot Shuffle Error: $e');
      }
      throw Exception('Error shuffling cards: ${e.toString()}');
    }
  }

  /// Retry shuffle with exponential backoff
  Future<TarotShuffleResponse> shuffleCardsWithRetry({
    required String shuffleType,
    String? language,
    int maxRetries = 3,
  }) async {
    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        return await shuffleCards(shuffleType: shuffleType, language: language);
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          rethrow;
        }
        // Exponential backoff: 1s, 2s, 4s
        await Future.delayed(Duration(seconds: 1 << (attempt - 1)));
      }
    }
    throw Exception('Failed after $maxRetries attempts');
  }

  /// Generic API call helper
  Future<Map<String, dynamic>> _makeApiCall(
    String endpoint, {
    Map<String, String>? queryParams,
    String? language,
  }) async {
    try {
      final uri = Uri.parse(
        '$_tarotBaseUrl/$endpoint',
      ).replace(queryParameters: queryParams);

      final currentToken = UserData().accessToken?.trim();

      final response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': '*/*',
              if (currentToken != null && currentToken.isNotEmpty)
                'Authorization': 'Bearer $currentToken',
              if (language != null && language.isNotEmpty)
                'Accept-Language': language,
            },
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Request timeout');
            },
          );

      if (kDebugMode) {
        debugPrint('Tarot API URL: ${uri.toString()}');
        debugPrint('Tarot API Status: ${response.statusCode}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        if (kDebugMode) {
          debugPrint(
            'Tarot API Error: ${response.statusCode} - ${response.body}',
          );
        }
        throw Exception('Failed API call: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timeout. Please try again.');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}. Please try again.');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Tarot API Error: $e');
      }
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Yes/No Reading
  Future<TarotYesNoResponse> getYesNoReading({
    String? cardName,
    String? direction,
    String? language,
  }) async {
    final queryParams = <String, String>{};
    if (cardName != null && cardName.isNotEmpty) {
      queryParams['cardName'] = cardName;
    }
    if (direction != null && direction.isNotEmpty) {
      queryParams['direction'] = direction;
    }
    if (language != null && language.isNotEmpty) {
      queryParams['lang'] = language;
    }
    final jsonData = await _makeApiCall(
      EndPoints.tarotYesNo,
      queryParams: queryParams,
      language: language,
    );
    debugPrint('🔍 Yes/No API Response: ${jsonEncode(jsonData)}');

    // Check if the JSON response indicates an error (status 400 = card not suitable)
    final jsonStatus = jsonData['status'];
    if (jsonStatus != null && jsonStatus != 200) {
      String errorMessage = 'Card not suitable for Yes/No reading';
      if (jsonData['message'] != null) {
        errorMessage = jsonData['message'].toString();
      } else if (jsonData['error'] != null) {
        errorMessage = jsonData['error'].toString();
      }
      debugPrint(
        '❌ Yes/No API Error - Status: $jsonStatus, Message: $errorMessage',
      );
      throw Exception(
        'Yes/No API Error: Status: $jsonStatus, Message: $errorMessage',
      );
    }

    try {
      final result = TarotYesNoResponse.fromJson(jsonData);
      debugPrint('✅ Yes/No Parsed - cardImage keys: ${result.cardImage.keys}');
      return result;
    } catch (e, stackTrace) {
      debugPrint('❌ Yes/No Parsing Error: $e');
      debugPrint('❌ Stack Trace: $stackTrace');
      rethrow;
    }
  }

  /// Career Guidance
  Future<TarotCareerResponse> getCareerReading({
    String? cardName,
    String? direction,
    String? language,
  }) async {
    final queryParams = <String, String>{};
    if (cardName != null && cardName.isNotEmpty) {
      queryParams['cardName'] = cardName;
    }
    if (direction != null && direction.isNotEmpty) {
      queryParams['direction'] = direction;
    }
    if (language != null && language.isNotEmpty) {
      queryParams['lang'] = language;
    }
    final jsonData = await _makeApiCall(
      EndPoints.tarotCareer,
      queryParams: queryParams,
      language: language,
    );
    debugPrint('🔍 Career API Response: ${jsonEncode(jsonData)}');

    // Check if the JSON response indicates an error (status 400 = card not suitable)
    final jsonStatus = jsonData['status'];
    if (jsonStatus != null && jsonStatus != 200) {
      String errorMessage = 'Card not suitable for Career reading';
      if (jsonData['message'] != null) {
        errorMessage = jsonData['message'].toString();
      } else if (jsonData['error'] != null) {
        errorMessage = jsonData['error'].toString();
      }
      debugPrint(
        '❌ Career API Error - Status: $jsonStatus, Message: $errorMessage',
      );
      throw Exception(
        'Career API Error: Status: $jsonStatus, Message: $errorMessage',
      );
    }

    try {
      final result = TarotCareerResponse.fromJson(jsonData);
      debugPrint('✅ Career Parsed - cardImage keys: ${result.cardImage.keys}');
      return result;
    } catch (e, stackTrace) {
      debugPrint('❌ Career Parsing Error: $e');
      debugPrint('❌ Stack Trace: $stackTrace');
      rethrow;
    }
  }

  /// Love Triangle Reading
  Future<TarotLoveTriangleResponse> getLoveTriangleReading({
    String? cardSelf,
    String? cardLover1,
    String? cardLover2,
    String? language,
  }) async {
    final queryParams = <String, String>{};
    if (cardSelf != null && cardSelf.isNotEmpty) {
      queryParams['cardSelf'] = cardSelf;
    }
    if (cardLover1 != null && cardLover1.isNotEmpty) {
      queryParams['cardLover1'] = cardLover1;
    }
    if (cardLover2 != null && cardLover2.isNotEmpty) {
      queryParams['cardLover2'] = cardLover2;
    }
    if (language != null && language.isNotEmpty) {
      queryParams['lang'] = language;
    }
    final jsonData = await _makeApiCall(
      EndPoints.tarotLoveTriangle,
      queryParams: queryParams,
      language: language,
    );
    debugPrint('🔍 Love Triangle API Response: ${jsonEncode(jsonData)}');

    // Check if the JSON response indicates an error
    final jsonStatus = jsonData['status'];
    if (jsonStatus != null && jsonStatus != 200) {
      // Try to extract a meaningful error message
      String errorMessage = 'API returned an error';
      if (jsonData['message'] != null) {
        errorMessage = jsonData['message'].toString();
      } else if (jsonData['error'] != null) {
        errorMessage = jsonData['error'].toString();
      } else if (jsonData['response'] != null && jsonData['response'] is Map) {
        final responseData = jsonData['response'] as Map;
        if (responseData['message'] != null) {
          errorMessage = responseData['message'].toString();
        } else if (responseData['error'] != null) {
          errorMessage = responseData['error'].toString();
        }
      }
      debugPrint(
        '❌ Love Triangle API Error - Status: $jsonStatus, Message: $errorMessage',
      );
      throw Exception(
        'Love Triangle API Error: Status: $jsonStatus, Message: $errorMessage',
      );
    }

    try {
      return TarotLoveTriangleResponse.fromJson(jsonData);
    } catch (e, stackTrace) {
      debugPrint('❌ Love Triangle Parsing Error: $e');
      debugPrint('❌ Stack Trace: $stackTrace');
      debugPrint('❌ Response Data: ${jsonEncode(jsonData)}');
      rethrow;
    }
  }

  /// In-Depth Love Reading
  Future<TarotInDepthLoveResponse> getInDepthLoveReading({
    String? cardName,
    String? language,
  }) async {
    final queryParams = <String, String>{};
    if (cardName != null && cardName.isNotEmpty) {
      queryParams['cardName'] = cardName;
    }
    if (language != null && language.isNotEmpty) {
      queryParams['lang'] = language;
    }
    final jsonData = await _makeApiCall(
      EndPoints.tarotInDepthLove,
      queryParams: queryParams,
      language: language,
    );
    debugPrint('🔍 In-Depth Love API Response: ${jsonEncode(jsonData)}');

    // Check if the JSON response indicates an error
    final jsonStatus = jsonData['status'];
    if (jsonStatus != null && jsonStatus != 200) {
      // Try to extract a meaningful error message
      String errorMessage = 'API returned an error';
      if (jsonData['message'] != null) {
        errorMessage = jsonData['message'].toString();
      } else if (jsonData['error'] != null) {
        errorMessage = jsonData['error'].toString();
      } else if (jsonData['response'] != null && jsonData['response'] is Map) {
        final responseData = jsonData['response'] as Map;
        if (responseData['message'] != null) {
          errorMessage = responseData['message'].toString();
        } else if (responseData['error'] != null) {
          errorMessage = responseData['error'].toString();
        }
      }
      debugPrint(
        '❌ In-Depth Love API Error - Status: $jsonStatus, Message: $errorMessage',
      );
      throw Exception(
        'In-Depth Love API Error: Status: $jsonStatus, Message: $errorMessage',
      );
    }

    try {
      final result = TarotInDepthLoveResponse.fromJson(jsonData);
      debugPrint(
        '✅ In-Depth Love Parsed - cardImage keys: ${result.cardImage.keys}',
      );
      return result;
    } catch (e, stackTrace) {
      debugPrint('❌ In-Depth Love Parsing Error: $e');
      debugPrint('❌ Stack Trace: $stackTrace');
      rethrow;
    }
  }

  /// Erotic Love Reading
  Future<TarotEroticLoveResponse> getEroticLoveReading({
    String? cardName,
    String? language,
  }) async {
    final queryParams = <String, String>{};
    if (cardName != null && cardName.isNotEmpty) {
      queryParams['cardName'] = cardName;
    }
    if (language != null && language.isNotEmpty) {
      queryParams['lang'] = language;
    }
    final jsonData = await _makeApiCall(
      EndPoints.tarotEroticLove,
      queryParams: queryParams,
      language: language,
    );
    debugPrint('🔍 Erotic Love API Response: ${jsonEncode(jsonData)}');

    // Check if the JSON response indicates an error
    final jsonStatus = jsonData['status'];
    if (jsonStatus != null && jsonStatus != 200) {
      String errorMessage = 'API returned an error';
      if (jsonData['message'] != null) {
        errorMessage = jsonData['message'].toString();
      } else if (jsonData['error'] != null) {
        errorMessage = jsonData['error'].toString();
      }
      debugPrint(
        '❌ Erotic Love API Error - Status: $jsonStatus, Message: $errorMessage',
      );
      throw Exception(
        'Erotic Love API Error: Status: $jsonStatus, Message: $errorMessage',
      );
    }

    try {
      final result = TarotEroticLoveResponse.fromJson(jsonData);
      debugPrint(
        '✅ Erotic Love Parsed - cardImage keys: ${result.cardImage.keys}',
      );
      return result;
    } catch (e, stackTrace) {
      debugPrint('❌ Erotic Love Parsing Error: $e');
      debugPrint('❌ Stack Trace: $stackTrace');
      rethrow;
    }
  }

  /// Made for Each Other Reading
  Future<TarotMadeForEachOtherResponse> getMadeForEachOtherReading({
    String? cardName,
    String? language,
  }) async {
    final queryParams = <String, String>{};
    if (cardName != null && cardName.isNotEmpty) {
      queryParams['cardName'] = cardName;
    }
    if (language != null && language.isNotEmpty) {
      queryParams['lang'] = language;
    }
    final jsonData = await _makeApiCall(
      EndPoints.tarotMadeForEachOther,
      queryParams: queryParams,
      language: language,
    );
    debugPrint('🔍 Made For Each Other API Response: ${jsonEncode(jsonData)}');

    // Check if the JSON response indicates an error
    final jsonStatus = jsonData['status'];
    if (jsonStatus != null && jsonStatus != 200) {
      String errorMessage = 'API returned an error';
      if (jsonData['message'] != null) {
        errorMessage = jsonData['message'].toString();
      } else if (jsonData['error'] != null) {
        errorMessage = jsonData['error'].toString();
      }
      debugPrint(
        '❌ Made For Each Other API Error - Status: $jsonStatus, Message: $errorMessage',
      );
      throw Exception(
        'Made For Each Other API Error: Status: $jsonStatus, Message: $errorMessage',
      );
    }

    try {
      final result = TarotMadeForEachOtherResponse.fromJson(jsonData);
      debugPrint(
        '✅ Made For Each Other Parsed - cardImage keys: ${result.cardImage.keys}',
      );
      return result;
    } catch (e, stackTrace) {
      debugPrint('❌ Made For Each Other Parsing Error: $e');
      debugPrint('❌ Stack Trace: $stackTrace');
      rethrow;
    }
  }

  /// Flirt Reading
  Future<TarotFlirtReadingResponse> getFlirtReading({
    String? cardName,
    String? language,
  }) async {
    final queryParams = <String, String>{};
    if (cardName != null && cardName.isNotEmpty) {
      queryParams['cardName'] = cardName;
    }
    if (language != null && language.isNotEmpty) {
      queryParams['lang'] = language;
    }
    final jsonData = await _makeApiCall(
      EndPoints.tarotFlirtReading,
      queryParams: queryParams,
      language: language,
    );
    debugPrint('🔍 Flirt Reading API Response: ${jsonEncode(jsonData)}');

    // Check if the JSON response indicates an error
    final jsonStatus = jsonData['status'];
    if (jsonStatus != null && jsonStatus != 200) {
      String errorMessage = 'API returned an error';
      if (jsonData['message'] != null) {
        errorMessage = jsonData['message'].toString();
      } else if (jsonData['error'] != null) {
        errorMessage = jsonData['error'].toString();
      }
      debugPrint(
        '❌ Flirt Reading API Error - Status: $jsonStatus, Message: $errorMessage',
      );
      throw Exception(
        'Flirt Reading API Error: Status: $jsonStatus, Message: $errorMessage',
      );
    }

    try {
      final result = TarotFlirtReadingResponse.fromJson(jsonData);
      debugPrint(
        '✅ Flirt Reading Parsed - cardImage keys: ${result.cardImage.keys}',
      );
      return result;
    } catch (e, stackTrace) {
      debugPrint('❌ Flirt Reading Parsing Error: $e');
      debugPrint('❌ Stack Trace: $stackTrace');
      rethrow;
    }
  }

  /// Daily Guidance
  Future<TarotDailyResponse> getDailyReading({
    String? cardName,
    String? language,
  }) async {
    final queryParams = <String, String>{};
    if (cardName != null && cardName.isNotEmpty) {
      queryParams['cardName'] = cardName;
    }
    if (language != null && language.isNotEmpty) {
      queryParams['lang'] = language;
    }
    final jsonData = await _makeApiCall(
      EndPoints.tarotDaily,
      queryParams: queryParams,
      language: language,
    );
    debugPrint('🔍 Daily API Response: ${jsonEncode(jsonData)}');

    // Check if the JSON response indicates an error (status 400 = card not suitable)
    final jsonStatus = jsonData['status'];
    if (jsonStatus != null && jsonStatus != 200) {
      String errorMessage = 'API returned an error';
      if (jsonData['message'] != null) {
        errorMessage = jsonData['message'].toString();
      } else if (jsonData['error'] != null) {
        errorMessage = jsonData['error'].toString();
      }
      debugPrint(
        '❌ Daily API Error - Status: $jsonStatus, Message: $errorMessage',
      );
      throw Exception(
        'Daily API Error: Status: $jsonStatus, Message: $errorMessage',
      );
    }

    try {
      final result = TarotDailyResponse.fromJson(jsonData);
      debugPrint('✅ Daily Parsed - cardImage keys: ${result.cardImage.keys}');

      // CRITICAL: Check if ALL segments are empty (no guidance available)
      // This prevents showing a reading where all areas say "No guidance available"
      final hasHealth = result.health.trim().isNotEmpty;
      final hasRelationship = result.relationship.trim().isNotEmpty;
      final hasCareer = result.career.trim().isNotEmpty;
      final hasFinance = result.finance.trim().isNotEmpty;

      if (!hasHealth && !hasRelationship && !hasCareer && !hasFinance) {
        debugPrint(
          '❌ Daily Reading - All segments are empty (no guidance available)',
        );
        debugPrint(
          '   Health: empty, Relationship: empty, Career: empty, Finance: empty',
        );
        throw Exception(
          'Daily API Error: Status: 400, Message: Card not suitable - no guidance available for any area',
        );
      }

      debugPrint(
        '✅ Daily Reading - Has content: Health=$hasHealth, Relationship=$hasRelationship, Career=$hasCareer, Finance=$hasFinance',
      );
      return result;
    } catch (e, stackTrace) {
      debugPrint('❌ Daily Parsing Error: $e');
      debugPrint('❌ Stack Trace: $stackTrace');
      rethrow;
    }
  }

  /// Romantic Breakup Reading
  Future<TarotRomanticBreakupResponse> getRomanticBreakupReading({
    String? cardCause,
    String? cardAdvise,
    String? language,
  }) async {
    final queryParams = <String, String>{};
    if (cardCause != null && cardCause.isNotEmpty) {
      queryParams['cardCause'] = cardCause;
    }
    if (cardAdvise != null && cardAdvise.isNotEmpty) {
      queryParams['cardAdvise'] = cardAdvise;
    }
    if (language != null && language.isNotEmpty) {
      queryParams['lang'] = language;
    }
    final jsonData = await _makeApiCall(
      EndPoints.tarotRomanticBreakup,
      queryParams: queryParams,
      language: language,
    );
    debugPrint('🔍 Romantic Breakup API Response: ${jsonEncode(jsonData)}');

    // Check if the JSON response indicates an error
    final jsonStatus = jsonData['status'];
    if (jsonStatus != null && jsonStatus != 200) {
      // Try to extract a meaningful error message
      String errorMessage = 'API returned an error';
      if (jsonData['message'] != null) {
        errorMessage = jsonData['message'].toString();
      } else if (jsonData['error'] != null) {
        errorMessage = jsonData['error'].toString();
      } else if (jsonData['response'] != null && jsonData['response'] is Map) {
        final responseData = jsonData['response'] as Map;
        if (responseData['message'] != null) {
          errorMessage = responseData['message'].toString();
        } else if (responseData['error'] != null) {
          errorMessage = responseData['error'].toString();
        }
      }
      debugPrint(
        '❌ Romantic Breakup API Error - Status: $jsonStatus, Message: $errorMessage',
      );
      throw Exception(
        'Romantic Breakup API Error: Status: $jsonStatus, Message: $errorMessage',
      );
    }

    try {
      return TarotRomanticBreakupResponse.fromJson(jsonData);
    } catch (e, stackTrace) {
      debugPrint('❌ Romantic Breakup Parsing Error: $e');
      debugPrint('❌ Stack Trace: $stackTrace');
      debugPrint('❌ Response Data: ${jsonEncode(jsonData)}');
      rethrow;
    }
  }

  /// Business Breakup Reading
  Future<TarotBusinessBreakupResponse> getBusinessBreakupReading({
    String? cardCause,
    String? cardAdvise,
    String? language,
  }) async {
    final queryParams = <String, String>{};
    if (cardCause != null && cardCause.isNotEmpty) {
      queryParams['cardCause'] = cardCause;
    }
    if (cardAdvise != null && cardAdvise.isNotEmpty) {
      queryParams['cardAdvise'] = cardAdvise;
    }
    if (language != null && language.isNotEmpty) {
      queryParams['lang'] = language;
    }
    final jsonData = await _makeApiCall(
      EndPoints.tarotBusinessBreakup,
      queryParams: queryParams,
      language: language,
    );
    debugPrint('🔍 Business Breakup API Response: ${jsonEncode(jsonData)}');

    // Check if the JSON response indicates an error
    final jsonStatus = jsonData['status'];
    if (jsonStatus != null && jsonStatus != 200) {
      // Try to extract a meaningful error message
      String errorMessage = 'API returned an error';
      if (jsonData['message'] != null) {
        errorMessage = jsonData['message'].toString();
      } else if (jsonData['error'] != null) {
        errorMessage = jsonData['error'].toString();
      } else if (jsonData['response'] != null && jsonData['response'] is Map) {
        final responseData = jsonData['response'] as Map;
        if (responseData['message'] != null) {
          errorMessage = responseData['message'].toString();
        } else if (responseData['error'] != null) {
          errorMessage = responseData['error'].toString();
        }
      }
      debugPrint(
        '❌ Business Breakup API Error - Status: $jsonStatus, Message: $errorMessage',
      );
      throw Exception(
        'Business Breakup API Error: Status: $jsonStatus, Message: $errorMessage',
      );
    }

    try {
      return TarotBusinessBreakupResponse.fromJson(jsonData);
    } catch (e, stackTrace) {
      debugPrint('❌ Business Breakup Parsing Error: $e');
      debugPrint('❌ Stack Trace: $stackTrace');
      debugPrint('❌ Response Data: ${jsonEncode(jsonData)}');
      rethrow;
    }
  }

  /// Fortune Cookie
  Future<TarotFortuneCookieResponse> getFortuneCookie({
    String? language,
  }) async {
    final queryParams = <String, String>{};
    if (language != null && language.isNotEmpty) {
      queryParams['lang'] = language;
    }
    final jsonData = await _makeApiCall(
      EndPoints.tarotFortuneCookie,
      queryParams: queryParams.isEmpty ? null : queryParams,
      language: language,
    );
    return TarotFortuneCookieResponse.fromJson(jsonData);
  }
}
