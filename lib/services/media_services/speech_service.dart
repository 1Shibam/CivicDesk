import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _isInitialized = false; // Track initialization state
  bool _isListening = false;
  String _lastWords = '';

  Future<bool> initialize() async {
    _isInitialized = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );
    return _isInitialized;
  }

  Future<String?> listen() async {
    if (!_isInitialized) {
      // Check initialization
      throw Exception("SpeechToText not initialized");
    }
    if (!_isListening) {
      _lastWords = '';
      bool success = await _speech.listen(
        onResult: (result) {
          _lastWords = result.recognizedWords;
          if (result.finalResult) {
            _isListening = false;
          }
        },
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
