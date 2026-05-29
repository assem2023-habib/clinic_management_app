import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/notification_entity.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_event.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_state.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';

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

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, colors),
            Expanded(
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: SkeletonList(count: 6),
                    );
                  }
                  if (state is NotificationLoaded) {
                    return _buildContent(context, colors, state);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppColorSet colors) {
    return Container(
      width: double.infinity,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.7),
        border: Border(bottom: BorderSide(color: colors.divider.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40, height: 40, alignment: Alignment.center,
                child: Icon(Icons.arrow_back_rounded, color: colors.textPrimary, size: 24),
              ),
            ),
          ),
          const Spacer(),
          Text(
            AppStrings.ntTitle,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.textPrimary),
          ),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => context.read<NotificationBloc>().add(const NotificationMarkAllRead()),
              child: Container(
                width: 40, height: 40, alignment: Alignment.center,
                child: Icon(Icons.done_all_rounded, color: colors.primary, size: 22),
              ),
            ),
          ),
        ],
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
            color: isActive ? const Color(0xFF00FF85).withValues(alpha: 0.15) : colors.cardBg,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: isActive ? const Color(0xFF00FF85).withValues(alpha: 0.5) : colors.divider.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isActive ? const Color(0xFF00FF85) : colors.textSecondary)),
              if (count != null && count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFF00FF85).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(9999)),
                  child: Text('$count', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF00FF85))),
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
        return _NotificationCard(
          notification: notification,
          onTap: () => context.read<NotificationBloc>().add(NotificationMarkRead(notification.id)),
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
            Text(AppStrings.ntEmptyTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textPrimary)),
            const SizedBox(height: AppSpacing.sm),
            Text(AppStrings.ntEmptyHint, style: TextStyle(fontSize: 14, color: colors.textSecondary), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationCard({required this.notification, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final typeData = _typeData(notification.type);

    return Dismissible(
      key: Key(notification.id),
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
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: notification.isRead ? colors.surface.withValues(alpha: 0.5) : colors.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: notification.isRead ? colors.divider.withValues(alpha: 0.05) : colors.divider.withValues(alpha: 0.12)),
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
                    child: Icon(typeData.icon, size: 22, color: typeData.color),
                  ),
                  if (!notification.isRead)
                    Positioned(
                      top: 0, right: 0,
                      child: Container(
                        width: 10, height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF00FF85),
                          boxShadow: [BoxShadow(color: Color(0xFF00FF85), blurRadius: 6)],
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
                    Text(notification.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: colors.textPrimary)),
                    const SizedBox(height: 4),
                    Text(notification.message, style: TextStyle(fontSize: 13, color: colors.textSecondary, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text(_formatTimestamp(notification.timestamp), style: TextStyle(fontSize: 11, color: colors.textLight.withValues(alpha: 0.5))),
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
    switch (type) {
      case NotificationType.appointment:
        return (icon: Icons.calendar_today_rounded, color: const Color(0xFF00FF85));
      case NotificationType.medical:
        return (icon: Icons.medical_services_rounded, color: const Color(0xFFABCFB6));
      case NotificationType.system:
        return (icon: Icons.settings_rounded, color: const Color(0xFF8C928C));
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
