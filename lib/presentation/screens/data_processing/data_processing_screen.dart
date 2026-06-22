import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'data_processing_painters.dart';
import 'widgets/dp_analysis_card.dart';
import 'widgets/dp_action_buttons.dart';
import 'widgets/dp_security_footer.dart';

class DataProcessingScreen extends StatefulWidget {
  final VoidCallback? onBackground;
  final VoidCallback? onCancel;
  const DataProcessingScreen({super.key, this.onBackground, this.onCancel});

  @override
  State<DataProcessingScreen> createState() => _DataProcessingScreenState();
}

class _DataProcessingScreenState extends State<DataProcessingScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _breathingController;
  List<DpParticleData> _particles = [];
  double _percent = 0.72;
  Timer? _progressTimer;
  Size _viewSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
    _breathingController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _initParticles();
    _progressTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (_percent < 0.99) {
        setState(() => _percent = (_percent + (0.001 + 0.004 * (_percent * 0.5))).clamp(0.0, 0.99));
      }
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _viewSize = MediaQuery.of(context).size);
      }
    });
  }

  void _initParticles() {
    final rng = DpSeededRandom(42);
    _particles = List.generate(20, (_) {
      return DpParticleData(
        x: rng.next() * 400, y: rng.next() * 800,
        vx: (rng.next() - 0.5) * 30, vy: (rng.next() - 0.5) * 30,
        size: rng.next() * 4 + 2, opacity: rng.next(),
        life: rng.next() * 8, maxLife: 8 + rng.next() * 7,
      );
    });
  }

  void _updateParticles() {
    final w = _viewSize.width;
    final h = _viewSize.height;
    if (w == 0 || h == 0) return;
    for (final p in _particles) {
      p.life += 0.016;
      if (p.life >= p.maxLife) {
        final rng = DpSeededRandom((p.life * 1000).round());
        p.x = rng.next() * w;
        p.y = rng.next() * h;
        p.vx = (rng.next() - 0.5) * 30;
        p.vy = (rng.next() - 0.5) * 30;
        p.size = rng.next() * 4 + 2;
        p.opacity = rng.next();
        p.life = 0;
        p.maxLife = 8 + rng.next() * 7;
      }
      p.x += p.vx * 0.016;
      p.y += p.vy * 0.016;
      if (p.x < -10) p.x = w + 10;
      if (p.x > w + 10) p.x = -10;
      if (p.y < -10) p.y = h + 10;
      if (p.y > h + 10) p.y = -10;
      final fadeIn = (p.life / p.maxLife) < 0.15 ? (p.life / p.maxLife) / 0.15 : 1.0;
      final fadeOut = (p.life / p.maxLife) > 0.85 ? 1.0 - ((p.life / p.maxLife) - 0.85) / 0.15 : 1.0;
      p.opacity = fadeIn * fadeOut * p.opacity.clamp(0.0, 0.4);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _breathingController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final breathingScale = 1.0 + _breathingController.value * 0.1;
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      body: Stack(
        children: [
          if (_viewSize != Size.zero)
            CustomPaint(
              size: _viewSize,
              painter: DpPulseCirclesPainter(_pulseController.value, _viewSize),
            ),
          if (_viewSize != Size.zero)
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, _) {
                _updateParticles();
                return CustomPaint(size: _viewSize, painter: DpParticlesPainter(_particles));
              },
            ),
          if (_viewSize != Size.zero)
            Positioned(
              top: -_viewSize.height * 0.1,
              right: -_viewSize.width * 0.05,
              width: _viewSize.width * 0.9,
              height: _viewSize.height * 0.5,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.mint.withValues(alpha: 0.1),
                  boxShadow: [
                    BoxShadow(
                      color: colors.mint.withValues(alpha: 0.1),
                      blurRadius: 120,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
          if (_viewSize != Size.zero)
            Positioned(
              bottom: -_viewSize.height * 0.1,
              left: -_viewSize.width * 0.05,
              width: _viewSize.width * 0.8,
              height: _viewSize.height * 0.4,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.mint.withValues(alpha: 0.1),
                  boxShadow: [
                    BoxShadow(
                      color: colors.mint.withValues(alpha: 0.1),
                      blurRadius: 100,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_rounded, color: colors.textMuted),
                          onPressed: widget.onCancel ?? () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '\u062a\u062d\u0644\u064a\u0644 \u0627\u0644\u0628\u064a\u0627\u0646\u0627\u062a \u0627\u0644\u0635\u062d\u064a\u0629',
                      style: TextStyle(
                        fontFamily: 'Sora', fontSize: 28, fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        '\u062c\u0627\u0631\u064a \u0625\u0646\u0634\u0627\u0621 \u062a\u0642\u0631\u064a\u0631\u0643 \u0627\u0644\u0635\u062d\u064a \u0627\u0644\u0634\u0627\u0645\u0644 \u0628\u0627\u0633\u062a\u062e\u062f\u0627\u0645 \u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a...',
                        style: TextStyle(
                          fontFamily: 'Sora', fontSize: AppSpacing.bodyLarge, fontWeight: FontWeight.w400,
                          color: colors.textMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    DpAnalysisCard(percent: _percent, breathingScale: breathingScale),
                    const SizedBox(height: AppSpacing.xxl),
                    DpActionButtons(
                      onBackground: widget.onBackground,
                      onCancel: widget.onCancel,
                    ),
                    const DpSecurityFooter(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
