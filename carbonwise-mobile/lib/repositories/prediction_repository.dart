import '../services/api_service.dart';
import '../models/prediction_model.dart';

class PredictionRepository {
  final ApiService _apiService;

  PredictionRepository(this._apiService);

  Future<Prediction> fetchPrediction6h() async {
    final response = await _apiService.get('/api/prediction/6h');
    return Prediction.fromJson(response.data);
  }

  Future<Prediction> fetchPrediction12h() async {
    final response = await _apiService.get('/api/prediction/12h');
    return Prediction.fromJson(response.data);
  }

  Future<Prediction> fetchPrediction24h() async {
    final response = await _apiService.get('/api/prediction/24h');
    return Prediction.fromJson(response.data);
  }

  Future<List<Prediction>> fetchAllPredictions() async {
    final results = await Future.wait([
      fetchPrediction6h(),
      fetchPrediction12h(),
      fetchPrediction24h(),
    ]);
    return results;
  }
}
