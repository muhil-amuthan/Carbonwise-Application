package com.carbonwise.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreatedDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    private String role; // CONSUMER, CITY_ADMIN, SYSTEM_ADMIN

    private String phone;

    private String city;

    private String profileImage;

    @Column(nullable = false)
    private Boolean isVerified = false;

    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
