import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'storage_service.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}

class ApiClient {
  final StorageService storageService;

  ApiClient({StorageService? storageService})
      : storageService = storageService ?? StorageService();

  Future<Map<String, String>> _headers({
    bool includeAuth = false,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth) {
      final token = await storageService.getToken();

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<dynamic> get(
    String path, {
    bool auth = false,
  }) async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}$path'),
      headers: await _headers(includeAuth: auth),
    );

    return _handleResponse(response);
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}$path'),
      headers: await _headers(includeAuth: auth),
      body: jsonEncode(body ?? {}),
    );

    return _handleResponse(response);
  }

  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    final response = await http.put(
      Uri.parse('${AppConfig.baseUrl}$path'),
      headers: await _headers(includeAuth: auth),
      body: jsonEncode(body ?? {}),
    );

    return _handleResponse(response);
  }

  Future<dynamic> delete(
    String path, {
    bool auth = false,
  }) async {
    final response = await http.delete(
      Uri.parse('${AppConfig.baseUrl}$path'),
      headers: await _headers(includeAuth: auth),
    );

    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    dynamic decoded;

    try {
      decoded = response.body.isEmpty ? null : jsonDecode(response.body);
    } catch (_) {
      decoded = null;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    String message = 'Có lỗi xảy ra';

    if (decoded is Map<String, dynamic>) {
      message = decoded['message'] ?? message;
    }

    if (response.statusCode == 401) {
      message = 'Phiên đăng nhập đã hết hạn hoặc token không hợp lệ';
    }

    if (response.statusCode == 403) {
      message = 'Bạn không có quyền thực hiện thao tác này';
    }

    throw ApiException(response.statusCode, message);
  }
}