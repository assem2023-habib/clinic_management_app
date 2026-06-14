import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class GlassAppBar extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final List<Widget>? actions;
  final VoidCallback? onLeadingTap;

  const GlassAppBar({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.actions,
    this.onLeadingTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: MediaQuery.of(context).padding.top + AppSpacing.xs + 2,
            bottom: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: 0.55),
          ),
          child: Stack(
            children: [
              CustomPaint(
                size: Size(double.infinity, MediaQuery.of(context).padding.top + AppSpacing.xs + 2 + AppSpacing.sm + kToolbarHeight),
                painter: _WavyBottomPainter(),
              ),
              Row(
                children: [
                  if (leading != null || onLeadingTap != null)
                    GestureDetector(
                      onTap: onLeadingTap,
                      child: leading ??
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: colors.surface.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                            ),
                            child: const Icon(Icons.menu_rounded, color: Colors.white, size: 22),
                          ),
                    ),
                  if (leading != null || onLeadingTap != null) SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  if (actions != null) ...actions!,
                  if (trailing != null) trailing!,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WavyBottomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path = Path();
    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      path.lineTo(x, size.height + sin((x / size.width) * pi) * 2);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
