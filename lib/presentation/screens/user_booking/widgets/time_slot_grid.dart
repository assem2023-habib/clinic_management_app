import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/time_slot_entity.dart';
import 'package:clinic_management_app/presentation/widgets/empty_data/empty_data_widget.dart';

class TimeSlotGrid extends StatelessWidget {
  final List<TimeSlotEntity> slots;
  final String? selectedSlotId;
  final ValueChanged<String> onSelectSlot;

  const TimeSlotGrid({
    super.key,
    required this.slots,
    this.selectedSlotId,
    required this.onSelectSlot,
  });

  @override
  Widget build(BuildContext context) {
    final morningSlots = slots.where((s) {
      final hour = int.tryParse(s.time.split(':').first) ?? 0;
      return hour < 12;
    }).toList();

    final eveningSlots = slots.where((s) {
      final hour = int.tryParse(s.time.split(':').first) ?? 0;
      return hour >= 12;
    }).toList();

    return Column(
      children: [
        if (morningSlots.isNotEmpty) ...[
          _buildPeriodHeader(context, Icons.wb_sunny_rounded, AppStrings.bookingMorning),
          const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
          _buildSlotGrid(context, morningSlots),
        ],
        if (eveningSlots.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          _buildPeriodHeader(context, Icons.nights_stay_rounded, AppStrings.bookingEvening),
          const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
          _buildSlotGrid(context, eveningSlots),
        ],
        if (slots.isEmpty)
           EmptyDataWidget(icon: Icons.schedule_rounded, title: AppStrings.bookingNoSlots, compact: true),
      ],
    );
  }

  Widget _buildPeriodHeader(BuildContext context, IconData icon, String title) {
    final colors = AppColors.of(context);
    return Row(
      children: [
        Icon(icon, color: colors.primary, size: 18),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: TextStyle(
            fontSize: AppSpacing.caption,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSlotGrid(BuildContext context, List<TimeSlotEntity> slots) {
    final colors = AppColors.of(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3.2,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final isSelected = slot.id == selectedSlotId;
        final isBooked = !slot.isAvailable;

        return GestureDetector(
          onTap: isBooked ? null : () => onSelectSlot(slot.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.primaryDark
                  : colors.cardBg,
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              border: Border.all(
                color: isSelected
                    ? colors.primary
                    : isBooked
                        ? colors.divider.withValues(alpha: 0.1)
                        : colors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 18,
                  color: isSelected
                      ? Colors.white
                      : isBooked
                          ? colors.textLight
                          : colors.primary,
                ),
                const SizedBox(width: AppSpacing.six),
                Expanded(
                  child: Text(
                    _formatTime(slot.time),
                    style: TextStyle(
                      fontSize: AppSpacing.caption,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : isBooked
                              ? colors.textLight
                              : colors.textPrimary,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, size: 18, color: Colors.white)
                else if (isBooked)
                  Icon(Icons.lock_rounded, size: AppSpacing.md, color: colors.textLight)
                else
                  Text(
                    AppStrings.bookingAvailable,
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.primary,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return time;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    if (hour < 12) {
      return '$hour:$minute ${AppStrings.am}';
    } else if (hour == 12) {
      return '12:$minute ${AppStrings.pm}';
    } else {
      return '${hour - 12}:$minute ${AppStrings.pm}';
    }
  }
}
