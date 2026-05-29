import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PsHeroIcon extends StatelessWidget {
  const PsHeroIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 192,
      height: 192,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF4EDEA3).withValues(alpha: 0.2)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.shield_rounded, size: 80, color: Color(0xFF4EDEA3)),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: const Icon(Icons.add, size: 18, color: Color(0xFF00180B)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().shakeY(duration: 6.seconds, amount: 8, curve: Curves.easeInOut);
  }
}
