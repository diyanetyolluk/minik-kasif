import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 0-3 arası yıldız gösterimi. Kazanılan yıldızlar sırayla "pop" animasyonu
/// ile büyüyerek belirir.
class StarRow extends StatelessWidget {
  final int count; // 0-3
  final double size;
  final bool animate;

  const StarRow({super.key, required this.count, this.size = 28, this.animate = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final filled = i < count;
        final star = Icon(
          filled ? Icons.star_rounded : Icons.star_outline_rounded,
          color: filled ? AppColors.gold : AppColors.lockGrey,
          size: size,
        );
        if (!animate || !filled) return star;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 400 + i * 200),
          curve: Curves.elasticOut,
          builder: (context, v, child) => Transform.scale(scale: v, child: child),
          child: star,
        );
      }),
    );
  }
}
