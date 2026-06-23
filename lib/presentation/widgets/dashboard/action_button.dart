import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppSpacing.iconSmall, color: Colors.white),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: const TextStyle(fontSize: AppSpacing.bodyMedium, color: Colors.white)),
        ],
      ),
    );
  }
}

