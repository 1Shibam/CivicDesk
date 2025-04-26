import 'package:complaints/services/media_services/speech_service.dart';

import 'package:flutter/material.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  SpeechScreenState createState() => SpeechScreenState();
}

class SpeechScreenState extends State<SpeechScreen> {
  final SpeechService _speechService = SpeechService();
  String _text = 'Tap mic to start speaking';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speechService.initialize();
    setState(() {
      _isInitialized = available;
      if (!available) {
        _text = 'Speech recognition not available';
      }
    });
  }

  void _toggleListening() async {
    if (!_isInitialized) return; // Guard clause

    if (_speechService.isListening) {
      _speechService.stop();
      setState(() => _text = _speechService.lastWords);
    } else {
      try {
        String? result = await _speechService.listen();
        if (result != null) {
          setState(() => _text = result);
        }
      } catch (e) {
        setState(() => _text = 'Error: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Text(_text)),
        FloatingActionButton(
          onPressed: _isInitialized
              ? _toggleListening
              : null, // Disable if not initialized
          child: Icon(_speechService.isListening ? Icons.mic_off : Icons.mic),
        ),
      ],
    );
  }
}
