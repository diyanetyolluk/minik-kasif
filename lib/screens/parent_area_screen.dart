import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../services/progress_service.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';

class ParentAreaScreen extends StatelessWidget {
  const ParentAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = ProgressService.instance;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: Text(S.parentArea, style: AppText.h1),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.ink),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(S.statsTitle, style: AppText.h2),
          const SizedBox(height: 10),
          _statRow(S.statMatch, '${p.matchCompleted}'),
          _statRow(S.statAbc, '${p.glyphsHeard}'),
          _statRow(S.statPaint, '${p.paintMinutes}'),
          _statRow(S.statStars, '${p.totalStars()}'),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: playfulCard(color: const Color(0xFFEFF7EE)),
            child: Row(
              children: [
                const Icon(Icons.shield_rounded, color: AppColors.leaf),
                const SizedBox(width: 12),
                Expanded(child: Text(S.privacyNote, style: AppText.body)),
              ],
            ),
          ),
          const SizedBox(height: 28),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppColors.coral),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () => _confirmReset(context),
            child: Text(S.resetProgress, style: AppText.h2.copyWith(color: AppColors.coral)),
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: playfulCard(color: Colors.white, radius: 16, shadowOffset: const Offset(0, 3)),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppText.body)),
          Text(value, style: AppText.h1),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(S.resetProgress, style: AppText.h2),
        content: Text(S.resetConfirm, style: AppText.body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(S.cancel)),
          TextButton(
            onPressed: () async {
              AudioService.instance.pop();
              await ProgressService.instance.resetAll();
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text(S.resetProgress, style: const TextStyle(color: AppColors.coral)),
          ),
        ],
      ),
    );
  }
}
