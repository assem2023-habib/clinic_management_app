import 'package:flutter/material.dart';

class DpSecurityFooter extends StatelessWidget {
  const DpSecurityFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0x0DFFFFFF))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildItem(Icons.lock, '\u062e\u0635\u0648\u0635\u064a\u0629 AI', '\u0645\u0634\u0641\u0631 \u062a\u0645\u0627\u0645\u0627\u064b'),
          _buildItem(Icons.verified_user, '\u062a\u0634\u0641\u064a\u0631 PDF', '\u0645\u0639\u064a\u0627\u0631 \u0637\u0628\u064a \u0639\u0627\u0644'),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF1B3B29),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFFC6EBD1)),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(
              fontFamily: 'Sora', fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFFC6EBD1),
            )),
            Text(subtitle, style: const TextStyle(
              fontFamily: 'Sora', fontSize: 8, fontWeight: FontWeight.w600, color: Color(0xFFBBCABF),
            )),
          ],
        ),
      ],
    );
  }
}
