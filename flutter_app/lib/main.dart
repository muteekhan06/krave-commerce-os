import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'core/state/app_state.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/animated_splash.dart';

import 'apps/customer/customer_app.dart';
import 'apps/kds/kds_app.dart';
import 'apps/rider/rider_app.dart';
import 'apps/owner/owner_app.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const KraveMasterApp(),
    ),
  );
}

class KraveMasterApp extends StatelessWidget {
  const KraveMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KRAVE Commerce OS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const MultiAppSelectorHub(),
    );
  }
}

class MultiAppSelectorHub extends StatelessWidget {
  const MultiAppSelectorHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface950,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Header Brand Badge
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.brand700,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text('KR', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('KRAVE Commerce OS', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                      Text('4-App Direct Ordering Ecosystem', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.surface400)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Select Application to Launch:',
                style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                'Each app boots with full restaurant brand splash animations and native workflows.',
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.surface500),
              ),
              const SizedBox(height: 20),

              // 4 App Cards
              Expanded(
                child: ListView(
                  children: [
                    _buildAppLauncherCard(
                      context: context,
                      title: '📱 Customer Storefront App',
                      badge: 'Direct Diner PWA',
                      badgeColor: AppColors.brand700,
                      description: 'Brand hero food animations, full digital menu with modifiers, SBP Raast QR + COD, animated live tracking map, DinePass cashback wallet & 5-stamp card.',
                      targetApp: const AnimatedRestaurantSplash(
                        roleBadge: 'Direct Customer PWA',
                        nextScreen: CustomerAppScreen(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildAppLauncherCard(
                      context: context,
                      title: '📟 Kitchen Display System (KDS)',
                      badge: 'Kitchen Prep Tablet',
                      badgeColor: AppColors.amber500,
                      description: 'Grill/Fryer/Expedite station routing, color-coded aging ticket timers (<5m, 5-10m, >10m siren), 1-tap Accept/Ready/Bump, ESC/POS 80mm thermal receipt generator.',
                      targetApp: const AnimatedRestaurantSplash(
                        roleBadge: 'Kitchen KDS Station',
                        nextScreen: KdsAppScreen(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildAppLauncherCard(
                      context: context,
                      title: '🛵 Rider Courier Fleet App',
                      badge: 'Field Courier Mobile',
                      badgeColor: AppColors.blue500,
                      description: 'Online/Offline duty switch, Google Maps turn-by-turn navigation, 3-stage handover (Arrived ➔ Bagged ➔ Delivered), COD cash-in-bag ledger.',
                      targetApp: const AnimatedRestaurantSplash(
                        roleBadge: 'Rider Courier Fleet',
                        nextScreen: RiderAppScreen(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildAppLauncherCard(
                      context: context,
                      title: '📊 Owner / Merchant OS App',
                      badge: 'Executive Control Panel',
                      badgeColor: AppColors.emerald500,
                      description: 'PKR 170,000 commission disintermediation metrics, 12h peak rush sales velocity chart, live order queue monitor, instant 86 sold-out switch, surge busy mode.',
                      targetApp: const AnimatedRestaurantSplash(
                        roleBadge: 'Merchant Executive OS',
                        nextScreen: OwnerAppScreen(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppLauncherCard({
    required BuildContext context,
    required String title,
    required String badge,
    required Color badgeColor,
    required String description,
    required Widget targetApp,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface900,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surface800),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => targetApp),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.surface400,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Launch with Animated Brand Splash',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brand500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward, size: 14, color: AppColors.brand500),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
