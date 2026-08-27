import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MinikKasifApp());
}

class MinikKasifApp extends StatelessWidget {
  const MinikKasifApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minik Kâşif',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const SplashScreen(),
    );
  }
}
