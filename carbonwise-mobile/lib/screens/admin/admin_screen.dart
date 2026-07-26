import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          final items = [
            ('Users', Icons.people, AppTheme.primaryGreen),
            ('Cities', Icons.location_city, AppTheme.primaryCyan),
            ('Sensors', Icons.sensors, AppTheme.primaryYellow),
            ('Devices', Icons.devices, Colors.purple),
            ('AI Training', Icons.smart_toy, AppTheme.primaryGreen),
            ('Reports', Icons.assessment, AppTheme.primaryCyan),
            ('Carbon Dataset', Icons.dataset, AppTheme.primaryYellow),
            ('System Monitor', Icons.monitor, AppTheme.primaryRed),
          ];
          final (title, icon, color) = items[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 32),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
