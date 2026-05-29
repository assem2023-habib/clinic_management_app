import 'package:flutter/material.dart';

class MrpMedicationCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String dosage;

  const MrpMedicationCard({
    super.key,
    required this.icon,
    required this.name,
    required this.dosage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF012B17).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00CA73).withValues(alpha: 0.2),
            ),
            child: Icon(icon, size: 24, color: const Color(0xFF40E78C)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFC6EBD1),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dosage,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFBEC9BF),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_left_rounded,
            size: 24,
            color: Color(0xFFBEC9BF),
          ),
        ],
      ),
    );
  }
}
