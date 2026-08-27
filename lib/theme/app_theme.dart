import 'package:flutter/material.dart';

/// Minik Kâşif için renk paleti ve genel görsel dil.
/// Sıcak, canlı ama göz yormayan pastel-canlı karışımı — "ucuz" değil,
/// derinlik için gradyanlar ve yumuşak gölgeler kullanılıyor.
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

  static const worldMatch = [Color(0xFFFF9472), Color(0xFFFF5E62)];
  static const worldAbc = [Color(0xFF6FC3FF), Color(0xFF3B82F6)];
  static const worldPaint = [Color(0xFF5EEAD4), Color(0xFF14B8A6)];

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
  );

  static const huge = TextStyle(
    fontFamily: _base,
    fontSize: 96,
    fontWeight: FontWeight.w900,
    color: AppColors.berry,
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

/// Ortak "yumuşak, kalın gölgeli" kart dekorasyonu — düz Material yerine
/// oyunsu bir derinlik hissi verir.
BoxDecoration playfulCard({
  required Color color,
  double radius = 26,
  Offset shadowOffset = const Offset(0, 6),
}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: AppColors.cardShadow,
        offset: shadowOffset,
        blurRadius: 0,
      ),
    ],
  );
}

BoxDecoration gradientCard({
  required List<Color> colors,
  double radius = 26,
  Offset shadowOffset = const Offset(0, 6),
}) {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: AppColors.cardShadow,
        offset: shadowOffset,
        blurRadius: 0,
      ),
    ],
  );
}
