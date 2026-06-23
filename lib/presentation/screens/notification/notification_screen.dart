import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/domain/entities/notification_entity.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_event.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_state.dart';
import 'package:clinic_management_app/presentation/screens/notification_failure/widgets/nf_actions.dart';
import 'package:clinic_management_app/presentation/screens/notification_failure/widgets/nf_content_card.dart';
import 'package:clinic_management_app/presentation/screens/notification_failure/widgets/nf_icon_section.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(const NotificationLoadAll());
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return AppShell(
      currentRoute: AppRoutes.notifications,
      useGlassAppBar: true,
      glassTitle: AppStrings.ntTitle,
      showParticleBg: true,
      glassActions: [
        GestureDetector(
          onTap: () => context.read<NotificationBloc>().add(const NotificationMarkAllRead()),
          child: Icon(Icons.done_all_rounded, color: colors.primary, size: AppSpacing.iconMedium),
        ),
      ],
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NotificationLoaded) {
            return _buildContent(context, colors, state);
          }
          if (state is NotificationError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const NfIconSection(),
                    const SizedBox(height: 32),
                    NfContentCard(
                      title: 'فَشِلَ إِرْسَالُ الإِشْعَارِ',
                      message: state.message,
                    ),
                    const SizedBox(height: 32),
                    NfActions(
                      onRetry: () => context.read<NotificationBloc>().add(const NotificationLoadAll()),
                      onBack: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppColorSet colors, NotificationLoaded state) {
    return Column(
      children: [
        _buildFilterChips(context, colors, state),
        Expanded(
          child: state.notifications.isEmpty
              ? _buildEmptyState(colors)
              : _buildNotificationList(context, colors, state),
        ),
      ],
    );
  }

  Widget _buildFilterChips(BuildContext context, AppColorSet colors, NotificationLoaded state) {
    final categories = [
      ('all', AppStrings.ntCategoryAll),
      ('unread', AppStrings.ntCategoryUnread),
      ('medical', AppStrings.ntCategoryMedical),
      ('appointment', AppStrings.ntCategoryAppointment),
      ('system', AppStrings.ntCategorySystem),
    ];

    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final isActive = state.activeCategory == categories[index].$1;
          return _buildChip(
            colors, categories[index].$2, isActive,
            () => context.read<NotificationBloc>().add(NotificationFilterCategory(categories[index].$1)),
            count: categories[index].$1 == 'unread' ? state.unreadCount : null,
          );
        },
      ),
    );
  }

  Widget _buildChip(AppColorSet colors, String label, bool isActive, VoidCallback onTap, {int? count}) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: isActive ? colors.neonGreen.withValues(alpha: 0.15) : colors.cardBg,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: isActive ? colors.neonGreen.withValues(alpha: 0.5) : colors.divider.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: TextStyle(fontSize: AppSpacing.bodyMedium, fontWeight: FontWeight.w600, color: isActive ? colors.neonGreen : colors.textSecondary)),
              if (count != null && count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: colors.neonGreen.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(9999)),
                  child: Text('$count', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: colors.neonGreen)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationList(BuildContext context, AppColorSet colors, NotificationLoaded state) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      itemCount: state.notifications.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final notification = state.notifications[index];
        return _AnimatedNotificationCard(
          notification: notification,
          onDelete: () => context.read<NotificationBloc>().add(NotificationDelete(notification.id)),
        );
      },
    );
  }

  Widget _buildEmptyState(AppColorSet colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withValues(alpha: 0.08),
              ),
              child: Icon(Icons.notifications_none_rounded, size: 40, color: colors.primary.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(AppStrings.ntEmptyTitle, style: TextStyle(fontSize: AppSpacing.titleMedium, fontWeight: FontWeight.w600, color: colors.textPrimary)),
            const SizedBox(height: AppSpacing.sm),
            Text(AppStrings.ntEmptyHint, style: TextStyle(fontSize: AppSpacing.bodyMedium, color: colors.textSecondary), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _AnimatedNotificationCard extends StatefulWidget {
  final NotificationEntity notification;
  final VoidCallback onDelete;

  const _AnimatedNotificationCard({required this.notification, required this.onDelete});

  @override
  State<_AnimatedNotificationCard> createState() => _AnimatedNotificationCardState();
}

class _AnimatedNotificationCardState extends State<_AnimatedNotificationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _dotScale;
  late Animation<double> _dotFade;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _dotScale = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut),
    );
    _dotFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_isAnimating || widget.notification.isRead) return;
    setState(() => _isAnimating = true);
    _animCtrl.forward().then((_) {
      if (mounted) {
        context.read<NotificationBloc>().add(NotificationMarkRead(widget.notification.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final typeData = _typeData(widget.notification.type);
    final isRead = widget.notification.isRead || _isAnimating;

    return Dismissible(
      key: Key(widget.notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.red),
      ),
      onDismissed: (_) => widget.onDelete(),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isRead ? colors.surface.withValues(alpha: 0.5) : colors.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isRead ? colors.divider.withValues(alpha: 0.05) : colors.divider.withValues(alpha: 0.12)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: typeData.color.withValues(alpha: 0.15),
                    ),
                    child: Icon(typeData.icon, size: AppSpacing.iconMedium, color: typeData.color),
                  ),
                  if (!widget.notification.isRead)
                    Positioned(
                      top: 0, right: 0,
                      child: FadeTransition(
                        opacity: _dotFade,
                        child: ScaleTransition(
                          scale: _dotScale,
                          child: Container(
                            width: 10, height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.neonGreen,
                              boxShadow: [BoxShadow(color: colors.neonGreen, blurRadius: 6)],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(widget.notification.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: colors.textPrimary)),
                    const SizedBox(height: 4),
                    Text(widget.notification.message, style: TextStyle(fontSize: 13, color: colors.textSecondary, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text(_formatTimestamp(widget.notification.timestamp), style: TextStyle(fontSize: 11, color: colors.textLight.withValues(alpha: 0.5))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ({IconData icon, Color color}) _typeData(NotificationType type) {
    final colors = AppColors.of(context);
    switch (type) {
      case NotificationType.appointment:
        return (icon: Icons.calendar_today_rounded, color: colors.neonGreen);
      case NotificationType.medical:
        return (icon: Icons.medical_services_rounded, color: colors.sage);
      case NotificationType.system:
        return (icon: Icons.settings_rounded, color: colors.iconGray);
    }
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return AppStrings.ntJustNow;
    if (diff.inMinutes < 60) return AppStrings.ntMinutesAgo;
    if (diff.inHours == 1) return AppStrings.ntHourAgo;
    if (diff.inHours < 6) return AppStrings.ntHoursAgo;
    if (diff.inDays < 1) return AppStrings.ntHoursAgoPlural;
    return '${diff.inDays} ${AppStrings.ntDaysAgo}';
  }
}
