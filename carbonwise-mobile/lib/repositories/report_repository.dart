import '../services/api_service.dart';
import '../models/report_model.dart';

class ReportRepository {
  final ApiService _apiService;

  ReportRepository(this._apiService);

  Future<Report> fetchDailyReport() async {
    final response = await _apiService.get('/api/reports/daily');
    return Report.fromJson(response.data);
  }

  Future<Report> fetchWeeklyReport() async {
    final response = await _apiService.get('/api/reports/weekly');
    return Report.fromJson(response.data);
  }

  Future<Report> fetchMonthlyReport() async {
    final response = await _apiService.get('/api/reports/monthly');
    return Report.fromJson(response.data);
  }
}
