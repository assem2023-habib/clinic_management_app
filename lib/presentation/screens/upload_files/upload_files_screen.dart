import 'dart:async';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'upload_files_painters.dart';
import 'widgets/uf_active_upload_card.dart';
import 'widgets/uf_recent_upload_item.dart';
import 'widgets/uf_security_card.dart';
import 'widgets/uf_bottom_nav.dart';
import 'widgets/uf_section_header.dart';

class UploadFilesScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onCancelUpload;
  final VoidCallback? onViewAll;

  const UploadFilesScreen({
    super.key,
    this.onBack,
    this.onCancelUpload,
    this.onViewAll,
  });

  @override
  State<UploadFilesScreen> createState() => _UploadFilesScreenState();
}

class _UploadFilesScreenState extends State<UploadFilesScreen> {
  double _progress = 65;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_progress < 100) {
        setState(() => _progress += (0.5 + DateTime.now().microsecondsSinceEpoch % 15) / 10);
        if (_progress > 100) _progress = 100;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get _remaining => ((100 - _progress) / 2).round().clamp(0, 999);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00180B),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: UfParticlePainter()),
              ),
            ),
            Column(
              children: [
                _buildAppBar(),
                Expanded(child: _buildBody()),
                const UfBottomNav(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF00180B).withValues(alpha: 0.8),
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: widget.onBack ?? () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF4EDEA3),
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            AppStrings.ufTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4EDEA3),
            ),
          ),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () {},
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.more_vert_rounded,
                  color: Color(0xFFBBCABF),
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          UfSectionHeader(label: AppStrings.ufActiveUploadLabel),
          const SizedBox(height: AppSpacing.sm),
          UfActiveUploadCard(
            fileName: 'Radiology_Report_Oct_2023.pdf',
            fileSize: '4.2 MB',
            progress: _progress,
            remainingSeconds: _remaining,
            onCancel: widget.onCancelUpload,
          ),
          const SizedBox(height: AppSpacing.md),
          UfSectionHeader(
            label: AppStrings.ufRecentUploadsLabel,
            actionLabel: AppStrings.ufViewAll,
            onAction: widget.onViewAll,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildRecentUploads(),
          const SizedBox(height: AppSpacing.md),
          const UfSecurityCard(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildRecentUploads() {
    return Column(
      children: [
        const UfRecentUploadItem(
          icon: Icons.picture_as_pdf_rounded,
          iconColor: Color(0xFF4EDEA3),
          fileName: 'Blood Test Results.pdf',
          subtitle: 'منذ ساعتين • 1.1 MB',
        ),
        const SizedBox(height: AppSpacing.sm),
        const UfRecentUploadItem(
          icon: Icons.image_rounded,
          iconColor: Color(0xFF45DFA4),
          fileName: 'Prescription_Dr_Smith.jpg',
          subtitle: 'أمس • 840 KB',
        ),
        const SizedBox(height: AppSpacing.sm),
        const UfRecentUploadItem(
          icon: Icons.science_rounded,
          iconColor: Color(0xFF4EDEA3),
          fileName: 'Genomic_Data_Profile.json',
          subtitle: '3 أكتوبر • 15.4 MB',
          opacity: 0.8,
        ),
      ],
    );
  }
}
