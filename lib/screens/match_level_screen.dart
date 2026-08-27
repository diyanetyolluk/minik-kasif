import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/game_data.dart';
import '../services/audio_service.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';
import '../widgets/mascot.dart';
import 'level_complete_screen.dart';

class MatchLevelScreen extends StatefulWidget {
  final int level;
  const MatchLevelScreen({super.key, required this.level});

  @override
  State<MatchLevelScreen> createState() => _MatchLevelScreenState();
}

class _CardData {
  final MatchItem item;
  bool open = false;
  bool solved = false;
  _CardData(this.item);
}

class _MatchLevelScreenState extends State<MatchLevelScreen> {
  late List<_CardData> _cards;
  _CardData? _first;
  bool _lock = false;
  int _mistakes = 0;
  int _left = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _setupLevel();
  }

  void _setupLevel() {
    final pairs = matchPairsForLevel(widget.level);
    final pool = List<MatchItem>.from(matchPool)..shuffle(math.Random(widget.level * 17 + 3));
    final chosen = pool.take(pairs).toList();
    final deck = [...chosen, ...chosen];
    deck.shuffle();
    _cards = deck.map((e) => _CardData(e)).toList();
    _left = pairs;
    _mistakes = 0;
    _first = null;
    _lock = false;
    _finished = false;
  }

  void _tap(_CardData card) async {
    if (_lock || card.open || card.solved || _finished) return;
    AudioService.instance.flip();
    setState(() => card.open = true);

    if (_first == null) {
      _first = card;
      return;
    }

    final a = _first!;
    final b = card;
    _first = null;

    if (a.item.emoji == b.item.emoji) {
      AudioService.instance.match();
      TtsService.instance.speak(b.item.name);
      setState(() {
        a.solved = true;
        b.solved = true;
        _left--;
      });
      if (_left == 0) {
        _finished = true;
        final stars = _mistakes == 0 ? 3 : (_mistakes <= matchPairsForLevel(widget.level) ? 2 : 1);
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LevelCompleteScreen(
              world: 'match',
              level: widget.level,
              stars: stars,
              stickerEmoji: a.item.emoji,
            ),
          ),
        );
      }
    } else {
      _lock = true;
      _mistakes++;
      AudioService.instance.wrong();
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      setState(() {
        a.open = false;
        b.open = false;
        _lock = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final columns = _cards.length > 12 ? 4 : 3;
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
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: 4),
            const PatiMascot(size: 64, mood: MascotMood.thinking),
            const SizedBox(height: 8),
            Text(S.findEmoji, style: AppText.body),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  itemCount: _cards.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, i) {
                    final c = _cards[i];
                    return GestureDetector(
                      onTap: () => _tap(c),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: c.open || c.solved ? Colors.white : AppColors.berry,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(color: AppColors.cardShadow, offset: const Offset(0, 4), blurRadius: 0),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          c.open || c.solved ? c.item.emoji : '❓',
                          style: TextStyle(fontSize: c.open || c.solved ? 38 : 28),
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
