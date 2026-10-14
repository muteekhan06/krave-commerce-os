import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/animated_splash.dart';
import 'rider_app.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const RiderStandaloneApp(),
    ),
  );
}

class RiderStandaloneApp extends StatelessWidget {
  const RiderStandaloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KRAVE Rider Fleet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AnimatedRestaurantSplash(
        roleBadge: 'Rider Courier Fleet',
        nextScreen: RiderAppScreen(),
      ),
    );
  }
}
