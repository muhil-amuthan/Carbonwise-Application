# 🌿 CarbonWise – AI Carbon Intelligence Platform

> **One App, Two Layers** — Empowering consumers and city administrators with real-time carbon intelligence, AI-powered predictions, and smart appliance scheduling.

---

## 🏗️ Architecture Overview

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

---

## 📦 Project Structure

```
CarbonWise/
├── carbonwise-mobile/          # Flutter Mobile Application
├── carbonwise-backend/         # Spring Boot REST API
├── carbonwise-ai/              # AI/ML Prediction Server
├── carbonwise-iot/             # IoT Device Firmware & MQTT
├── archive/                    # Archived web prototype
└── README.md
```

---

## 🛠️ Technology Stack

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

---

## 📋 Complete System Modules

1. **Authentication Module** – Login, Register, OTP, JWT, User Roles
2. **Consumer Module** – Dashboard, Live Carbon Score, Carbon Forecast, Tips
3. **Smart Appliance Module** – Add Device, Schedule, AI Scheduling, Device Status
4. **Carbon Prediction Module** – Live Intensity, 6/12/24h Forecasts, Best Time
5. **City Monitoring Module** – Sensor Monitoring, CO₂, PM2.5, PM10, Weather
6. **GIS Module** – Google Maps, Carbon Heatmap, Pollution Heatmap, Route Analysis
7. **AI Module** – Data Collection, Training, Prediction, Recommendation Engine
8. **IoT Module** – ESP32, Raspberry Pi, Sensors, MQTT, Device Controller
9. **Notification Module** – Grid Alerts, Best Charging Time, Weather Alerts
10. **Reports Module** – Daily/Weekly/Monthly Reports, Carbon Saved, PDF Download
11. **Admin Module** – User/City/Sensor/Device Management, AI Training, Monitoring

---

## 🔐 User Roles

| Role | Access |
|------|--------|
| Consumer | Dashboard, Appliances, Predictions, Reports, Notifications |
| City Admin | City Monitoring, GIS, Sensor Management, City Reports |
| System Admin | Full System Access, User Management, AI Training |

---

## 🚀 Development Phases

### Phase 1 – Core Mobile App
- User authentication (JWT + OTP)
- Dashboard with live carbon intensity
- Google Maps integration
- Basic consumer profile

### Phase 2 – AI
- Carbon prediction (6–24 hours)
- Best time recommendation engine
- Carbon analytics and gap filling

### Phase 3 – IoT
- ESP32 sensor integration
- MQTT communication protocol
- Smart appliance control via MQTT

### Phase 4 – Smart Features
- Automatic AI scheduling
- Push notifications (FCM)
- Reports and analytics (PDF)

### Phase 5 – Production
- Admin panel (full)
- Multi-city support
- Performance optimization
- Play Store deployment

---

## 🗄️ Database Schema

### Core Tables
- `Users` – User accounts, roles, preferences
- `Devices` – Smart appliances linked to users
- `Schedules` – Device scheduling (manual & AI)
- `CarbonIntensity` – Live and historical carbon data
- `Predictions` – AI prediction outputs
- `Sensors` – IoT sensor registry
- `SensorData` – Time-series sensor readings
- `Notifications` – User notification history
- `Reports` – Generated report metadata
- `Cities` – City/region configuration
- `EnergySources` – Grid energy mix data
- `RenewableData` – Renewable energy tracking
- `CarbonHistory` – Historical carbon footprints
- `AIModels` – Model versioning and metadata
- `Logs` – System audit logs

---

## 🔌 REST API Endpoints

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/login` | User login |
| POST | `/api/auth/register` | User registration |
| POST | `/api/auth/verifyOTP` | OTP verification |
| POST | `/api/auth/forgotPassword` | Password reset |

### Consumer
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/consumer/dashboard` | Dashboard data |
| GET | `/api/consumer/carbon/live` | Live carbon intensity |
| GET | `/api/consumer/carbon/history` | Carbon history |

### Prediction
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/prediction/6h` | 6-hour forecast |
| GET | `/api/prediction/12h` | 12-hour forecast |
| GET | `/api/prediction/24h` | 24-hour forecast |

### Devices
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/device` | Add device |
| GET | `/api/device` | List devices |
| PUT | `/api/device/{id}` | Update device |
| DELETE | `/api/device/{id}` | Delete device |

### Scheduler
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/schedule` | Create schedule |
| GET | `/api/schedule` | List schedules |

### Sensors
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/sensor/data` | Post sensor data |
| GET | `/api/sensor/live` | Live sensor readings |

### Reports
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/reports/daily` | Daily report |
| GET | `/api/reports/weekly` | Weekly report |
| GET | `/api/reports/monthly` | Monthly report |

### Admin
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/admin/users` | List users |
| GET | `/api/admin/cities` | List cities |
| GET | `/api/admin/sensors` | List sensors |

---

## 📱 Complete User Flow

```
User Opens App → Login/Register → Dashboard → Live Carbon Intensity
→ AI Prediction → Best Time Recommendation → Schedule Appliance
→ Smart Plug Executes Schedule → Receive Notification → Carbon Savings Report
```

---

## 🚀 Quick Start

### Mobile App
```bash
cd carbonwise-mobile
flutter pub get
flutter run
```

### Backend
```bash
cd carbonwise-backend
./mvnw spring-boot:run
```

### AI Server
```bash
cd carbonwise-ai
pip install -r requirements.txt
python api/app.py
```

### IoT Devices
```bash
cd carbonwise-iot
# Flash ESP32 via Arduino IDE or PlatformIO
# Configure Raspberry Pi via scripts
```

---

## 📄 License

This project is proprietary and confidential. All rights reserved.

---

> Built with 💚 for a greener Tamil Nadu
