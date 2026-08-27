import 'package:flutter/material.dart';

/// Minik Kâşif için renk paleti ve genel görsel dil.
/// Sıcak, canlı ama göz yormayan pastel-canlı karışımı — "ucuz" değil,
/// derinlik için çok katmanlı gradyanlar, renkli yumuşak gölgeler ve
/// hafif parlaklık (gloss) vurguları kullanılıyor.
class AppColors {
  static const bg = Color(0xFFFDF6EC);
  static const bgAlt = Color(0xFFEFE7FA);
  static const ink = Color(0xFF3D3A50);
  static const inkSoft = Color(0xFF6E6A82);

  static const sun = Color(0xFFFFC93C);
  static const coral = Color(0xFFFF7B54);
  static const mint = Color(0xFF33C6B7);
  static const berry = Color(0xFF9B5DE5);
  static const sky = Color(0xFF3FA7F5);
  static const leaf = Color(0xFF2ECC71);
  static const pink = Color(0xFFF45B94);

  static const cardShadow = Color(0x1F3D3A50);

  // Üç durak: açık uç (parlaklık hissi) -> ana renk -> koyu uç (derinlik).
  static const worldMatch = [Color(0xFFFFB199), Color(0xFFFF7B54), Color(0xFFE0453D)];
  static const worldAbc = [Color(0xFF93D6FF), Color(0xFF4C93F5), Color(0xFF2E56D1)];
  static const worldPaint = [Color(0xFF8CF3E1), Color(0xFF2BC4AE), Color(0xFF128F7E)];

  static const gold = Color(0xFFFFD93C);
  static const lockGrey = Color(0xFFC9C4D6);
}

class AppText {
  static const _base = 'Roboto';

  static const display = TextStyle(
    fontFamily: _base,
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: AppColors.ink,
    letterSpacing: .2,
  );

  static const h1 = TextStyle(
    fontFamily: _base,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
  );

  static const h2 = TextStyle(
    fontFamily: _base,
    fontSize: 19,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  static const body = TextStyle(
    fontFamily: _base,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.inkSoft,
  );

  static const button = TextStyle(
    fontFamily: _base,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    shadows: [Shadow(color: Color(0x40000000), offset: Offset(0, 1.5), blurRadius: 3)],
  );

  static const huge = TextStyle(
    fontFamily: _base,
    fontSize: 96,
    fontWeight: FontWeight.w900,
    color: AppColors.berry,
  );

  /// Gradyanlı kartların üstünde kullanılan, hafif gölgeli beyaz başlık.
  static const onGradientTitle = TextStyle(
    fontFamily: _base,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    shadows: [Shadow(color: Color(0x33000000), offset: Offset(0, 1.5), blurRadius: 4)],
  );

  static const onGradientBody = TextStyle(
    fontFamily: _base,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    shadows: [Shadow(color: Color(0x2A000000), offset: Offset(0, 1), blurRadius: 3)],
  );
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.berry,
      brightness: Brightness.light,
    ),
    fontFamily: 'Roboto',
    splashFactory: InkRipple.splashFactory,
  );
}

/// Düz renkli kart — yumuşak, çok katmanlı, renkli gölgeyle derinlik hissi.
/// Eski "sert/düz gölge" yerine bulanık + katmanlı bir gölge kullanılıyor,
/// ince beyaz bir kenar ise "camsı" bir kenarlık hissi veriyor.
BoxDecoration playfulCard({
  required Color color,
  double radius = 26,
  Offset shadowOffset = const Offset(0, 6),
}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: Colors.white.withOpacity(0.7), width: 1.2),
    boxShadow: [
      BoxShadow(
        color: AppColors.ink.withOpacity(0.12),
        offset: shadowOffset,
        blurRadius: 16,
        spreadRadius: -3,
      ),
      BoxShadow(
        color: AppColors.ink.withOpacity(0.06),
        offset: const Offset(0, 2),
        blurRadius: 4,
      ),
    ],
  );
}

/// Gradyanlı, öne çıkan oyunsu kart/düğme dekorasyonu. Kartın kendi
/// renginden tonlanmış yumuşak bir "ambiyans" gölgesi + ince camsı kenarlık
/// ile derinlik verir. [colors] 2 veya 3 durak olabilir; 3 durak verilirse
/// (açık->orta->koyu) daha zengin bir gradyan oluşur.
BoxDecoration gradientCard({
  required List<Color> colors,
  double radius = 26,
  Offset shadowOffset = const Offset(0, 8),
}) {
  final base = colors.length > 1 ? colors[colors.length ~/ 2] : colors.first;
  final stops = colors.length == 3 ? const [0.0, 0.45, 1.0] : null;
  return BoxDecoration(
    gradient: LinearGradient(
      colors: colors,
      stops: stops,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.2),
    boxShadow: [
      BoxShadow(
        color: base.withOpacity(0.45),
        offset: shadowOffset,
        blurRadius: 20,
        spreadRadius: -6,
      ),
      BoxShadow(
        color: AppColors.ink.withOpacity(0.14),
        offset: const Offset(0, 3),
        blurRadius: 6,
      ),
    ],
  );
}
