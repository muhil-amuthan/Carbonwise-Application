import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _selectedPeriod = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carbon Reports'), actions: [IconButton(icon: const Icon(Icons.download), onPressed: () {})]),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(16), child: Row(children: [_buildPeriodTab('Daily', 0), const SizedBox(width: 8), _buildPeriodTab('Weekly', 1), const SizedBox(width: 8), _buildPeriodTab('Monthly', 2)])),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Carbon Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  _buildSummaryRow('Total Carbon Used', '287.0 kg CO₂', AppTheme.primaryRed),
                  _buildSummaryRow('Total Carbon Saved', '86.1 kg CO₂ (-30%)', AppTheme.primaryGreen),
                  _buildSummaryRow('Electricity Used', '350 kWh', AppTheme.primaryYellow),
                  _buildSummaryRow('Renewable Usage', '57%', AppTheme.primaryCyan),
                ]))),
                const SizedBox(height: 16),
                Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Device Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  _buildDeviceStatRow('EV Charger', '120 kg', '36 kg saved'),
                  _buildDeviceStatRow('Air Conditioner', '85 kg', '15 kg saved'),
                  _buildDeviceStatRow('Washing Machine', '45 kg', '25 kg saved'),
                  _buildDeviceStatRow('Water Heater', '37 kg', '10 kg saved'),
                ]))),
                const SizedBox(height: 16),
                SizedBox(width: double.infinity, height: 52, child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.picture_as_pdf), label: const Text('Download PDF Report'))),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodTab(String label, int index) {
    final isSelected = _selectedPeriod == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriod = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryGreen.withOpacity(0.15) : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: AppTheme.primaryGreen) : Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, color: isSelected ? AppTheme.primaryGreen : Colors.white54)),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color color) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [Expanded(child: Text(label, style: const TextStyle(fontSize: 14))), Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color))]),
  );

  Widget _buildDeviceStatRow(String device, String carbon, String saved) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(children: [
      Expanded(flex: 2, child: Text(device, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
      Expanded(child: Text(carbon, style: const TextStyle(fontSize: 13, color: Colors.white54))),
      Expanded(child: Text(saved, style: const TextStyle(fontSize: 13, color: AppTheme.primaryGreen))),
    ]),
  );
}
