import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:flutter/foundation.dart';

/// Service for handling search queries and mapping them to routes
class DashboardSearchService {
  /// Search for a route based on query keywords
  /// Returns the route string if found, null otherwise
  String? searchRoute(String query) {
    if (query.trim().isEmpty) return null;

    final lowerQuery = query.toLowerCase().trim();

    // Tarot Card Reading
    if (lowerQuery.contains('tarot') || 
        lowerQuery.contains('card') ||
        lowerQuery.contains('तारो') ||
        lowerQuery.contains('तारो कार्ड')) {
      return AppRoutes.tarotReading;
    }

    // Kundli / Birth Chart
    if (lowerQuery.contains('kundli') || 
        lowerQuery.contains('chart') ||
        lowerQuery.contains('birth') ||
        lowerQuery.contains('कुंडली') ||
        lowerQuery.contains('कुण्डली') ||
        lowerQuery.contains('जन्मपत्री') ||
        lowerQuery.contains('जन्म कुंडली')) {
      return AppRoutes.kundliForm;
    }

    // Horoscope / Rashifal
    if (lowerQuery.contains('horoscope') || 
        lowerQuery.contains('rashifal') ||
        lowerQuery.contains('rashi') ||
        lowerQuery.contains('राशिफल') ||
        lowerQuery.contains('होरोस्कोप')) {
      return AppRoutes.horoscope;
    }

    // Live Astrologer / Consultation
    if (lowerQuery.contains('astrologer') || 
        lowerQuery.contains('live') || 
        lowerQuery.contains('consult') ||
        lowerQuery.contains('consultation') ||
        lowerQuery.contains('ज्योतिषी') ||
        lowerQuery.contains('एस्ट्रोलॉजर') ||
        lowerQuery.contains('लाइव ज्योतिषी')) {
      return AppRoutes.liveAstrologers;
    }

    // Panchang
    if (lowerQuery.contains('panchang') ||
        lowerQuery.contains('पंचांग')) {
      return AppRoutes.panchang;
    }

    // Numerology
    if (lowerQuery.contains('numerology') ||
        lowerQuery.contains('अंक ज्योतिष') ||
        lowerQuery.contains('न्यूमेरोलॉजी')) {
      return AppRoutes.numerology;
    }

    // Palm Reading
    if (lowerQuery.contains('palm') || 
        lowerQuery.contains('hast') ||
        lowerQuery.contains('hand') ||
        lowerQuery.contains('हस्त') ||
        lowerQuery.contains('हस्त रेखा')) {
      return AppRoutes.palmReading;
    }

    // Face Reading
    if (lowerQuery.contains('face') || 
        lowerQuery.contains('mukh') ||
        lowerQuery.contains('मुख') ||
        lowerQuery.contains('मुख रेखा')) {
      return AppRoutes.faceReading;
    }

    // Match Making
    if (lowerQuery.contains('match') || 
        lowerQuery.contains('kundli') ||
        lowerQuery.contains('compatibility') ||
        lowerQuery.contains('मिलान') ||
        lowerQuery.contains('कुंडली मिलान')) {
      return AppRoutes.matchMakingForm;
    }

    // Handwriting Astrology
    if (lowerQuery.contains('handwriting') ||
        lowerQuery.contains('signature') ||
        lowerQuery.contains('हस्तलेख')) {
      return AppRoutes.handwritingAstrology;
    }

    // Courses
    if (lowerQuery.contains('course') ||
        lowerQuery.contains('education') ||
        lowerQuery.contains('learn') ||
        lowerQuery.contains('पाठ्यक्रम')) {
      return AppRoutes.courses;
    }

    // Blogs
    if (lowerQuery.contains('blog') ||
        lowerQuery.contains('article') ||
        lowerQuery.contains('ब्लॉग')) {
      return AppRoutes.allBlogs;
    }

    // Wallet
    if (lowerQuery.contains('wallet') ||
        lowerQuery.contains('balance') ||
        lowerQuery.contains('पर्स')) {
      return AppRoutes.wallet;
    }

    // Profile
    if (lowerQuery.contains('profile') ||
        lowerQuery.contains('account') ||
        lowerQuery.contains('प्रोफ़ाइल')) {
      return AppRoutes.profile;
    }

    // Cart
    if (lowerQuery.contains('cart') ||
        lowerQuery.contains('basket') ||
        lowerQuery.contains('टोकरी')) {
      return AppRoutes.cart;
    }

    // Orders
    if (lowerQuery.contains('order') ||
        lowerQuery.contains('purchase') ||
        lowerQuery.contains('ऑर्डर')) {
      return AppRoutes.orders;
    }

    // Astrology Services
    if (lowerQuery.contains('service') ||
        lowerQuery.contains('services') ||
        lowerQuery.contains('सेवा')) {
      return AppRoutes.astrologyServices;
    }

    // No match found
    if (kDebugMode) {
      debugPrint('Dashboard Search: No route found for query: "$query"');
    }
    return null;
  }
}

