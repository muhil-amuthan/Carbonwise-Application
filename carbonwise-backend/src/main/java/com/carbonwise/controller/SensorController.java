package com.carbonwise.controller;

import com.carbonwise.dto.SensorDTO;
import com.carbonwise.entity.SensorData;
import com.carbonwise.repository.SensorDataRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/sensor")
@RequiredArgsConstructor
public class SensorController {

    private final SensorDataRepository sensorDataRepository;

    @PostMapping("/data")
    public ResponseEntity<Void> postSensorData(@RequestBody SensorDTO request) {
        SensorData data = SensorData.builder()
                .sensorId(request.getSensorId())
                .co2(request.getCo2())
                .pm25(request.getPm25())
                .pm10(request.getPm10())
                .temperature(request.getTemperature())
                .humidity(request.getHumidity())
                .timestamp(LocalDateTime.now())
                .build();
        sensorDataRepository.save(data);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/live")
    public ResponseEntity<List<SensorDTO>> getLiveSensorData() {
        LocalDateTime cutoff = LocalDateTime.now().minusMinutes(30);
        List<SensorData> data = sensorDataRepository.findByTimestampAfter(cutoff);
        return ResponseEntity.ok(data.stream().map(this::mapToDTO).collect(Collectors.toList()));
    }

    private SensorDTO mapToDTO(SensorData entity) {
        return SensorDTO.builder()
                .sensorId(entity.getSensorId())
                .co2(entity.getCo2())
                .pm25(entity.getPm25())
                .pm10(entity.getPm10())
                .temperature(entity.getTemperature())
                .humidity(entity.getHumidity())
                .timestamp(entity.getTimestamp().toString())
                .build();
    }
}
