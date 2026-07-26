import 'package:flutter/material.dart';
import '../core/services/api_service.dart';
import '../models/sensor_model.dart';

class SensorProvider extends ChangeNotifier {
  final ApiService _apiService;
  List<Sensor> _sensors = [];
  List<SensorData> _liveData = [];
  bool _isLoading = false;
  String? _error;

  SensorProvider(this._apiService);

  List<Sensor> get sensors => _sensors;
  List<SensorData> get liveData => _liveData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchLiveSensorData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/api/sensor/live');
      _liveData = (response.data as List)
          .map((e) => SensorData.fromJson(e))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
