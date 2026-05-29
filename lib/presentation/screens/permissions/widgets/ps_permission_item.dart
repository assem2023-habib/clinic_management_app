import 'package:flutter/material.dart';

class PsPermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String hint;

  const PsPermissionItem({super.key, required this.icon, required this.title, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF032515).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 22, color: const Color(0xFF4EDEA3)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title, style: const TextStyle(fontFamily: 'Sora', fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFFC6EBD1))),
                const SizedBox(height: 2),
                Text(hint, style: const TextStyle(fontFamily: 'Sora', fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: Color(0xFFBBCABF))),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.cancel_rounded, size: 20, color: Color(0xFFFFB4AB)),
        ],
      ),
    );
  }
}
