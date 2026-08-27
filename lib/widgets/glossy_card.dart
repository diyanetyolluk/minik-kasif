import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// [gradientCard] dekorasyonunun üstüne ince, diyagonal bir "cam parlaklığı"
/// (gloss) katmanı ekleyen sarmalayıcı. Harici görsel/asset gerektirmez —
/// yarı saydam beyaz bir gradyan ile premium/"cilalı" bir his verir.
class GlossyCard extends StatelessWidget {
  final List<Color> colors;
  final double radius;
  final Offset shadowOffset;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const GlossyCard({
    super.key,
    required this.colors,
    required this.child,
    this.radius = 26,
    this.shadowOffset = const Offset(0, 8),
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientCard(colors: colors, radius: radius, shadowOffset: shadowOffset),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          children: [
            Positioned(
              top: -radius * 0.7,
              left: -radius * 0.5,
              right: -radius * 0.5,
              child: IgnorePointer(
                child: Container(
                  height: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    gradient: LinearGradient(
                      colors: [Colors.white.withOpacity(0.34), Colors.white.withOpacity(0.0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}
