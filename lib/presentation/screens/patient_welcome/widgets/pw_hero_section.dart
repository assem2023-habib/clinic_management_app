import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class PwFloatingChip {
  final double top, left, delay;
  final String label;
  const PwFloatingChip({required this.top, required this.left, required this.label, required this.delay});
}

List<PwFloatingChip> chipsForPage(int page) {
  final page1 = [
    PwFloatingChip(top: 32, left: 16, label: AppStrings.pwChipBpm, delay: 0),
    PwFloatingChip(top: 220, left: 180, label: AppStrings.pwChipAiScan, delay: 1),
  ];
  final page2 = [
    PwFloatingChip(top: 28, left: 24, label: AppStrings.pwChipReminder, delay: 0),
    PwFloatingChip(top: 210, left: 160, label: AppStrings.upcomingAppts, delay: 1),
  ];
  final page3 = [
    PwFloatingChip(top: 34, left: 12, label: AppStrings.pwChipAnalysis, delay: 0),
    PwFloatingChip(top: 200, left: 190, label: AppStrings.secureEncrypted, delay: 1),
  ];
  switch (page) {
    case 0: return page1;
    case 1: return page2;
    default: return page3;
  }
}

class PwHeroSection extends StatelessWidget {
  final IconData icon;
  final List<PwFloatingChip> chips;

  const PwHeroSection({super.key, required this.icon, required this.chips});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 240,
            height: 240,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 260, height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.mint.withValues(alpha: 0.15)),
                  ),
                ),
                Container(
                  width: 210, height: 210,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.mint.withValues(alpha: 0.08)),
                  ),
                ),
                Container(
                  width: 128, height: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.cardBg.withValues(alpha: 0.5),
                    border: Border.all(color: colors.mint.withValues(alpha: 0.15)),
                    boxShadow: [BoxShadow(color: colors.mint.withValues(alpha: 0.08), blurRadius: 40)],
                  ),
                  child: Icon(icon, size: 64, color: colors.mint),
                ),
              ],
            ),
          ),
          for (final chip in chips)
            Positioned(
              top: chip.top,
              left: chip.left,
              child: _FloatingChipWidget(label: chip.label, delay: chip.delay),
            ),
        ],
      ),
    );
  }
}

class _FloatingChipWidget extends StatefulWidget {
  final String label;
  final double delay;
  const _FloatingChipWidget({required this.label, required this.delay});

  @override
  State<_FloatingChipWidget> createState() => _FloatingChipWidgetState();
}

class _FloatingChipWidgetState extends State<_FloatingChipWidget> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: (widget.delay * 1000).round()), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.ten, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: colors.emerald)),
              const SizedBox(width: AppSpacing.six),
              Text(widget.label, style: TextStyle(fontFamily: 'Sora', fontSize: AppSpacing.labelSmall, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: colors.textPrimary)),
            ],
          ),
        ),
      ),
    );
  }
}

