import '../l10n/strings.dart';

/// Eşleştirme oyununda kullanılan nesneler. Her biri bir emoji ve
/// iki dilde okunuşudur (TTS için).
class MatchItem {
  final String emoji;
  final String tr;
  final String en;
  const MatchItem(this.emoji, this.tr, this.en);
  String get name => AppLang.isTr ? tr : en;
}

const List<MatchItem> matchPool = [
  MatchItem('🐶', 'Köpek', 'Dog'),
  MatchItem('🐱', 'Kedi', 'Cat'),
  MatchItem('🐰', 'Tavşan', 'Rabbit'),
  MatchItem('🦁', 'Aslan', 'Lion'),
  MatchItem('🐸', 'Kurbağa', 'Frog'),
  MatchItem('🐧', 'Penguen', 'Penguin'),
  MatchItem('🐻', 'Ayı', 'Bear'),
  MatchItem('🐵', 'Maymun', 'Monkey'),
  MatchItem('🦊', 'Tilki', 'Fox'),
  MatchItem('🐢', 'Kaplumbağa', 'Turtle'),
  MatchItem('🐳', 'Balina', 'Whale'),
  MatchItem('🦋', 'Kelebek', 'Butterfly'),
  MatchItem('🐝', 'Arı', 'Bee'),
  MatchItem('🐌', 'Salyangoz', 'Snail'),
  MatchItem('🦉', 'Baykuş', 'Owl'),
  MatchItem('🐴', 'At', 'Horse'),
];

/// Bölüm numarasına göre kaç çift kart kullanılacağını verir (zorluk eğrisi).
int matchPairsForLevel(int level) {
  const curve = [3, 3, 4, 4, 5, 5, 6, 8];
  return curve[(level - 1).clamp(0, curve.length - 1)];
}

/// Harf/Sayı dünyası: Türkçe alfabe + 1-20 arası sayılar.
const List<String> turkishLetters = [
  'A', 'B', 'C', 'Ç', 'D', 'E', 'F', 'G', 'Ğ', 'H', 'I', 'İ', 'J', 'K', 'L',
  'M', 'N', 'O', 'Ö', 'P', 'R', 'S', 'Ş', 'T', 'U', 'Ü', 'V', 'Y', 'Z',
];
const List<String> englishLetters = [
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
  'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
];

const List<String> _numWordsTr = [
  'bir', 'iki', 'üç', 'dört', 'beş', 'altı', 'yedi', 'sekiz', 'dokuz', 'on',
  'on bir', 'on iki', 'on üç', 'on dört', 'on beş', 'on altı', 'on yedi',
  'on sekiz', 'on dokuz', 'yirmi',
];
const List<String> _numWordsEn = [
  'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine',
  'ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen',
  'seventeen', 'eighteen', 'nineteen', 'twenty',
];

String numberWord(int n) => AppLang.isTr ? _numWordsTr[n - 1] : _numWordsEn[n - 1];

/// Her bölümde (level) kaç soru sorulacağını ve kaç seçenek sunulacağını
/// belirleyen zorluk eğrisi.
class AbcLevelConfig {
  final int questionCount;
  final int optionCount;
  final bool useNumbers; // false: harf, true: sayı
  const AbcLevelConfig(this.questionCount, this.optionCount, this.useNumbers);
}

AbcLevelConfig abcConfigForLevel(int level) {
  final useNumbers = level.isEven; // bölümler harf/sayı arası dönüşümlü
  const options = [3, 3, 4, 4, 5, 5, 6, 6, 6, 6];
  final opt = options[(level - 1).clamp(0, options.length - 1)];
  return AbcLevelConfig(5, opt, useNumbers);
}

/// Boyama dünyasındaki basit çizgi-resim şablonları.
class PaintTemplate {
  final String id;
  final String tr;
  final String en;
  const PaintTemplate(this.id, this.tr, this.en);
  String get name => AppLang.isTr ? tr : en;
}

const List<PaintTemplate> paintTemplates = [
  PaintTemplate('sun', 'Güneş', 'Sun'),
  PaintTemplate('house', 'Ev', 'House'),
  PaintTemplate('fish', 'Balık', 'Fish'),
  PaintTemplate('butterfly', 'Kelebek', 'Butterfly'),
  PaintTemplate('rocket', 'Roket', 'Rocket'),
  PaintTemplate('flower', 'Çiçek', 'Flower'),
];
