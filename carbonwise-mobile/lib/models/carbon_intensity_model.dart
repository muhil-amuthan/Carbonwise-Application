class CarbonIntensity {
  final double intensity;
  final double solarWindPercent;
  final double hydroPercent;
  final double gasPercent;
  final double coalPercent;
  final String status;
  final DateTime timestamp;

  CarbonIntensity({
    required this.intensity,
    required this.solarWindPercent,
    required this.hydroPercent,
    required this.gasPercent,
    required this.coalPercent,
    required this.status,
    required this.timestamp,
  });

  double get renewablePercent => solarWindPercent + hydroPercent;

  factory CarbonIntensity.fromJson(Map<String, dynamic> json) {
    return CarbonIntensity(
      intensity: (json['intensity'] as num).toDouble(),
      solarWindPercent: (json['solarWindPercent'] as num).toDouble(),
      hydroPercent: (json['hydroPercent'] as num).toDouble(),
      gasPercent: (json['gasPercent'] as num).toDouble(),
      coalPercent: (json['coalPercent'] as num).toDouble(),
      status: json['status'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'intensity': intensity,
      'solarWindPercent': solarWindPercent,
      'hydroPercent': hydroPercent,
      'gasPercent': gasPercent,
      'coalPercent': coalPercent,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
