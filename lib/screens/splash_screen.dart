import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../services/progress_service.dart';
import '../theme/app_theme.dart';
import '../widgets/mascot.dart';
import 'home_screen.dart';

/// Açılış ekranı: ilerleme verisi (SharedPreferences) yüklenirken
/// kısa bir marka anı gösterir.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    await ProgressService.instance.init();
    AppLang.set(ProgressService.instance.lang);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PatiMascot(size: 130, mood: MascotMood.happy),
            const SizedBox(height: 16),
            Text('Minik Kâşif', style: AppText.display),
          ],
        ),
      ),
    );
  }
}
