import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class SessionExpiredScreen extends StatefulWidget {
  final VoidCallback? onLogin;
  final VoidCallback? onGoHome;
  final VoidCallback? onCloseApp;

  const SessionExpiredScreen({
    super.key,
    this.onLogin,
    this.onGoHome,
    this.onCloseApp,
  });

  @override
  State<SessionExpiredScreen> createState() => _SessionExpiredScreenState();
}

class _SessionExpiredScreenState extends State<SessionExpiredScreen>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      body: SafeArea(
        child: Stack(
          children: [
            _buildParticleBackground(),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md + AppSpacing.xs),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppSpacing.appBarHeight),
                    _buildIconSection(),
                    const SizedBox(height: AppSpacing.md),
                    _buildContent(),
                    const SizedBox(height: AppSpacing.md),
                    _buildActions(),
                    const SizedBox(height: AppSpacing.iconContainer),
                    _buildFooter(),
                    const SizedBox(height: AppSpacing.appBarHeight),
                  ],
                ),
              ),
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
          painter: _SessionParticlePainter(),
        ),
      ),
    );
  }

  Widget _buildIconSection() {
    final colors = AppColors.of(context);
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildRipple(0.0),
          _buildRipple(0.5),
          AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(160, 160),
                painter: _RotatingGlowPainter(
                  _glowController.value * 2 * pi,
                ),
              );
            },
          ),
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surfaceDark.withValues(alpha: 0.4),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.neonGreen.withValues(alpha: 0.03),
                  blurRadius: 40,
                ),
              ],
            ),
            child: Icon(
              Icons.timer_off_rounded,
              size: 64,
              color: colors.mint,
            ),
          ).animate(onInit: (c) => c.repeat(reverse: true))
            .scale(
              duration: 3.seconds,
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.05, 1.05),
              curve: Curves.easeInOut,
            )
            .move(
              duration: 3.seconds,
              begin: const Offset(0, 0),
              end: const Offset(0, -10),
              curve: Curves.easeInOut,
            ),
          Positioned(
            top: 0,
            right: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.emerald,
                ),
                child: Icon(
                  Icons.lock_rounded,
                  size: AppSpacing.iconSmall,
                  color: colors.scaffoldBg,
                ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRipple(double startOffset) {
    return AnimatedBuilder(
      animation: _rippleController,
      builder: (context, child) {
        final rippleColors = AppColors.of(context);
        final t = (_rippleController.value + startOffset) % 1.0;
        final scale = 1.0 + t * 0.6;
        final opacity = (1.0 - t) * 0.4;
        return Container(
          width: 160 * scale,
          height: 160 * scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: rippleColors.emerald.withValues(alpha: opacity),
              width: 2,
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    final colors = AppColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surfaceDark.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: colors.neonGreen.withValues(alpha: 0.03),
            blurRadius: 40,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            AppStrings.sesTitle,
            style: TextStyle(
              fontSize: AppSpacing.headline,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.sesMessage,
            style: TextStyle(
              fontSize: AppSpacing.bodyLarge,
              color: colors.textMuted,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    final colors = AppColors.of(context);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.onLogin ??
                () => Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.login),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.emerald,
              foregroundColor: colors.buttonTextDark,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              ),
              elevation: 0,
              shadowColor: colors.emerald.withValues(alpha: 0.3),
            ),
            child:  Text(
              AppStrings.sesLogin,
              style: TextStyle(fontSize: AppSpacing.bodyLarge, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: widget.onGoHome ??
                () => Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.dashboard),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.textPrimary,
              side: BorderSide(color: colors.borderDark),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              ),
            ),
            child:  Text(
              AppStrings.sesGoHome,
              style: TextStyle(fontSize: AppSpacing.bodyLarge, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: widget.onCloseApp ?? () => SystemNavigator.pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.textPrimary,
              side: BorderSide(
                color: colors.borderDark.withValues(alpha: 0.3),
              ),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              ),
            ),
            child:  Text(
              AppStrings.sesCloseApp,
              style: TextStyle(fontSize: AppSpacing.bodyLarge, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    final colors = AppColors.of(context);
    return Text(
      AppStrings.sesFooter,
      style: TextStyle(
        fontSize: AppSpacing.bodySmall,
        fontWeight: FontWeight.w600,
        color: colors.textMuted,
        letterSpacing: 0.05,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _RotatingGlowPainter extends CustomPainter {
  final double rotationAngle;
  _RotatingGlowPainter(this.rotationAngle);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..shader = SweepGradient(
        startAngle: rotationAngle,
        endAngle: rotationAngle + 2 * pi,
        colors: [
          Colors.transparent,
          AppColors.dark.emerald,
          Colors.transparent,
          AppColors.dark.emerald,
          Colors.transparent,
        ],
        stops: [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(rect);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RotatingGlowPainter oldDelegate) =>
      oldDelegate.rotationAngle != rotationAngle;
}

class _SessionParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = _SeededRandom(42);
    final paint = Paint()
      ..color = AppColors.dark.mint.withValues(alpha: 0.3);

    for (var i = 0; i < 40; i++) {
      final x = rng.next() * size.width;
      final y = rng.next() * size.height;
      final radius = rng.next() * 3 + 1;
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
