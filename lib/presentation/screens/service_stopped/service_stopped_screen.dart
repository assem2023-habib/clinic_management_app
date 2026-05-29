import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFF00180B),
      body: Stack(
        children: [
          const _ParticleLayer(),
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) => _buildPulsingCircles(),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24),
                      _buildStatusBadge(),
                      const SizedBox(height: 24),
                      _buildIconComposition(),
                      const SizedBox(height: 40),
                      _buildTitle(),
                      const SizedBox(height: 12),
                      _buildMessage(),
                      const SizedBox(height: 40),
                      _buildActions(),
                      const SizedBox(height: 40),
                      _buildErrorCode(),
                      const SizedBox(height: 24),
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

  Widget _buildPulsingCircles() {
    final t = _pulseController.value;
    return IgnorePointer(
      child: Center(
        child: SizedBox(
          width: 450,
          height: 450,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _pulseCircle(t, 0.0),
              _pulseCircle(t, 0.375),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pulseCircle(double t, double delay) {
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
              color: phase <= 0.5
                  ? const Color(0xFF4EDEA3).withValues(alpha: 0.2)
                  : const Color(0xFF4EDEA3).withValues(alpha: 0.1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF93000A),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: const Color(0xFFFFB4AB).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFFFB4AB),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            AppStrings.ssStatusOffline,
            style: const TextStyle(
              fontFamily: 'Sora',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.05,
              color: Color(0xFFFFDAD6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconComposition() {
    return SizedBox(
      width: 192,
      height: 192,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) {
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
                        color: const Color(0xFF4EDEA3).withValues(alpha: 0.2),
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
              color: const Color(0xFF032515).withValues(alpha: 0.6),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  blurRadius: 50,
                ),
              ],
            ),
            child: const Icon(
              Icons.cloud_off_rounded,
              size: 80,
              color: Color(0xFF4EDEA3),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF00180B),
                shape: BoxShape.circle,
              ),
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF3C4A42),
                  ),
                ),
                child: const Icon(
                  Icons.construction_rounded,
                  size: 20,
                  color: Color(0xFFFFB4AB),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      AppStrings.ssTitle,
      style: TextStyle(
        fontFamily: 'Sora',
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: Color(0xFF4EDEA3),
        height: 1.2,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        AppStrings.ssMessage,
        style: TextStyle(
          fontFamily: 'Sora',
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Color(0xFFBBCABF),
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 240,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: widget.onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 20),
            label: const Text(
              AppStrings.ssRetry,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: const Color(0xFF00422B),
              elevation: 0,
              shadowColor: const Color(0xFF10B981).withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 240,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context)
                .pushReplacementNamed(AppRoutes.dashboard),
            icon: const Icon(Icons.home_rounded, size: 20),
            label: const Text(
              AppStrings.ssGoHome,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFF032515).withValues(alpha: 0.6),
              foregroundColor: const Color(0xFF4EDEA3),
              side: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorCode() {
    return const Text(
      AppStrings.ssErrorCode,
      style: TextStyle(
        fontFamily: 'Sora',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.05,
        color: Color(0xFF86948A),
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
          ..color = const Color(0xFF10B981).withValues(alpha: alpha)
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
