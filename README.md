# 🌿 CarbonWise – AI Carbon Intelligence Platform

> **One App, Two Layers** — Empowering consumers and city administrators with real-time carbon intelligence, AI-powered predictions, and smart appliance scheduling.

---

## 📱 Android APK

**CarbonWise Android APK — install it on your phone and run the demo.**

### ⬇️ Download

- **Option A (recommended):** open the repo's [**Releases**](https://github.com/muhil-amuthan/Carbonwise-Application/releases) page and download **`CarbonWise.apk`** from the latest `carbonwise-demo-v1` release.
- **Option B:** open [**Actions → Build Android APK**](https://github.com/muhil-amuthan/Carbonwise-Application/actions/workflows/build_apk.yml) → tap the latest successful run → download the **CarbonWise-App-Release** artifact (ZIP contains `app-release.apk`, rename to `CarbonWise.apk`).

### 📲 Install on Android

1. Copy `CarbonWise.apk` to your phone (or download it directly on the phone).
2. Tap the file → allow **“Install unknown apps”** for your browser/Files app if prompted.
3. Tap **Install** → **Open**.

### ▶️ Run the demo (2-minute flow)

1. On the Login screen tap **“One-Tap Demo / Guest Access”** (no backend needed).
2. Follow the bottom navigation: **Dashboard → Prediction → Devices → Maps → Reports → Profile**.
3. On **Devices**, tap **+ ADD DEVICE** → fill the form → watch **CONNECTING… → ONLINE • DEMO**.
4. On **Reports**, tap **DOWNLOAD AUDITED PDF** (saves `CarbonWise_Carbon_Report_YYYY-MM-DD.pdf`).
5. Try the **AI Optimization Engine** budget slider and the **Action Plan roadmap** on the Dashboard.

### 🔑 Demo credentials (optional)

- Pre-filled on the Login screen: `user@carbonwise.com` / `user123` (needs the live backend; if the server is cold it fails fast with an error — use Guest Access instead).
- **Guest Access = Demo Mode**, works fully offline.

### ⚠️ Demo Mode limitations (labeled in-app as DEMO MODE / DEMO DATA)

- Devices, grid intensity, forecasts, and GIS layers are **realistic simulated data**, not live telemetry/hardware.
- Map tiles need a production Google Maps API key (currently a safe dummy key) — markers and the demo GIS layer still render.
- Real backend login / MQTT / ESP32 hardware are not required for the demo.

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
│
├── 📱 carbonwise-mobile/
│   ├── core/
│   ├── models/
│   ├── providers/
│   ├── repositories/
│   ├── services/
│   ├── widgets/
│   ├── screens/
│   ├── routes/
│   ├── assets/
│   └── main.dart
│
├── 🖥️ carbonwise-backend/
│   ├── config/
│   ├── controller/
│   ├── service/
│   ├── repository/
│   ├── entity/
│   ├── dto/
│   ├── mapper/
│   ├── security/
│   ├── mqtt/
│   ├── ai/
│   ├── scheduler/
│   ├── notification/
│   ├── websocket/
│   ├── validation/
│   ├── utils/
│   ├── exception/
│   └── pom.xml
│
├── 🤖 carbonwise-ai/
│   ├── api/
│   ├── datasets/
│   ├── preprocessing/
│   ├── training/
│   ├── prediction/
│   ├── recommendation/
│   ├── models/
│   ├── saved_models/
│   ├── evaluation/
│   └── utils/
│
├── 🔌 carbonwise-iot/
│   ├── esp32/
│   ├── gateway/
│   ├── firmware/
│   ├── mqtt/
│   └── documentation/
│
├── 📄 README.md
├── 📄 ARCHITECTURE.md
├── 📄 API_DOCUMENTATION.md
├── 📄 DATABASE_SCHEMA.md
├── 📄 DEPLOYMENT.md
├── 📄 LICENSE
└── 📄 .gitignore
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

## 🚀 Quick Start

### Mobile App
```bash
cd carbonwise-mobile
flutter pub get
flutter run
```

### Backend
The `pom.xml` and Spring Boot Maven plugin are inside `carbonwise-backend`. Always change into that directory before invoking Maven (or use the helper below); running `mvn spring-boot:run` from the repository root causes Maven's `No plugin found for prefix 'spring-boot'` error.

```bash
cd carbonwise-backend
mvn spring-boot:run
# Backend: http://localhost:8080
```

To start the backend and Flutter frontend together, from the repository root run:

```bash
./scripts/start-dev.sh
```
The helper verifies that port 8080 is listening before starting Flutter. Stop both processes with `Ctrl+C`.

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
# Run Raspberry Pi gateway
python gateway/mqtt_gateway.py
```

---

## 📄 Documentation

- [API Documentation](API_DOCUMENTATION.md) – Complete REST API reference
- [Database Schema](DATABASE_SCHEMA.md) – PostgreSQL table definitions
- [Deployment Guide](DEPLOYMENT.md) – Production deployment instructions
- [Architecture](ARCHITECTURE.md) – System architecture overview

---

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

> Built with "Muhil" for a greener Tamil Nadu
