import 'package:flutter/material.dart';

class NfIconSection extends StatelessWidget {
  const NfIconSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      height: 128,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 192,
            height: 192,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFB4AB).withValues(alpha: 0.15),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFB4AB).withValues(alpha: 0.15),
                  blurRadius: 60,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF032515).withValues(alpha: 0.6),
              border: Border.all(
                color: const Color(0xFFFFB4AB).withValues(alpha: 0.2),
              ),
            ),
            child: const Icon(
              Icons.notifications_off_rounded,
              size: 64,
              color: Color(0xFFFFB4AB),
            ),
          ),
        ],
      ),
    );
  }
}
