import 'dart:async';
import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/game_data.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import '../theme/app_theme.dart';
import '../widgets/coloring_templates.dart';
import 'level_complete_screen.dart';

class _Stroke {
  final Color color;
  final double width;
  final List<Offset?> points = [];
  _Stroke(this.color, this.width);
}

class PaintLevelScreen extends StatefulWidget {
  final int level;
  const PaintLevelScreen({super.key, required this.level});

  @override
  State<PaintLevelScreen> createState() => _PaintLevelScreenState();
}

class _PaintLevelScreenState extends State<PaintLevelScreen> {
  static const _colors = [
    Color(0xFFFF7B54), Color(0xFFFFC93C), Color(0xFF33C6B7), Color(0xFF3FA7F5),
    Color(0xFF9B5DE5), Color(0xFFF45B94), Color(0xFF2ECC71), Color(0xFF8D6E63),
    Color(0xFF3D3A50), Colors.white,
  ];

  final List<_Stroke> _strokes = [];
  Color _color = _colors.first;
  double _width = 16;
  int _strokeCount = 0;
  Timer? _timer;
  int _seconds = 0;

  late PaintTemplate _template;

  @override
  void initState() {
    super.initState();
    _template = paintTemplates[(widget.level - 1) % paintTemplates.length];
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _seconds++);
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (_seconds > 0) {
      ProgressService.instance.addPaintSeconds(_seconds);
    }
    super.dispose();
  }

  void _startStroke(Offset p) {
    setState(() {
      final s = _Stroke(_color, _width)..points.add(p);
      _strokes.add(s);
      _strokeCount++;
    });
    AudioService.instance.brush();
  }

  void _extendStroke(Offset p) {
    if (_strokes.isEmpty) return;
    setState(() => _strokes.last.points.add(p));
  }

  void _endStroke() {
    if (_strokes.isEmpty) return;
    setState(() => _strokes.last.points.add(null));
  }

  void _clear() {
    AudioService.instance.pop();
    setState(() {
      _strokes.clear();
      _strokeCount = 0;
    });
  }

  void _finish() {
    final stars = _strokeCount >= 12 ? 3 : (_strokeCount >= 4 ? 2 : 1);
    AudioService.instance.star();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LevelCompleteScreen(
          world: 'paint',
          level: widget.level,
          stars: stars,
          stickerEmoji: '🎨',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
                  ),
                  Expanded(
                    child: Text(_template.name, style: AppText.h1, textAlign: TextAlign.center),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: playfulCard(color: Colors.white),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final size = Size(constraints.maxWidth, constraints.maxHeight);
                      return GestureDetector(
                        onPanStart: (d) => _startStroke(d.localPosition),
                        onPanUpdate: (d) => _extendStroke(d.localPosition),
                        onPanEnd: (_) => _endStroke(),
                        child: CustomPaint(
                          size: size,
                          painter: _ColoringPainter(
                            strokes: _strokes,
                            outline: ColoringTemplates.build(_template.id, size),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _colors.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final c = _colors[i];
                    final selected = c == _color;
                    return GestureDetector(
                      onTap: () => setState(() => _color = c),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected ? AppColors.ink : Colors.black12,
                            width: selected ? 3 : 1,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  _toolBtn(Icons.brush_rounded, () => setState(() => _width = 8)),
                  const SizedBox(width: 8),
                  _toolBtn(Icons.format_paint_rounded, () => setState(() => _width = 20)),
                  const SizedBox(width: 8),
                  _toolBtn(Icons.delete_outline_rounded, _clear),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: _finish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.leaf,
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.check_rounded, color: Colors.white),
                    label: Text(S.finishPainting, style: AppText.button),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, height: 48,
        decoration: playfulCard(color: Colors.white, radius: 14, shadowOffset: const Offset(0, 3)),
        child: Icon(icon, color: AppColors.inkSoft),
      ),
    );
  }
}

class _ColoringPainter extends CustomPainter {
  final List<_Stroke> strokes;
  final List<Path> outline;
  _ColoringPainter({required this.strokes, required this.outline});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);

    for (final s in strokes) {
      final paint = Paint()
        ..color = s.color
        ..strokeWidth = s.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      for (int i = 0; i < s.points.length - 1; i++) {
        final p1 = s.points[i];
        final p2 = s.points[i + 1];
        if (p1 != null && p2 != null) {
          canvas.drawLine(p1, p2, paint);
        }
      }
    }

    final outlinePaint = Paint()
      ..color = AppColors.ink.withOpacity(0.85)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    for (final path in outline) {
      canvas.drawPath(path, outlinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ColoringPainter oldDelegate) => true;
}
