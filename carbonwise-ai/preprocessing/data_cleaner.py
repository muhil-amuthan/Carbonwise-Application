"""
Data Preprocessing Module
Handles data collection, cleaning, and feature engineering
"""

import pandas as pd
import numpy as np
from typing import Dict, List


class DataCleaner:
    """Clean and preprocess carbon intensity data"""

    def clean_carbon_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Remove outliers and fill missing values"""
        # Remove extreme outliers
        df = df[df['intensity'].between(50, 800)]

        # Fill missing timestamps with interpolation
        df['intensity'] = df['intensity'].interpolate(method='linear')
        df['solar_wind_percent'] = df['solar_wind_percent'].interpolate(method='linear')
        df['hydro_percent'] = df['hydro_percent'].interpolate(method='linear')
        df['gas_percent'] = df['gas_percent'].interpolate(method='linear')
        df['coal_percent'] = df['coal_percent'].interpolate(method='linear')

        # Forward fill remaining NaNs
        df = df.fillna(method='ffill').fillna(method='bfill')

        return df

    def normalize_features(self, df: pd.DataFrame) -> pd.DataFrame:
        """Normalize features for ML model input"""
        feature_cols = ['intensity', 'solar_wind_percent', 'hydro_percent',
                        'gas_percent', 'coal_percent', 'temperature']

        for col in feature_cols:
            if col in df.columns:
                mean = df[col].mean()
                std = df[col].std()
                df[f'{col}_normalized'] = (df[col] - mean) / std

        return df


class FeatureEngineer:
    """Create derived features for prediction models"""

    def create_time_features(self, df: pd.DataFrame) -> pd.DataFrame:
        """Extract time-based features"""
        df['hour'] = df['timestamp'].dt.hour
        df['day_of_week'] = df['timestamp'].dt.dayofweek
        df['month'] = df['timestamp'].dt.month
        df['is_weekend'] = df['day_of_week'].isin([5, 6]).astype(int)
        df['is_solar_peak'] = df['hour'].between(10, 14).astype(int)
        df['is_peak_demand'] = df['hour'].isin([8, 18, 19, 20]).astype(int)

        # Season features
        df['is_summer'] = df['month'].isin([3, 4, 5, 6]).astype(int)
        df['is_monsoon'] = df['month'].isin([7, 8, 9, 10]).astype(int)
        df['is_winter'] = df['month'].isin([11, 12, 1, 2]).astype(int)

        return df

    def create_lag_features(self, df: pd.DataFrame, lags: List[int] = [1, 3, 6, 12, 24]) -> pd.DataFrame:
        """Create lag features for time-series prediction"""
        for lag in lags:
            df[f'intensity_lag_{lag}'] = df['intensity'].shift(lag)
            df[f'renewable_lag_{lag}'] = df['solar_wind_percent'].shift(lag)

        # Rolling statistics
        df['intensity_rolling_6h'] = df['intensity'].rolling(window=6).mean()
        df['intensity_rolling_24h'] = df['intensity'].rolling(window=24).mean()
        df['renewable_rolling_6h'] = df['solar_wind_percent'].rolling(window=6).mean()

        return df

    def create_carbon_status_feature(self, df: pd.DataFrame) -> pd.DataFrame:
        """Create carbon status categorical feature"""
        conditions = [
            df['intensity'] <= 150,
            df['intensity'] <= 300,
            df['intensity'] <= 450,
            df['intensity'] > 450,
        ]
        labels = ['CLEAN', 'MODERATE', 'DIRTY', 'CRITICAL']

        df['carbon_status'] = np.select(conditions, labels, default='MODERATE')
        return df
