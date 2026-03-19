import 'package:flutter/material.dart';
import 'package:sanad/core/networking/api_exception.dart';
import 'package:sanad/core/networking/api_service.dart';
import 'package:sanad/features/auth/model/auth_user.dart';

class AuthController extends ChangeNotifier {
  AuthUser? _currentUser;
  String? _accessToken;
  String? _refreshToken;
  bool _isRefreshingProfile = false;
  bool _isLoggingOut = false;

  AuthUser? get currentUser => _currentUser;
  bool get isAuthenticated =>
      _currentUser != null &&
      _accessToken != null &&
      _accessToken!.isNotEmpty &&
      _refreshToken != null &&
      _refreshToken!.isNotEmpty;
  bool get isRefreshingProfile => _isRefreshingProfile;
  bool get isLoggingOut => _isLoggingOut;

  Future<void> login({
    required String nationalId,
    required String password,
  }) async {
    final response = await ApiService.instance.login(
      nationalId: nationalId,
      password: password,
    );

    _applyAuthResponse(response);
  }

  Future<void> register({
    required String fullName,
    required String nationalId,
    required String email,
    required String phone,
    required String dateOfBirth,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await ApiService.instance.register(
      fullName: fullName,
      nationalId: nationalId,
      email: email,
      phone: phone,
      dateOfBirth: dateOfBirth,
      password: password,
      confirmPassword: confirmPassword,
    );

    _applyAuthResponse(response);
  }

  Future<void> refreshProfile() async {
    if (!isAuthenticated || _isRefreshingProfile) {
      return;
    }

    _isRefreshingProfile = true;
    notifyListeners();

    try {
      final response = await _executeAuthorized(
        (accessToken) =>
            ApiService.instance.getProfile(accessToken: accessToken),
      );

      final userJson = response['user'];

      if (userJson is! Map<String, dynamic>) {
        throw const ApiException('استجابة المستخدم غير مكتملة');
      }

      _currentUser = AuthUser.fromJson(userJson);
    } finally {
      _isRefreshingProfile = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    if (_isLoggingOut) {
      return;
    }

    _isLoggingOut = true;
    notifyListeners();

    final refreshToken = _refreshToken;

    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await ApiService.instance.logout(refreshToken: refreshToken);
      }
    } catch (_) {
    } finally {
      _clearSession(notify: false);
      _isLoggingOut = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> _executeAuthorized(
    Future<Map<String, dynamic>> Function(String accessToken) request,
  ) async {
    final accessToken = _accessToken;

    if (accessToken == null || accessToken.isEmpty) {
      throw const ApiException('يجب تسجيل الدخول أولًا', statusCode: 401);
    }

    try {
      return await request(accessToken);
    } on ApiException catch (error) {
      if (!error.isUnauthorized) {
        rethrow;
      }

      await _refreshAuthSession();

      final refreshedAccessToken = _accessToken;

      if (refreshedAccessToken == null || refreshedAccessToken.isEmpty) {
        throw const ApiException(
          'انتهت الجلسة. سجل الدخول مرة أخرى',
          statusCode: 401,
        );
      }

      return request(refreshedAccessToken);
    }
  }

  Future<void> _refreshAuthSession() async {
    final refreshToken = _refreshToken;

    if (refreshToken == null || refreshToken.isEmpty) {
      _clearSession();
      throw const ApiException(
        'انتهت الجلسة. سجل الدخول مرة أخرى',
        statusCode: 401,
      );
    }

    try {
      final response = await ApiService.instance.refreshSession(
        refreshToken: refreshToken,
      );

      _applyAuthResponse(response, notify: false);
    } on ApiException {
      _clearSession(notify: false);
      rethrow;
    }
  }

  void _applyAuthResponse(Map<String, dynamic> response, {bool notify = true}) {
    final accessToken = response['accessToken'];
    final refreshToken = response['refreshToken'];
    final userJson = response['user'];

    if (accessToken is! String ||
        accessToken.isEmpty ||
        refreshToken is! String ||
        refreshToken.isEmpty ||
        userJson is! Map<String, dynamic>) {
      throw const ApiException('استجابة المصادقة غير مكتملة');
    }

    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _currentUser = AuthUser.fromJson(userJson);

    if (notify) {
      notifyListeners();
    }
  }

  void _clearSession({bool notify = true}) {
    _accessToken = null;
    _refreshToken = null;
    _currentUser = null;

    if (notify) {
      notifyListeners();
    }
  }
}
