import '../services/api_service.dart';
import '../models/device_model.dart';

class DeviceRepository {
  final ApiService _apiService;

  DeviceRepository(this._apiService);

  Future<List<Device>> fetchDevices() async {
    final response = await _apiService.get('/api/device');
    return (response.data as List).map((e) => Device.fromJson(e)).toList();
  }

  Future<Device> addDevice(Map<String, dynamic> deviceData) async {
    final response = await _apiService.post('/api/device', data: deviceData);
    return Device.fromJson(response.data);
  }

  Future<Device> updateDevice(String id, Map<String, dynamic> deviceData) async {
    final response = await _apiService.put('/api/device/$id', data: deviceData);
    return Device.fromJson(response.data);
  }

  Future<void> deleteDevice(String id) async {
    await _apiService.delete('/api/device/$id');
  }
}
