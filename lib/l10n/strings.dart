import 'package:flutter/foundation.dart';

/// Basit, kod üretimi gerektirmeyen TR/EN dil katmanı.
/// AppLang.instance dinlenebilir (ValueNotifier) — dil değişince tüm
/// ekranlar otomatik güncellenir.
class AppLang {
  AppLang._();
  static final ValueNotifier<String> code = ValueNotifier<String>('tr');

  static bool get isTr => code.value == 'tr';
  static void toggle() => code.value = isTr ? 'en' : 'tr';
  static void set(String c) => code.value = c;
}

class S {
  static String t(String tr, String en) => AppLang.isTr ? tr : en;

  // Genel
  static String get appName => t('Minik Kâşif', 'Little Explorer');
  static String get tagline => t('Oyna, öğren, keşfet!', 'Play, learn, explore!');
  static String get back => t('Geri', 'Back');
  static String get worldMap => t('Dünya Haritası', 'World Map');

  // Dünyalar
  static String get worldMatchTitle => t('Eşleştirme Adası', 'Matching Island');
  static String get worldAbcTitle => t('Harf-Sayı Ormanı', 'Letters & Numbers Forest');
  static String get worldPaintTitle => t('Boyama Vadisi', 'Coloring Valley');
  static String get worldMatchSub => t('Hafızanı test et', 'Test your memory');
  static String get worldAbcSub => t('Dinle ve bul', 'Listen and find');
  static String get worldPaintSub => t('Hayal gücünü kullan', 'Use your imagination');

  static String levelLabel(int n) => t('Bölüm $n', 'Level $n');
  static String get locked => t('Kilitli', 'Locked');
  static String get play => t('Oyna', 'Play');
  static String get next => t('Devam', 'Continue');
  static String get retry => t('Tekrar Dene', 'Try Again');
  static String get done => t('Bitti', 'Done');
  static String get back2map => t('Haritaya Dön', 'Back to Map');

  static String get bravo => t('Harika!', 'Awesome!');
  static String get levelDone => t('Bölümü tamamladın!', 'Level complete!');
  static String get newSticker => t('Yeni çıkartma kazandın!', 'You earned a new sticker!');

  static String get findEmoji => t('Aynısını bul', 'Find the match');

  // ABC dünyası
  static String get whichLetter => t('Hangisi bu?', 'Which one is this?');
  static String get listenAgain => t('Tekrar dinle', 'Listen again');

  // Boyama
  static String get pickColor => t('Bir renk seç', 'Pick a color');
  static String get clear => t('Temizle', 'Clear');
  static String get finishPainting => t('Tamamladım', "I'm done");

  // Ebeveyn
  static String get parentArea => t('Ebeveyn Bölümü', 'Parents Area');
  static String get parentGateTitle =>
      t('Bu bölüm yetişkinler içindir', 'This area is for grown-ups');
  static String gateQuestion(int a, int b) =>
      t('$a çarpı $b kaçtır?', 'What is $a times $b?');
  static String get confirm => t('Onayla', 'Confirm');
  static String get gateWrong => t('Olmadı, tekrar dene', 'Not quite, try again');
  static String get statsTitle => t('Oynama İstatistikleri', 'Play Statistics');
  static String get statMatch => t('Eşleştirme — tamamlanan bölüm', 'Matching — levels completed');
  static String get statAbc => t('Dinlenen harf/sayı', 'Letters/numbers listened');
  static String get statPaint => t('Boyama süresi (dakika)', 'Coloring time (minutes)');
  static String get statStars => t('Toplam yıldız', 'Total stars');
  static String get privacyNote => t(
        'Bu uygulama internete bağlanmaz, çocuğunuzdan hiçbir kişisel veri toplamaz, '
        'üçüncü taraf reklam veya izleyici içermez. Tüm veriler yalnızca bu cihazda saklanır.',
        'This app makes no internet connection, collects no personal data from your child, '
        'and contains no third-party ads or trackers. All data stays on this device only.',
      );
  static String get resetProgress => t('İlerlemeyi Sıfırla', 'Reset Progress');
  static String get resetConfirm =>
      t('Tüm yıldızlar ve ilerleme silinecek. Emin misin?', 'All stars and progress will be erased. Are you sure?');
  static String get cancel => t('Vazgeç', 'Cancel');
  static String get stickerAlbum => t('Çıkartma Albümü', 'Sticker Album');
  static String get noStickersYet =>
      t('Henüz çıkartma yok. Bölümleri tamamla, topla!', 'No stickers yet. Complete levels to collect them!');
}
