import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tüm oyun ilerlemesini (yıldızlar, kilitler, çıkartmalar, istatistikler)
/// cihazda saklayan tek merkez. Hiçbir veri internete gitmez.
class ProgressService {
  ProgressService._();
  static final ProgressService instance = ProgressService._();

  SharedPreferences? _prefs;
  final ValueNotifier<int> version = ValueNotifier<int>(0); // UI yenileme tetikleyici

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _p => _prefs!;

  void _bump() => version.value++;

  // ---- Yıldızlar ----
  String _key(String world, int level) => 'stars_${world}_$level';

  int starsFor(String world, int level) => _p.getInt(_key(world, level)) ?? 0;

  Future<void> setStars(String world, int level, int stars) async {
    final current = starsFor(world, level);
    if (stars > current) {
      await _p.setInt(_key(world, level), stars);
    }
    // istatistik sayaçları
    if (world == 'match') {
      await _incStat('stat_match_done');
    }
    _bump();
  }

  bool isUnlocked(String world, int level) {
    if (level <= 1) return true;
    return starsFor(world, level - 1) > 0;
  }

  int totalStars() {
    int total = 0;
    for (final world in ['match', 'abc', 'paint']) {
      for (int i = 1; i <= 12; i++) {
        total += starsFor(world, i);
      }
    }
    return total;
  }

  // ---- İstatistikler ----
  Future<void> _incStat(String key, [int by = 1]) async {
    final v = _p.getInt(key) ?? 0;
    await _p.setInt(key, v + by);
  }

  Future<void> incGlyphsHeard() async {
    await _incStat('stat_glyphs_heard');
    _bump();
  }

  Future<void> addPaintSeconds(int seconds) async {
    await _incStat('stat_paint_seconds', seconds);
    _bump();
  }

  int get matchCompleted => _p.getInt('stat_match_done') ?? 0;
  int get glyphsHeard => _p.getInt('stat_glyphs_heard') ?? 0;
  int get paintMinutes => ((_p.getInt('stat_paint_seconds') ?? 0) / 60).floor();

  // ---- Çıkartmalar ----
  // Her giriş "id|glyph" biçiminde saklanır (id: dünya_bölüm, glyph: gösterilecek emoji/harf).
  Set<String> get _stickerEntries => (_p.getStringList('stickers') ?? []).toSet();

  /// UI'de göstermek için (id, glyph) çiftleri.
  List<MapEntry<String, String>> get stickers {
    return _stickerEntries.map((e) {
      final parts = e.split('|');
      return MapEntry(parts.first, parts.length > 1 ? parts[1] : '⭐');
    }).toList()
      ..sort((a, b) => a.key.compareTo(b.key));
  }

  bool hasSticker(String id) => _stickerEntries.any((e) => e.split('|').first == id);

  Future<void> unlockSticker(String id, String glyph) async {
    if (hasSticker(id)) return;
    final s = _stickerEntries..add('$id|$glyph');
    await _p.setStringList('stickers', s.toList());
    _bump();
  }

  // ---- Dil ----
  String get lang => _p.getString('lang') ?? 'tr';
  Future<void> setLang(String code) async {
    await _p.setString('lang', code);
    _bump();
  }

  // ---- Sıfırla ----
  Future<void> resetAll() async {
    await _p.clear();
    _bump();
  }
}
