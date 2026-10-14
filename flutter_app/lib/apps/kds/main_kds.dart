import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/animated_splash.dart';
import 'kds_app.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const KdsStandaloneApp(),
    ),
  );
}

class KdsStandaloneApp extends StatelessWidget {
  const KdsStandaloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KRAVE Kitchen KDS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AnimatedRestaurantSplash(
        roleBadge: 'Kitchen KDS Station',
        nextScreen: KdsAppScreen(),
      ),
    );
  }
}
