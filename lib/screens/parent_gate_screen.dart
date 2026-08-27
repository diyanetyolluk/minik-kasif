import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';
import 'parent_area_screen.dart';

/// Apple App Store "Kids" kategorisi kural 1.3 ve Google Play Families
/// politikasının gerektirdiği ebeveyn kapısı: küçük bir çocuğun kolayca
/// geçemeyeceği basit bir çarpım sorusu.
class ParentGateScreen extends StatefulWidget {
  const ParentGateScreen({super.key});

  @override
  State<ParentGateScreen> createState() => _ParentGateScreenState();
}

class _ParentGateScreenState extends State<ParentGateScreen> {
  late int _a, _b;
  final _ctrl = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    _roll();
  }

  void _roll() {
    final rnd = math.Random();
    _a = 3 + rnd.nextInt(6);
    _b = 3 + rnd.nextInt(6);
  }

  void _check() {
    final answer = int.tryParse(_ctrl.text.trim());
    if (answer == _a * _b) {
      AudioService.instance.correct();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ParentAreaScreen()));
    } else {
      AudioService.instance.wrong();
      setState(() {
        _error = S.gateWrong;
        _ctrl.clear();
        _roll();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(backgroundColor: AppColors.bg, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: playfulCard(color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_rounded, size: 40, color: AppColors.berry),
                const SizedBox(height: 12),
                Text(S.parentGateTitle, style: AppText.h2, textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Text(S.gateQuestion(_a, _b), style: AppText.h1, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                SizedBox(
                  width: 140,
                  child: TextField(
                    controller: _ctrl,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: AppText.h1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.sky, width: 2),
                      ),
                    ),
                    onSubmitted: (_) => _check(),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(_error!, style: const TextStyle(color: AppColors.coral, fontWeight: FontWeight.w700)),
                ],
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sky,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _check,
                    child: Text(S.confirm, style: AppText.button),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
