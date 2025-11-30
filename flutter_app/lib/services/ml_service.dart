import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/prediction.dart';

class MLService {
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Initialize the model
  Future<void> initialize() async {
    try {
      print('Loading ML model...');

      // Load the TFLite model
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');

      // Load labels
      final labelsData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsData.split('\n').where((l) => l.isNotEmpty).toList();

      // Print model info
      final inputShape = _interpreter!.getInputTensor(0).shape;
      final outputShape = _interpreter!.getOutputTensor(0).shape;

      print('Model loaded successfully!');
      print('Input shape: $inputShape');
      print('Output shape: $outputShape');
      print('Labels: $_labels');

      _isInitialized = true;
    } catch (e) {
      print('Error loading model: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  /// Make a prediction
  Future<Prediction> predict(List<List<double>> sensorData) async {
    if (!_isInitialized || _interpreter == null) {
      throw Exception('Model not initialized! Call initialize() first.');
    }

    try {
      // Prepare input
      final input = _prepareInput(sensorData);

      // Prepare output buffer
      final output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);

      // Run inference
      final startTime = DateTime.now();
      _interpreter!.run(input, output);
      final inferenceTime = DateTime.now().difference(startTime).inMilliseconds;

      print('Inference time: ${inferenceTime}ms');

      // Extract probabilities
      final probabilities = (output[0] as List).cast<double>();

      // Find the class with max probability
      double maxProb = probabilities[0];
      int maxIndex = 0;
      for (int i = 1; i < probabilities.length; i++) {
        if (probabilities[i] > maxProb) {
          maxProb = probabilities[i];
          maxIndex = i;
        }
      }

      // Build map of all probabilities
      final allProbs = <String, double>{};
      for (int i = 0; i < _labels.length; i++) {
        allProbs[_labels[i]] = probabilities[i];
      }

      print('Prediction: ${_labels[maxIndex]} (${(maxProb * 100).toStringAsFixed(1)}%)');

      return Prediction(
        label: _labels[maxIndex],
        confidence: maxProb,
        allProbabilities: allProbs,
      );
    } catch (e) {
      print('Prediction error: $e');
      rethrow;
    }
  }

  /// Prepare sensor data for the model
  List _prepareInput(List<List<double>> sensorData) {
    // Typical model expects [1, N, 3] where N = number of samples
    // sensorData format: [[accX, accY, accZ], ...]

    final expectedSamples = 300; // 3 seconds at 100Hz

    List<List<double>> processedData;

    if (sensorData.length == expectedSamples) {
      processedData = sensorData;
    } else if (sensorData.length < expectedSamples) {
      // Pad with zeros
      processedData = List.from(sensorData);
      while (processedData.length < expectedSamples) {
        processedData.add([0.0, 0.0, 0.0]);
      }
    } else {
      // Truncate
      processedData = sensorData.sublist(0, expectedSamples);
    }

    // Reshape to [1, 300, 3]
    return [processedData];
  }

  /// Dispose resources
  void dispose() {
    _interpreter?.close();
    _isInitialized = false;
    print('ML Service disposed');
  }
}

