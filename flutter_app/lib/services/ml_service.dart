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

      // Download model
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) throw Exception('Failed to download model');

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final modelFile = File('${tempDir.path}/model.tflite');
      await modelFile.writeAsBytes(response.bodyBytes);

      // Load interpreter
      _interpreter = await Interpreter.fromFile(modelFile);

      // Optionally download labels
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

  // ... (reste de la classe predict, dispose, etc. reste inchangé)
}
