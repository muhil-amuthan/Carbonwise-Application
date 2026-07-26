package com.carbonwise.controller;

import com.carbonwise.dto.CarbonDTO;
import com.carbonwise.dto.DashboardDTO;
import com.carbonwise.entity.CarbonIntensity;
import com.carbonwise.repository.CarbonIntensityRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/consumer")
@RequiredArgsConstructor
public class ConsumerController {

    private final CarbonIntensityRepository carbonIntensityRepository;

    @GetMapping("/dashboard")
    public ResponseEntity<DashboardDTO> getDashboard(@RequestParam String userId) {
        CarbonIntensity latest = carbonIntensityRepository.findTopByOrderByTimestampDesc()
                .orElse(null);

        DashboardDTO dashboard = DashboardDTO.builder()
                .liveCarbon(mapToCarbonDTO(latest))
                .totalCarbonSaved(86.1)
                .totalElectricityUsed(350.0)
                .renewablePercentage(57.0)
                .activeDevices(4)
                .bestChargingTime("10:00 AM - 2:00 PM")
                .bestApplianceTime("11:00 AM - 1:00 PM")
                .build();

        return ResponseEntity.ok(dashboard);
    }

    @GetMapping("/carbon/live")
    public ResponseEntity<CarbonDTO> getLiveCarbon() {
        CarbonIntensity latest = carbonIntensityRepository.findTopByOrderByTimestampDesc()
                .orElse(null);
        return ResponseEntity.ok(mapToCarbonDTO(latest));
    }

    @GetMapping("/carbon/history")
    public ResponseEntity<List<CarbonDTO>> getCarbonHistory(@RequestParam(defaultValue = "30") int days) {
        LocalDateTime start = LocalDateTime.now().minusDays(days);
        List<CarbonIntensity> history = carbonIntensityRepository.findByTimestampBetween(start, LocalDateTime.now());
        return ResponseEntity.ok(history.stream().map(this::mapToCarbonDTO).collect(Collectors.toList()));
    }

    private CarbonDTO mapToCarbonDTO(CarbonIntensity entity) {
        if (entity == null) return null;
        return CarbonDTO.builder()
                .intensity(entity.getIntensity())
                .solarWindPercent(entity.getSolarWindPercent())
                .hydroPercent(entity.getHydroPercent())
                .gasPercent(entity.getGasPercent())
                .coalPercent(entity.getCoalPercent())
                .status(entity.getStatus())
                .timestamp(entity.getTimestamp().toString())
                .build();
    }
}
