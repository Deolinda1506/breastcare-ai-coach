# 🎗️ BreastCare AI Coach

<div align="center">

![BreastCare AI Coach](assets/images/logo.png)

**AI-powered assistant for breast self-examination guidance using Edge Machine Learning**

[![Accuracy](https://img.shields.io/badge/Accuracy-91.11%25-brightgreen)](https://studio.edgeimpulse.com/public/YOUR_PROJECT_ID)
[![F1 Score](https://img.shields.io/badge/F1%20Score-0.96-blue)]()
[![Inference](https://img.shields.io/badge/Inference-1ms-orange)]()
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)
[![Hackathon](https://img.shields.io/badge/HackerEarth-Edge%20AI%20Contest-purple)](https://www.hackerearth.com/challenges/hackathon/edge-ai-contest/)

[🎥 Demo Video](#demo) | [📊 Edge Impulse Project](https://studio.edgeimpulse.com/public/YOUR_PROJECT_ID/latest) | [📱 Try it Live](#installation)

</div>

---

## 🎯 The Problem

**Breast cancer affects 2.3 million women annually worldwide:**
- 🔴 Most diagnosed cancer globally
- 🔴 70% of women don't know how to perform breast self-examination (BSE) correctly
- 🔴 Early detection increases survival rate to **99%**
- 🔴 Existing solutions cost **$250-600** and require appointments

**The gap:** Women need accessible, affordable, real-time guidance for effective self-examination.

---

## 💡 Our Solution

**BreastCare AI Coach** uses Edge Machine Learning to provide **real-time feedback** during breast self-examination, ensuring correct technique and empowering women to detect changes early.

### ✨ Key Features

✅ **Real-time Movement Classification**
   - Detects correct circular palpation patterns
   - Identifies common mistakes (too fast, erratic, insufficient pressure)
   - 91.11% accuracy on test data
   
✅ **Instant Feedback**
   - Visual cues (✅ ❌ ⚠️)
   - Action-oriented guidance
   - Confidence scores display

✅ **Privacy-First**
   - 100% offline operation
   - On-device ML (no cloud)
   - No data collection

✅ **Accessible**
   - Free mobile app
   - Works on any smartphone
   - Also runs on Arduino ($30)

✅ **Ultra-Fast**
   - 1ms classifier inference
   - 29ms total processing time
   - Real-time capable

---

## 🏗️ Architecture
```
┌─────────────┐
│   User      │
│ (performs   │
│  movements) │
└──────┬──────┘
       │
       ▼
┌─────────────────────┐
│  Accelerometer      │
│  (3-axis, 100Hz)    │
└──────┬──────────────┘
       │
       ▼
┌─────────────────────────────┐
│  Spectral Analysis          │
│  • FFT (length: 16)         │
│  • RMS computation          │
│  • 39 features extracted    │
└──────┬──────────────────────┘
       │
       ▼
┌─────────────────────────────┐
│  ML Model (TensorFlow Lite) │
│  • Dense(20) + Dense(10)    │
│  • Size: 15.3 KB            │
│  • Inference: 1 ms          │
│  • Accuracy: 91.11%         │
└──────┬──────────────────────┘
       │
       ▼
┌─────────────────────┐
│  Real-time Feedback │
│  • Correct ✅       │
│  • Too fast ⚠️      │
│  • Erratic ❌       │
│  • Light touch ⚠️   │
└─────────────────────┘
```

---

## 📊 Results

### Model Performance

| Metric | Validation | Test | Status |
|--------|-----------|------|--------|
| **Accuracy** | 91.0% | 91.11% | ✅ Excellent |
| **Precision** | 0.91 | 0.96 | ✅ Excellent |
| **Recall** | 0.91 | 0.96 | ✅ Excellent |
| **F1 Score** | 0.91 | 0.96 | ✅ Excellent |
| **ROC AUC** | 0.99 | 0.99 | 🏆 Near Perfect |

### Per-Class Performance

| Class | Accuracy | F1 Score | Status |
|-------|----------|----------|--------|
| Circular Correct | 90.3% | 0.95 | ✅ Excellent |
| Circular Fast | 80.6% | 0.88 | ✅ Very Good |
| Erratic | 97.2% | 0.93 | 🏆 Outstanding |
| Light Touch | 97.2% | 0.99 | 🏆 Near Perfect |

### On-Device Performance
```
⚡ Classifier Inference:  1 ms
⏱️ Total Processing:     29 ms (including feature extraction)
💾 Peak RAM Usage:       4.3 KB
📦 Flash Storage:        15.3 KB (float32)
🔋 Power Efficient:      Yes
```

**This means:**
- ✅ Instant feedback (1000 predictions/second capable!)
- ✅ Runs on any device (minimal resources)
- ✅ Battery-friendly
- ✅ Deployable to $2 microcontrollers

---

## 🚀 Tech Stack

| Category | Technology |
|----------|-----------|
| **ML Platform** | Edge Impulse Studio |
| **Model Format** | TensorFlow Lite (float32) |
| **Mobile App** | Flutter / Dart |
| **ML Integration** | tflite_flutter ^0.12.1 |
| **Sensors** | sensors_plus ^7.0.0 |
| **Processing** | Spectral Analysis (FFT, RMS) |
| **Hardware Tested** | iPhone, Arduino Nano 33 BLE Sense |
| **Deployment** | iOS, Android, Arduino, Web |

---

## 🎥 Demo

### Mobile App

<div align="center">

![App Demo](assets/images/demo.gif)

*Real-time classification with instant feedback*

</div>

### Screenshots

<table>
  <tr>
    <td><img src="assets/images/home_screen.png" alt="Home" width="250"/></td>
    <td><img src="assets/images/exam_screen.png" alt="Exam" width="250"/></td>
    <td><img src="assets/images/results_screen.png" alt="Results" width="250"/></td>
  </tr>
  <tr>
    <td align="center"><b>Home Screen</b></td>
    <td align="center"><b>Guided Exam</b></td>
    <td align="center"><b>Real-time Results</b></td>
  </tr>
</table>

### Edge Impulse Performance

<div align="center">

![Confusion Matrix](assets/images/confusion_matrix.png)
*Test Set Confusion Matrix: 91.11% Accuracy*

![Performance Metrics](assets/images/performance_metrics.png)
*On-Device Performance: 1ms inference, 15.3KB model*

</div>

---

## 📱 Installation

### Prerequisites

- **Flutter SDK** 3.0 or higher
- **iOS** 12+ or **Android** 8+
- **Xcode** (for iOS) or **Android Studio** (for Android)

### Quick Start
```bash
# 1. Clone the repository
git clone https://github.com/Deolinda1506/breastcare-ai-coach.git
cd breastcare-ai-coach/flutter_app

# 2. Install dependencies
flutter pub get

# 3. Run on iOS
flutter run -d ios

# 4. Run on Android
flutter run -d android
```

### Model Setup

The TensorFlow Lite model is included in `assets/`:
- `model.tflite` (15.3 KB)
- `labels.txt`

No additional setup required!

---

## 💻 Development

### Project Structure
```
breastcare-ai-coach/
├── flutter_app/              # Mobile application
│   ├── lib/
│   │   ├── main.dart
│   │   ├── models/
│   │   │   └── prediction.dart
│   │   ├── services/
│   │   │   ├── ml_service.dart
│   │   │   └── sensor_service.dart
│   │   └── screens/
│   │       ├── home_screen.dart
│   │       ├── exam_screen.dart
│   │       ├── qr_screen.dart
│   │       └── qr_scanner_screen.dart
│   └── assets/
│       ├── model.tflite
│       └── labels.txt
├── assets/
│   ├── images/
│   └── videos/
├── docs/
│   ├── TECHNICAL_REPORT.md
│   └── USER_GUIDE.md
├── README.md
└── LICENSE
```

### Key Components

#### ML Service (`lib/services/ml_service.dart`)
- Loads TensorFlow Lite model
- Processes 3-second windows (300 samples @ 100Hz)
- Performs inference (1ms)
- Returns predictions with confidence scores

#### Sensor Service (`lib/services/sensor_service.dart`)
- Captures accelerometer data at 100Hz
- Buffers 3-second windows
- Manages timing and callbacks

#### UI Screens
- **Home**: Project overview and quick start
- **Exam**: Real-time classification with visual feedback
- **QR Scanner**: Load ML models from QR codes

---

## 🔬 Technical Details

### Dataset

- **Samples**: 50 recordings (30 seconds each)
- **Total Duration**: 19 minutes 34 seconds
- **Augmentation**: Sliding window (3s windows, 1s stride)
- **Training Windows**: 720
- **Classes**: 4 movement types
  - `circular_correct`: Proper slow circular palpation
  - `circular_fast`: Excessively rapid movements
  - `erratic`: Disorganized patterns
  - `light_touch`: Insufficient pressure

### Model Architecture
```
Input: 39 spectral features
  ↓
Dense(20 neurons, ReLU)
  ↓
Dense(10 neurons, ReLU)
  ↓
Output(4 classes, Softmax)
```

**Training Configuration:**
- Epochs: 100
- Learning rate: 0.0005
- Optimizer: Adam
- Batch size: 32
- Validation split: 20%

### Feature Extraction

- **Method**: Spectral Analysis (FFT)
- **FFT Length**: 16
- **Frequency Range**: 9-53 Hz
- **Features**: 39 per 3-second window
- **Most Important**: accY (Y-axis acceleration) spectral power

---

## 🏆 Achievements

### HackerEarth x Edge Impulse Hackathon 2025

✅ **Technical Excellence**
- 91.11% test accuracy
- 1ms inference time
- 15.3KB model size
- ROC AUC 0.99

✅ **Innovation**
- First Edge AI app for BSE guidance
- Single-sensor approach
- Real-time actionable feedback

✅ **Impact**
- Free vs $250-600 commercial alternatives
- Privacy-preserving (100% offline)
- Accessible to billions worldwide

---

## 🛣️ Roadmap

### Phase 1: Enhanced App (Q1 2026)
- [ ] History tracking
- [ ] Progress analytics
- [ ] Multi-language support
- [ ] Monthly reminders
- [ ] Tutorial mode

### Phase 2: Model Improvements (Q2 2026)
- [ ] Expand dataset (200+ samples)
- [ ] Multi-sensor fusion
- [ ] User calibration
- [ ] 95%+ accuracy target

### Phase 3: Hardware (Q2 2026)
- [ ] Arduino physical testing
- [ ] Wearable prototype
- [ ] Smartwatch integration

### Phase 4: Clinical Validation (Q3 2026)
- [ ] User study (100+ participants)
- [ ] Healthcare professional validation
- [ ] IRB approval

### Phase 5: Scale (Q4 2026)
- [ ] NGO partnerships
- [ ] Global distribution
- [ ] 50+ languages

---

## 📖 Documentation

- 📊 **[Technical Report](docs/TECHNICAL_REPORT.md)** - Detailed methodology and results
- 👤 **[User Guide](docs/USER_GUIDE.md)** - How to use the app
- 💻 **[Development Guide](docs/DEVELOPMENT.md)** - Setup and contribution
- 📁 **[Dataset Documentation](docs/DATASET.md)** - Data collection details

---

## ⚠️ Disclaimers

**Important Medical Information:**

- ⚠️ This is an **educational prototype**, NOT a medical device
- ⚠️ Does NOT diagnose or detect breast cancer
- ⚠️ Does NOT replace professional medical examination
- ⚠️ Provides **technique guidance only**, not medical advice
- ⚠️ Not FDA-cleared or CE-marked
- ⚠️ Always consult healthcare providers for health concerns

**Privacy:**
- ✅ 100% offline operation
- ✅ No data collection
- ✅ No cloud connectivity required
- ✅ User maintains complete control

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Areas for Contribution

- 📱 Mobile app enhancements
- 🧠 Model improvements
- 🌍 Translations
- 📚 Documentation
- 🧪 Testing

### Development Setup

See [DEVELOPMENT.md](docs/DEVELOPMENT.md) for detailed setup instructions.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Edge Impulse** for the ML platform and tools
- **HackerEarth** for hosting this impactful hackathon
- **Open-source community** for Flutter, TensorFlow Lite, and sensor packages
- **Healthcare professionals** who provided BSE guidance
- **All women** fighting breast cancer worldwide 💗

---

## 📞 Contact

- **GitHub**: [@Deolinda1506](https://github.com/Deolinda1506)
- **Edge Impulse Project**: [View Public Project](https://studio.edgeimpulse.com/public/YOUR_PROJECT_ID/latest)
- **Hackathon**: [HackerEarth Edge AI Contest](https://www.hackerearth.com/challenges/hackathon/edge-ai-contest/)

---

## 🌟 Star This Project

If you find this project helpful or impactful, please give it a ⭐ on GitHub!

---

## 📊 Project Stats
```
Lines of Code:     ~2,000
Model Size:        15.3 KB
Inference Time:    1 ms
Accuracy:          91.11%
Training Data:     19m 34s
Training Windows:  720
Classes:           4
Features:          39
Development Time:  4 weeks
Impact Potential:  Billions of women worldwide
```

---

<div align="center">

**Made with ❤️ for women's health**

**#BreastCancerAwareness #EdgeAI #MachineLearning #HealthTech #Flutter**

Built during HackerEarth x Edge Impulse Hackathon 2025 (Oct 30 - Nov 30)

</div>
