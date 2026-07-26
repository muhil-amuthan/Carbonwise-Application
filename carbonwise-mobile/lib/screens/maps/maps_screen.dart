import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carbon Heatmap')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(target: LatLng(AppConstants.defaultLat, AppConstants.defaultLng), zoom: AppConstants.defaultZoom),
            markers: _markers,
            circles: _circles,
            onMapCreated: (controller) => _mapController = controller,
            mapType: MapType.normal,
          ),
          Positioned(
            top: 16, right: 16,
            child: Column(children: [
              _buildMapControl(Icons.thermostat, 'Carbon Heatmap', AppTheme.primaryGreen),
              const SizedBox(height: 8),
              _buildMapControl(Icons.air, 'Pollution', AppTheme.primaryRed),
              const SizedBox(height: 8),
              _buildMapControl(Icons.sensor_detected, 'Sensors', AppTheme.primaryCyan),
              const SizedBox(height: 8),
              _buildMapControl(Icons.warning, 'Risk Zones', Colors.orange),
            ]),
          ),
          Positioned(
            bottom: 16, left: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  const Text('Legend', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _buildLegend(AppTheme.primaryGreen, 'Green Zone (Low CO₂)'),
                  _buildLegend(AppTheme.primaryYellow, 'Moderate Zone'),
                  _buildLegend(AppTheme.primaryRed, 'High Risk Zone'),
                  _buildLegend(AppTheme.primaryCyan, 'Sensor Node'),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControl(IconData icon, String label, Color color) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(8)),
    child: Column(children: [Icon(icon, color: color, size: 20), const SizedBox(height: 4), Text(label, style: const TextStyle(fontSize: 9, color: Colors.white))]),
  );

  Widget _buildLegend(Color color, String label) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
    ]),
  );
}
