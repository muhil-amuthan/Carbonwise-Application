/*
 * CarbonWise ESP32 Sensor Node
 * Reads environmental sensors and sends data via MQTT
 * 
 * Sensors: CO2 (MH-Z19B), PM2.5 (PMS5003), Temperature/Humidity (DHT22)
 * Communication: MQTT over WiFi
 */

#include <WiFi.h>
#include <PubSubClient.h>
#include <DHT.h>
#include <ArduinoJson.h>

// WiFi Configuration
const char* WIFI_SSID = "YOUR_WIFI_SSID";
const char* WIFI_PASSWORD = "YOUR_WIFI_PASSWORD";

// MQTT Configuration
const char* MQTT_BROKER = "mqtt.carbonwise.in";
const int MQTT_PORT = 1883;
const char* MQTT_CLIENT_ID = "esp32_sensor_01";
const char* MQTT_TOPIC = "carbonwise/sensor/data";
const char* MQTT_USERNAME = "carbonwise";
const char* MQTT_PASSWORD = "carbonwise123";

// Sensor Pins
#define DHT_PIN 23
#define DHT_TYPE DHT22
#define CO2_RX_PIN 16
#define CO2_TX_PIN 17
#define PM25_RX_PIN 18
#define PM25_TX_PIN 19

// Timing
#define SENSOR_READ_INTERVAL 30000  // 30 seconds
#define MQTT_RECONNECT_DELAY 5000

// Objects
WiFiClient espClient;
PubSubClient mqtt(espClient);
DHT dht(DHT_PIN, DHT_TYPE);

// Sensor Data
struct SensorReading {
    float co2;
    float pm25;
    float pm10;
    float temperature;
    float humidity;
    unsigned long timestamp;
};

SensorReading lastReading;

void setup() {
    Serial.begin(115200);
    
    // Initialize sensors
    dht.begin();
    Serial2.begin(9600, SERIAL_8N1, CO2_RX_PIN, CO2_TX_PIN);  // MH-Z19B CO2
    Serial1.begin(9600, SERIAL_8N1, PM25_RX_PIN, PM25_TX_PIN); // PMS5003 PM2.5
    
    // Connect WiFi
    setup_wifi();
    
    // Setup MQTT
    mqtt.setServer(MQTT_BROKER, MQTT_PORT);
    mqtt.setCallback(mqtt_callback);
}

void setup_wifi() {
    Serial.print("Connecting to WiFi...");
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    
    Serial.println(" Connected!");
    Serial.print("IP: ");
    Serial.println(WiFi.localIP());
}

void mqtt_callback(char* topic, byte* payload, unsigned int length) {
    // Handle incoming MQTT messages (device control commands)
    String message;
    for (int i = 0; i < length; i++) {
        message += (char)payload[i];
    }
    
    Serial.print("MQTT Message [");
    Serial.print(topic);
    Serial.print("]: ");
    Serial.println(message);
    
    // Parse control commands
    if (String(topic) == "carbonwise/device/control") {
        // Handle device on/off commands
        // e.g., {"deviceId": "smart_plug_01", "action": "ON"}
    }
}

void reconnect_mqtt() {
    while (!mqtt.connected()) {
        Serial.print("Connecting MQTT...");
        if (mqtt.connect(MQTT_CLIENT_ID, MQTT_USERNAME, MQTT_PASSWORD)) {
            Serial.println(" Connected!");
            mqtt.subscribe("carbonwise/device/control");
        } else {
            Serial.print(" Failed, rc=");
            Serial.print(mqtt.state());
            Serial.println(" Retrying in 5s...");
            delay(MQTT_RECONNECT_DELAY);
        }
    }
}

float read_co2() {
    // Read MH-Z19B CO2 sensor via UART
    byte cmd[9] = {0xFF, 0x01, 0x86, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79};
    byte response[9];
    
    Serial2.write(cmd, 9);
    Serial2.readBytes(response, 9);
    
    if (response[0] == 0xFF && response[1] == 0x86) {
        int co2 = (response[2] << 8) + response[3];
        return (float)co2;
    }
    return -1;  // Error
}

float read_pm25() {
    // Read PMS5003 PM2.5 sensor via UART
    // Simplified - actual implementation requires frame parsing
    return 0.0;  // TODO: Implement PMS5003 frame parser
}

SensorReading read_all_sensors() {
    SensorReading reading;
    
    reading.co2 = read_co2();
    reading.pm25 = read_pm25();
    reading.pm10 = reading.pm25 * 1.5;  // Approximate PM10 from PM2.5
    reading.temperature = dht.readTemperature();
    reading.humidity = dht.readHumidity();
    reading.timestamp = millis();
    
    return reading;
}

void publish_sensor_data(SensorReading reading) {
    // Create JSON payload
    StaticJsonDocument<256> doc;
    doc["sensorId"] = MQTT_CLIENT_ID;
    doc["co2"] = reading.co2;
    doc["pm25"] = reading.pm25;
    doc["pm10"] = reading.pm10;
    doc["temperature"] = reading.temperature;
    doc["humidity"] = reading.humidity;
    doc["timestamp"] = reading.timestamp;
    
    char buffer[256];
    serializeJson(doc, buffer);
    
    mqtt.publish(MQTT_TOPIC, buffer);
    Serial.println("Published: " + String(buffer));
}

void loop() {
    if (!mqtt.connected()) {
        reconnect_mqtt();
    }
    mqtt.loop();
    
    // Read sensors periodically
    static unsigned long lastRead = 0;
    if (millis() - lastRead > SENSOR_READ_INTERVAL) {
        lastRead = millis();
        
        SensorReading reading = read_all_sensors();
        
        // Validate readings
        if (reading.temperature != NAN && reading.humidity != NAN) {
            publish_sensor_data(reading);
            lastReading = reading;
        }
    }
}
