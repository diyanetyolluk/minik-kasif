import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Boyama şablonları — 0..1 aralığında bağıl koordinatlarla tanımlanır,
/// çizim anında canvas boyutuna göre ölçeklenir. Böylece her ekran
/// boyutunda net görünürler.
class ColoringTemplates {
  static List<Path> build(String id, Size size) {
    switch (id) {
      case 'sun':
        return _sun(size);
      case 'house':
        return _house(size);
      case 'fish':
        return _fish(size);
      case 'butterfly':
        return _butterfly(size);
      case 'rocket':
        return _rocket(size);
      case 'flower':
        return _flower(size);
      default:
        return _sun(size);
    }
  }

  static Offset _p(Size s, double x, double y) => Offset(x * s.width, y * s.height);

  static List<Path> _sun(Size s) {
    final center = _p(s, 0.5, 0.45);
    final r = s.width * 0.16;
    final circle = Path()..addOval(Rect.fromCircle(center: center, radius: r));
    final rays = Path();
    for (int i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      final inner = center + Offset(math.cos(a), math.sin(a)) * (r * 1.25);
      final outer = center + Offset(math.cos(a), math.sin(a)) * (r * 1.85);
      rays.moveTo(inner.dx, inner.dy);
      rays.lineTo(outer.dx, outer.dy);
    }
    return [circle, rays];
  }

  static List<Path> _house(Size s) {
    final wall = Path()
      ..addRect(Rect.fromLTWH(s.width * 0.22, s.height * 0.45, s.width * 0.56, s.height * 0.38));
    final roof = Path()
      ..moveTo(s.width * 0.15, s.height * 0.46)
      ..lineTo(s.width * 0.5, s.height * 0.18)
      ..lineTo(s.width * 0.85, s.height * 0.46)
      ..close();
    final door = Path()
      ..addRect(Rect.fromLTWH(s.width * 0.46, s.height * 0.60, s.width * 0.12, s.height * 0.23));
    final window = Path()
      ..addRect(Rect.fromLTWH(s.width * 0.28, s.height * 0.52, s.width * 0.12, s.height * 0.12));
    final window2 = Path()
      ..addRect(Rect.fromLTWH(s.width * 0.60, s.height * 0.52, s.width * 0.12, s.height * 0.12));
    return [wall, roof, door, window, window2];
  }

  static List<Path> _fish(Size s) {
    final body = Path()
      ..addOval(Rect.fromCenter(center: _p(s, 0.44, 0.5), width: s.width * 0.5, height: s.height * 0.32));
    final tail = Path()
      ..moveTo(s.width * 0.68, s.height * 0.5)
      ..lineTo(s.width * 0.90, s.height * 0.34)
      ..lineTo(s.width * 0.90, s.height * 0.66)
      ..close();
    final eye = Path()..addOval(Rect.fromCircle(center: _p(s, 0.30, 0.44), radius: s.width * 0.02));
    final finTop = Path()
      ..moveTo(s.width * 0.40, s.height * 0.36)
      ..lineTo(s.width * 0.46, s.height * 0.22)
      ..lineTo(s.width * 0.54, s.height * 0.36);
    return [body, tail, eye, finTop];
  }

  static List<Path> _butterfly(Size s) {
    final body = Path()
      ..moveTo(s.width * 0.5, s.height * 0.22)
      ..quadraticBezierTo(s.width * 0.47, s.height * 0.5, s.width * 0.5, s.height * 0.78);
    final paths = [body];
    for (final side in [-1.0, 1.0]) {
      final wingTop = Path()
        ..addOval(Rect.fromCenter(
          center: _p(s, 0.5 + side * 0.18, 0.36),
          width: s.width * 0.28,
          height: s.height * 0.26,
        ));
      final wingBottom = Path()
        ..addOval(Rect.fromCenter(
          center: _p(s, 0.5 + side * 0.14, 0.60),
          width: s.width * 0.20,
          height: s.height * 0.20,
        ));
      paths.addAll([wingTop, wingBottom]);
    }
    return paths;
  }

  static List<Path> _rocket(Size s) {
    final body = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(s.width * 0.40, s.height * 0.28, s.width * 0.20, s.height * 0.42),
        Radius.circular(s.width * 0.1),
      ));
    final nose = Path()
      ..moveTo(s.width * 0.40, s.height * 0.30)
      ..lineTo(s.width * 0.5, s.height * 0.12)
      ..lineTo(s.width * 0.60, s.height * 0.30);
    final finLeft = Path()
      ..moveTo(s.width * 0.40, s.height * 0.62)
      ..lineTo(s.width * 0.26, s.height * 0.78)
      ..lineTo(s.width * 0.40, s.height * 0.72)
      ..close();
    final finRight = Path()
      ..moveTo(s.width * 0.60, s.height * 0.62)
      ..lineTo(s.width * 0.74, s.height * 0.78)
      ..lineTo(s.width * 0.60, s.height * 0.72)
      ..close();
    final window = Path()..addOval(Rect.fromCircle(center: _p(s, 0.5, 0.42), radius: s.width * 0.05));
    final flame = Path()
      ..moveTo(s.width * 0.44, s.height * 0.70)
      ..lineTo(s.width * 0.5, s.height * 0.88)
      ..lineTo(s.width * 0.56, s.height * 0.70);
    return [body, nose, finLeft, finRight, window, flame];
  }

  static List<Path> _flower(Size s) {
    final center = _p(s, 0.5, 0.38);
    final petals = <Path>[];
    for (int i = 0; i < 6; i++) {
      final a = i * math.pi / 3;
      final pc = center + Offset(math.cos(a), math.sin(a)) * s.width * 0.14;
      petals.add(Path()
        ..addOval(Rect.fromCenter(center: pc, width: s.width * 0.16, height: s.height * 0.13)));
    }
    final middle = Path()..addOval(Rect.fromCircle(center: center, radius: s.width * 0.07));
    final stem = Path()
      ..moveTo(center.dx, center.dy + s.width * 0.1)
      ..lineTo(center.dx, s.height * 0.88);
    final leaf = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(center.dx + s.width * 0.08, s.height * 0.7),
        width: s.width * 0.14,
        height: s.height * 0.08,
      ));
    return [...petals, middle, stem, leaf];
  }
}
