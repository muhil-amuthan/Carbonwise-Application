# CarbonWise IoT Sensors

## Supported Sensors

| Sensor | Type | Interface | Range | Accuracy |
|--------|------|-----------|-------|----------|
| MH-Z19B | CO₂ | UART | 0-5000 ppm | ±50 ppm |
| PMS5003 | PM2.5/PM10 | UART | 0-1000 μg/m³ | ±10% |
| DHT22 | Temperature/Humidity | GPIO | -40~80°C / 0-100% RH | ±0.5°C / ±2% |
| SCD30 | CO₂ | I²C | 0-40000 ppm | ±30 ppm |

## Wiring Guide (ESP32)

```
ESP32 Pin Mapping:
- DHT22   → GPIO 23
- MH-Z19B → UART2 (RX: GPIO 16, TX: GPIO 17)
- PMS5003 → UART1 (RX: GPIO 18, TX: GPIO 19)
- SCD30   → I²C (SDA: GPIO 21, SCL: GPIO 22)
```

## MQTT Topics

| Topic | Purpose |
|-------|---------|
| `carbonwise/sensor/data` | Sensor readings from ESP32 |
| `carbonwise/device/control` | Commands to smart plugs |
| `carbonwise/device/status` | Device status updates |

## Power Supply

- ESP32: 3.3V via USB or LiPo battery
- Sensors: 5V from ESP32 Vin pin
- Smart Plug Relay: 5V separate supply
