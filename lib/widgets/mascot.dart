import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Maskotumuz Pati — CustomPainter ile vektör olarak çizilen bir tilki.
/// Harici görsel dosyasına ihtiyaç duymaz, her boyuta pürüzsüz ölçeklenir.
/// Çok katmanlı gradyanlar, yumuşak bir parlaklık (gloss) vurgusu ve
/// bulanık ambiyans gölgesiyle "stüdyo çizimi" hissi hedeflenir; nefes
/// alma + göz kırpma + hafif kulak kıpırdaması ile de canlı durur.
class PatiMascot extends StatefulWidget {
  final double size;
  final MascotMood mood;

  const PatiMascot({super.key, this.size = 140, this.mood = MascotMood.happy});

  @override
  State<PatiMascot> createState() => _PatiMascotState();
}

enum MascotMood { happy, excited, thinking, sad }

class _PatiMascotState extends State<PatiMascot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = _ctrl.value;
        final bob = math.sin(t * 2 * math.pi) * (widget.size * 0.02);
        final earWiggle = math.sin(t * 2 * math.pi * 2) * 0.03;
        // Göz kırpma: döngünün küçük bir diliminde göz kapansın.
        final blink = (t > 0.46 && t < 0.5) ? 1.0 : 0.0;
        return Transform.translate(
          offset: Offset(0, bob),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: _PatiPainter(mood: widget.mood, blink: blink, t: t, earWiggle: earWiggle),
            ),
          ),
        );
      },
    );
  }
}

class _PatiPainter extends CustomPainter {
  final MascotMood mood;
  final double blink;
  final double t;
  final double earWiggle;
  _PatiPainter({required this.mood, required this.blink, required this.t, required this.earWiggle});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.56;

    const fur = Color(0xFFFFA855);
    const furLight = Color(0xFFFFCB84);
    const furDark = Color(0xFFE86A16);
    const cream = Color(0xFFFFF6E8);
    const ink = Color(0xFF3D3A50);

    // Zemin gölgesi — üç katmanlı, azalan opaklıkla "yumuşak/bulanık" hissi
    // taklit edilir (harici blur filtresine ihtiyaç duymadan).
    for (final layer in [
      (w * 0.56, 0x14372B4D),
      (w * 0.48, 0x1C372B4D),
      (w * 0.40, 0x26372B4D),
    ]) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, h * 0.99), width: layer.$1, height: h * 0.055),
        Paint()..color = Color(layer.$2),
      );
    }

    // Kulaklar — hafif kıpırdama + gradyanlı derinlik.
    final earInner = Paint()..color = cream;
    for (final side in [-1.0, 1.0]) {
      final earCenter = Offset(cx + side * w * 0.28, cy - h * 0.36);
      canvas.save();
      canvas.translate(earCenter.dx, earCenter.dy);
      canvas.rotate(side * 0.35 + earWiggle * side);
      final earPath = Path()
        ..moveTo(-w * 0.11, h * 0.16)
        ..quadraticBezierTo(0, -h * 0.28, w * 0.11, h * 0.16)
        ..close();
      final earPaint = Paint()
        ..shader = const LinearGradient(
          colors: [furLight, fur, furDark],
          stops: [0.0, 0.55, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(earPath.getBounds());
      canvas.drawPath(earPath, earPaint);
      canvas.save();
      canvas.scale(0.55);
      canvas.translate(0, h * 0.05);
      canvas.drawPath(earPath, earInner);
      canvas.restore();
      canvas.restore();
    }

    // Kafa (baş) — çok katmanlı gradyan.
    final headRect = Rect.fromCenter(center: Offset(cx, cy), width: w * 0.72, height: h * 0.62);
    final headPaint = Paint()
      ..shader = const LinearGradient(
        colors: [furLight, fur, furDark],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(headRect);
    canvas.drawOval(headRect, headPaint);

    // Üstte yumuşak parlaklık (gloss) vurgusu — ışık kaynağı sol üstten.
    final glossPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white.withOpacity(0.38), Colors.white.withOpacity(0.0)],
      ).createShader(Rect.fromCircle(center: Offset(cx - w * 0.12, cy - h * 0.24), radius: w * 0.26));
    canvas.drawOval(headRect, glossPaint);

    // Yanak/burun beyaz alanı
    final muzzlePath = Path()
      ..moveTo(cx - w * 0.22, cy + h * 0.02)
      ..quadraticBezierTo(cx, cy + h * 0.28, cx + w * 0.22, cy + h * 0.02)
      ..quadraticBezierTo(cx, cy + h * 0.16, cx - w * 0.22, cy + h * 0.02)
      ..close();
    canvas.drawPath(
      muzzlePath,
      Paint()
        ..shader = const LinearGradient(
          colors: [cream, Color(0xFFFFEBCF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(muzzlePath.getBounds()),
    );

    // Burun
    final noseRect = Rect.fromCenter(center: Offset(cx, cy + h * 0.10), width: w * 0.09, height: h * 0.07);
    canvas.drawOval(noseRect, Paint()..color = ink);
    canvas.drawCircle(
      Offset(cx - w * 0.015, cy + h * 0.085),
      w * 0.012,
      Paint()..color = Colors.white.withOpacity(0.55),
    );

    // Gözler
    final eyeDx = w * 0.15;
    final eyeCy = cy - h * 0.02;
    for (final side in [-1.0, 1.0]) {
      final ex = cx + side * eyeDx;
      if (blink > 0.5) {
        final p = Paint()
          ..color = ink
          ..strokeWidth = w * 0.018
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(Offset(ex - w * 0.045, eyeCy), Offset(ex + w * 0.045, eyeCy), p);
      } else {
        canvas.drawOval(
          Rect.fromCenter(center: Offset(ex, eyeCy), width: w * 0.075, height: h * 0.095),
          Paint()..color = ink,
        );
        canvas.drawCircle(
          Offset(ex + w * 0.02, eyeCy - h * 0.022),
          w * 0.022,
          Paint()..color = Colors.white.withOpacity(0.95),
        );
        canvas.drawCircle(
          Offset(ex - w * 0.012, eyeCy + h * 0.018),
          w * 0.009,
          Paint()..color = Colors.white.withOpacity(0.55),
        );
      }
    }

    // Kaşlar (moda göre)
    final browPaint = Paint()
      ..color = furDark
      ..strokeWidth = w * 0.02
      ..strokeCap = StrokeCap.round;
    for (final side in [-1.0, 1.0]) {
      final bx = cx + side * eyeDx;
      final tilt = mood == MascotMood.thinking ? -0.25 * side : 0.0;
      canvas.drawLine(
        Offset(bx - w * 0.05, eyeCy - h * 0.09 + tilt * h * 0.05),
        Offset(bx + w * 0.05, eyeCy - h * 0.11 - tilt * h * 0.05),
        browPaint,
      );
    }

    // Yanak pembeliği
    final blush = Paint()..color = const Color(0x55FF8FA3);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - w * 0.27, cy + h * 0.10), width: w * 0.11, height: h * 0.06), blush);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + w * 0.27, cy + h * 0.10), width: w * 0.11, height: h * 0.06), blush);

    // Ağız (mood'a göre)
    final mouthPaint = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.022
      ..strokeCap = StrokeCap.round;
    final mouthCenter = Offset(cx, cy + h * 0.155);
    final mouthPath = Path();
    switch (mood) {
      case MascotMood.excited:
        mouthPath.addArc(
          Rect.fromCenter(center: mouthCenter, width: w * 0.22, height: h * 0.14),
          0.15 * math.pi,
          0.7 * math.pi,
        );
        canvas.drawPath(mouthPath, mouthPaint);
        break;
      case MascotMood.sad:
        mouthPath.addArc(
          Rect.fromCenter(center: mouthCenter + Offset(0, h * 0.02), width: w * 0.16, height: h * 0.1),
          math.pi * 1.1,
          0.8 * math.pi,
        );
        canvas.drawPath(mouthPath, mouthPaint);
        break;
      case MascotMood.happy:
      case MascotMood.thinking:
        mouthPath.addArc(
          Rect.fromCenter(center: mouthCenter, width: w * 0.16, height: h * 0.09),
          0.1 * math.pi,
          0.8 * math.pi,
        );
        canvas.drawPath(mouthPath, mouthPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PatiPainter old) =>
      old.blink != blink || old.mood != mood || old.t != t;
}
