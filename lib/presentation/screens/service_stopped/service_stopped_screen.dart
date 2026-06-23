import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class ServiceStoppedScreen extends StatefulWidget {
  final VoidCallback? onRetry;

  const ServiceStoppedScreen({super.key, this.onRetry});

  @override
  State<ServiceStoppedScreen> createState() => _ServiceStoppedScreenState();
}

class _ServiceStoppedScreenState extends State<ServiceStoppedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      body: Stack(
        children: [
          const _ParticleLayer(),
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) => _buildPulsingCircles(colors),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md + AppSpacing.xs),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: AppSpacing.lg),
                      _buildStatusBadge(),
                      const SizedBox(height: AppSpacing.lg),
                      _buildIconComposition(),
                      const SizedBox(height: AppSpacing.iconContainer),
                      _buildTitle(),
                      const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                      _buildMessage(),
                      const SizedBox(height: AppSpacing.iconContainer),
                      _buildActions(),
                      const SizedBox(height: AppSpacing.iconContainer),
                      _buildErrorCode(),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulsingCircles(AppColorSet colors) {
    final t = _pulseController.value;
    return IgnorePointer(
      child: Center(
        child: SizedBox(
          width: 450,
          height: 450,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _pulseCircle(t, 0.0, colors),
              _pulseCircle(t, 0.375, colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pulseCircle(double t, double delay, AppColorSet colors) {
    final phase = (t + delay) % 1.0;
    final scale = 0.8 + phase * 1.0;
    final opacity = phase <= 0.5
        ? phase * 2.0 * 0.2
        : (1.0 - phase) * 2.0 * 0.2;
    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colors.mint.withValues(alpha: 0.2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final badgeColors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: badgeColors.errorRed,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: badgeColors.error.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: badgeColors.error,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: AppSpacing.xs + 2),
          Text(
            AppStrings.ssStatusOffline,
            style: TextStyle(
              fontFamily: 'Sora',
              fontSize: AppSpacing.bodySmall,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.05,
              color: badgeColors.errorLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconComposition() {
    final colors = AppColors.of(context);
    return SizedBox(
      width: 192,
      height: 192,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) {
              final pulseColors = AppColors.of(context);
              final t = _pulseController.value;
              final scale = 1.0 + t * 0.05;
              final opacity = 1.0 - t * 0.3;
              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 192,
                    height: 192,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: pulseColors.mint.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.cardBg.withValues(alpha: 0.6),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.emerald.withValues(alpha: 0.15),
                  blurRadius: 50,
                ),
              ],
            ),
            child: Icon(
              Icons.cloud_off_rounded,
              size: 80,
              color: colors.mint,
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.scaffoldBg,
                shape: BoxShape.circle,
              ),
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.borderDark,
                  ),
                ),
                child: Icon(
                  Icons.construction_rounded,
                  size: AppSpacing.iconSmall,
                  color: colors.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    final colors = AppColors.of(context);
    return Text(
      AppStrings.ssTitle,
      style: TextStyle(
        fontFamily: 'Sora',
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: colors.mint,
        height: 1.2,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage() {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + AppSpacing.xs),
      child: Text(
        AppStrings.ssMessage,
        style: TextStyle(
          fontFamily: 'Sora',
          fontSize: AppSpacing.titleMedium,
          fontWeight: FontWeight.w400,
          color: colors.textMuted,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActions() {
    final colors = AppColors.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 240,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: widget.onRetry,
            icon: const Icon(Icons.refresh_rounded, size: AppSpacing.iconSmall),
            label:  Text(
              AppStrings.ssRetry,
              style: TextStyle(
                fontSize: AppSpacing.bodyMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.emerald,
              foregroundColor: colors.buttonTextDark,
              elevation: 0,
              shadowColor: colors.emerald.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm + 4),
        SizedBox(
          width: 240,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context)
                .pushReplacementNamed(AppRoutes.dashboard),
            icon: const Icon(Icons.home_rounded, size: AppSpacing.iconSmall),
            label:  Text(
              AppStrings.ssGoHome,
              style: TextStyle(
                fontSize: AppSpacing.bodyMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: colors.cardBg.withValues(alpha: 0.6),
              foregroundColor: colors.mint,
              side: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorCode() {
    final errorColors = AppColors.of(context);
    return Text(
      AppStrings.ssErrorCode,
      style: TextStyle(
        fontFamily: 'Sora',
        fontSize: AppSpacing.bodySmall,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.05,
        color: errorColors.textLight,
      ),
    );
  }
}

class _ParticleLayer extends StatelessWidget {
  const _ParticleLayer();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _ServiceStoppedParticlePainter(),
        ),
      ),
    );
  }
}

class _ServiceStoppedParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = _SeededRandom(42);
    for (var i = 0; i < 60; i++) {
      final x = rng.next() * size.width;
      final y = rng.next() * size.height;
      final radius = rng.next() * 3 + 0.5;
      final alpha = rng.next() * 0.5 + 0.1;
      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = AppColors.dark.emerald.withValues(alpha: alpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
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
