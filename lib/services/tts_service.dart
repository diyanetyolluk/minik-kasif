import 'package:flutter_tts/flutter_tts.dart';
import '../l10n/strings.dart';

/// Cihazın yerleşik sesli okuma motorunu kullanır — internet gerekmez,
/// harici ses dosyası indirmez, tamamen cihaz üzerinde çalışır.
class TtsService {
  TtsService._();
  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _ready = false;

  Future<void> _ensureReady() async {
    if (_ready) return;
    await _tts.setSpeechRate(0.42);
    await _tts.setPitch(1.15);
    await _tts.setVolume(1.0);
    _ready = true;
  }

  Future<void> speak(String text) async {
    await _ensureReady();
    await _tts.setLanguage(AppLang.isTr ? 'tr-TR' : 'en-US');
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() => _tts.stop();
}
