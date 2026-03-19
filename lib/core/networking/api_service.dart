import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_constants.dart';
import 'api_exception.dart';

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();
  static const Duration _requestTimeout = Duration(seconds: 15);

  final http.Client _client = http.Client();

  Future<Map<String, dynamic>> login({
    required String nationalId,
    required String password,
  }) {
    return _post(
      endpoint: ApiConstants.login,
      body: {'nationalId': nationalId, 'password': password},
    );
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String nationalId,
    required String email,
    required String phone,
    required String dateOfBirth,
    required String password,
    required String confirmPassword,
  }) {
    return _post(
      endpoint: ApiConstants.register,
      body: {
        'fullName': fullName,
        'nationalId': nationalId,
        'email': email,
        'phone': phone,
        'dateOfBirth': dateOfBirth,
        'password': password,
        'confirmPassword': confirmPassword,
      },
    );
  }

  Future<Map<String, dynamic>> refreshSession({required String refreshToken}) {
    return _post(
      endpoint: ApiConstants.refresh,
      body: {'refreshToken': refreshToken},
    );
  }

  Future<Map<String, dynamic>> logout({required String refreshToken}) {
    return _post(
      endpoint: ApiConstants.logout,
      body: {'refreshToken': refreshToken},
    );
  }

  Future<Map<String, dynamic>> getProfile({required String accessToken}) {
    return _get(endpoint: ApiConstants.profile, accessToken: accessToken);
  }

  Future<Map<String, dynamic>> _get({
    required String endpoint,
    String? accessToken,
  }) {
    return _request(
      endpoint: endpoint,
      method: 'GET',
      accessToken: accessToken,
    );
  }

  Future<Map<String, dynamic>> _post({
    required String endpoint,
    required Map<String, dynamic> body,
    String? accessToken,
  }) {
    return _request(
      endpoint: endpoint,
      method: 'POST',
      body: body,
      accessToken: accessToken,
    );
  }

  Future<Map<String, dynamic>> _request({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    String? accessToken,
  }) async {
    final responseUri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = <String, String>{
      'Accept': 'application/json',
      if (body != null) 'Content-Type': 'application/json',
      if (accessToken != null && accessToken.isNotEmpty)
        'Authorization': 'Bearer $accessToken',
    };

    try {
      final requestFuture = switch (method) {
        'GET' => _client.get(responseUri, headers: headers),
        'POST' => _client.post(
          responseUri,
          headers: headers,
          body: body == null ? null : jsonEncode(body),
        ),
        _ => throw const ApiException('طريقة الطلب غير مدعومة'),
      };

      final response = await requestFuture.timeout(_requestTimeout);
      final payload = _parsePayload(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return payload;
      }

      final message = payload['message'];

      if (message is String && message.trim().isNotEmpty) {
        throw ApiException(message, statusCode: response.statusCode);
      }

      throw ApiException(
        'فشل الطلب برمز ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } on TimeoutException {
      throw const ApiException('انتهت مهلة الاتصال بالسيرفر');
    } on http.ClientException {
      throw const ApiException(
        'تعذر الوصول إلى السيرفر. تأكد أن الباك إند شغال',
      );
    }
  }

  Map<String, dynamic> _parsePayload(String body) {
    if (body.trim().isEmpty) {
      return {};
    }

    try {
      final decoded = jsonDecode(body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      return {};
    }

    return {};
  }
}
