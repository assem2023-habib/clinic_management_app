import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class MrpPatientSummary extends StatelessWidget {
  final String name;
  final int age;

  const MrpPatientSummary({
    super.key,
    required this.name,
    required this.age,
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
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF006D44),
                width: 2,
              ),
            ),
            child: const CircleAvatar(
              backgroundColor: Color(0xFF032515),
              child: Icon(
                Icons.person_rounded,
                size: 32,
                color: Color(0xFF80D8A6),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFC6EBD1),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildTag('$age ${AppStrings.dpYear}'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF006D44).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF80D8A6),
        ),
      ),
    );
  }
}
