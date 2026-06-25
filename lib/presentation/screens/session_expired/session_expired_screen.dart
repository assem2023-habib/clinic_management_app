import 'package:clinic_management_app/core/constants/app_icons.dart';
import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/animations/animations.dart';
import 'package:clinic_management_app/core/painters/painters.dart';

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
          painter: ParticlePainter(color: AppColors.dark.mint, particleCount: 40, minRadius: 1.0, maxRadius: 4.0, minAlpha: 0.2, maxAlpha: 0.4, useBlur: true),
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
                painter: RotatingGlowPainter(_glowController.value * 2 * pi, color: colors.emerald),
              );
            },
          ),
            FloatAnimation(
              child: Container(
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
                  AppIcons.timerOff,
                  size: 64,
                  color: colors.mint,
                ),
              ),
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
                  AppIcons.lock,
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
