import '../services/api_service.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final ApiService _apiService;

  NotificationRepository(this._apiService);

  Future<List<CarbonNotification>> fetchNotifications() async {
    final response = await _apiService.get('/api/notifications');
    return (response.data as List).map((e) => CarbonNotification.fromJson(e)).toList();
  }

  Future<void> markAsRead(String notificationId) async {
    await _apiService.put('/api/notifications/$notificationId/read');
  }

  Future<int> fetchUnreadCount() async {
    final notifications = await fetchNotifications();
    return notifications.where((n) => !n.isRead).length;
  }
}
