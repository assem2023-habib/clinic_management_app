import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'suspended_painters.dart';
import 'widgets/sp_background.dart';
import 'widgets/sp_icon_section.dart';
import 'widgets/sp_content_card.dart';
import 'widgets/sp_reason_card.dart';
import 'widgets/sp_actions.dart';

class SuspendedScreen extends StatefulWidget {
  final VoidCallback? onContactSupport;
  final VoidCallback? onLogout;

  const SuspendedScreen({
    super.key,
    this.onContactSupport,
    this.onLogout,
  });

  @override
  State<SuspendedScreen> createState() => _SuspendedScreenState();
}

class _SuspendedScreenState extends State<SuspendedScreen>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _pulseController;
  final List<ParticleData> _particles = [];

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _initParticles();
  }

  @override
  void dispose() {
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _initParticles() {
    final rng = SeededRandom(42);
    for (var i = 0; i < 50; i++) {
      _particles.add(ParticleData(
        x: rng.next(),
        y: rng.next(),
        speedX: (rng.next() - 0.5) * 0.3,
        speedY: (rng.next() - 0.5) * 0.3,
        size: rng.next() * 2 + 0.5,
        opacity: rng.next() * 0.5 + 0.2,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            return Stack(
              children: [
                SpBackground(
                  particleController: _particleController,
                  pulseController: _pulseController,
                  particles: _particles,
                  size: size,
                ),
                _buildContent(colors),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(AppColorSet colors) {
    return Column(
      children: [
        _buildAppBar(colors),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md + AppSpacing.xs),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.appBarHeight),
                const SpIconSection(),
                const SizedBox(height: AppSpacing.md),
                const SpContentCard(),
                const SizedBox(height: AppSpacing.md),
                const SpReasonCard(),
                const SizedBox(height: AppSpacing.md),
                SpActions(
                  onContactSupport: widget.onContactSupport,
                  onLogout: widget.onLogout,
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(AppColorSet colors) {
    return Container(
      width: double.infinity,
      height: AppSpacing.appBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md + AppSpacing.xs),
      child: Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: AppSpacing.iconContainer,
              height: AppSpacing.iconContainer,
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_forward_rounded,
                color: colors.mint,
                size: AppSpacing.iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
