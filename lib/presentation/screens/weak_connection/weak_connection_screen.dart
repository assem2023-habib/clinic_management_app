import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class WeakConnectionScreen extends StatefulWidget {
  final VoidCallback? onRetry;

  const WeakConnectionScreen({super.key, this.onRetry});

  @override
  State<WeakConnectionScreen> createState() => _WeakConnectionScreenState();
}

class _WeakConnectionScreenState extends State<WeakConnectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final centralSize = screenWidth * 0.48;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Stack(
        children: [
          _buildStarfield(),
          _buildAmbientGlows(context, colors),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.appBarHeight),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: AppSpacing.xl),
                          _buildCentralElement(centralSize, colors),
                          const SizedBox(height: 48),
                          _buildContent(colors),
                          const SizedBox(height: 24),
                          _buildActions(colors),
                          const SizedBox(height: 24),
                          _buildSignalMeter(colors),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarfield() {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _StarfieldPainter(),
        ),
      ),
    );
  }

  Widget _buildAmbientGlows(BuildContext context, AppColorSet colors) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          top: size.height * 0.15,
          left: size.width * 0.05,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.neonGreen.withValues(alpha: 0.04),
              boxShadow: [
                BoxShadow(
                  color: colors.neonGreen.withValues(alpha: 0.05),
                  blurRadius: 100,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: size.height * 0.15,
          right: size.width * 0.05,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.sage.withValues(alpha: 0.03),
              boxShadow: [
                BoxShadow(
                  color: colors.sage.withValues(alpha: 0.04),
                  blurRadius: 80,
                  spreadRadius: 40,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCentralElement(double size, AppColorSet colors) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ListenableBuilder(
            listenable: _ringController,
            builder: (context, _) {
              return _buildPulseRing(size, 0, _ringController.value, colors);
            },
          ),
          ListenableBuilder(
            listenable: _ringController,
            builder: (context, _) {
              return _buildPulseRing(size, 1, (_ringController.value + 0.33) % 1.0, colors);
            },
          ),
          ListenableBuilder(
            listenable: _ringController,
            builder: (context, _) {
              return _buildPulseRing(size, 2, (_ringController.value + 0.66) % 1.0, colors);
            },
          ),
          _buildBioCore(size, colors),
        ],
      ),
    );
  }

  Widget _buildPulseRing(double size, int index, double progress, AppColorSet colors) {
    final scale = 0.33 + progress * 0.87;
    final opacity = (1.0 - progress) * 0.5;
    return Transform.scale(
      scale: scale,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colors.neonGreen.withValues(alpha: opacity),
          ),
        ),
      ),
    );
  }

  Widget _buildBioCore(double size, AppColorSet colors) {
    final coreSize = size * 0.5;
    return Container(
      width: coreSize,
      height: coreSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.surface.withValues(alpha: 0.7),
        border: Border.all(
          color: colors.neonGreen.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.neonGreen.withValues(alpha: 0.2),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: coreSize * 0.65,
          height: coreSize * 0.65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.neonGreen.withValues(alpha: 0.1),
          ),
          child: Center(
            child: Icon(
              Icons.wifi_off_rounded,
              size: coreSize * 0.4,
              color: colors.neonGreen,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(AppColorSet colors) {
    return Column(
      children: [
        Text(
          AppStrings.wcTitle,
          style: TextStyle(
            fontFamily: 'Sora',
            fontSize: AppSpacing.titleError,
            fontWeight: FontWeight.w600,
            color: colors.textDisabled,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            AppStrings.wcMessage,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: AppSpacing.bodyLarge,
              fontWeight: FontWeight.w400,
              color: colors.textMuted,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(AppColorSet colors) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: AppSpacing.buttonHeight,
          child: ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              disabledBackgroundColor: Colors.white.withValues(alpha: 0.1),
              disabledForegroundColor: colors.textDisabled,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.buttonRadius)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: colors.sage,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Text(
                  AppStrings.wcWaiting,
                  style: TextStyle(fontSize: AppSpacing.bodyLarge, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          height: AppSpacing.buttonHeight,
          child: OutlinedButton(
            onPressed: widget.onRetry,
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.neonGreen,
              side: BorderSide(
                color: colors.neonGreen.withValues(alpha: 0.4),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.buttonRadius)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh_rounded, size: AppSpacing.iconSmall),
                const SizedBox(width: AppSpacing.sm),
                const Text(
                  AppStrings.wcRetry,
                  style: TextStyle(fontSize: AppSpacing.bodyLarge, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignalMeter(AppColorSet colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: colors.neonGreen.withValues(alpha: 0.05),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _signalBar(6, 0.2, colors),
                const SizedBox(width: 3),
                _signalBar(10, 0.2, colors),
                const SizedBox(width: 3),
                _signalBar(14, 0.4, colors, color: Colors.red),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            AppStrings.wcSignalStrength,
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: AppSpacing.bodySmall,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.05,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _signalBar(double height, double opacity, AppColorSet colors, {Color? color}) {
    final signalColor = color ?? colors.neonGreen;
    return Container(
      width: 4,
      height: height,
      decoration: BoxDecoration(
        color: signalColor.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = _SeededRandom(42);
    final paint = Paint()
      ..color = AppColors.dark.emerald.withValues(alpha: 0.12);
    for (var i = 0; i < 50; i++) {
      final x = rng.next() * size.width;
      final y = rng.next() * size.height;
      final radius = rng.next() * 1.2 + 0.5;
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
