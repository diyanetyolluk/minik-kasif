import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/strings.dart';

class WorldConfig {
  final String id; // 'match' | 'abc' | 'paint'
  final int levelCount;
  final List<Color> gradient;
  final IconData icon;
  final String Function() title;
  final String Function() subtitle;

  const WorldConfig({
    required this.id,
    required this.levelCount,
    required this.gradient,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

final List<WorldConfig> worlds = [
  WorldConfig(
    id: 'match',
    levelCount: 8,
    gradient: AppColors.worldMatch,
    icon: Icons.pets_rounded,
    title: () => S.worldMatchTitle,
    subtitle: () => S.worldMatchSub,
  ),
  WorldConfig(
    id: 'abc',
    levelCount: 10,
    gradient: AppColors.worldAbc,
    icon: Icons.abc_rounded,
    title: () => S.worldAbcTitle,
    subtitle: () => S.worldAbcSub,
  ),
  WorldConfig(
    id: 'paint',
    levelCount: 6,
    gradient: AppColors.worldPaint,
    icon: Icons.palette_rounded,
    title: () => S.worldPaintTitle,
    subtitle: () => S.worldPaintSub,
  ),
];

WorldConfig worldById(String id) => worlds.firstWhere((w) => w.id == id);
