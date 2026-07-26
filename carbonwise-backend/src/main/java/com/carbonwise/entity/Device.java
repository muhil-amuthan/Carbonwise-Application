package com.carbonwise.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreatedDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "devices")
@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Device {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private String id;
    @Column(nullable = false) private String userId;
    @Column(nullable = false) private String name;
    @Column(nullable = false) private String type;
    @Column(nullable = false) private Double powerRating;
    private Boolean isActive = false; private Boolean isScheduled = false;
    private String scheduleId; private String mqttTopic;
    @CreatedDate @Column(updatable = false) private LocalDateTime createdAt;
}
