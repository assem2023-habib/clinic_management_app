import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PwFloatingChip {
  final double top, left, delay;
  final String label;
  const PwFloatingChip({required this.top, required this.left, required this.label, required this.delay});
}

List<PwFloatingChip> chipsForPage(int page) {
  const page1 = [
    PwFloatingChip(top: 32, left: 16, label: '82 BPM', delay: 0),
    PwFloatingChip(top: 220, left: 180, label: 'AI Scan Active', delay: 1),
  ];
  const page2 = [
    PwFloatingChip(top: 28, left: 24, label: 'تذكير ذكي', delay: 0),
    PwFloatingChip(top: 210, left: 160, label: '3 مواعيد قادمة', delay: 1),
  ];
  const page3 = [
    PwFloatingChip(top: 34, left: 12, label: 'تحليل AI', delay: 0),
    PwFloatingChip(top: 200, left: 190, label: 'آمن ومشفر', delay: 1),
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

class _FloatingChipWidget extends StatelessWidget {
  final String label;
  final double delay;
  const _FloatingChipWidget({required this.label, required this.delay});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: colors.emerald)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontFamily: 'Sora', fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: colors.textPrimary)),
        ],
      ),
    ).animate(delay: (delay * 1000).round().ms).shakeY(
      duration: 3.seconds,
      amount: 3,
      curve: Curves.easeInOut,
    );
  }
}
