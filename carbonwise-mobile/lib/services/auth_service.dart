import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post('/api/auth/login', data: {
      'email': email,
      'password': password,
    });
    final data = response.data;
    await _saveTokens(data);
    return data;
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await _apiService.post('/api/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    });
    return response.data;
  }

  Future<bool> verifyOTP({required String email, required String otp}) async {
    final response = await _apiService.post('/api/auth/verifyOTP', data: {
      'email': email,
      'otp': otp,
    });
    return response.data['verified'] == true;
  }

  Future<void> forgotPassword({required String email}) async {
    await _apiService.post('/api/auth/forgotPassword', data: {
      'email': email,
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.refreshTokenKey);
    await prefs.remove(AppConstants.userIdKey);
    await prefs.remove(AppConstants.userRoleKey);
  }

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey) != null;
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.userRoleKey);
  }

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, data['token']);
    await prefs.setString(AppConstants.refreshTokenKey, data['refreshToken']);
    await prefs.setString(AppConstants.userIdKey, data['userId']);
    await prefs.setString(AppConstants.userRoleKey, data['role']);
  }
}
