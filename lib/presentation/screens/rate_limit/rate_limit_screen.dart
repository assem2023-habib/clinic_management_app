import 'dart:async';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/screens/rate_limit/rate_limit_painters.dart';
import 'package:clinic_management_app/core/constants/app_icons.dart';

class RateLimitScreen extends StatefulWidget {
  final int? retryAfterSeconds;
  final VoidCallback? onRetry;
  final VoidCallback? onContactSupport;

  const RateLimitScreen({
    super.key,
    this.retryAfterSeconds,
    this.onRetry,
    this.onContactSupport,
  });

  @override
  State<RateLimitScreen> createState() => _RateLimitScreenState();
}

class _RateLimitScreenState extends State<RateLimitScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  int? _remaining;
  Timer? _timer;
  int _totalTime = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    if (widget.retryAfterSeconds != null && widget.retryAfterSeconds! > 0) {
      _remaining = widget.retryAfterSeconds;
      _totalTime = widget.retryAfterSeconds!;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_remaining != null && _remaining! > 0) {
          setState(() => _remaining = _remaining! - 1);
        } else {
          _timer?.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  double get _progress =>
      _remaining != null && _totalTime > 0 ? _remaining! / _totalTime : 0.0;

  bool get _isReady => _remaining == null || _remaining! <= 0;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      body: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(color: colors.scaffoldBg),
            child: const SizedBox.expand(),
          ),
          _buildPulsingCircles(colors),
          _buildAtmosphericGlows(colors),
          _buildParticles(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: AppSpacing.xl),
                      _buildAnalogClock(),
                      const SizedBox(height: AppSpacing.xl),
                      _buildShieldIcon(colors),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildContent(colors),
                      const SizedBox(height: AppSpacing.lg),
                      _buildTimerCard(colors: colors),
                      const SizedBox(height: AppSpacing.sm),
                      _buildActions(colors: colors),
                      const SizedBox(height: AppSpacing.xl),
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
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                _pulseCircle(300, 0.0, colors),
                _pulseCircle(500, 0.25, colors),
                _pulseCircle(700, 0.5, colors),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _pulseCircle(double size, double delay, AppColorSet colors) {
    final t = (_pulseController.value + delay) % 1.0;
    final scale = 0.8 + 0.7 * t;
    final opacity = t <= 0.5 ? t * 2.0 * 0.5 : (1.0 - t) * 2.0 * 0.5;
    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colors.neonGreen.withValues(alpha: 0.15),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAtmosphericGlows(AppColorSet colors) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -96,
              left: -96,
              child: Container(
                width: 384,
                height: 384,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.neonGreen.withValues(alpha: 0.06),
                  boxShadow: [
                    BoxShadow(
                      color: colors.neonGreen.withValues(alpha: 0.04),
                      blurRadius: 120,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -96,
              right: -96,
              child: Container(
                width: 384,
                height: 384,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.sage.withValues(alpha: 0.03),
                  boxShadow: [
                    BoxShadow(
                      color: colors.sage.withValues(alpha: 0.02),
                      blurRadius: 120,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticles() {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: ParticlePainter(),
        ),
      ),
    );
  }

  Widget _buildAnalogClock() {
    return SizedBox(
      width: 100,
      height: 100,
      child: CustomPaint(
        painter: ClockPainter(progress: _progress),
      ),
    );
  }

  Widget _buildShieldIcon(AppColorSet colors) {
    return SizedBox(
      width: 256,
      height: 256,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: DashedCirclePainter(),
            ),
          ),
          Container(
            width: 192,
            height: 192,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.neonGreen.withValues(alpha: 0.03),
              boxShadow: [
                BoxShadow(
                  color: colors.neonGreen.withValues(alpha: 0.05),
                  blurRadius: 80,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
          Icon(
            AppIcons.medicalServices,
            size: 72,
            color: colors.neonGreen.withValues(alpha: 0.8),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AppColorSet colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          Text(
            AppStrings.rlTitle,
            style: TextStyle(
              fontFamily: 'Sora',
              fontSize: AppSpacing.titleError,
              fontWeight: FontWeight.w600,
              color: colors.neonGreen,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.rlMessage,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: AppSpacing.bodyLarge,
              fontWeight: FontWeight.w400,
              color: colors.textMuted,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTimerCard({required AppColorSet colors}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.rlWaitingTimer,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: AppSpacing.bodySmall,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                color: colors.neonGreen,
              ),
            ),
            Text(
              _isReady
                  ? AppStrings.rlReadyNow
                  : '$_remaining ${AppStrings.rlSecond}',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: AppSpacing.bodySmall,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                  color: _isReady
                      ? colors.neonGreen
                      : colors.textDisabled,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: SizedBox(
              width: double.infinity,
              height: AppSpacing.bulletSize,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: AppSpacing.bulletSize,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.linear,
                    width: _progress *
                        MediaQuery.of(context).size.width *
                        0.85,
                    height: AppSpacing.bulletSize,
                    decoration: BoxDecoration(
                      color: colors.neonGreen,
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: [
                        BoxShadow(
                          color: colors.neonGreen
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions({required AppColorSet colors}) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: AppSpacing.buttonHeight,
          child: ElevatedButton(
            onPressed: _isReady ? (widget.onRetry ?? () {}) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.neonGreen,
              foregroundColor: colors.surface,
              disabledBackgroundColor: Colors.white.withValues(alpha: 0.04),
              disabledForegroundColor:
                  colors.textMuted.withValues(alpha: 0.5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  AppIcons.refresh,
                  size: AppSpacing.iconSmall,
                  color: _isReady
                      ? colors.surface
                      : colors.textMuted.withValues(alpha: 0.5),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  AppStrings.rlRetry,
                  style: TextStyle(
                    fontSize: AppSpacing.bodyLarge,
                    fontWeight: FontWeight.w700,
                    color: _isReady
                        ? colors.surface
                        : colors.textMuted.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: widget.onContactSupport,
          style: TextButton.styleFrom(
            foregroundColor: colors.textMuted,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
          ),
          child: Text(
            AppStrings.rlContactSupport,
            style: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: AppSpacing.bodySmall,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
