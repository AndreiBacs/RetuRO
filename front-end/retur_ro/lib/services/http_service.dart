import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'config_service.dart';
import '../config/app_config.dart';

class HttpService {
  static Duration get _timeout => Duration(seconds: AppConfig.defaultTimeoutSeconds);

  static final HttpService _instance = HttpService._internal();
  factory HttpService() => _instance;
  HttpService._internal();

  late http.Client _client;
  // String? _authToken;

  void initialize() {
    _client = http.Client();
  }

  // void setAuthToken(String token) {
  //   _authToken = token;
  // }

  // void clearAuthToken() {
  //   _authToken = null;
  // }

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // if (_authToken != null) {
    //   headers['Authorization'] = 'Bearer $_authToken';
    // }

    return headers;
  }

  // GET request
  Future<HttpResponse> get(
    String endpoint, {
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);

      if (kDebugMode) {
        print('GET: $uri');
      }

      final response = await _client
          .get(uri, headers: _headers)
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // POST request
  Future<HttpResponse> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);

      if (kDebugMode) {
        print('POST: $uri');
        if (body != null) print('Body: $body');
      }

      final response = await _client
          .post(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // PUT request
  Future<HttpResponse> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);

      if (kDebugMode) {
        print('PUT: $uri');
        if (body != null) print('Body: $body');
      }

      final response = await _client
          .put(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // DELETE request
  Future<HttpResponse> delete(
    String endpoint, {
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);

      if (kDebugMode) {
        print('DELETE: $uri');
      }

      final response = await _client
          .delete(uri, headers: _headers)
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // PATCH request
  Future<HttpResponse> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);

      if (kDebugMode) {
        print('PATCH: $uri');
        if (body != null) print('Body: $body');
      }

      final response = await _client
          .patch(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Uri _buildUri(String endpoint, Map<String, String>? queryParameters) {
    // Ensure proper path joining
    final configService = ConfigService();
    final baseUrl = configService.baseUrl.endsWith('/')
        ? configService.baseUrl.substring(0, configService.baseUrl.length - 1)
        : configService.baseUrl;
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    final uri = Uri.parse('$baseUrl$path');

    if (queryParameters != null) {
      return uri.replace(queryParameters: queryParameters);
    }

    return uri;
  }

  HttpResponse _handleResponse(http.Response response) {
    if (kDebugMode) {
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }

    try {
      final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      // Handle ApiResponse format from backend
      if (data is Map<String, dynamic>) {
        final apiResponse = data;
        final success = apiResponse['success'] as bool? ?? false;
        final responseData = apiResponse['data'];
        final message =
            apiResponse['message'] as String? ??
            apiResponse['error'] as String? ??
            _getStatusMessage(response.statusCode);

        return HttpResponse(
          success:
              success &&
              response.statusCode >= 200 &&
              response.statusCode < 300,
          statusCode: response.statusCode,
          data: responseData,
          message: message,
        );
      }

      // Fallback for non-ApiResponse format
      return HttpResponse(
        success: response.statusCode >= 200 && response.statusCode < 300,
        statusCode: response.statusCode,
        data: data,
        message: _getStatusMessage(response.statusCode),
      );
    } catch (e) {
      return HttpResponse(
        success: false,
        statusCode: response.statusCode,
        data: null,
        message: 'Failed to parse response: $e',
      );
    }
  }

  HttpResponse _handleError(dynamic error) {
    if (kDebugMode) {
      print('HTTP Error: $error');
    }

    String message;
    if (error is http.ClientException) {
      message = 'Network error: ${error.message}';
    } else if (error.toString().contains('timeout')) {
      message = 'Request timeout';
    } else {
      message = 'Unexpected error: $error';
    }

    return HttpResponse(
      success: false,
      statusCode: 0,
      data: null,
      message: message,
    );
  }

  String _getStatusMessage(int statusCode) {
    switch (statusCode) {
      case 200:
        return 'OK';
      case 201:
        return 'Created';
      case 204:
        return 'No Content';
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not Found';
      case 500:
        return 'Internal Server Error';
      default:
        return 'Status: $statusCode';
    }
  }

  void dispose() {
    _client.close();
  }
}

class HttpResponse {
  final bool success;
  final int statusCode;
  final dynamic data;
  final String message;

  HttpResponse({
    required this.success,
    required this.statusCode,
    required this.data,
    required this.message,
  });

  @override
  String toString() {
    return 'HttpResponse(success: $success, statusCode: $statusCode, message: $message, data: $data)';
  }
}

// API endpoints constants
class ApiEndpoints {
  // Barcode endpoints
  static const String barcodeCheck = '/barcodes/check';
}
