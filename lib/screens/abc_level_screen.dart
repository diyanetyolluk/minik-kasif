import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/game_data.dart';
import '../services/audio_service.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';
import '../widgets/mascot.dart';
import 'level_complete_screen.dart';

/// Sesli soru-cevap: "Hangisi bu?" — cihaz harfi/sayıyı söyler, çocuk
/// doğru seçeneğe dokunur. Zorluk arttıkça seçenek sayısı büyür.
class AbcLevelScreen extends StatefulWidget {
  final int level;
  const AbcLevelScreen({super.key, required this.level});

  @override
  State<AbcLevelScreen> createState() => _AbcLevelScreenState();
}

class _AbcLevelScreenState extends State<AbcLevelScreen> with SingleTickerProviderStateMixin {
  late AbcLevelConfig _cfg;
  late List<String> _pool;
  late math.Random _rnd;

  int _qIndex = 0;
  String _target = '';
  List<String> _options = [];
  int _mistakes = 0;
  bool _wrongThisQ = false;
  bool _locked = false;
  String? _wrongPick;

  late AnimationController _shakeCtrl;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _cfg = abcConfigForLevel(widget.level);
    _rnd = math.Random(widget.level * 31 + 7);
    _pool = _cfg.useNumbers
        ? List.generate(20, (i) => '${i + 1}')
        : (AppLang.isTr ? turkishLetters : englishLetters);
    _nextQuestion();
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  void _nextQuestion() {
    final shuffled = List<String>.from(_pool)..shuffle(_rnd);
    _target = shuffled.first;
    final distractors = shuffled.skip(1).take(_cfg.optionCount - 1).toList();
    _options = [_target, ...distractors]..shuffle(_rnd);
    _wrongThisQ = false;
    _wrongPick = null;
    setState(() {});
    Future.delayed(const Duration(milliseconds: 350), _speakTarget);
  }

  void _speakTarget() {
    final word = _cfg.useNumbers ? numberWord(int.parse(_target)) : _target;
    TtsService.instance.speak(word);
  }

  Future<void> _pick(String value) async {
    if (_locked) return;
    if (value == _target) {
      _locked = true;
      AudioService.instance.correct();
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      if (_qIndex + 1 >= _cfg.questionCount) {
        final stars = _mistakes == 0 ? 3 : (_mistakes <= 2 ? 2 : 1);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LevelCompleteScreen(
              world: 'abc',
              level: widget.level,
              stars: stars,
              stickerEmoji: _target,
            ),
          ),
        );
      } else {
        setState(() {
          _qIndex++;
          _locked = false;
        });
        _nextQuestion();
      }
    } else {
      AudioService.instance.wrong();
      _wrongPick = value;
      if (!_wrongThisQ) {
        _wrongThisQ = true;
        _mistakes++;
      }
      setState(() {});
      _shakeCtrl.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      setState(() => _wrongPick = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final columns = _options.length <= 4 ? 2 : 3;
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
                    child: Text(S.levelLabel(widget.level), style: AppText.h1, textAlign: TextAlign.center),
                  ),
                  Text('${_qIndex + 1}/${_cfg.questionCount}', style: AppText.body),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const PatiMascot(size: 60, mood: MascotMood.happy),
            const SizedBox(height: 6),
            Text(S.whichLetter, style: AppText.h2),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _speakTarget,
              child: Container(
                width: 96, height: 96,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppColors.cardShadow, offset: const Offset(0, 5), blurRadius: 0)],
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.volume_up_rounded, color: AppColors.sky, size: 48),
              ),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: _speakTarget,
              child: Text(S.listenAgain, style: AppText.body.copyWith(decoration: TextDecoration.underline)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.builder(
                  itemCount: _options.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.3,
                  ),
                  itemBuilder: (context, i) {
                    final opt = _options[i];
                    final isWrong = _wrongPick == opt;
                    return AnimatedBuilder(
                      animation: _shakeCtrl,
                      builder: (context, child) {
                        double dx = 0;
                        if (isWrong) {
                          dx = math.sin(_shakeCtrl.value * math.pi * 6) * 8;
                        }
                        return Transform.translate(offset: Offset(dx, 0), child: child);
                      },
                      child: GestureDetector(
                        onTap: () => _pick(opt),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isWrong ? AppColors.coral.withOpacity(0.25) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: AppColors.cardShadow, offset: const Offset(0, 4), blurRadius: 0),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(opt, style: AppText.h1.copyWith(fontSize: 34, color: AppColors.berry)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
