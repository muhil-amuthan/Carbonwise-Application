"""
Model Training Module
Train LSTM and Random Forest models for carbon prediction
"""

import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import joblib
from typing import Dict, Any


class CarbonModelTrainer:
    """Train prediction models for carbon intensity"""

    def __init__(self):
        self.models = {}

    def train_random_forest(self, data: pd.DataFrame) -> Dict[str, Any]:
        """
        Train Random Forest model for carbon prediction

        Args:
            data: Preprocessed DataFrame with features

        Returns:
            Training metrics and model info
        """
        feature_cols = [
            'hour', 'day_of_week', 'month', 'is_weekend',
            'is_solar_peak', 'is_peak_demand', 'temperature',
            'humidity', 'intensity_lag_1', 'intensity_lag_6',
            'intensity_lag_24', 'intensity_rolling_6h',
            'renewable_rolling_6h',
        ]

        X = data[feature_cols].values
        y = data['intensity'].values

        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, shuffle=False
        )

        model = RandomForestRegressor(
            n_estimators=100,
            max_depth=15,
            min_samples_split=5,
            random_state=42,
        )

        model.fit(X_train, y_train)

        # Evaluate
        y_pred = model.predict(X_test)
        mae = mean_absolute_error(y_test, y_pred)
        rmse = np.sqrt(mean_squared_error(y_test, y_pred))
        r2 = r2_score(y_test, y_pred)

        # Save model
        joblib.dump(model, 'models/random_forest_carbon.pkl')

        self.models['random_forest'] = model

        return {
            'model_type': 'RandomForest',
            'mae': round(mae, 2),
            'rmse': round(rmse, 2),
            'r2': round(r2, 4),
            'feature_count': len(feature_cols),
            'training_samples': len(X_train),
        }

    def train_lstm(self, data: pd.DataFrame) -> Dict[str, Any]:
        """
        Train LSTM model for carbon intensity prediction

        Args:
            data: Preprocessed DataFrame

        Returns:
            Training metrics
        """
        # TODO: Implement LSTM training with TensorFlow
        # Requires time-series windowing and sequence preparation
        return {
            'model_type': 'LSTM',
            'status': 'pending_implementation',
        }

    def evaluate_model(self, model_name: str, test_data: pd.DataFrame) -> Dict[str, Any]:
        """
        Evaluate a trained model on test data

        Args:
            model_name: Name of the model to evaluate
            test_data: Test DataFrame

        Returns:
            Evaluation metrics
        """
        model = self.models.get(model_name)
        if model is None:
            raise ValueError(f"Model {model_name} not found")

        feature_cols = [
            'hour', 'day_of_week', 'month', 'is_weekend',
            'is_solar_peak', 'is_peak_demand', 'temperature',
            'intensity_lag_1', 'intensity_lag_6',
        ]

        X_test = test_data[feature_cols].values
        y_test = test_data['intensity'].values
        y_pred = model.predict(X_test)

        return {
            'mae': round(mean_absolute_error(y_test, y_pred), 2),
            'rmse': round(np.sqrt(mean_squared_error(y_test, y_pred)), 2),
            'r2': round(r2_score(y_test, y_pred), 4),
            'predictions': y_pred.tolist(),
            'actuals': y_test.tolist(),
        }
