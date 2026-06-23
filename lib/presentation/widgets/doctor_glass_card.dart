import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class DoctorGlassCard extends StatefulWidget {
  final DoctorEntity doctor;
  final Duration animDelay;
  final VoidCallback? onBook;
  final VoidCallback? onMore;
  final VoidCallback? onSupervisionRequest;
  final bool showMore;
  final bool showSupervision;

  const DoctorGlassCard({
    super.key,
    required this.doctor,
    this.animDelay = Duration.zero,
    this.onBook,
    this.onMore,
    this.onSupervisionRequest,
    this.showMore = true,
    this.showSupervision = false,
  });

  @override
  State<DoctorGlassCard> createState() => _DoctorGlassCardState();
}

class _DoctorGlassCardState extends State<DoctorGlassCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _entranceCtrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;
  late AnimationController _supervisionCtrl;
  late Animation<double> _supervisionScale;
  late Animation<double> _supervisionFade;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _opacity = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic));

    _supervisionCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _supervisionScale = CurvedAnimation(parent: _supervisionCtrl, curve: Curves.elasticOut);
    _supervisionFade = CurvedAnimation(parent: _supervisionCtrl, curve: Curves.easeOut);

    Future.delayed(widget.animDelay, () {
      if (mounted) _entranceCtrl.forward();
    });
    Future.delayed(widget.animDelay + const Duration(milliseconds: 300), () {
      if (mounted && widget.showSupervision) _supervisionCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _supervisionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTapUp: (_) {
              Navigator.pushNamed(context, AppRoutes.doctorProfile, arguments: widget.doctor.id);
            },
            child: AnimatedScale(
              scale: _isHovered ? 1.015 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: _isHovered
                      ? [BoxShadow(
                          color: AppColors.of(context).primary.withValues(alpha: 0.12),
                          blurRadius: 24,
                          spreadRadius: 2,
                        )]
                      : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colors.surfaceDark.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                          _buildLocation(),
                          const SizedBox(height: AppSpacing.six),
                          _buildBio(),
                          const SizedBox(height: 14),
                          _buildActions(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final colors = AppColors.of(context);
    final doctor = widget.doctor;

    return Row(
      children: [
        _buildAvatar(),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star_rounded, size: 18, color: colors.secondary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    doctor.rating?.toStringAsFixed(1) ?? '0.0',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: colors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'د. ${doctor.name}',
                style: TextStyle(
                  fontSize: AppSpacing.titleMedium,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  letterSpacing: -0.01,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                doctor.specialty,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    final doctor = widget.doctor;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: doctor.imageUrl != null
              ? Image.network(
                  doctor.imageUrl!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _buildAvatarFallback(),
                )
              : _buildAvatarFallback(),
        ),
        if (doctor.isAvailable)
          Positioned(
            top: -3,
            left: -3,
            child: _PulsingDot(),
          ),
      ],
    );
  }

  Widget _buildAvatarFallback() {
    final colors = AppColors.of(context);
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primaryDark, colors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(Icons.person_rounded, size: 36, color: colors.primary),
    );
  }

  Widget _buildLocation() {
    final colors = AppColors.of(context);
    final doctor = widget.doctor;

    return Row(
      children: [
        Icon(Icons.location_on_rounded, size: 18, color: colors.textLight),
        const SizedBox(width: AppSpacing.six),
        Expanded(
          child: Text(
            doctor.clinicAddress ?? doctor.clinicName ?? '',
            style: TextStyle(fontSize: AppSpacing.bodyMedium, color: colors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBio() {
    final colors = AppColors.of(context);

    if (widget.doctor.bio == null || widget.doctor.bio!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      widget.doctor.bio!,
      style: TextStyle(
        fontSize: AppSpacing.bodyMedium,
        height: 1.65,
        color: colors.textSecondary.withValues(alpha: 0.75),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildActions() {
    final colors = AppColors.of(context);
    final status = widget.doctor.supervisionRequestStatus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTapDown: (_) {},
                onTapUp: (_) => widget.onBook?.call(),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: colors.primaryDark,
                    borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primaryDark.withValues(alpha: 0.35),
                        blurRadius: 14,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    AppStrings.sdBookAppointment,
                    style: TextStyle(
                      fontSize: AppSpacing.bodyLarge,
                      fontWeight: FontWeight.w700,
                      color: colors.primaryLight,
                    ),
                  ),
                ),
              ),
            ),
            if (widget.showMore) ...[
              const SizedBox(width: AppSpacing.ten),
              GestureDetector(
                onTap: widget.onMore,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colors.cardBg.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Icon(Icons.more_vert, color: colors.textPrimary),
                ),
              ),
            ],
          ],
        ),
        if (widget.showSupervision) ...[
          const SizedBox(height: AppSpacing.ten),
          FadeTransition(
            opacity: _supervisionFade,
            child: ScaleTransition(
              scale: _supervisionScale,
              child: _buildSupervisionButton(colors, status),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSupervisionButton(AppColorSet colors, String? status) {
    final bool hasActiveRequest = status == 'approved';
    final bool hasPendingRequest = status == 'pending';
    final bool hasRejectedRequest = status == 'rejected';
    final bool hasCancelledRequest = status == 'cancelled';

    Color bgColor;
    String label;
    VoidCallback? onTap;

    if (hasActiveRequest) {
      bgColor = colors.primary.withValues(alpha: 0.15);
      label = AppStrings.supervisingYou;
      onTap = null;
    } else if (hasPendingRequest) {
      bgColor = Colors.amber.withValues(alpha: 0.15);
      label = AppStrings.supervisionPending;
      onTap = null;
    } else if (hasRejectedRequest) {
      bgColor = colors.error.withValues(alpha: 0.1);
      label = AppStrings.requestAgain;
      onTap = widget.onSupervisionRequest;
    } else if (hasCancelledRequest) {
      bgColor = colors.textSecondary.withValues(alpha: 0.1);
      label = AppStrings.requestSupervision;
      onTap = widget.onSupervisionRequest;
    } else {
      bgColor = colors.secondary.withValues(alpha: 0.15);
      label = AppStrings.requestSupervision;
      onTap = widget.onSupervisionRequest;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 42,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          border: Border.all(
            color: hasActiveRequest
                ? colors.primary.withValues(alpha: 0.3)
                : hasPendingRequest
                    ? Colors.amber.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.06),
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasActiveRequest
                  ? Icons.shield_rounded
                  : hasPendingRequest
                      ? Icons.hourglass_top_rounded
                      : Icons.person_add_alt_1_rounded,
              size: 16,
              color: hasActiveRequest
                  ? colors.primary
                  : hasPendingRequest
                      ? Colors.amber.shade300
                      : colors.textPrimary,
            ),
            const SizedBox(width: AppSpacing.six),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: hasActiveRequest
                    ? colors.primary
                    : hasPendingRequest
                        ? Colors.amber.shade300
                        : colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _opacityAnim = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.3).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.3, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_ctrl);
    _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return FadeTransition(
      opacity: _opacityAnim,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: colors.secondary,
          shape: BoxShape.circle,
          border: Border.all(color: colors.scaffoldBg, width: 2),
          boxShadow: [
            BoxShadow(
              color: colors.secondary.withValues(alpha: 0.5),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}

