import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/worlds.dart';
import '../services/progress_service.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';
import '../widgets/star_row.dart';
import 'match_level_screen.dart';
import 'abc_level_screen.dart';
import 'paint_level_screen.dart';

/// Candy-Crush tarzı, kıvrılan bir yol üzerinde dizilmiş bölüm (level)
/// düğümlerini gösteren dünya haritası. Kilitli bölümler asma kilitle,
/// açık bölümler yıldızlarıyla görünür.
class WorldPathScreen extends StatelessWidget {
  final WorldConfig world;
  const WorldPathScreen({super.key, required this.world});

  static const double _nodeGap = 128;
  static const double _amplitude = 90;

  Offset _nodeOffset(int index, double width) {
    final cx = width / 2;
    final x = cx + math.sin(index * 0.9) * _amplitude;
    final y = 90.0 + index * _nodeGap;
    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final total = world.levelCount;
    final contentHeight = 90.0 + (total - 1) * _nodeGap + 140;

    return ValueListenableBuilder(
      valueListenable: ProgressService.instance.version,
      builder: (context, _, __) {
        return Scaffold(
          backgroundColor: AppColors.bgAlt,
          body: SafeArea(
            child: Column(
              children: [
                _Header(world: world),
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: width,
                      height: contentHeight,
                      child: Stack(
                        children: [
                          CustomPaint(
                            size: Size(width, contentHeight),
                            painter: _PathPainter(
                              points: [
                                for (int i = 0; i < total; i++) _nodeOffset(i, width)
                              ],
                              color: world.gradient[1],
                            ),
                          ),
                          for (int i = 0; i < total; i++)
                            _buildNode(context, i, _nodeOffset(i, width)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNode(BuildContext context, int index, Offset pos) {
    final level = index + 1;
    final unlocked = ProgressService.instance.isUnlocked(world.id, level);
    final stars = ProgressService.instance.starsFor(world.id, level);

    return Positioned(
      left: pos.dx - 40,
      top: pos.dy - 40,
      child: Column(
        children: [
          GestureDetector(
            onTap: unlocked ? () => _openLevel(context, level) : null,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: unlocked
                    ? LinearGradient(colors: world.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight)
                    : null,
                color: unlocked ? null : AppColors.lockGrey,
                boxShadow: [
                  BoxShadow(
                    color: unlocked ? world.gradient[1].withOpacity(0.5) : AppColors.cardShadow,
                    offset: const Offset(0, 6),
                    blurRadius: 14,
                    spreadRadius: -3,
                  ),
                  const BoxShadow(color: AppColors.cardShadow, offset: Offset(0, 2), blurRadius: 3),
                ],
                border: Border.all(color: Colors.white, width: 4),
              ),
              alignment: Alignment.center,
              child: unlocked
                  ? Text('$level', style: AppText.h1.copyWith(color: Colors.white, fontSize: 26))
                  : const Icon(Icons.lock_rounded, color: Colors.white, size: 28),
            ),
          ),
          const SizedBox(height: 4),
          if (unlocked) StarRow(count: stars, size: 16),
        ],
      ),
    );
  }

  void _openLevel(BuildContext context, int level) async {
    AudioService.instance.button();
    Widget screen;
    switch (world.id) {
      case 'match':
        screen = MatchLevelScreen(level: level);
        break;
      case 'abc':
        screen = AbcLevelScreen(level: level);
        break;
      default:
        screen = PaintLevelScreen(level: level);
    }
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class _Header extends StatelessWidget {
  final WorldConfig world;
  const _Header({required this.world});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
          ),
          Expanded(
            child: Text(world.title(), style: AppText.h1, textAlign: TextAlign.center),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _PathPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  _PathPainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final paint = Paint()
      ..color = color.withOpacity(0.35)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final cur = points[i];
      final mid = Offset((prev.dx + cur.dx) / 2, (prev.dy + cur.dy) / 2);
      path.quadraticBezierTo(prev.dx, prev.dy, mid.dx, mid.dy);
    }
    path.lineTo(points.last.dx, points.last.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PathPainter oldDelegate) => false;
}
