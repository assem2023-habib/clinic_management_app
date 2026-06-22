import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/presentation/screens/permissions/permissions_painters.dart';
import 'package:clinic_management_app/presentation/screens/permissions/widgets/ps_footer.dart';
import 'package:clinic_management_app/presentation/screens/permissions/widgets/ps_hero_icon.dart';
import 'package:clinic_management_app/presentation/screens/permissions/widgets/ps_permission_item.dart';

class PermissionsScreen extends StatefulWidget {
  final VoidCallback? onGoToSettings;
  final VoidCallback? onTryLater;

  const PermissionsScreen({super.key, this.onGoToSettings, this.onTryLater});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  final List<PsParticleData> _particles = [];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
    final rng = Random();
    for (int i = 0; i < 20; i++) {
      _particles.add(PsParticleData(
        x: rng.nextDouble() * 400, y: rng.nextDouble() * 800,
        speedX: (rng.nextDouble() - 0.5) * 0.3, speedY: (rng.nextDouble() - 0.5) * 0.3,
        size: rng.nextDouble() * 3 + 1, opacity: rng.nextDouble() * 0.4 + 0.1,
      ));
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _updateParticles(Size size) {
    for (final p in _particles) {
      p.x += p.speedX;
      p.y += p.speedY;
      if (p.x < 0 || p.x > size.width || p.y < 0 || p.y > size.height) {
        final rng = PsSeededRandom((p.x * 9999 + p.y * 9999).abs().toInt() % 100000 + 1);
        p.x = rng.next() * size.width;
        p.y = rng.next() * size.height;
        p.size = rng.next() * 3 + 1;
        p.speedX = (rng.next() - 0.5) * 0.3;
        p.speedY = (rng.next() - 0.5) * 0.3;
        p.opacity = rng.next() * 0.4 + 0.1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);
              return AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  _updateParticles(size);
                  return Stack(
                    children: [
                      CustomPaint(size: size, painter: PsPulseRingPainter(_pulseController)),
                      Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: PsParticlePainter(_particles)))),
                    ],
                  );
                },
              );
            },
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: colors.mint),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Text('Vitals Monitor', style: TextStyle(fontFamily: 'Sora', fontSize: 24, fontWeight: FontWeight.w700, color: colors.mint)),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const PsHeroIcon(),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Text('الصَّلاحِيَاتُ المَطْلُوبَةُ', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Sora', fontSize: 28, fontWeight: FontWeight.w600, height: 1.2, color: colors.textPrimary)),
                      const SizedBox(height: 12),
                      Text('لِلْحُصُولِ عَلَى أَفْضَلِ تَجْرِبَةٍ طِبِّيَّةٍ دَقِيقَةٍ، نَحْتَاجُ إِلَى الوُصُولِ لِبَعْضِ الصَّلاحِيَاتِ الأَسَاسِيَّةِ.', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Sora', fontSize: 16, fontWeight: FontWeight.w400, height: 1.5, color: colors.textMuted)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      PsPermissionItem(icon: Icons.photo_camera_rounded, title: 'الكَامِيرَا', hint: 'لِمَسْحِ الوَصَفَاتِ الطِّبِّيَّةِ ضَوْئِيّاً'),
                      const SizedBox(height: 8),
                      PsPermissionItem(icon: Icons.location_on_rounded, title: 'المَوْقِعُ الجُغْرَافِيُّ', hint: 'لِتَحْدِيدِ أَقْرَبِ عِيَادَةِ طَوَارِئْ'),
                    ],
                  ),
                ),
                const Spacer(),
                PsFooter(onGoToSettings: widget.onGoToSettings, onTryLater: widget.onTryLater),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
