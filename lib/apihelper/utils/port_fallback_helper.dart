import 'dart:io';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;

/// Centralised fallback logic for services that used to hit dedicated micro-service ports.
///
/// Strategy:
///   Port 8002 services (user AI: face-reading, navtara, kundli, matchmaking)
///       primary  : http://3.109.91.254:8000/api/users
///       fallback : http://3.109.91.254:8002
///
///   Port 8009 services (chat / call REST)
///       primary  : http://3.109.91.254:8000/api/calls
///       fallback : http://3.109.91.254:8009
///
///   Socket.IO (chat / call / live-stream)
///       primary  : http://3.109.91.254:8000   (gateway)
///       fallback : http://3.109.91.254:8009
class PortFallbackHelper {
  static const String _primaryHost = 'http://3.109.91.254:8000';
  static const String _port8002Host = 'http://3.109.91.254:8002';
  static const String _port8009Host = 'http://3.109.91.254:8009';

  static const String usersApiPrimary = '$_primaryHost/api/users';
  static const String usersApiFallback = _port8002Host;

  static const String callsApiPrimary = '$_primaryHost/api/calls';
  static const String callsApiFallback = _port8009Host;

  static const String socketPrimary = _primaryHost;
  static const String socketFallback = _port8009Host;

  static Future<http.Response> callWithFallback({
    required Future<http.Response> Function() primary,
    required Future<http.Response> Function() fallback,
  }) async {
    try {
      return await primary();
    } on SocketException catch (e) {
      dev.log('[PortFallback] SocketException -> fallback. Reason: $e');
      return await fallback();
    } on http.ClientException catch (e) {
      if (_isConnectionError(e.message)) {
        dev.log('[PortFallback] ClientException "${e.message}" -> fallback');
        return await fallback();
      }
      rethrow;
    }
  }

  static Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 20),
  }) =>
      http.get(Uri.parse(url), headers: headers).timeout(timeout);

  static Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    String? body,
    Duration timeout = const Duration(seconds: 20),
  }) =>
      http.post(Uri.parse(url), headers: headers, body: body).timeout(timeout);

  static Future<http.Response> put(
    String url, {
    Map<String, String>? headers,
    String? body,
    Duration timeout = const Duration(seconds: 20),
  }) =>
      http.put(Uri.parse(url), headers: headers, body: body).timeout(timeout);

  static Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 20),
  }) =>
      http.delete(Uri.parse(url), headers: headers).timeout(timeout);

  static bool _isConnectionError(String message) {
    final lower = message.toLowerCase();
    return lower.contains('connection refused') ||
        lower.contains('connection failed') ||
        lower.contains('connection reset') ||
        lower.contains('failed host lookup') ||
        lower.contains('no route to host') ||
        lower.contains('network is unreachable');
  }
}