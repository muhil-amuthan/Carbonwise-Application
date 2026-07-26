import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/services/api_service.dart';
import 'core/services/auth_service.dart';
import 'core/services/notification_service.dart';
import 'providers/auth_provider.dart';
import 'providers/carbon_provider.dart';
import 'providers/device_provider.dart';
import 'providers/prediction_provider.dart';
import 'providers/sensor_provider.dart';
import 'providers/report_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/map_provider.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // await Firebase.initializeApp();

  // Initialize notification service
  await NotificationService.instance.initialize();

  runApp(const CarbonWiseApp());
}

class CarbonWiseApp extends StatelessWidget {
  const CarbonWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<ApiService>(create: (_) => ApiService()),
        Provider<AuthService>(create: (_) => AuthService()),

        // Providers
        ChangeNotifierProvider(create: (ctx) => AuthProvider(ctx.read<AuthService>())),
        ChangeNotifierProvider(create: (ctx) => CarbonProvider(ctx.read<ApiService>())),
        ChangeNotifierProvider(create: (ctx) => DeviceProvider(ctx.read<ApiService>())),
        ChangeNotifierProvider(create: (ctx) => PredictionProvider(ctx.read<ApiService>())),
        ChangeNotifierProvider(create: (ctx) => SensorProvider(ctx.read<ApiService>())),
        ChangeNotifierProvider(create: (ctx) => ReportProvider(ctx.read<ApiService>())),
        ChangeNotifierProvider(create: (ctx) => NotificationProvider(ctx.read<ApiService>())),
        ChangeNotifierProvider(create: (ctx) => MapProvider(ctx.read<ApiService>())),
      ],
      child: MaterialApp.router(
        title: 'CarbonWise',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
