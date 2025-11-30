import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/ml_service.dart';
import '../services/sensor_service.dart';
import '../models/prediction.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({Key? key}) : super(key: key);

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final MLService _mlService = MLService();
  final SensorService _sensorService = SensorService();

  bool _isInitialized = false;
  bool _isCollecting = false;
  Prediction? _lastPrediction;
  String _statusMessage = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _mlService.initialize();
      setState(() {
        _isInitialized = true;
        _statusMessage = 'Ready! Tap to start';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
      });
    }
  }

  void _startExam() {
    if (!_isInitialized || _isCollecting) return;

    setState(() {
      _isCollecting = true;
      _statusMessage = 'Collecting data... (3s)';
      _lastPrediction = null;
    });

    _sensorService.startCollecting(
      durationSeconds: 3,
      targetSamples: 300,
      onDataReady: (data) async {
        try {
          final prediction = await _mlService.predict(data);

          setState(() {
            _lastPrediction = prediction;
            _isCollecting = false;
            _statusMessage = prediction.feedbackMessage;
          });

        } catch (e) {
          setState(() {
            _isCollecting = false;
            _statusMessage = 'Prediction error: $e';
          });
        }
      },
      onError: (error) {
        setState(() {
          _isCollecting = false;
          _statusMessage = 'Error: $error';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guided Exam'),
        backgroundColor: Colors.pink.shade400,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pink.shade400,
              Colors.pink.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _buildInstructionsCard(),
                const SizedBox(height: 32),
                Expanded(child: _buildVisualization()),
                const SizedBox(height: 32),
                _buildActionButton(),
                const SizedBox(height: 16),
                _buildStatusText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.pink.shade400),
              const SizedBox(width: 12),
              Text(
                'Instructions',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• Place the phone on your wrist\n'
            '• Make slow circular movements\n'
            '• 3–4 circles in 3 seconds\n'
            '• Medium, consistent pressure',
            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualization() {
    if (_isCollecting) {
      return _buildCollectingView();
    } else if (_lastPrediction != null) {
      return _buildResultView(_lastPrediction!);
    } else {
      return _buildReadyView();
    }
  }

  Widget _buildCollectingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: CircularProgressIndicator(
              strokeWidth: 8,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Analysing...',
            style: GoogleFonts.poppins(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView(Prediction prediction) {
    final color = _getColorForPrediction(prediction);

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            prediction.emoji,
            style: const TextStyle(fontSize: 80),
          ),

          const SizedBox(height: 24),

          Text(
            _getLabelText(prediction.label),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            '${(prediction.confidence * 100).toStringAsFixed(1)}% confidence',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 32),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              prediction.feedbackMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 24),
          _buildProbabilitiesChart(prediction),
        ],
      ),
    );
  }

  Widget _buildReadyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pan_tool,
            size: 120,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(height: 24),
          Text(
            'Ready to start',
            style: GoogleFonts.poppins(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tap the button below',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProbabilitiesChart(Prediction prediction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: prediction.allProbabilities.entries.map((entry) {
        final percentage = entry.value * 100;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getLabelText(entry.key),
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: entry.value,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(
                  _getColorForLabel(entry.key),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: _isInitialized && !_isCollecting ? _startExam : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.pink.shade400,
        padding: const EdgeInsets.symmetric(
          horizontal: 48,
          vertical: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isCollecting ? Icons.hourglass_empty : Icons.play_arrow,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            _isCollecting ? 'Analyzing...' : 'Start (3s)',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusText() {
    return Text(
      _statusMessage,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }

  Color _getColorForPrediction(Prediction prediction) {
    if (prediction.isCorrect) {
      return Colors.green;
    } else if (prediction.label == 'erratic') {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }

  Color _getColorForLabel(String label) {
    switch (label) {
      case 'circular_correct':
        return Colors.green;
      case 'circular_fast':
        return Colors.orange;
      case 'erratic':
        return Colors.red;
      case 'light_touch':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  String _getLabelText(String label) {
    switch (label) {
      case 'circular_correct':
        return 'Correct Movement';
      case 'circular_fast':
        return 'Too Fast';
      case 'erratic':
        return 'Erratic';
      case 'light_touch':
        return 'Light Pressure';
      default:
        return label;
    }
  }

  @override
  void dispose() {
    _sensorService.dispose();
    _mlService.dispose();
    super.dispose();
  }
}

