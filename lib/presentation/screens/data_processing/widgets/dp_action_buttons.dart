import 'package:flutter/material.dart';

class DpActionButtons extends StatelessWidget {
  final VoidCallback? onBackground;
  final VoidCallback? onCancel;
  const DpActionButtons({super.key, this.onBackground, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: onBackground ?? () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: const Color(0xFF003824),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              elevation: 0,
              shadowColor: const Color(0xFF10B981).withValues(alpha: 0.2),
            ),
            child: const Text(
              '\u0627\u0644\u0645\u062a\u0627\u0628\u0639\u0629 \u0641\u064a \u0627\u0644\u062e\u0644\u0641\u064a\u0629',
              style: TextStyle(fontFamily: 'Sora', fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: TextButton(
            onPressed: onCancel ?? () => Navigator.pop(context),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
              foregroundColor: const Color(0xFFC6EBD1),
            ),
            child: const Text(
              '\u0625\u0644\u063a\u0627\u0621 \u0627\u0644\u0639\u0645\u0644\u064a\u0629',
              style: TextStyle(fontFamily: 'Sora', fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}
