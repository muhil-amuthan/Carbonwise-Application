import '../services/api_service.dart';

class MapRepository {
  final ApiService _apiService;

  MapRepository(this._apiService);

  Future<List<Map<String, dynamic>>> fetchCarbonHeatmap() async {
    final response = await _apiService.get('/api/gis/heatmap/carbon');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<List<Map<String, dynamic>>> fetchSensorLocations() async {
    final response = await _apiService.get('/api/gis/sensors');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<List<Map<String, dynamic>>> fetchHighRiskZones() async {
    final response = await _apiService.get('/api/gis/risk-zones');
    return List<Map<String, dynamic>>.from(response.data);
  }
}
