import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class MrpDocumentCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const MrpDocumentCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFF012B17).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFF032515),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(
                Icons.description_rounded,
                size: 48,
                color: Color(0xFF1B3B29),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFC6EBD1),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFFBEC9BF),
            ),
          ),
        ],
      ),
    );
  }
}

class MrpUploadButton extends StatelessWidget {
  final VoidCallback? onUpload;

  const MrpUploadButton({super.key, this.onUpload});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onUpload,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.15),
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 24),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.upload_file_rounded,
              size: 32,
              color: Color(0xFF80D8A6),
            ),
            const SizedBox(height: 8),
            const Text(
              AppStrings.mrUploadDocument,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFC6EBD1),
              ),
            ),
            const Text(
              AppStrings.mrUploadHint,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFFBEC9BF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
