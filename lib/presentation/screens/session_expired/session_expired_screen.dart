import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:flutter_animate/flutter_animate.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFF00180B),
      body: SafeArea(
        child: Stack(
          children: [
            _buildParticleBackground(),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 64),
                    _buildIconSection(),
                    const SizedBox(height: AppSpacing.md),
                    _buildContent(),
                    const SizedBox(height: AppSpacing.md),
                    _buildActions(),
                    const SizedBox(height: 40),
                    _buildFooter(),
                    const SizedBox(height: 64),
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
              color: const Color(0xFF0F301F).withValues(alpha: 0.4),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00FF85).withValues(alpha: 0.03),
                  blurRadius: 40,
                ),
              ],
            ),
            child: const Icon(
              Icons.timer_off_rounded,
              size: 64,
              color: Color(0xFF4EDEA3),
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
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF10B981),
              ),
              child: const Icon(
                Icons.lock_rounded,
                size: 20,
                color: Color(0xFF00180B),
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
        final t = (_rippleController.value + startOffset) % 1.0;
        final scale = 1.0 + t * 0.6;
        final opacity = (1.0 - t) * 0.4;
        return Container(
          width: 160 * scale,
          height: 160 * scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF10B981).withValues(alpha: opacity),
              width: 2,
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFF0F301F).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF85).withValues(alpha: 0.03),
            blurRadius: 40,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            AppStrings.sesTitle,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xFFC6EBD1),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            AppStrings.sesMessage,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFBBCABF),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.onLogin ??
                () => Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.login),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: const Color(0xFF00422B),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              shadowColor: const Color(0xFF10B981).withValues(alpha: 0.3),
            ),
            child: const Text(
              AppStrings.sesLogin,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
              foregroundColor: const Color(0xFFC6EBD1),
              side: const BorderSide(color: Color(0xFF3C4A42)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              AppStrings.sesGoHome,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: widget.onCloseApp ?? () => SystemNavigator.pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFC6EBD1),
              side: BorderSide(
                color: const Color(0xFF3C4A42).withValues(alpha: 0.3),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              AppStrings.sesCloseApp,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return const Text(
      AppStrings.sesFooter,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(0xFFBBCABF),
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
        colors: const [
          Colors.transparent,
          Color(0xFF10B981),
          Colors.transparent,
          Color(0xFF10B981),
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
      ..color = const Color(0xFF4EDEA3).withValues(alpha: 0.3);
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
