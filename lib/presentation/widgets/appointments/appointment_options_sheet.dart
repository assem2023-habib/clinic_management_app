import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/presentation/widgets/appointments/time_slot_grid.dart';
import 'package:clinic_management_app/core/constants/app_icons.dart';

class AppointmentOptionsSheet extends StatelessWidget {
  final AppointmentEntity appointment;
  const AppointmentOptionsSheet({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final docName = appointment.doctorName ?? appointment.doctor?.name ?? '';
    final doc = appointment.doctor;
    final imgUrl = doc?.imageUrl;

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Center(child: Container(
          margin: const EdgeInsets.symmetric(vertical: 14),
          width: 44, height: 5,
          decoration: BoxDecoration(
            color: c.textLight.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(999),
          ),
        )),
        Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.cardBg,
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            clipBehavior: Clip.antiAlias,
            child: imgUrl != null
                ? Image.network(imgUrl, fit: BoxFit.cover)
                : Icon(AppIcons.person, color: c.textSecondary),
          ),
          const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('الخيارات المتاحة لـ', style: TextStyle(fontSize: AppSpacing.labelSmall, color: c.textSecondary)),
            Text(docName, style: TextStyle(fontSize: AppSpacing.bodyLarge, fontWeight: FontWeight.w700, color: c.textPrimary)),
          ]),
        ]),
        const SizedBox(height: AppSpacing.md),
        _SheetOption(
          icon: AppIcons.editCalendarOutline,
          label: 'تعديل الموعد',
          colors: c,
          onTap: () { Navigator.pop(context); _openReschedule(context); },
        ),
        _SheetOption(
          icon: AppIcons.notificationsOutline,
          label: 'تفعيل التذكير',
          colors: c,
          onTap: () => Navigator.pop(context),
        ),
        _SheetOption(
          icon: AppIcons.info,
          label: 'تفاصيل الموعد',
          colors: c,
          onTap: () => Navigator.pop(context),
        ),
        _SheetOption(
          icon: AppIcons.eventBusy,
          label: 'إلغاء الموعد',
          isDestructive: true,
          colors: c,
          onTap: () { Navigator.pop(context); _confirmCancel(context); },
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(width: double.infinity,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: c.surface,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.md - AppSpacing.xxs)),
            ),
            child: Text(AppStrings.cancel, style: TextStyle(fontSize: AppSpacing.bodyMedium, fontWeight: FontWeight.w700, color: c.textSecondary)),
          ),
        ),
      ]),
    );
  }

  void _openReschedule(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const TimeSlotGrid(),
    );
  }

  void _confirmCancel(BuildContext context) {
    final c = AppColors.of(context);
    showDialog(
      context: context,
      barrierColor: c.scaffoldBg.withValues(alpha: 0.85),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: _CancelDialog(appointment: appointment),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  final AppColorSet colors;
  const _SheetOption({
    required this.icon, required this.label, required this.onTap,
    this.isDestructive = false, required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSpacing.md - AppSpacing.xxs),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + AppSpacing.xs, vertical: AppSpacing.md - AppSpacing.xxs),
              child: Row(children: [
                Icon(icon, size: AppSpacing.iconMedium, color: isDestructive ? colors.error : colors.textSecondary),
                const SizedBox(width: 14),
                Text(label,
                  style: TextStyle(
                    fontSize: AppSpacing.subtitle, fontWeight: FontWeight.w500,
                    color: isDestructive ? colors.error : colors.textPrimary,
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _CancelDialog extends StatelessWidget {
  final AppointmentEntity appointment;
  const _CancelDialog({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final docName = appointment.doctorName ?? appointment.doctor?.name ?? '';
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) => Transform.scale(
        scale: scale,
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 20),
          decoration: BoxDecoration(
            color: c.surface,
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(AppSpacing.lg),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: c.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.md),
                border: Border.all(color: c.error.withValues(alpha: 0.22)),
              ),
              child: Icon(AppIcons.eventBusy, color: c.error, size: 28),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('إلغاء الموعد؟', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: c.textPrimary)),
            const SizedBox(height: AppSpacing.sm),
            Text('هل تريد إلغاء موعد\n$docName؟\nلا يمكن التراجع عن هذا الإجراء.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: AppSpacing.caption, color: c.textSecondary, height: 1.7),
            ),
            const SizedBox(height: 22),
            Row(children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: c.cardBg,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                  ),
                  child: Text('رجوع', style: TextStyle(fontSize: AppSpacing.bodyMedium, fontWeight: FontWeight.w700, color: c.textSecondary)),
                ),
              ),
              const SizedBox(width: AppSpacing.ten),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم إلغاء موعد $docName'),
                        backgroundColor: c.surface,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: c.error.withValues(alpha: 0.12),
                    side: BorderSide(color: c.error.withValues(alpha: 0.25)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                  ),
                  child: Text('إلغاء الموعد', style: TextStyle(fontSize: AppSpacing.bodyMedium, fontWeight: FontWeight.w700, color: c.error)),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
