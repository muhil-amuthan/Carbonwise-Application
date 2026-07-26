package com.carbonwise.controller;

import com.carbonwise.dto.DeviceDTO;
import com.carbonwise.entity.Device;
import com.carbonwise.repository.DeviceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/device")
@RequiredArgsConstructor
public class DeviceController {

    private final DeviceRepository deviceRepository;

    @PostMapping
    public ResponseEntity<DeviceDTO> addDevice(@RequestBody DeviceDTO request, @RequestParam String userId) {
        Device device = Device.builder()
                .userId(userId)
                .name(request.getName())
                .type(request.getType())
                .powerRating(request.getPowerRating())
                .isActive(false)
                .isScheduled(false)
                .build();
        Device saved = deviceRepository.save(device);
        return ResponseEntity.ok(mapToDTO(saved));
    }

    @GetMapping
    public ResponseEntity<List<DeviceDTO>> getDevices(@RequestParam String userId) {
        List<Device> devices = deviceRepository.findByUserId(userId);
        return ResponseEntity.ok(devices.stream().map(this::mapToDTO).collect(Collectors.toList()));
    }

    @PutMapping("/{id}")
    public ResponseEntity<DeviceDTO> updateDevice(@PathVariable String id, @RequestBody DeviceDTO request) {
        Device device = deviceRepository.findById(id).orElse(null);
        if (device == null) return ResponseEntity.notFound().build();

        device.setName(request.getName());
        device.setType(request.getType());
        device.setPowerRating(request.getPowerRating());
        device.setIsActive(request.getIsActive());

        Device saved = deviceRepository.save(device);
        return ResponseEntity.ok(mapToDTO(saved));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteDevice(@PathVariable String id) {
        deviceRepository.deleteById(id);
        return ResponseEntity.ok().build();
    }

    private DeviceDTO mapToDTO(Device entity) {
        return DeviceDTO.builder()
                .id(entity.getId())
                .userId(entity.getUserId())
                .name(entity.getName())
                .type(entity.getType())
                .powerRating(entity.getPowerRating())
                .isActive(entity.getIsActive())
                .isScheduled(entity.getIsScheduled())
                .scheduleId(entity.getScheduleId())
                .build();
    }
}
