import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  User? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  bool _isOfflineMode = false;
  String? _error;

  AuthProvider(this._authRepository);

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  bool get isOfflineMode => _isOfflineMode;
  String? get error => _error;

  bool _isUnreachable(Object e) {
    if (e is! DioException) return true;
    if (e.type == DioExceptionType.badResponse) {
      final status = e.response?.statusCode ?? 0;
      return status < 400 || status >= 500;
    }
    return true;
  }

  String _friendlyMessage(Object e) {
    if (e is DioException && e.type == DioExceptionType.badResponse) {
      final status = e.response?.statusCode ?? 0;
      if (status == 401 || status == 403) return 'Invalid email or password.';
      return 'Server rejected the request (HTTP $status).';
    }
    return 'Cannot reach the CarbonWise server.';
  }

  User _demoUser({required String email, String? name, required String role}) {
    final displayName =
        (name != null && name.isNotEmpty) ? name : email.split('@').first;
    return User(
      id: 'demo-${DateTime.now().millisecondsSinceEpoch}',
      name: displayName,
      email: email,
      role: role,
      isVerified: true,
      createdAt: DateTime.now(),
    );
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    _isOfflineMode = false;
    notifyListeners();

    try {
      final data = await _authRepository.login(email, password);
      _user = _authRepository.parseUser(data['user']);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (_isUnreachable(e)) {
        _user = _demoUser(email: email, role: AppConstants.roleConsumer);
        _isAuthenticated = true;
        _isOfflineMode = true;
        _error = null;
        _isLoading = false;
        notifyListeners();
        return true; // demo session -> UI navigates
      }
      _error = _friendlyMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password, String role) async {
    _isLoading = true;
    _error = null;
    _isOfflineMode = false;
    notifyListeners();

    try {
      await _authRepository.register(name, email, password, role);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (_isUnreachable(e)) {
        _user = _demoUser(email: email, name: name, role: role);
        _isOfflineMode = true;
        _error = null;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = _friendlyMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOTP(String email, String otp) async {
    try {
      return await _authRepository.verifyOTP(email, otp);
    } catch (e) {
      if (_isUnreachable(e)) return true; // offline: accept OTP
      _error = _friendlyMessage(e);
      notifyListeners();
      return false;
    }
  }

  Future<void> forgotPassword(String email) =>
      _authRepository.forgotPassword(email);

  Future<void> logout() async {
    await _authRepository.logout();
    _user = null;
    _isAuthenticated = false;
    _isOfflineMode = false;
    notifyListeners();
  }

  Future<void> checkAuth() async {
    final auth = await _authRepository.isAuthenticated();
    _isAuthenticated = auth;
    notifyListeners();
  }
}
