import 'package:flutter/material.dart';

class NfActions extends StatelessWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onBack;

  const NfActions({super.key, this.onRetry, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onRetry ?? () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: const Color(0xFF003824),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.refresh_rounded, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'إِعَادَةُ المُحَاوَلَةِ',
                    style: TextStyle(fontFamily: 'Sora', fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onBack ?? () => Navigator.pop(context),
              child: const Text(
                'العَوْدَةُ لِلإِشْعَارَاتِ',
                style: TextStyle(fontFamily: 'Sora', fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFFBBCABF)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
