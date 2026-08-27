import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../services/progress_service.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';
import '../widgets/mascot.dart';
import '../widgets/star_row.dart';
import '../widgets/confetti_overlay.dart';

/// Bölüm bitince gösterilen kutlama ekranı: yıldızlar, konfeti,
/// varsa yeni çıkartma. "Devam" bir sonraki bölüme değil, haritaya döner
/// (harita zaten kilit açılmış yeni bölümü gösterir).
class LevelCompleteScreen extends StatefulWidget {
  final String world;
  final int level;
  final int stars; // 1-3
  final String? stickerEmoji;

  const LevelCompleteScreen({
    super.key,
    required this.world,
    required this.level,
    required this.stars,
    this.stickerEmoji,
  });

  @override
  State<LevelCompleteScreen> createState() => _LevelCompleteScreenState();
}

class _LevelCompleteScreenState extends State<LevelCompleteScreen> {
  bool _newSticker = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AudioService.instance.levelComplete();
      await ProgressService.instance.setStars(widget.world, widget.level, widget.stars);
      if (widget.stickerEmoji != null) {
        final id = '${widget.world}_${widget.level}';
        final before = ProgressService.instance.hasSticker(id);
        await ProgressService.instance.unlockSticker(id, widget.stickerEmoji!);
        if (!before && mounted) {
          setState(() => _newSticker = true);
          AudioService.instance.stickerCollect();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.berry,
      body: Stack(
        children: [
          const Positioned.fill(child: ConfettiOverlay()),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const PatiMascot(size: 140, mood: MascotMood.excited),
                    const SizedBox(height: 12),
                    Text(S.levelDone,
                        style: AppText.display.copyWith(color: Colors.white), textAlign: TextAlign.center),
                    const SizedBox(height: 18),
                    StarRow(count: widget.stars, size: 52, animate: true),
                    if (_newSticker) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: playfulCard(color: Colors.white),
                        child: Column(
                          children: [
                            Text(widget.stickerEmoji!, style: const TextStyle(fontSize: 48)),
                            const SizedBox(height: 6),
                            Text(S.newSticker, style: AppText.body, textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.berry,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: () {
                          AudioService.instance.button();
                          Navigator.of(context).pop();
                        },
                        child: Text(S.back2map,
                            style: AppText.button.copyWith(color: AppColors.berry, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
