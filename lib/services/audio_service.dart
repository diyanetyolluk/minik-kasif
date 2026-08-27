import 'package:audioplayers/audioplayers.dart';

/// Kısa oyun ses efektlerini çalar. Her çağrıda yeni bir AudioPlayer havuzdan
/// alınır ki üst üste hızlı tıklamalarda sesler birbirini kesmesin.
class AudioService {
  AudioService._();
  static final AudioService instance = AudioService._();

  bool _muted = false;
  bool get muted => _muted;
  void toggleMute() => _muted = !_muted;

  final List<AudioPlayer> _pool = List.generate(6, (_) => AudioPlayer()
    ..setReleaseMode(ReleaseMode.stop)
    ..setPlayerMode(PlayerMode.lowLatency));
  int _cursor = 0;

  Future<void> play(String fileName) async {
    if (_muted) return;
    final player = _pool[_cursor];
    _cursor = (_cursor + 1) % _pool.length;
    try {
      await player.stop();
      await player.play(AssetSource('sounds/$fileName'));
    } catch (_) {
      // Ses cihazda çalınamazsa oyunu bozma — sessizce geç.
    }
  }

  Future<void> tap() => play('tap.wav');
  Future<void> correct() => play('correct.wav');
  Future<void> wrong() => play('wrong.wav');
  Future<void> flip() => play('flip.wav');
  Future<void> match() => play('match.wav');
  Future<void> star() => play('star.wav');
  Future<void> levelComplete() => play('level_complete.wav');
  Future<void> levelUnlock() => play('level_unlock.wav');
  Future<void> button() => play('button.wav');
  Future<void> whoosh() => play('whoosh.wav');
  Future<void> pop() => play('pop.wav');
  Future<void> brush() => play('brush.wav');
  Future<void> stickerCollect() => play('collect_sticker.wav');

  void dispose() {
    for (final p in _pool) {
      p.dispose();
    }
  }
}
