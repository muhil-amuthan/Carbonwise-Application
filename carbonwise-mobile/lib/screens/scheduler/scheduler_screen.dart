import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SchedulerScreen extends StatelessWidget {
  const SchedulerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appliance Scheduler')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppTheme.primaryGreen.withOpacity(0.15), AppTheme.primaryCyan.withOpacity(0.08)]),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.bolt, color: AppTheme.primaryGreen, size: 32),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Clean Energy Window Active', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.primaryGreen)),
                    const SizedBox(height: 4),
                    const Text('Solar generation is peaking. Shift heavy loads now.', style: TextStyle(fontSize: 13, color: Colors.white70)),
                  ])),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Schedule Options', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [Icon(Icons.edit_calendar, color: AppTheme.primaryCyan), const SizedBox(width: 12), const Text('Manual Schedule', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))]),
                  const SizedBox(height: 8),
                  const Text('Set your own start and end times for device operation.', style: TextStyle(fontSize: 13, color: Colors.white54)),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () {}, child: const Text('Create Manual Schedule')),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [Icon(Icons.smart_toy, color: AppTheme.primaryGreen), const SizedBox(width: 12), const Text('AI-Optimized Schedule', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))]),
                  const SizedBox(height: 8),
                  const Text('AI automatically picks the lowest carbon intensity window.', style: TextStyle(fontSize: 13, color: Colors.white54)),
                  const SizedBox(height: 4),
                  Text('Estimated savings: 30% carbon reduction', style: TextStyle(fontSize: 13, color: AppTheme.primaryGreen)),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () {}, child: const Text('Create AI Schedule')),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
