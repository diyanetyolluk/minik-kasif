import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../services/progress_service.dart';
import '../theme/app_theme.dart';

class StickerAlbumScreen extends StatelessWidget {
  const StickerAlbumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ProgressService.instance.version,
      builder: (context, _, __) {
        final stickers = ProgressService.instance.stickers;
        return Scaffold(
          backgroundColor: AppColors.bg,
          appBar: AppBar(
            backgroundColor: AppColors.bg,
            elevation: 0,
            title: Text(S.stickerAlbum, style: AppText.h1),
            centerTitle: true,
            iconTheme: const IconThemeData(color: AppColors.ink),
          ),
          body: stickers.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(S.noStickersYet, style: AppText.body, textAlign: TextAlign.center),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: stickers.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, i) {
                    final glyph = stickers[i].value;
                    return Container(
                      decoration: playfulCard(color: Colors.white, radius: 16, shadowOffset: const Offset(0, 3)),
                      alignment: Alignment.center,
                      child: Text(glyph, style: const TextStyle(fontSize: 26)),
                    );
                  },
                ),
        );
      },
    );
  }
}
