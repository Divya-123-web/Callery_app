import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// Error thrown for any failed API call. [message] is safe to show to the user.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

/// Small helper used by all services (auth, lists).
/// Base URL comes from the company's Mock API V2 documentation.
class ApiClient {
  ApiClient._();

  static const String _host = 'mock-api.calleyacd.com';
  static const String baseUrl = 'https://$_host/api';
  static const Duration _timeout = Duration(seconds: 20);

  /// The company's mock server presents a certificate whose name does not
  /// match its host ("Hostname mismatch"). We accept it ONLY for this one
  /// mock host; every other host is still fully verified.
  static http.Client _createClient() {
    final inner = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => host == _host;
    return IOClient(inner);
  }

  /// POST with a JSON body.
  static Future<dynamic> post(String path, Map<String, dynamic> body) {
    return _send('POST', path, body: body);
  }

  /// GET. The list-details API needs a JSON body on GET, so [body] is optional.
  static Future<dynamic> get(
    String path, {
    Map<String, String>? query,
    Map<String, dynamic>? body,
  }) {
    return _send('GET', path, query: query, body: body);
  }

  static Future<dynamic> _send(
    String method,
    String path, {
    Map<String, String>? query,
    Map<String, dynamic>? body,
  }) async {
    final client = _createClient();
    try {
      final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
      final request = http.Request(method, uri);
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      if (body != null) {
        request.body = jsonEncode(body);
      }

      // ---- DEBUG LOG (request) ----
      final safeBody = body == null
          ? null
          : (Map<String, dynamic>.from(body)
            ..updateAll((k, v) => k == 'password' ? '***' : v));
      debugPrint('[API] $method $uri');
      debugPrint('[API] body: ${safeBody == null ? '-' : jsonEncode(safeBody)}');

      final streamed = await client.send(request).timeout(_timeout);
      final response = await http.Response.fromStream(streamed);

      // ---- DEBUG LOG (response) ----
      debugPrint('[API] status: ${response.statusCode}');
      debugPrint('[API] response: ${response.body}');

      dynamic data;
      if (response.body.isNotEmpty) {
        try {
          data = jsonDecode(response.body);
        } catch (_) {
          data = null;
        }
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      }

      String message = 'Something went wrong (${response.statusCode})';
      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      } else if (data is Map && data['error'] != null) {
        message = data['error'].toString();
      }
      throw ApiException(message, response.statusCode);
    } on ApiException {
      rethrow;
    } on SocketException catch (e) {
      debugPrint('[API] SocketException: $e');
      throw ApiException('No internet connection: ${e.message}');
    } on TimeoutException catch (e) {
      debugPrint('[API] TimeoutException: $e');
      throw ApiException('Request timed out. Please try again.');
    } on http.ClientException catch (e) {
      debugPrint('[API] ClientException: $e');
      throw ApiException('Could not reach the server: ${e.message}');
    } catch (e, st) {
      debugPrint('[API] ${e.runtimeType}: $e');
      debugPrint('$st');
      throw ApiException('${e.runtimeType}: $e');
    } finally {
      client.close();
    }
  }
}