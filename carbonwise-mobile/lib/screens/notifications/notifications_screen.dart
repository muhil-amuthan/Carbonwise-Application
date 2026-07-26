import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/notification_provider.dart';
import '../../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_done),
            onPressed: () {
              // Mark all as read
            },
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 64, color: Colors.white.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  const Text('No notifications yet'),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.notifications.length,
            itemBuilder: (context, index) {
              final notification = provider.notifications[index];
              return _buildNotificationCard(notification);
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(CarbonNotification notification) {
    final iconData = _getNotificationIcon(notification.type);
    final color = _getNotificationColor(notification.type);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(iconData, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: notification.isRead ? FontWeight.w400 : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: const TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case AppConstants.notifGridClean:
        return Icons.zap;
      case AppConstants.notifGridDirty:
        return Icons.warning;
      case AppConstants.notifBestCharging:
        return Icons.ev_station;
      case AppConstants.notifDeviceCompleted:
        return Icons.check_circle;
      case AppConstants.notifHighPollution:
        return Icons.cloud;
      case AppConstants.notifWeatherAlert:
        return Icons.storm;
      case AppConstants.notifDailyReport:
        return Icons.assessment;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case AppConstants.notifGridClean:
        return AppTheme.primaryGreen;
      case AppConstants.notifGridDirty:
        return AppTheme.primaryRed;
      case AppConstants.notifBestCharging:
        return AppTheme.primaryCyan;
      case AppConstants.notifDeviceCompleted:
        return AppTheme.primaryGreen;
      case AppConstants.notifHighPollution:
        return AppTheme.primaryRed;
      case AppConstants.notifWeatherAlert:
        return AppTheme.primaryYellow;
      case AppConstants.notifDailyReport:
        return AppTheme.primaryCyan;
      default:
        return Colors.white54;
    }
  }
}
