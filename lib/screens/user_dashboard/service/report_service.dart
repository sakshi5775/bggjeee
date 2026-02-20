import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/data_model/report_model.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:get/get.dart';

class ReportService {
  final ApiRepository _apiRepository = ApiRepository(apiClient: Get.find());

  /// Get report pricing list
  Future<List<ReportPricing>?> getPricing() async {
    if (!await LoginGuard.ensureLoggedIn(
      message: 'Please login to view report pricing',
    )) {
      return null;
    }

    try {
      final response = await _apiRepository.getApi<ReportPricingResponse>(
        EndPoints.reportBaseUrl + EndPoints.pdfPricing,
        decoder: (json) => ReportPricingResponse.fromJson(json),
      );

      if (response.statusCode == 200 && response.body != null) {
        return response.body!.data;
      }
      return null;
    } catch (e) {
      print('Error fetching report pricing: $e');
      return null;
    }
  }

  /// Generate standard Kundli PDF
  /// Requires: name, date, time, lat, lon, tz, lang, style, place, etc.
  Future<String?> generateReport({
    required Map<String, dynamic> params,
    String? reportPath,
  }) async {
    if (!await LoginGuard.ensureLoggedIn(
      message: 'Please login to generate reports',
    )) {
      return null;
    }

    try {
      // Add required company details as per user request example
      final fullParams = {
        ...params,
        'company_name':
            'Parashari Indian Institute of Astrology & Research Centre Private Limited',
        'company_address': 'Vinamra Khand, Gomti Nagar, Lucknow, Uttar Pradesh',
        'company_email': 'astrobharatai@gmail.com',
        'company_phone': '+919956025055',
        'company_website': 'https://astrobharatai.com/',
      };

      // Map the report key to the correct backend endpoint
      final endpoint = _mapReportKeyToEndpoint(reportPath, isMatching: false);

      // Clean up params: only pdf/generate needs pdf_type
      if (endpoint != EndPoints.generatePdf) {
        fullParams.remove('pdf_type');
      }

      final response = await _apiRepository.getApi<ReportGenerateResponse>(
        EndPoints.reportBaseUrl + endpoint,
        query: fullParams,
        decoder: (json) => ReportGenerateResponse.fromJson(json),
      );

      print('Report Generation Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final body = response.body;
        if (body != null) {
          print('Report Generation Success: ${body.downloadUrl}');
          return body.downloadUrl ?? '';
        } else {
          print(
            'Report Generation Error: Response body is null despite 200 status',
          );
          return null;
        }
      } else {
        print('Report generation failed with status: ${response.statusCode}');
        print('Response body: ${response.bodyString}');
        return null;
      }
    } catch (e) {
      print('Error generating report: $e');
      if (e is Response) {
        print('Error Response Body (from Response): ${e.bodyString}');
      }
      rethrow;
    }
  }

  /// Generate Kundli Matching PDF
  Future<String?> generateMatchingReport({
    required Map<String, dynamic> params,
    String? reportPath,
  }) async {
    if (!await LoginGuard.ensureLoggedIn(
      message: 'Please login to generate matching reports',
    )) {
      return null;
    }

    try {
      // Add required company details
      final fullParams = {
        ...params,
        'company_name':
            'Parashari Indian Institute of Astrology & Research Centre Private Limited',
        'company_address': 'Vinamra Khand, Gomti Nagar, Lucknow, Uttar Pradesh',
        'company_email': 'astrobharatai@gmail.com',
        'company_phone': '+919956025055',
        'company_website': 'https://astrobharatai.com/',
      };

      // Map the report key to the correct backend endpoint
      final endpoint = _mapReportKeyToEndpoint(reportPath, isMatching: true);

      // Matching reports never need pdf_type
      fullParams.remove('pdf_type');

      final response = await _apiRepository.getApi<ReportGenerateResponse>(
        EndPoints.reportBaseUrl + endpoint,
        query: fullParams,
        decoder: (json) => ReportGenerateResponse.fromJson(json),
      );

      print('Matching Report Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final body = response.body;
        if (body != null) {
          print('Matching Report Success: ${body.downloadUrl}');
          return body.downloadUrl ?? '';
        } else {
          print(
            'Matching Report Error: Response body is null despite 200 status',
          );
          return null;
        }
      } else {
        print(
          'Matching report generation failed with status: ${response.statusCode}',
        );
        print('Response body: ${response.bodyString}');
        return null;
      }
    } catch (e) {
      print('Error generating matching report: $e');
      if (e is Response) {
        print('Error response body: ${e.bodyString}');
      }
      rethrow;
    }
  }

  /// Map pricing report keys to actual backend endpoints.
  /// This handles mismatches between the pricing API and the specialized routes.
  String _mapReportKeyToEndpoint(String? key, {required bool isMatching}) {
    if (key == null) {
      return isMatching ? EndPoints.generateMatchingPdf : EndPoints.generatePdf;
    }

    // Default specialized path prefix
    final String prefix = 'pdf/';

    // Normalizing keys to handle various formats from backend
    switch (key.toLowerCase()) {
      // Basic mappings
      case 'horoscope_small':
      case 'horoscope_medium':
      case 'horoscope_large':
        return EndPoints.generatePdf;
      case 'matching_pdf':
        return EndPoints.generateMatchingPdf;

      // Specialized report mappings (mapping snake_case to correct backend paths)
      case 'foreign_travel_report':
        return '${prefix}foreign_travel_report';
      case 'government_job_report':
        return '${prefix}government_job_report';
      case 'financial_opportunities_and_challenges_report':
        return '${prefix}financial_opportunities_and_challenges_report';
      case 'education_and_learning_pathways_report':
        return '${prefix}education_and_learning_pathways_report';
      case 'kundali_samyak':
        return '${prefix}kundali_samyak';
      case 'kundali_dirgha_drishti':
      case 'kundali_dirghadrishti':
        return '${prefix}kundali_dirghaDrishti';
      case 'kundali_mool_patrika':
      case 'kundali_moolpatrika':
        return '${prefix}Kundali_moolPatrika';
      case 'vedic_five_year_predictions':
        return '${prefix}vedic_five_year_predictions';
      case 'vedic_ten_year_predictions':
        return '${prefix}vedic_ten_year_predictions';
      case 'vedic_fifteen_year_predictions':
        return '${prefix}vedic_fifteen_year_predictions';
      case 'destiny_of_heart':
        return '${prefix}destiny_of_heart';

      // Fallback: If it already looks like a path, use it, otherwise prepend prefix
      default:
        return key.startsWith(prefix) ? key : prefix + key;
    }
  }
}
