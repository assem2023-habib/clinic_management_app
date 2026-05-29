import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class UaDataNodes extends StatelessWidget {
  const UaDataNodes({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _buildChip(Icons.lock_open_rounded, AppStrings.uaEncryption),
        _buildChip(Icons.verified_user_rounded, AppStrings.uaDataProtection),
        _buildChip(Icons.security_rounded, AppStrings.uaSecureProtocol),
      ],
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF4EDEA3)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFBBCABF),
            ),
          ),
        ],
      ),
    );
  }
}
