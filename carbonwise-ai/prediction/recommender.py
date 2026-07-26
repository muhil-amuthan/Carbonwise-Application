"""
Carbon Recommendation Engine
Provides best time recommendations for appliance scheduling
"""

from datetime import datetime, timedelta
from typing import Dict, Any


class CarbonRecommender:
    """Recommendation engine for optimal appliance scheduling"""

    # Device-specific recommendations
    DEVICE_PROFILES = {
        'EV_CHARGER': {
            'ideal_window': (10, 14),    # Solar peak hours
            'duration_hours': 4,
            'priority': 'high',
        },
        'AIR_CONDITIONER': {
            'ideal_window': (10, 13),    # Pre-cooling during solar peak
            'duration_hours': 3,
            'priority': 'medium',
        },
        'WASHING_MACHINE': {
            'ideal_window': (10, 14),
            'duration_hours': 2,
            'priority': 'low',
        },
        'WATER_HEATER': {
            'ideal_window': (10, 12),    # Heat water during solar peak
            'duration_hours': 1,
            'priority': 'medium',
        },
        'SMART_PLUG': {
            'ideal_window': (10, 14),
            'duration_hours': 1,
            'priority': 'low',
        },
    }

    def get_recommendation(self, prediction: Dict) -> Dict[str, Any]:
        """
        Generate recommendation based on prediction data

        Args:
            prediction: Prediction data from CarbonPredictor

        Returns:
            Recommendation dict with best times
        """
        data_points = prediction.get('data_points', [])

        # Find lowest carbon intensity windows
        clean_windows = [dp for dp in data_points if dp['predictedIntensity'] < 150]
        moderate_windows = [dp for dp in data_points if 150 <= dp['predictedIntensity'] < 300]

        if clean_windows:
            best_time = min(clean_windows, key=lambda x: x['predictedIntensity'])
            best_hour = datetime.fromisoformat(best_time['time']).hour
            best_charging = f"{best_hour}:00 - {best_hour + 4}:00"
            best_appliance = f"{best_hour}:00 - {best_hour + 2}:00"
            recommendation_text = (
                "✅ Optimal carbon window detected! "
                "Schedule heavy loads during this clean energy period. "
                "Solar generation is at peak, resulting in minimal carbon emissions."
            )
        elif moderate_windows:
            best_time = min(moderate_windows, key=lambda x: x['predictedIntensity'])
            best_hour = datetime.fromisoformat(best_time['time']).hour
            best_charging = f"{best_hour}:00 - {best_hour + 4}:00"
            best_appliance = f"{best_hour}:00 - {best_hour + 2}:00"
            recommendation_text = (
                "⚠️ Moderate carbon window available. "
                "Avoid running heavy loads if possible, or schedule during "
                "the relatively cleaner period."
            )
        else:
            best_charging = "Not available in this window"
            best_appliance = "Not available in this window"
            recommendation_text = (
                "❌ High carbon intensity predicted throughout. "
                "Delay heavy loads if possible. Consider using battery storage."
            )

        return {
            'best_charging_time': best_charging,
            'best_appliance_time': best_appliance,
            'text': recommendation_text,
        }

    def get_recommendation_for_device(self, device_type: str) -> Dict[str, Any]:
        """
        Get device-specific recommendation

        Args:
            device_type: Type of device (e.g., EV_CHARGER)

        Returns:
            Device-specific recommendation
        """
        profile = self.DEVICE_PROFILES.get(device_type, self.DEVICE_PROFILES['SMART_PLUG'])
        ideal_start, ideal_end = profile['ideal_window']

        now = datetime.now()
        if now.hour < ideal_start:
            next_ideal = now.replace(hour=ideal_start, minute=0)
            status = "Wait for optimal window"
        elif now.hour <= ideal_end:
            next_ideal = now
            status = "Currently in optimal window!"
        else:
            next_ideal = (now + timedelta(days=1)).replace(hour=ideal_start, minute=0)
            status = "Next optimal window tomorrow"

        return {
            'deviceType': device_type,
            'idealWindow': f"{ideal_start}:00 - {ideal_end}:00",
            'durationHours': profile['duration_hours'],
            'priority': profile['priority'],
            'nextAvailable': next_ideal.isoformat(),
            'status': status,
            'estimatedCarbonSaving': "~30% reduction",
        }
