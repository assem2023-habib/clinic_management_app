import 'dart:async';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/widgets/state_screen/state_screen.dart';

class RateLimitScreen extends StatefulWidget {
  final int? retryAfterSeconds;

  const RateLimitScreen({super.key, this.retryAfterSeconds});

  @override
  State<RateLimitScreen> createState() => _RateLimitScreenState();
}

class _RateLimitScreenState extends State<RateLimitScreen> {
  int? _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.retryAfterSeconds != null && widget.retryAfterSeconds! > 0) {
      _remaining = widget.retryAfterSeconds;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_remaining != null && _remaining! > 0) {
          setState(() => _remaining = _remaining! - 1);
        } else {
          _timer?.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    Widget? timerWidget;
    if (_remaining != null && _remaining! > 0) {
      timerWidget = Column(
        children: [
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: colors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.warning.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_rounded, size: 20, color: colors.warning),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${AppStrings.rlWaitPrefix} ${_formatDuration(_remaining!)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.warning),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return StateScreen(
      showAppBar: true,
      appBarTitle: AppStrings.appName,
      icon: Icons.timer_off_rounded,
      title: AppStrings.rlTitle,
      message: AppStrings.rlMessage,
      primaryAction: StateAction(
        label: AppStrings.rlRetry,
        icon: Icons.refresh_rounded,
        onTap: _remaining == null || _remaining! <= 0 ? () {} : null,
        isPrimary: _remaining == null || _remaining! <= 0,
      ),
      secondaryAction: StateAction(
        label: AppStrings.rlGoHome,
        isPrimary: false,
        onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard),
      ),
      statusChips: const [
        StatusChip(icon: Icons.warning_rounded, label: AppStrings.rlTooManyRequests),
        StatusChip(icon: Icons.shield_rounded, label: AppStrings.rlRateLimited),
      ],
      bottomWidget: timerWidget,
    );
  }
}
