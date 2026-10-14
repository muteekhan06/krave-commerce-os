import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/animated_splash.dart';
import 'customer_app.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const CustomerStandaloneApp(),
    ),
  );
}

class CustomerStandaloneApp extends StatelessWidget {
  const CustomerStandaloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KRAVE Direct Ordering',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const AnimatedRestaurantSplash(
        roleBadge: 'Direct Customer App',
        nextScreen: CustomerAppScreen(),
      ),
    );
  }
}
