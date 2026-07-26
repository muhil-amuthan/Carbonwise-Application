"""
CarbonWise MQTT Gateway for Raspberry Pi
Acts as MQTT broker bridge and device controller
"""

import paho.mqtt.client as mqtt
import json
import logging
from datetime import datetime

# MQTT Configuration
MQTT_BROKER = "mqtt.carbonwise.in"
MQTT_PORT = 1883
MQTT_CLIENT_ID = "rpi_gateway_01"

# Topics
SENSOR_DATA_TOPIC = "carbonwise/sensor/data"
DEVICE_CONTROL_TOPIC = "carbonwise/device/control"
DEVICE_STATUS_TOPIC = "carbonwise/device/status"

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("CarbonWise-MQTT-Gateway")


class MQTTGateway:
    """MQTT gateway for Raspberry Pi device control"""

    def __init__(self):
        self.client = mqtt.Client(MQTT_CLIENT_ID)
        self.client.on_connect = self._on_connect
        self.client.on_message = self._on_message

    def connect(self):
        """Connect to MQTT broker"""
        self.client.connect(MQTT_BROKER, MQTT_PORT, 60)
        self.client.loop_start()
        logger.info("MQTT Gateway connected")

    def _on_connect(self, client, userdata, flags, rc):
        """Handle MQTT connection"""
        logger.info(f"Connected with result code {rc}")
        # Subscribe to relevant topics
        client.subscribe(SENSOR_DATA_TOPIC)
        client.subscribe(DEVICE_CONTROL_TOPIC)

    def _on_message(self, client, userdata, msg):
        """Handle incoming MQTT messages"""
        try:
            payload = json.loads(msg.payload.decode())
            topic = msg.topic

            if topic == SENSOR_DATA_TOPIC:
                self._handle_sensor_data(payload)
            elif topic == DEVICE_CONTROL_TOPIC:
                self._handle_device_control(payload)

        except json.JSONDecodeError:
            logger.error(f"Invalid JSON on topic {msg.topic}")

    def _handle_sensor_data(self, data):
        """Process sensor data and forward to backend"""
        logger.info(f"Sensor data: {data['sensorId']}")
        # Forward to Spring Boot API
        # requests.post('https://api.carbonwise.in/api/sensor/data', json=data)

    def _handle_device_control(self, data):
        """Execute device control commands"""
        device_id = data.get('deviceId')
        action = data.get('action')

        logger.info(f"Device control: {device_id} -> {action}")

        # Execute GPIO control for smart plugs
        # GPIO HIGH = ON, GPIO LOW = OFF

        # Publish status back
        status = {
            'deviceId': device_id,
            'status': action,
            'timestamp': datetime.now().isoformat(),
        }
        self.client.publish(DEVICE_STATUS_TOPIC, json.dumps(status))

    def publish_schedule_command(self, device_id, start_time, end_time):
        """Send schedule command to device"""
        command = {
            'deviceId': device_id,
            'action': 'SCHEDULE',
            'startTime': start_time,
            'endTime': end_time,
        }
        self.client.publish(DEVICE_CONTROL_TOPIC, json.dumps(command))

    def disconnect(self):
        """Disconnect from MQTT broker"""
        self.client.loop_stop()
        self.client.disconnect()


if __name__ == "__main__":
    gateway = MQTTGateway()
    gateway.connect()

    try:
        while True:
            pass  # Keep running
    except KeyboardInterrupt:
        gateway.disconnect()
        logger.info("Gateway disconnected")
