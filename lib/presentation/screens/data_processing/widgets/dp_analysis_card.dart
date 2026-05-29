import 'package:flutter/material.dart';
import '../data_processing_painters.dart';

class DpAnalysisCard extends StatelessWidget {
  final double percent;
  final double breathingScale;
  const DpAnalysisCard({super.key, required this.percent, required this.breathingScale});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFF1B3B29).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.08),
            blurRadius: 40,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 192,
            height: 192,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(192, 192),
                  painter: DpProgressRingPainter(percent),
                ),
                Transform.scale(
                  scale: breathingScale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.memory, size: 40, color: Color(0xFF4EDEA3)),
                      const SizedBox(height: 4),
                      Text(
                        '${(percent * 100).round()}%',
                        style: const TextStyle(
                          fontFamily: 'Sora', fontSize: 40, fontWeight: FontWeight.w700,
                          color: Color(0xFF4EDEA3), height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'مُكْتَمِل',
                        style: TextStyle(
                          fontFamily: 'Sora', fontSize: 12, fontWeight: FontWeight.w600,
                          color: Color(0xFFBBCABF), letterSpacing: 0.05,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1B3B29),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 18, height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: const Color(0xFF4EDEA3),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '\u0627\u0644\u0630\u0643\u0627\u0621 \u0627\u0644\u0627\u0635\u0637\u0646\u0627\u0639\u064a \u064a\u062d\u0644\u0644 \u0627\u0644\u0628\u064a\u0627\u0646\u0627\u062a...',
                  style: TextStyle(
                    fontFamily: 'Sora', fontSize: 14, fontWeight: FontWeight.w500,
                    color: Color(0xFF4EDEA3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '\u064a\u062a\u0645 \u0627\u0644\u0622\u0646 \u0645\u0639\u0627\u0644\u062c\u0629 48 \u0646\u0642\u0637\u0629 \u0628\u064a\u0627\u0646\u064a\u0629 \u062d\u064a\u0648\u064a\u0629',
            style: TextStyle(
              fontFamily: 'Sora', fontSize: 16, fontWeight: FontWeight.w400,
              color: Color(0xFFBBCABF),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
