import 'package:flutter/foundation.dart';

class ApiConstants {
  static const String _androidEmulatorBaseUrl = 'http://10.0.2.2:3000/api/';
  static const String _defaultBaseUrl = 'http://127.0.0.1:3000/api/';
  static const String _baseUrlOverride = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    final normalizedOverride = _normalizeBaseUrl(_baseUrlOverride);

    if (normalizedOverride != null) {
      return normalizedOverride;
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return _androidEmulatorBaseUrl;
    }

    return _defaultBaseUrl;
  }

  static String? _normalizeBaseUrl(String value) {
    final trimmedValue = value.trim();

    if (trimmedValue.isEmpty) {
      return null;
    }

    return trimmedValue.endsWith('/') ? trimmedValue : '$trimmedValue/';
  }

  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String refresh = 'auth/refresh';
  static const String logout = 'auth/logout';
  static const String profile = 'auth/me';
  static const String health = 'health';
}
