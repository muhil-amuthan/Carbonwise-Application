import 'package:flutter/material.dart';
import '../core/services/api_service.dart';
import '../models/prediction_model.dart';

class PredictionProvider extends ChangeNotifier {
  final ApiService _apiService;
  Prediction? _prediction6h;
  Prediction? _prediction12h;
  Prediction? _prediction24h;
  bool _isLoading = false;
  String? _error;

  PredictionProvider(this._apiService);

  Prediction? get prediction6h => _prediction6h;
  Prediction? get prediction12h => _prediction12h;
  Prediction? get prediction24h => _prediction24h;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPrediction6h() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/api/prediction/6h');
      _prediction6h = Prediction.fromJson(response.data);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPrediction12h() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/api/prediction/12h');
      _prediction12h = Prediction.fromJson(response.data);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPrediction24h() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/api/prediction/24h');
      _prediction24h = Prediction.fromJson(response.data);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllPredictions() async {
    await Future.wait([
      fetchPrediction6h(),
      fetchPrediction12h(),
      fetchPrediction24h(),
    ]);
  }
}
