import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

class YellowFlowersApp extends StatelessWidget {
  const YellowFlowersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flores Amarillas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}
