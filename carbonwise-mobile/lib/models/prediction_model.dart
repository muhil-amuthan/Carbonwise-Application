class Prediction {
  final String id;
  final DateTime predictedAt;
  final List<PredictionDataPoint> dataPoints;
  final String bestChargingTime;
  final String bestApplianceTime;
  final String recommendation;

  Prediction({
    required this.id,
    required this.predictedAt,
    required this.dataPoints,
    required this.bestChargingTime,
    required this.bestApplianceTime,
    required this.recommendation,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      id: json['id'],
      predictedAt: DateTime.parse(json['predictedAt']),
      dataPoints: (json['dataPoints'] as List)
          .map((e) => PredictionDataPoint.fromJson(e))
          .toList(),
      bestChargingTime: json['bestChargingTime'],
      bestApplianceTime: json['bestApplianceTime'],
      recommendation: json['recommendation'],
    );
  }
}

class PredictionDataPoint {
  final DateTime time;
  final double predictedIntensity;
  final double confidence;

  PredictionDataPoint({
    required this.time,
    required this.predictedIntensity,
    required this.confidence,
  });

  factory PredictionDataPoint.fromJson(Map<String, dynamic> json) {
    return PredictionDataPoint(
      time: DateTime.parse(json['time']),
      predictedIntensity: (json['predictedIntensity'] as num).toDouble(),
      confidence: (json['confidence'] as num).toDouble(),
    );
  }
}
