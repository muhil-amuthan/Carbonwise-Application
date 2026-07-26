"""
CarbonWise AI Prediction Server
Flask API for carbon intensity prediction and recommendation engine
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
from prediction.predictor import CarbonPredictor
from prediction.recommender import CarbonRecommender

app = Flask(__name__)
CORS(app)

# Initialize models
predictor = CarbonPredictor()
recommender = CarbonRecommender()


@app.route('/api/prediction/<int:hours>h', methods=['GET'])
def get_prediction(hours):
    """Get carbon intensity prediction for specified hours"""
    try:
        if hours not in [6, 12, 24]:
            return jsonify({'error': 'Invalid prediction window. Use 6, 12, or 24.'}), 400

        prediction = predictor.predict(hours)
        recommendation = recommender.get_recommendation(prediction)

        return jsonify({
            'id': f'pred_{hours}h_{prediction["timestamp"]}',
            'predictedAt': prediction['timestamp'],
            'dataPoints': prediction['data_points'],
            'bestChargingTime': recommendation['best_charging_time'],
            'bestApplianceTime': recommendation['best_appliance_time'],
            'recommendation': recommendation['text'],
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/api/prediction/live', methods=['GET'])
def get_live_intensity():
    """Get current carbon intensity"""
    try:
        intensity = predictor.get_live_intensity()
        return jsonify(intensity)
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/api/recommendation', methods=['GET'])
def get_recommendation():
    """Get best time recommendation"""
    try:
        device_type = request.args.get('device', 'general')
        recommendation = recommender.get_recommendation_for_device(device_type)
        return jsonify(recommendation)
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/api/gis/interpolate', methods=['POST'])
def spatial_interpolation():
    """Run Kriging spatial interpolation for city grid"""
    try:
        data = request.json
        result = predictor.spatial_interpolation(
            data.get('sensor_data', []),
            data.get('grid_resolution', 12),
        )
        return jsonify(result)
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({'status': 'healthy', 'service': 'carbonwise-ai'})


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
