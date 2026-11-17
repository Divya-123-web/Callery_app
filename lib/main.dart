import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/language/screens/language_screen.dart';

void main() {
  runApp(const CalleyApp());
}

class CalleyApp extends StatelessWidget {
  const CalleyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calley',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // The app starts on the Language screen, then goes to Sign In.
      home: const LanguageScreen(isOnboarding: true),
    );
  }
}