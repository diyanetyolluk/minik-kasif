import 'package:flutter/material.dart';

/// Dokunulduğunda hafifçe küçülüp geri sıçrayan, "premium" bir dokunma
/// hissi veren sarmalayıcı. Herhangi bir widget'ı, kendi GestureDetector'ını
/// yazmaya gerek kalmadan tıklanabilir + tepki verir hale getirir.
class BouncyTap extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double pressedScale;

  const BouncyTap({
    super.key,
    required this.child,
    required this.onTap,
    this.pressedScale = 0.96,
  });

  @override
  State<BouncyTap> createState() => _BouncyTapState();
}

class _BouncyTapState extends State<BouncyTap> {
  double _scale = 1.0;

  void _setPressed(bool pressed) {
    if (!mounted) return;
    setState(() => _scale = pressed ? widget.pressedScale : 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
