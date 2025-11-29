# Technical Report: BreastCare AI Coach

## Executive Summary

This report details the machine learning methodology, dataset creation, model architecture, and performance analysis of BreastCare AI Coach - an Edge ML system for guiding breast self-examination.

## 1. Problem Definition

### 1.1 Medical Context
[Statistiques cancer du sein]

### 1.2 Technical Challenge
Classify body movements in real-time using only accelerometer data with high accuracy (<100ms latency).

## 2. Dataset

### 2.1 Data Collection
- **Device**: iPhone [modèle]
- **Sensor**: 3-axis accelerometer
- **Sampling Rate**: 100 Hz
- **Duration**: 30 seconds per sample
- **Total Samples**: 50
- **Total Duration**: 25 minutes

### 2.2 Classes
[Description de chaque classe]

### 2.3 Data Augmentation
- Sliding window: 3-second windows
- Stride: 1 second
- Result: 900+ training examples

## 3. Model Architecture

### 3.1 Feature Extraction
**Spectral Analysis:**
- FFT (Fast Fourier Transform)
- RMS (Root Mean Square)
- Spectral peaks (top 3)
- Power spectral density
- Total features: ~150

### 3.2 Neural Network
[Architecture détaillée]

### 3.3 Training Configuration
[Paramètres]

## 4. Results

### 4.1 Performance Metrics
[Tables de résultats]

### 4.2 Error Analysis
[Analyse des confusions]

## 5. Deployment

### 5.1 Optimization
- Quantization: int8
- Pruning: None (model already small)
- Final size: 15.3 KB

### 5.2 Target Platforms
- Mobile (TFLite)
- Microcontrollers (Arduino)
- Web (WebAssembly)

## 6. Limitations & Future Work

### 6.1 Current Limitations
- Single accelerometer (could add gyroscope)
- 4 classes (could expand to more granular feedback)
- Self-collected dataset (needs clinical validation)

### 6.2 Future Improvements
- Larger dataset (100+ samples per class)
- Multi-sensor fusion
- Personalization (user-specific calibration)
- Clinical validation study

## 7. Conclusion

The model achieves 91.11% accuracy with 1ms inference time, demonstrating the feasibility of Edge AI for real-time BSE guidance.

## References

1. UCI HAR Dataset
2. Edge Impulse Documentation
3. WHO Breast Cancer Guidelines
4. [Autres sources]
