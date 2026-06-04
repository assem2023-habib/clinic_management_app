import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/presentation/widgets/appointments/status_badge.dart';

class AppointmentCard extends StatefulWidget {
  final AppointmentEntity appointment;
  final bool isFeatured;
  final bool isPast;
  final VoidCallback? onMoreTap;
  final VoidCallback? onTap;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.isFeatured = false,
    this.isPast = false,
    this.onMoreTap,
    this.onTap,
  });

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> with SingleTickerProviderStateMixin {
  bool _hov = false;
  late AnimationController _entrCtrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _entrCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));
    _opacity = CurvedAnimation(parent: _entrCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entrCtrl, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 120), () => mounted ? _entrCtrl.forward() : null);
  }

  @override
  void dispose() { _entrCtrl.dispose(); super.dispose(); }

  BoxDecoration _decoration(AppColorSet c) {
    if (widget.isPast) {
      return BoxDecoration(
        color: c.background.withValues(alpha: 0.35),
        borderRadius: const BorderRadius.all(Radius.circular(AppSpacing.cardRadius)),
      );
    }
    if (widget.isFeatured) {
      return BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(AppSpacing.cardRadius)),
        gradient: RadialGradient(
          colors: [c.primaryDark.withValues(alpha: 0.25), c.surface.withValues(alpha: 0.5)],
        ),
        border: Border.all(color: c.primary.withValues(alpha: 0.22)),
        boxShadow: [BoxShadow(color: c.primary.withValues(alpha: 0.12), blurRadius: 20, spreadRadius: -4)],
      );
    }
    return BoxDecoration(
      color: c.cardBg.withValues(alpha: 0.42),
      borderRadius: const BorderRadius.all(Radius.circular(AppSpacing.cardRadius)),
      border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      boxShadow: _hov ? [BoxShadow(color: c.primaryDark.withValues(alpha: 0.2), blurRadius: 36)] : [],
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final apt = widget.appointment;
    final docName = apt.doctorName ?? apt.doctor?.name ?? '';
    final specialty = apt.doctor?.specialty ?? '';

    return FadeTransition(opacity: _opacity,
      child: SlideTransition(position: _slide,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hov = true),
          onExit: (_) => setState(() => _hov = false),
          child: AnimatedScale(
            scale: widget.isPast ? 1.0 : (_hov ? 1.015 : 1.0),
            duration: const Duration(milliseconds: 250),
            child: Opacity(
              opacity: widget.isPast ? 0.72 : 1.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    decoration: _decoration(c),
                    padding: AppSpacing.cardPadding,
                    child: Column(children: [
                      _buildTop(c, docName, specialty),
                      Divider(height: AppSpacing.lg, color: c.divider.withValues(alpha: 0.09), thickness: 1),
                      _buildBottom(c),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTop(AppColorSet c, String docName, String specialty) {
    final apt = widget.appointment;
    final doc = apt.doctor;
    final imgUrl = doc?.imageUrl;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(children: [
            Container(
              width: AppSpacing.avatarSize, height: AppSpacing.avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.surface,
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              clipBehavior: Clip.antiAlias,
              child: imgUrl != null
                  ? Image.network(imgUrl, fit: BoxFit.cover)
                  : Icon(Icons.person_rounded, color: c.textSecondary, size: AppSpacing.iconSize),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(docName,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: c.textPrimary)),
                const SizedBox(height: 3),
                Text(specialty,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: c.textSecondary)),
              ]),
            ),
          ]),
        ),
        StatusBadge(apt.status),
      ],
    );
  }

  Widget _buildBottom(AppColorSet c) {
    final apt = widget.appointment;
    final timeStr = apt.timeSlot ?? (apt.startTime != null && apt.endTime != null ? '${apt.startTime} - ${apt.endTime}' : '--:--');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.schedule, color: c.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(AppStrings.time, style: TextStyle(fontSize: 11, color: c.textSecondary)),
            const SizedBox(height: 2),
            Text(timeStr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: c.textPrimary)),
          ]),
        ]),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onMoreTap,
            borderRadius: BorderRadius.circular(19),
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Icon(Icons.more_vert, color: c.textSecondary, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}
