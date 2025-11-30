import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/prediction.dart';

class MLService {
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Initialize model from assets
  Future<void> initialize() async {
    try {
      print('Loading ML model from assets...');
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      final labelsData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsData.split('\n').where((l) => l.isNotEmpty).toList();
      _isInitialized = true;
    } catch (e) {
      print('Error loading model: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  /// Load model from a remote URL
  Future<void> loadModelFromUrl(String url, {String? labelsUrl}) async {
    try {
      print('Downloading model from $url ...');

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) throw Exception('Failed to download model');

      final tempDir = await getTemporaryDirectory();
      final modelFile = File('${tempDir.path}/model.tflite');
      await modelFile.writeAsBytes(response.bodyBytes);

      _interpreter = await Interpreter.fromFile(modelFile);

      if (labelsUrl != null) {
        final labelsResponse = await http.get(Uri.parse(labelsUrl));
        if (labelsResponse.statusCode == 200) {
          _labels = labelsResponse.body
              .split('\n')
              .where((l) => l.isNotEmpty)
              .toList();
        } else {
          throw Exception('Failed to download labels');
        }
      }

      _isInitialized = true;
      print('Model loaded successfully from URL!');
    } catch (e) {
      print('Error loading model from URL: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  /// Make a prediction
  Future<Prediction> predict(List<List<double>> sensorData) async {
    if (!_isInitialized || _interpreter == null) {
      throw Exception('Model not initialized!');
    }

    final input = _prepareInput(sensorData);
    final output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);

    final startTime = DateTime.now();
    _interpreter!.run(input, output);
    final inferenceTime = DateTime.now().difference(startTime).inMilliseconds;

    print('Inference time: ${inferenceTime}ms');

    final probabilities = (output[0] as List).cast<double>();
    double maxProb = probabilities[0];
    int maxIndex = 0;
    for (int i = 1; i < probabilities.length; i++) {
      if (probabilities[i] > maxProb) {
        maxProb = probabilities[i];
        maxIndex = i;
      }
    }

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
  }

  /// Prepare sensor data for the model
  List _prepareInput(List<List<double>> sensorData) {
    final expectedSamples = 300;

    List<List<double>> processedData;

    if (sensorData.length == expectedSamples) {
      processedData = sensorData;
    } else if (sensorData.length < expectedSamples) {
      processedData = List.from(sensorData);
      while (processedData.length < expectedSamples) {
        processedData.add([0.0, 0.0, 0.0]);
      }
    } else {
      processedData = sensorData.sublist(0, expectedSamples);
    }

    return [processedData];
  }

  /// Dispose resources
  void dispose() {
    _interpreter?.close();
    _isInitialized = false;
    print('ML Service disposed');
  }
}
