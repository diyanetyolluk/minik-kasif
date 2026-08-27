import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Harici paket kullanmadan, saf CustomPainter ile konfeti efekti.
/// Bölüm tamamlama ekranlarında kutlama hissi verir.
class ConfettiOverlay extends StatefulWidget {
  final bool play;
  const ConfettiOverlay({super.key, this.play = true});

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiPiece {
  double x, y, vx, vy, rot, vrot, size;
  Color color;
  _ConfettiPiece({
    required this.x, required this.y, required this.vx, required this.vy,
    required this.rot, required this.vrot, required this.size, required this.color,
  });
}

class _ConfettiOverlayState extends State<ConfettiOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final List<_ConfettiPiece> _pieces = [];
  final _rnd = math.Random();

  static const _palette = [
    Color(0xFFFF7B54), Color(0xFFFFC93C), Color(0xFF33C6B7),
    Color(0xFF9B5DE5), Color(0xFF3FA7F5), Color(0xFFF45B94),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..addListener(_step)
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed && widget.play) {
          _spawn();
          _ctrl.forward(from: 0);
        }
      });
    if (widget.play) {
      _spawn();
      _ctrl.forward();
    }
  }

  void _spawn() {
    _pieces.clear();
    for (int i = 0; i < 60; i++) {
      _pieces.add(_ConfettiPiece(
        x: _rnd.nextDouble(),
        y: -0.1 - _rnd.nextDouble() * 0.4,
        vx: (_rnd.nextDouble() - 0.5) * 0.15,
        vy: 0.35 + _rnd.nextDouble() * 0.35,
        rot: _rnd.nextDouble() * math.pi,
        vrot: (_rnd.nextDouble() - 0.5) * 6,
        size: 6 + _rnd.nextDouble() * 8,
        color: _palette[_rnd.nextInt(_palette.length)],
      ));
    }
  }

  void _step() {
    setState(() {});
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.play) return const SizedBox.shrink();
    return IgnorePointer(
      child: CustomPaint(
        painter: _ConfettiPainter(_pieces, _ctrl.value),
        size: Size.infinite,
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiPiece> pieces;
  final double t;
  _ConfettiPainter(this.pieces, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in pieces) {
      final x = (p.x + p.vx * t) * size.width;
      final y = (p.y + p.vy * t + 0.4 * t * t) * size.height;
      if (y < -20 || y > size.height + 20) continue;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rot + p.vrot * t);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.5),
        Paint()..color = p.color,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => true;
}
