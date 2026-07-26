import 'package:flutter/material.dart';
import '../core/services/api_service.dart';
import '../models/carbon_intensity_model.dart';

class CarbonProvider extends ChangeNotifier {
  final ApiService _apiService;
  CarbonIntensity? _liveIntensity;
  List<CarbonIntensity> _history = [];
  bool _isLoading = false;
  String? _error;

  CarbonProvider(this._apiService);

  CarbonIntensity? get liveIntensity => _liveIntensity;
  List<CarbonIntensity> get history => _history;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchLiveIntensity() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/api/consumer/carbon/live');
      _liveIntensity = CarbonIntensity.fromJson(response.data);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCarbonHistory({int days = 30}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get(
        '/api/consumer/carbon/history',
        queryParameters: {'days': days},
      );
      _history = (response.data as List)
          .map((e) => CarbonIntensity.fromJson(e))
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
