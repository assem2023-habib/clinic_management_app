import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/time_slot_entity.dart';
import 'package:clinic_management_app/presentation/widgets/empty_data/empty_data_widget.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class ProfileScheduleSection extends StatelessWidget {
  final List<TimeSlotEntity> slots;
  final bool canManage;
  final void Function(String slotId)? onToggleSlot;
  final void Function(TimeSlotEntity slot)? onSelectSlot;

  const ProfileScheduleSection({
    super.key,
    required this.slots,
    this.canManage = false,
    this.onToggleSlot,
    this.onSelectSlot,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final morningSlots = slots.where((s) {
      final hour = int.tryParse(s.time.split(':').first) ?? 0;
      return hour < 12;
    }).toList();
    final eveningSlots = slots.where((s) {
      final hour = int.tryParse(s.time.split(':').first) ?? 0;
      return hour >= 12;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.availableAppts, style: TextStyle(fontSize: AppSpacing.titleMedium, fontWeight: FontWeight.w600, color: colors.textPrimary)),
            if (canManage)
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.edit_calendar_rounded, size: 18, color: colors.primary),
                label: Text(AppStrings.manageSchedule, style: TextStyle(color: colors.primary)),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (morningSlots.isNotEmpty) ...[
          Text(AppStrings.bookingMorning, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: colors.textSecondary)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: morningSlots.map((slot) => GestureDetector(
              onTap: () {
                if (canManage) {
                  onToggleSlot?.call(slot.id);
                } else if (slot.isAvailable) {
                  onSelectSlot?.call(slot);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: slot.isAvailable
                      ? (canManage ? colors.cardBg : colors.primary.withValues(alpha: 0.1))
                      : colors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: slot.isAvailable
                        ? (canManage ? colors.divider : colors.primary)
                        : colors.divider.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  slot.time,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: slot.isAvailable
                        ? (canManage ? colors.textPrimary : colors.primary)
                        : colors.textLight,
                    decoration: !slot.isAvailable && canManage
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              ),
            )).toList(),
          ),
        ],
        if (eveningSlots.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(AppStrings.bookingEvening, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: colors.textSecondary)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: eveningSlots.map((slot) => GestureDetector(
              onTap: () {
                if (canManage) {
                  onToggleSlot?.call(slot.id);
                } else if (slot.isAvailable) {
                  onSelectSlot?.call(slot);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: slot.isAvailable
                      ? (canManage ? colors.cardBg : colors.primary.withValues(alpha: 0.1))
                      : colors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: slot.isAvailable
                        ? (canManage ? colors.divider : colors.primary)
                        : colors.divider.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  slot.time,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: slot.isAvailable
                        ? (canManage ? colors.textPrimary : colors.primary)
                        : colors.textLight,
                    decoration: !slot.isAvailable && canManage
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              ),
            )).toList(),
          ),
        ],
        if (slots.isEmpty)
           EmptyDataWidget(icon: Icons.event_available_rounded, title: AppStrings.noAvailableSlots, compact: true),
      ],
    );
  }
}

