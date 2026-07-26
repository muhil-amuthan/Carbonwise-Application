import 'package:flutter/material.dart';
import '../core/services/api_service.dart';
import '../models/report_model.dart';

class ReportProvider extends ChangeNotifier {
  final ApiService _apiService;
  Report? _dailyReport;
  Report? _weeklyReport;
  Report? _monthlyReport;
  bool _isLoading = false;
  String? _error;

  ReportProvider(this._apiService);

  Report? get dailyReport => _dailyReport;
  Report? get weeklyReport => _weeklyReport;
  Report? get monthlyReport => _monthlyReport;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDailyReport() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/api/reports/daily');
      _dailyReport = Report.fromJson(response.data);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeeklyReport() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/api/reports/weekly');
      _weeklyReport = Report.fromJson(response.data);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMonthlyReport() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/api/reports/monthly');
      _monthlyReport = Report.fromJson(response.data);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
