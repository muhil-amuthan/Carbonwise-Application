# CarbonWise – AI Carbon Intelligence Platform

## Architecture

```
                        CarbonWise
                              │
      ┌───────────────────────┼────────────────────────┐
      │                       │                        │
 Android Mobile App      Spring Boot API         AI/ML Server
      │                       │                        │
      └───────────────┬───────┴───────────────┬────────┘
                      │                       │
                 PostgreSQL             MQTT Broker
                      │                       │
             Firebase Cloud          ESP32 / Raspberry Pi
                      │
                Google Maps API
```

## Final Deployment Architecture

```
                    Android Application
                           │
                     Internet (HTTPS)
                           │
                  Spring Boot REST API
                           │
        ┌──────────────────┼───────────────────┐
        │                  │                   │
 PostgreSQL DB      AI Prediction API     MQTT Broker
        │                  │                   │
        └──────────────────┼───────────────────┘
                           │
                  ESP32 / Raspberry Pi
                           │
                  Environmental Sensors
```

## Technology Stack

| Layer | Technology |
|-------|-----------|
| Mobile App | Flutter |
| Backend | Spring Boot |
| Database | PostgreSQL |
| Authentication | JWT + Spring Security |
| AI/ML | Python, Scikit-learn, TensorFlow |
| IoT | ESP32, Raspberry Pi |
| Communication | MQTT |
| Maps | Google Maps SDK |
| Notifications | Firebase Cloud Messaging |
| Cloud Storage | Firebase Storage |
| Deployment | Render (Backend), Railway (Database), Firebase |

## Modules

1. Authentication Module
2. Consumer Module
3. Smart Appliance Module
4. Carbon Prediction Module
5. City Monitoring Module
6. GIS Module
7. AI Module
8. IoT Module
9. Notification Module
10. Reports Module
11. Admin Module

## User Roles

- **Consumer** – Dashboard, Appliances, Predictions, Reports
- **City Admin** – City Monitoring, GIS, Sensor Management
- **System Admin** – Full System Access, User Management, AI Training

## Development Phases

- **Phase 1** – Core Mobile App (Auth, Dashboard, Maps)
- **Phase 2** – AI (Carbon Prediction, Recommendations)
- **Phase 3** – IoT (ESP32, MQTT, Smart Appliance Control)
- **Phase 4** – Smart Features (Auto Scheduling, Notifications, Reports)
- **Phase 5** – Production (Admin Panel, Multi-city, Play Store)
