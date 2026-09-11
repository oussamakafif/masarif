import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MasarifApp());
}

class MasarifApp extends StatelessWidget {
  const MasarifApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مصاريف — Masarif',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      // Frontend-only demo: forcing RTL layout without full localization setup.
      // For production, add flutter_localizations + Locale('ar') for proper
      // date/number formatting and native RTL behavior.
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: const OnboardingScreen(),
    );
  }
}