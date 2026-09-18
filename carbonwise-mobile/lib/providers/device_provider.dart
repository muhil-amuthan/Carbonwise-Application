import 'dart:async';
import 'package:flutter/material.dart';
import '../repositories/device_repository.dart';
import '../models/device_model.dart';

class DeviceProvider extends ChangeNotifier {
  final DeviceRepository _repository;
  List<Device> _devices = [];
  bool _isLoading = false;
  String? _error;

  DeviceProvider(this._repository);

  List<Device> get devices => _devices;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDevices() async {
    _isLoading = true;
    notifyListeners();

    try {
      _devices = await _repository.fetchDevices();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Instant local add (no full refetch): shows CONNECTING... then ONLINE.
  /// Works fully offline — never blocks the demo on the network.
  Future<bool> addDevice(Map<String, dynamic> deviceData) async {
    try {
      final created = await _repository.addDevice(deviceData);
      final pending = Device(
        id: created.id,
        userId: created.userId,
        name: created.name,
        type: created.type,
        powerRating: created.powerRating,
        isActive: false,
        isConnecting: true,
        isScheduled: false,
        scheduleId: created.scheduleId,
        customLocation: deviceData['location']?.toString() ?? created.customLocation,
        createdAt: created.createdAt,
      );
      final existingIdx = _devices.indexWhere((d) => d.id == created.id);
      if (existingIdx != -1) {
        _devices[existingIdx] = pending;
      } else {
        _devices.add(pending);
      }
      _error = null;
      notifyListeners();

      // Simulated provisioning handshake -> ONLINE (demo-safe, local only).
      Future.delayed(const Duration(milliseconds: 1200), () {
        final i = _devices.indexWhere((d) => d.id == created.id);
        if (i != -1 && _devices[i].isConnecting) {
          final p = _devices[i];
          _devices[i] = Device(
            id: p.id,
            userId: p.userId,
            name: p.name,
            type: p.type,
            powerRating: p.powerRating,
            isActive: true,
            isConnecting: false,
            isScheduled: p.isScheduled,
            scheduleId: p.scheduleId,
            customLocation: p.customLocation,
            createdAt: p.createdAt,
          );
          notifyListeners();
        }
      });
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateDevice(String id, Map<String, dynamic> deviceData) async {
    try {
      await _repository.updateDevice(id, deviceData);
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
      await _repository.deleteDevice(id);
      await fetchDevices();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleDevice(String id) async {
    final index = _devices.indexWhere((d) => d.id == id);
    if (index != -1) {
      final current = _devices[index];
      _devices[index] = Device(
        id: current.id,
        userId: current.userId,
        name: current.name,
        type: current.type,
        powerRating: current.powerRating,
        isActive: !current.isActive,
        isScheduled: current.isScheduled,
        scheduleId: current.scheduleId,
        customLocation: current.customLocation,
        createdAt: current.createdAt,
      );
      notifyListeners();
    }
    return true;
  }
}
