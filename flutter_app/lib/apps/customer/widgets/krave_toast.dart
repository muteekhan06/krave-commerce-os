import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

enum ToastType { success, info, warning, error, cashback }

class KraveToast {
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    ToastType type = ToastType.success,
    Duration duration = const Duration(seconds: 3),
  }) {
    HapticFeedback.mediumImpact();

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _ToastWidget(
        title: title,
        message: message,
        type: type,
        onDismiss: () => entry.remove(),
        duration: duration,
      ),
    );

    overlay.insert(entry);
  }
}

class _ToastWidget extends StatefulWidget {
  final String? title;
  final String message;
  final ToastType type;
  final VoidCallback onDismiss;
  final Duration duration;

  const _ToastWidget({
    this.title,
    required this.message,
    required this.type,
    required this.onDismiss,
    required this.duration,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getBgColor() {
    switch (widget.type) {
      case ToastType.success:
        return const Color(0xFF064E3B); // Deep Emerald
      case ToastType.cashback:
        return const Color(0xFF78350F); // Warm Amber
      case ToastType.warning:
        return const Color(0xFF92400E);
      case ToastType.error:
        return AppColors.brand900;
      case ToastType.info:
      default:
        return AppColors.surface950;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle_rounded;
      case ToastType.cashback:
        return Icons.military_tech_rounded;
      case ToastType.warning:
        return Icons.warning_amber_rounded;
      case ToastType.error:
        return Icons.error_outline_rounded;
      case ToastType.info:
      default:
        return Icons.notifications_active_rounded;
    }
  }

  Color _getIconColor() {
    switch (widget.type) {
      case ToastType.success:
        return AppColors.emerald500;
      case ToastType.cashback:
        return AppColors.amber500;
      case ToastType.warning:
        return AppColors.amber500;
      case ToastType.error:
        return Colors.redAccent;
      case ToastType.info:
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _getBgColor(),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.12),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_getIcon(), color: _getIconColor(), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.title != null) ...[
                          Text(
                            widget.title!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                        Text(
                          widget.message,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.95),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
