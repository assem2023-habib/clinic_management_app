import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class UaContent extends StatelessWidget {
  const UaContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          AppStrings.uaTitle,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4EDEA3),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            AppStrings.uaMessage,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFFBBCABF),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
