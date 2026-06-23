import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class OfflineScreen extends StatefulWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onShowCached;

  const OfflineScreen({super.key, this.onRetry, this.onShowCached});

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  static const _imageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBSeUtfQ8B9jy-BT5l7LjgFV_x82Y5dBqwrkXeIGya0Zd7-gG5jEZ7B5xC-CAfrxyQfcMJWUCnj1VRUFGa_1-uCjsmV5FPNuHXwqzxZMvzyec_OzweSM1TiYV6y7xJTSe7L6tFeitBlC9NiJq3GoLTYHb5_Qt00LbdEx3DefG-miD1k3bs7--8GV1JbDyCMezVQnweqPlNDRaDEQsFEzj05YBvU1kYM4Ky1zwCpK6_8dkG1v_zL-xIIWOktu_S-0IbNII2Za9X2P8k';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(screenSize),
          _buildScanlines(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(colors),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: AppSpacing.xl),
                          _buildIllustration(),
                          const SizedBox(height: AppSpacing.xxl),
                          _buildGlassCard(),
                          const SizedBox(height: AppSpacing.xxl),
                          _buildStatusDetails(colors),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildParticles(),
        ],
      ),
    );
  }

  Widget _buildBackground(Size screenSize) {
    final colors = AppColors.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            colors.surface,
            colors.offlineBg,
          ],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }

  Widget _buildScanlines() {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _ScanlinePainter(),
        ),
      ),
    );
  }

  Widget _buildParticles() {
    final colors = AppColors.of(context);
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _ParticlePainter(colors),
        ),
      ),
    );
  }

  Widget _buildHeader(AppColorSet colors) {
    return Container(
      height: AppSpacing.appBarHeight,
      decoration: BoxDecoration(
        color: colors.offlineBg.withValues(alpha: 0.7),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.15),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            color: colors.primary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              AppStrings.appName,
              style: TextStyle(
                fontFamily: 'Sora',
                fontSize: AppSpacing.titleError,
                fontWeight: FontWeight.w600,
                color: colors.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    final colors = AppColors.of(context);
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: child,
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.width * 0.72,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.neonGreen.withValues(alpha: 0.04),
                boxShadow: [
                  BoxShadow(
                    color: colors.neonGreen.withValues(alpha: 0.06),
                    blurRadius: 100,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              child: Image.network(
                _imageUrl,
                width: MediaQuery.of(context).size.width * 0.55,
                height: MediaQuery.of(context).size.width * 0.55,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    _buildFallbackIcon(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    final colors = AppColors.of(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.surface.withValues(alpha: 0.5),
        border: Border.all(
          color: colors.neonGreen.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.neonGreen.withValues(alpha: 0.15),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Icon(
        Icons.signal_cellular_off_rounded,
        size: 72,
        color: colors.neonGreen.withValues(alpha: 0.7),
      ),
    );
  }

  Widget _buildGlassCard() {
    final colors = AppColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.olTitle,
            style: TextStyle(
              fontFamily: 'Sora',
              fontSize: AppSpacing.titleError,
              fontWeight: FontWeight.w600,
              height: 1.3,
              color: colors.sage,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              AppStrings.olMessage,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: AppSpacing.bodyLarge,
                fontWeight: FontWeight.w400,
                color: colors.borderLight,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildActions(),
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
          height: AppSpacing.buttonHeight,
          child: ElevatedButton(
            onPressed: widget.onRetry ?? () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.neonGreen,
              foregroundColor: colors.buttonFg,
              disabledBackgroundColor: colors.neonGreen.withValues(alpha: 0.5),
              disabledForegroundColor: colors.buttonFg.withValues(alpha: 0.5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.refresh_rounded, size: AppSpacing.iconSmall),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  AppStrings.olRetry,
                  style: const TextStyle(
                    fontSize: AppSpacing.titleMedium,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          height: AppSpacing.buttonHeight,
          child: TextButton(
            onPressed: widget.onShowCached ?? () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.dashboard, (route) => false),
            style: TextButton.styleFrom(
              foregroundColor: colors.sage,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cached_rounded, size: AppSpacing.iconSmall),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  AppStrings.olShowCached,
                  style: const TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: AppSpacing.bodySmall,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDetails(AppColorSet colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 16,
              color: colors.textSecondary.withValues(alpha: 0.4),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              AppStrings.olSignalLost,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: AppSpacing.bodySmall,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                color: colors.textSecondary.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
        const SizedBox(width: AppSpacing.lg),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.dns_rounded,
              size: 16,
              color: colors.textSecondary.withValues(alpha: 0.4),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              AppStrings.olServerUnreachable,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: AppSpacing.bodySmall,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                color: colors.textSecondary.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(
        Offset(0, y + 2),
        Offset(size.width, y + 2),
        Paint()..color = Colors.black.withValues(alpha: 0.04),
      );
    }

    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.red.withValues(alpha: 0.005),
        Colors.green.withValues(alpha: 0.003),
        Colors.blue.withValues(alpha: 0.005),
      ],
    );
    canvas.drawRect(
      rect,
      Paint()..shader = gradient.createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ParticlePainter extends CustomPainter {
  final AppColorSet colors;

  const _ParticlePainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colors.neonGreen.withValues(alpha: 0.12);
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.25),
      2,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.7),
      3,
      paint..color = colors.sage.withValues(alpha: 0.08),
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.85),
      1.5,
      paint..color = colors.neonGreen.withValues(alpha: 0.12),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
