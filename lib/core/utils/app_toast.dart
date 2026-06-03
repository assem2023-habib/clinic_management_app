import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';

OverlayEntry? _toastEntry;

void showAppToast(BuildContext context, String message, {IconData? icon}) {
  _toastEntry?.remove();
  final overlay = Overlay.of(context);
  final colors = AppColors.of(context);

  _toastEntry = OverlayEntry(
    builder: (_) => _AppToastOverlay(
      message: message,
      colors: colors,
      icon: icon,
    ),
  );

  overlay.insert(_toastEntry!);
  Future.delayed(const Duration(seconds: 3), () {
    _toastEntry?.remove();
    _toastEntry = null;
  });
}

class _AppToastOverlay extends StatefulWidget {
  final String message;
  final AppColorSet colors;
  final IconData? icon;

  const _AppToastOverlay({
    required this.message,
    required this.colors,
    this.icon,
  });

  @override
  State<_AppToastOverlay> createState() => _AppToastOverlayState();
}

class _AppToastOverlayState extends State<_AppToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 100,
      left: 24,
      right: 24,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _opacity,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            decoration: BoxDecoration(
              color: const Color(0xFF1B3B29),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: widget.colors.primary.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.45),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: widget.colors.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    widget.message,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: widget.colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
