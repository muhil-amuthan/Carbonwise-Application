# CarbonWise MQTT Broker Configuration

## Broker Setup (Mosquitto)

### Installation
```bash
sudo apt-get install mosquitto mosquitto-clients
```

### Configuration (`/etc/mosquitto/mosquitto.conf`)
```
listener 1883
allow_anonymous false
password_file /etc/mosquitto/passwd

# WebSocket support for browser testing
listener 9001
protocol websockets
```

### Create Users
```bash
sudo mosquitto_passwd -c /etc/mosquitto/passwd carbonwise
# Enter password: carbonwise123
```

### Start Service
```bash
sudo systemctl enable mosquitto
sudo systemctl start mosquitto
```

## Topic Structure

```
carbonwise/
├── sensor/
│   ├── data          (ESP32 → Broker → Backend)
│   └── status        (ESP32 heartbeat)
├── device/
│   ├── control       (Backend → Broker → RPi → Smart Plug)
│   ├── status        (Smart Plug → Broker → Backend)
│   └── schedule      (Backend → Broker → RPi)
├── prediction/
│   ├── live          (AI Server → Broker → App)
│   └── forecast      (AI Server → Broker → App)
└── notification/
    └── alert         (Backend → Broker → App)
```

## QoS Levels

| Topic | QoS | Reason |
|-------|-----|--------|
| sensor/data | 1 | At least once delivery |
| device/control | 2 | Exactly once - critical commands |
| device/status | 0 | Fast delivery, no persistence |
| prediction/live | 0 | Real-time updates |
