import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/device_provider.dart';
import '../../models/device_model.dart';

class AppliancesScreen extends StatefulWidget {
  const AppliancesScreen({super.key});

  @override
  State<AppliancesScreen> createState() => _AppliancesScreenState();
}

class _AppliancesScreenState extends State<AppliancesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeviceProvider>().fetchDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Appliances')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDeviceDialog(),
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.add, color: AppTheme.backgroundDark),
      ),
      body: Consumer<DeviceProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.devices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.devices_other, size: 64, color: Colors.white.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  const Text('No devices added yet'),
                  const SizedBox(height: 8),
                  const Text('Tap + to add your first smart appliance',
                      style: TextStyle(color: Colors.white54)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.devices.length,
            itemBuilder: (context, index) {
              final device = provider.devices[index];
              return _buildDeviceCard(device);
            },
          );
        },
      ),
    );
  }

  Widget _buildDeviceCard(Device device) {
    final iconData = _getDeviceIconData(device.type);
    final color = device.isActive ? AppTheme.primaryGreen : Colors.white54;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${device.powerRating} kW • ${_getDeviceTypeName(device.type)}',
                    style: const TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                ],
              ),
            ),
            Switch(
              value: device.isActive,
              activeColor: AppTheme.primaryGreen,
              onChanged: (val) {
                // Toggle device
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getDeviceIconData(String type) {
    switch (type) {
      case AppConstants.deviceSmartPlug:
        return Icons.power;
      case AppConstants.deviceEVCharger:
        return Icons.ev_station;
      case AppConstants.deviceAirConditioner:
        return Icons.ac_unit;
      case AppConstants.deviceWashingMachine:
        return Icons.local_laundry_service;
      case AppConstants.deviceWaterHeater:
        return Icons.water_drop;
      default:
        return Icons.device_unknown;
    }
  }

  String _getDeviceTypeName(String type) {
    switch (type) {
      case AppConstants.deviceSmartPlug:
        return 'Smart Plug';
      case AppConstants.deviceEVCharger:
        return 'EV Charger';
      case AppConstants.deviceAirConditioner:
        return 'Air Conditioner';
      case AppConstants.deviceWashingMachine:
        return 'Washing Machine';
      case AppConstants.deviceWaterHeater:
        return 'Water Heater';
      default:
        return 'Unknown';
    }
  }

  void _showAddDeviceDialog() {
    final nameController = TextEditingController();
    String selectedType = AppConstants.deviceSmartPlug;
    double powerRating = 1.0;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Smart Device'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Device Name'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(hintText: 'Device Type'),
                items: const [
                  DropdownMenuItem(value: AppConstants.deviceSmartPlug, child: Text('Smart Plug')),
                  DropdownMenuItem(value: AppConstants.deviceEVCharger, child: Text('EV Charger')),
                  DropdownMenuItem(value: AppConstants.deviceAirConditioner, child: Text('Air Conditioner')),
                  DropdownMenuItem(value: AppConstants.deviceWashingMachine, child: Text('Washing Machine')),
                  DropdownMenuItem(value: AppConstants.deviceWaterHeater, child: Text('Water Heater')),
                ],
                onChanged: (v) => setDialogState(() => selectedType = v!),
              ),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Power Rating (kW)'),
                onChanged: (v) => powerRating = double.tryParse(v) ?? 1.0,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<DeviceProvider>().addDevice({
                  'name': nameController.text,
                  'type': selectedType,
                  'powerRating': powerRating,
                });
                Navigator.pop(ctx);
              },
              child: const Text('Add Device'),
            ),
          ],
        ),
      ),
    );
  }
}
