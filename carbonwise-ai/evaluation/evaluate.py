"""
Model Evaluation Module
Evaluate and compare prediction models
"""

import numpy as np
from sklearn.metrics import (
    mean_absolute_error,
    mean_squared_error,
    r2_score,
    mean_absolute_percentage_error,
)
from typing import Dict, Any, List


class ModelEvaluator:
    """Evaluate and compare carbon prediction models"""

    def evaluate_predictions(
        self, actual: List[float], predicted: List[float]
    ) -> Dict[str, Any]:
        """
        Calculate comprehensive evaluation metrics

        Args:
            actual: Actual carbon intensity values
            predicted: Predicted carbon intensity values

        Returns:
            Dictionary of evaluation metrics
        """
        actual_arr = np.array(actual)
        predicted_arr = np.array(predicted)

        mae = mean_absolute_error(actual_arr, predicted_arr)
        rmse = np.sqrt(mean_squared_error(actual_arr, predicted_arr))
        r2 = r2_score(actual_arr, predicted_arr)
        mape = mean_absolute_percentage_error(actual_arr, predicted_arr)

        # Carbon-specific metric: accuracy of clean/dirty classification
        actual_status = self._classify_intensity(actual_arr)
        predicted_status = self._classify_intensity(predicted_arr)
        status_accuracy = np.mean(actual_status == predicted_status)

        return {
            'MAE': round(mae, 2),
            'RMSE': round(rmse, 2),
            'R2': round(r2, 4),
            'MAPE': round(mape * 100, 2),
            'status_accuracy': round(status_accuracy * 100, 1),
            'sample_count': len(actual),
        }

    def _classify_intensity(self, values: np.ndarray) -> np.ndarray:
        """Classify carbon intensity into status categories"""
        conditions = [
            values <= 150,
            values <= 300,
            values <= 450,
            values > 450,
        ]
        return np.select(conditions, [0, 1, 2, 3], default=1)

    def compare_models(
        self, models_results: Dict[str, Dict[str, Any]]
    ) -> Dict[str, Any]:
        """
        Compare multiple models and select the best one

        Args:
            models_results: Dict of model_name -> metrics

        Returns:
            Comparison results and best model
        """
        comparison = {}
        best_model = None
        best_rmse = float('inf')

        for name, metrics in models_results.items():
            comparison[name] = metrics
            if metrics['RMSE'] < best_rmse:
                best_rmse = metrics['RMSE']
                best_model = name

        return {
            'comparison': comparison,
            'best_model': best_model,
            'best_rmse': best_rmse,
        }
