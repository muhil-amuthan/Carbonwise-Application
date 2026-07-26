class CarbonNotification {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  CarbonNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.isRead = false,
    required this.createdAt,
  });

  factory CarbonNotification.fromJson(Map<String, dynamic> json) {
    return CarbonNotification(
      id: json['id'],
      userId: json['userId'],
      type: json['type'],
      title: json['title'],
      message: json['message'],
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
