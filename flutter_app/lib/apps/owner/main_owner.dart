import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/animated_splash.dart';
import 'owner_app.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const OwnerStandaloneApp(),
    ),
  );
}

class OwnerStandaloneApp extends StatelessWidget {
  const OwnerStandaloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KRAVE Merchant OS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AnimatedRestaurantSplash(
        roleBadge: 'Merchant Executive OS',
        nextScreen: OwnerAppScreen(),
      ),
    );
  }
}
