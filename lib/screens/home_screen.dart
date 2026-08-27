import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/worlds.dart';
import '../services/progress_service.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';
import '../widgets/mascot.dart';
import '../widgets/star_row.dart';
import 'world_path_screen.dart';
import 'parent_gate_screen.dart';
import 'sticker_album_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppLang.code,
      builder: (context, _, __) {
        return ValueListenableBuilder(
          valueListenable: ProgressService.instance.version,
          builder: (context, _, __) {
            final totalStars = ProgressService.instance.totalStars();
            return Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    _TopBar(totalStars: totalStars),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                        children: [
                          const SizedBox(height: 4),
                          const PatiMascot(size: 120, mood: MascotMood.happy),
                          const SizedBox(height: 6),
                          Text(S.appName, style: AppText.display, textAlign: TextAlign.center),
                          const SizedBox(height: 4),
                          Text(S.tagline, style: AppText.body, textAlign: TextAlign.center),
                          const SizedBox(height: 24),
                          for (final w in worlds) ...[
                            _WorldCard(world: w),
                            const SizedBox(height: 16),
                          ],
                          const SizedBox(height: 8),
                          Center(
                            child: TextButton.icon(
                              onPressed: () {
                                AudioService.instance.button();
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => const ParentGateScreen()));
                              },
                              icon: const Icon(Icons.family_restroom_rounded, color: AppColors.inkSoft),
                              label: Text(S.parentArea,
                                  style: AppText.body.copyWith(decoration: TextDecoration.underline)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  final int totalStars;
  const _TopBar({required this.totalStars});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          _pill(
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.star_rounded, color: AppColors.gold, size: 22),
              const SizedBox(width: 4),
              Text('$totalStars', style: AppText.h2),
            ]),
            onTap: () {},
          ),
          const SizedBox(width: 10),
          _pill(
            child: const Icon(Icons.auto_awesome_rounded, color: AppColors.berry, size: 22),
            onTap: () {
              AudioService.instance.button();
              Navigator.push(context, MaterialPageRoute(builder: (_) => const StickerAlbumScreen()));
            },
          ),
          const Spacer(),
          _pill(
            child: Text(AppLang.isTr ? 'EN' : 'TR', style: AppText.h2),
            onTap: () {
              AudioService.instance.button();
              AppLang.toggle();
              ProgressService.instance.setLang(AppLang.code.value);
            },
          ),
        ],
      ),
    );
  }

  Widget _pill({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: playfulCard(color: Colors.white, radius: 16, shadowOffset: const Offset(0, 4)),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class _WorldCard extends StatelessWidget {
  final WorldConfig world;
  const _WorldCard({required this.world});

  @override
  Widget build(BuildContext context) {
    int stars = 0;
    for (int i = 1; i <= world.levelCount; i++) {
      stars += ProgressService.instance.starsFor(world.id, i);
    }
    final maxStars = world.levelCount * 3;

    return GestureDetector(
      onTap: () {
        AudioService.instance.whoosh();
        Navigator.push(context, MaterialPageRoute(builder: (_) => WorldPathScreen(world: world)));
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: gradientCard(colors: world.gradient),
        child: Row(
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(world.icon, color: Colors.white, size: 34),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(world.title(), style: AppText.h1.copyWith(color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(world.subtitle(), style: AppText.body.copyWith(color: Colors.white.withOpacity(0.9))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, color: Colors.white.withOpacity(0.9), size: 16),
                      const SizedBox(width: 4),
                      Text('$stars / $maxStars',
                          style: AppText.body.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }
}
