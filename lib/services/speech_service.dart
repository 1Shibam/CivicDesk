import 'package:flutter/rendering.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  String _lastWords = '';

  Future<bool> initialize() async {
    bool available = await _speech.initialize(
      onStatus: (status) => debugPrint('Status: $status'),
      onError: (error) => debugPrint('Error: $error'),
    );
    return available;
  }

  Future<String?> listen() async {
    if (!_isListening) {
      _lastWords = '';
      bool success = await _speech.listen(
        onResult: (result) {
          _lastWords = result.recognizedWords;
          if (result.finalResult) {
            _isListening = false;
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        partialResults: true, // Get real-time partial results
      );
      _isListening = success;
      return _lastWords;
    }
    return null;
  }

  void stop() {
    _speech.stop();
    _isListening = false;
  }

  bool get isListening => _isListening;
  String get lastWords => _lastWords;
}
