import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

const double _marginMobile = 20.0;
const double _gutter = AppSpacing.md;

class ForbiddenScreen extends StatelessWidget {
  final VoidCallback? onContactSupport;

  const ForbiddenScreen({super.key, this.onContactSupport});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _buildParticleBackground(),
            Column(
              children: [
                _buildAppBar(context, colors),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: _marginMobile),
                      child: Column(
                        children: [
                          const SizedBox(height: AppSpacing.xl),
                          _buildIconSection(colors),
                          const SizedBox(height: AppSpacing.md),
                          _buildContentCard(colors),
                          const SizedBox(height: AppSpacing.md),
                          _buildActions(context, colors),
                          const SizedBox(height: AppSpacing.md),
                          _buildInfoCards(context, colors),
                          const SizedBox(height: AppSpacing.xl),
                          _buildFooter(colors),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticleBackground() {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _ParticlePainter(),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppColorSet colors) {
    return Container(
      width: double.infinity,
      height: AppSpacing.appBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: _marginMobile),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.95),
        border: Border(bottom: BorderSide(color: colors.divider.withValues(alpha: 0.05))),
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.lg - AppSpacing.xs),
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: AppSpacing.iconContainer,
                height: AppSpacing.iconContainer,
                alignment: Alignment.center,
                child: Icon(Icons.arrow_forward_rounded, color: colors.primary, size: AppSpacing.iconSize),
              ),
            ),
          ),
          const Spacer(),
          Text(
            AppStrings.appName,
            style: TextStyle(
              fontSize: AppSpacing.titleError,
              fontWeight: FontWeight.w700,
              color: colors.primary,
            ),
          ),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.lg - AppSpacing.xs),
              onTap: () {},
              child: Container(
                width: AppSpacing.iconContainer,
                height: AppSpacing.iconContainer,
                alignment: Alignment.center,
                child: Icon(Icons.help_outline_rounded, color: colors.textLight, size: AppSpacing.iconSmall + 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconSection(AppColorSet colors) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surface.withValues(alpha: 0.6),
              border: Border.all(color: colors.divider.withValues(alpha: 0.08)),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.1),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Icon(
              Icons.shield_rounded,
              size: 80,
              color: colors.primary,
            ),
          ),
          SizedBox(
            width: 160,
            height: 160,
            child: CustomPaint(
              painter: _OrbitPainter(colors.primary),
            ),
          ).animate(onInit: (controller) => controller.repeat())..rotate(duration: 10.seconds, begin: 0, end: 1),
          Positioned(
            top: 0,
            left: 80 - 4,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary,
                boxShadow: [BoxShadow(color: colors.primary, blurRadius: 10)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(AppColorSet colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: colors.divider.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.fbTitle,
            style: TextStyle(
              fontSize: AppSpacing.headline,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.fbMessage,
            style: TextStyle(
              fontSize: AppSpacing.bodyLarge,
              color: colors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, AppColorSet colors) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.neonGreen,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.buttonRadius)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home_rounded, size: AppSpacing.iconSmall + 2),
                const SizedBox(width: AppSpacing.sm),
                Text(AppStrings.fbGoHome, style: const TextStyle(fontSize: AppSpacing.bodyLarge, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onContactSupport,
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.primary,
              side: BorderSide(color: colors.primary.withValues(alpha: 0.3)),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.buttonRadius)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.support_agent_rounded, size: AppSpacing.iconSmall + 2),
                const SizedBox(width: AppSpacing.sm),
                Text(AppStrings.fbContactSupport, style: const TextStyle(fontSize: AppSpacing.bodyLarge, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCards(BuildContext context, AppColorSet colors) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: _gutter,
        runSpacing: _gutter,
        children: [
          _buildInfoCard(context, colors,
            icon: Icons.lock_reset_rounded,
            label: AppStrings.fbAccessIdLabel,
            value: AppStrings.fbAccessIdValue,
          ),
          _buildInfoCard(context, colors,
            icon: Icons.verified_user_rounded,
            label: AppStrings.fbSecurityLabel,
            value: AppStrings.fbSecurityValue,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, AppColorSet colors, {required IconData icon, required String label, required String value}) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: (screenWidth - _marginMobile * 2 - _gutter) / 2,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        border: Border.all(color: colors.divider.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: colors.cardBg,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: Icon(icon, size: AppSpacing.titleMedium, color: colors.primary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(label, style: TextStyle(fontSize: AppSpacing.bodySmall, fontWeight: FontWeight.w500, color: colors.textPrimary)),
                Text(value, style: TextStyle(fontSize: AppSpacing.labelSmall, color: colors.textSecondary, fontFamily: 'monospace')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(AppColorSet colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dot(colors, 0.4),
        const SizedBox(width: AppSpacing.sm),
        _dot(colors, 0.6),
        const SizedBox(width: AppSpacing.sm),
        _dot(colors, 1.0),
        const SizedBox(width: AppSpacing.sm),
        _dot(colors, 0.6),
        const SizedBox(width: AppSpacing.sm),
        _dot(colors, 0.4),
      ],
    );
  }

  Widget _dot(AppColorSet colors, double opacity) {
    return Container(
      width: AppSpacing.bulletSize,
      height: AppSpacing.bulletSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.primary.withValues(alpha: opacity),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  final Color color;
  _OrbitPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: size.width - 8, height: size.height - 8),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = _SeededRandom(42);
    final paint = Paint()..color = AppColors.dark.emerald.withValues(alpha: 0.15);
    for (var i = 0; i < 30; i++) {
      final x = rng.next() * size.width;
      final y = rng.next() * size.height;
      final radius = rng.next() * 1.5 + 0.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SeededRandom {
  int _seed;
  _SeededRandom(this._seed);

  double next() {
    _seed = (_seed * 1103515245 + 12345) & 0x7fffffff;
    return _seed / 0x7fffffff;
  }
}
