import '../services/api_service.dart';
import '../models/carbon_intensity_model.dart';

class CarbonRepository {
  final ApiService _apiService;

  CarbonRepository(this._apiService);

  Future<CarbonIntensity> fetchLiveIntensity() async {
    final response = await _apiService.get('/api/consumer/carbon/live');
    return CarbonIntensity.fromJson(response.data);
  }

  Future<List<CarbonIntensity>> fetchCarbonHistory({int days = 30}) async {
    final response = await _apiService.get(
      '/api/consumer/carbon/history',
      queryParameters: {'days': days},
    );
    return (response.data as List).map((e) => CarbonIntensity.fromJson(e)).toList();
  }
}
