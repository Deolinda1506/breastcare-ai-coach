import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class SensorService {
  final List<List<double>> _dataBuffer = [];
  StreamSubscription<AccelerometerEvent>? _subscription;
  Timer? _collectionTimer;
  bool _isCollecting = false;

  bool get isCollecting => _isCollecting;

  void startCollecting({
    required Function(List<List<double>>) onDataReady,
    required Function(String) onError,
    int durationSeconds = 3,
    int targetSamples = 300,
  }) {
    if (_isCollecting) {
      onError('Collection déjà en cours!');
      return;
    }

    _isCollecting = true;
    _dataBuffer.clear();

    _collectionTimer = Timer(Duration(seconds: durationSeconds), () {
      _stopCollecting(onDataReady);
    });

    _subscription = accelerometerEvents.listen(
      (AccelerometerEvent event) {
        if (!_isCollecting) return;
        _dataBuffer.add([event.x, event.y, event.z]);
        if (_dataBuffer.length >= targetSamples) {
          _stopCollecting(onDataReady);
        }
      },
      onError: (error) {
        onError('Erreur capteur: $error');
        stopCollecting();
      },
    );
  }

  void _stopCollecting(Function(List<List<double>>) onDataReady) {
    if (!_isCollecting) return;
    _isCollecting = false;
    _subscription?.cancel();
    _collectionTimer?.cancel();

    if (_dataBuffer.isNotEmpty) {
      onDataReady(List.from(_dataBuffer));
    }
    _dataBuffer.clear();
  }

  void stopCollecting() {
    _isCollecting = false;
    _subscription?.cancel();
    _collectionTimer?.cancel();
    _dataBuffer.clear();
  }

  void dispose() {
    stopCollecting();
  }
}

