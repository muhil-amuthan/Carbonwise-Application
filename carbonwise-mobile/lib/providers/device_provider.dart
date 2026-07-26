import 'package:flutter/material.dart';
import '../core/services/api_service.dart';
import '../models/device_model.dart';

class DeviceProvider extends ChangeNotifier {
  final ApiService _apiService;
  List<Device> _devices = [];
  bool _isLoading = false;
  String? _error;

  DeviceProvider(this._apiService);

  List<Device> get devices => _devices;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDevices() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/api/device');
      _devices = (response.data as List)
          .map((e) => Device.fromJson(e))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addDevice(Map<String, dynamic> deviceData) async {
    try {
      await _apiService.post('/api/device', data: deviceData);
      await fetchDevices();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateDevice(String id, Map<String, dynamic> deviceData) async {
    try {
      await _apiService.put('/api/device/$id', data: deviceData);
      await fetchDevices();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteDevice(String id) async {
    try {
      await _apiService.delete('/api/device/$id');
      await fetchDevices();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
