class Prediction {
  final String label;
  final double confidence;
  final Map<String, double> allProbabilities;
  final DateTime timestamp;

  Prediction({
    required this.label,
    required this.confidence,
    required this.allProbabilities,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get isCorrect => label == 'circular_correct' && confidence > 0.8;
  bool get isUncertain => confidence < 0.6;

  String get feedbackMessage {
    if (isUncertain) {
      return 'Uncertain movement, please try again';
    }
    
    switch (label) {
      case 'circular_correct':
        return confidence > 0.8
            ? 'Excellent! Correct movement!'
            : 'Good movement, keep going';
      case 'circular_fast':
        return 'Slow down your movement';
      case 'erratic':
        return 'Movement too erratic';
      case 'light_touch':
        return 'Press a bit harder';
      default:
        return 'Movement detected';
    }
  }

  String get emoji {
    switch (label) {
      case 'circular_correct':
        return '';
      case 'circular_fast':
        return '';
      case 'erratic':
        return '';
      case 'light_touch':
        return '';
      default:
        return '';
    }
  }
}

