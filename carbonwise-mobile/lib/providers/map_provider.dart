import 'package:flutter/material.dart';
import '../core/services/api_service.dart';

class MapProvider extends ChangeNotifier {
  final ApiService _apiService;
  List<Map<String, dynamic>> _heatmapData = [];
  List<Map<String, dynamic>> _sensorLocations = [];
  List<Map<String, dynamic>> _highRiskZones = [];
  bool _isLoading = false;
  String? _error;

  MapProvider(this._apiService);

  List<Map<String, dynamic>> get heatmapData => _heatmapData;
  List<Map<String, dynamic>> get sensorLocations => _sensorLocations;
  List<Map<String, dynamic>> get highRiskZones => _highRiskZones;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCarbonHeatmap() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/api/gis/heatmap/carbon');
      _heatmapData = List<Map<String, dynamic>>.from(response.data);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSensorLocations() async {
    try {
      final response = await _apiService.get('/api/gis/sensors');
      _sensorLocations = List<Map<String, dynamic>>.from(response.data);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchHighRiskZones() async {
    try {
      final response = await _apiService.get('/api/gis/risk-zones');
      _highRiskZones = List<Map<String, dynamic>>.from(response.data);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
