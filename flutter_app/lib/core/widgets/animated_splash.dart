import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AnimatedRestaurantSplash extends StatefulWidget {
  final Widget nextScreen;
  final String roleBadge;

  const AnimatedRestaurantSplash({
    super.key,
    required this.nextScreen,
    this.roleBadge = 'Direct Ordering OS',
  });

  @override
  State<AnimatedRestaurantSplash> createState() => _AnimatedRestaurantSplashState();
}

class _AnimatedRestaurantSplashState extends State<AnimatedRestaurantSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _letterSpacingAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.75, curve: Curves.easeInOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.85, curve: Curves.easeIn),
      ),
    );

    _letterSpacingAnimation = Tween<double>(begin: 1.0, end: 6.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();

    // Auto navigate to target screen after animation completes
    Future.delayed(const Duration(milliseconds: 2600), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 700),
            pageBuilder: (_, __, ___) => widget.nextScreen,
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface950,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Radial Ambient Red Glow in Background
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.brand700.withOpacity(0.35 * _glowAnimation.value),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Centered Animated Branding Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo Mark with Glowing Container
                    Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.brand700,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.brand700.withOpacity(0.55 * _glowAnimation.value),
                              blurRadius: 36 * _glowAnimation.value,
                              spreadRadius: 4 * _glowAnimation.value,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'KR',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Restaurant Brand Name Animation with Expanding Letter-Spacing
                    Opacity(
                      opacity: _fadeAnimation.value,
                      child: Text(
                        'KRAVE',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: _letterSpacingAnimation.value,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Restaurant Slogan / Sub-headline
                    Opacity(
                      opacity: _fadeAnimation.value,
                      child: Text(
                        'ARTISANAL SMASH BURGERS',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.surface400,
                          letterSpacing: 2.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Direct Ordering Badge
                    Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.surface900,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.surface800),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.emerald400,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.roleBadge.toUpperCase(),
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.emerald400,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Powered By label
              Positioned(
                bottom: 34,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: _fadeAnimation.value * 0.7,
                  child: Center(
                    child: Text(
                      'Restaurant-Owned Direct Commerce',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.surface500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
