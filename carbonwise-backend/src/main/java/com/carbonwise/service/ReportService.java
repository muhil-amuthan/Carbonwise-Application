package com.carbonwise.service;

import com.carbonwise.dto.ReportDTO;
import com.carbonwise.entity.Report;
import com.carbonwise.repository.ReportRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ReportService {

    private final ReportRepository reportRepository;

    public ReportDTO getDailyReport(String userId) {
        Report report = reportRepository.findByUserIdAndType(userId, "DAILY")
                .orElse(null);
        return mapToDTO(report);
    }

    public ReportDTO getWeeklyReport(String userId) {
        Report report = reportRepository.findByUserIdAndType(userId, "WEEKLY")
                .orElse(null);
        return mapToDTO(report);
    }

    public ReportDTO getMonthlyReport(String userId) {
        Report report = reportRepository.findByUserIdAndType(userId, "MONTHLY")
                .orElse(null);
        return mapToDTO(report);
    }

    private ReportDTO mapToDTO(Report entity) {
        if (entity == null) return null;
        return ReportDTO.builder()
                .id(entity.getId())
                .userId(entity.getUserId())
                .type(entity.getType())
                .startDate(entity.getStartDate().toString())
                .endDate(entity.getEndDate().toString())
                .totalCarbonUsed(entity.getTotalCarbonUsed())
                .totalCarbonSaved(entity.getTotalCarbonSaved())
                .totalElectricityUsed(entity.getTotalElectricityUsed())
                .renewablePercentage(entity.getRenewablePercentage())
                .deviceCount(entity.getDeviceCount())
                .pdfUrl(entity.getPdfUrl())
                .build();
    }
}
