package com.carbonwise.controller;

import com.carbonwise.dto.ScheduleDTO;
import com.carbonwise.entity.Schedule;
import com.carbonwise.repository.ScheduleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/schedule")
@RequiredArgsConstructor
public class ScheduleController {

    private final ScheduleRepository scheduleRepository;

    @PostMapping
    public ResponseEntity<ScheduleDTO> createSchedule(@RequestBody ScheduleDTO request) {
        Schedule schedule = Schedule.builder()
                .deviceId(request.getDeviceId())
                .userId(request.getUserId())
                .startTime(java.time.LocalDateTime.parse(request.getStartTime()))
                .endTime(java.time.LocalDateTime.parse(request.getEndTime()))
                .isAiRecommended(request.getIsAiRecommended())
                .estimatedCarbonSaving(request.getEstimatedCarbonSaving())
                .status("PENDING")
                .createdAt(java.time.LocalDateTime.now())
                .build();
        Schedule saved = scheduleRepository.save(schedule);
        return ResponseEntity.ok(mapToDTO(saved));
    }

    @GetMapping
    public ResponseEntity<List<ScheduleDTO>> getSchedules(@RequestParam String userId) {
        List<Schedule> schedules = scheduleRepository.findByUserId(userId);
        return ResponseEntity.ok(schedules.stream().map(this::mapToDTO).collect(Collectors.toList()));
    }

    private ScheduleDTO mapToDTO(Schedule entity) {
        return ScheduleDTO.builder()
                .id(entity.getId())
                .deviceId(entity.getDeviceId())
                .userId(entity.getUserId())
                .startTime(entity.getStartTime().toString())
                .endTime(entity.getEndTime().toString())
                .isAiRecommended(entity.getIsAiRecommended())
                .estimatedCarbonSaving(entity.getEstimatedCarbonSaving())
                .status(entity.getStatus())
                .build();
    }
}
