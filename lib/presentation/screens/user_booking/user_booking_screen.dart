import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/user_booking/user_booking_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/user_booking/user_booking_event.dart';
import 'package:clinic_management_app/presentation/blocs/user_booking/user_booking_state.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';
import 'package:clinic_management_app/presentation/screens/appointment_confirmation/confirmation_data.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/widgets/glass_card.dart';

class UserBookingScreen extends StatefulWidget {
  final String doctorId;
  const UserBookingScreen({super.key, required this.doctorId});

  @override
  State<UserBookingScreen> createState() => _UserBookingScreenState();
}

class _UserBookingScreenState extends State<UserBookingScreen>
    with TickerProviderStateMixin {

  late AnimationController _headerFadeController;
  late AnimationController _confirmBtnController;
  late AnimationController _slotListController;
  late Animation<double> _headerFade;
  late Animation<double> _confirmScale;
  late Animation<double> _slotFade;
  late Animation<Offset> _slotSlide;

  @override
  void initState() {
    super.initState();
    _headerFadeController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 600),
    )..forward();
    _headerFade = CurvedAnimation(parent: _headerFadeController, curve: Curves.easeOut);

    _confirmBtnController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 150),
    );
    _confirmScale = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _confirmBtnController, curve: Curves.easeInOut));

    _slotListController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400),
    )..forward();
    _slotFade = CurvedAnimation(parent: _slotListController, curve: Curves.easeOut);
    _slotSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slotListController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _headerFadeController.dispose();
    _confirmBtnController.dispose();
    _slotListController.dispose();
    super.dispose();
  }

  void _restartSlotAnimation() {
    _slotListController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final role = context.watch<AuthCubit>().state.role;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => UserBookingBloc(
          doctorRepository: RepositoryProvider.of<DoctorRepository>(context),
          appointmentRepository: RepositoryProvider.of<AppointmentRepository>(context),
        )..add(UserBookingLoad(widget.doctorId)),
        child: Scaffold(
          backgroundColor: colors.background,
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(colors),
          body: role != UserRole.patient
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline_rounded, size: 64, color: colors.textLight),
                      const SizedBox(height: 16),
                      Text(AppStrings.bookingPatientOnly, style: TextStyle(color: colors.textSecondary)),
                    ],
                  ),
                )
              : BlocConsumer<UserBookingBloc, UserBookingState>(
                  listener: (context, state) {
                    if (state is UserBookingConfirmed) {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.appointmentConfirmation,
                        arguments: ConfirmationData(
                          appointmentId: state.appointmentId,
                          doctor: state.doctor,
                          date: state.date,
                          timeSlot: state.timeSlot,
                          patientName: state.patientName,
                        ),
                      );
                    }
                    if (state is UserBookingError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is UserBookingLoading || state is UserBookingInitial) {
                      return const SkeletonList();
                    }
                    if (state is UserBookingLoaded) {
                      final patientId = context.read<AuthCubit>().state.userId ?? 'p1';
                      final selectedSlot = state.selectedSlotId != null
                          ? state.slots.where((s) => s.id == state.selectedSlotId).firstOrNull
                          : null;

                      return Stack(
                        children: [
                          SingleChildScrollView(
                            padding: const EdgeInsets.only(
                              top: 100, left: 16, right: 16, bottom: 120,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDateSection(colors, state),
                                const SizedBox(height: 32),
                                _buildDoctorCard(colors, state.doctor),
                                const SizedBox(height: 32),
                                SlideTransition(
                                  position: _slotSlide,
                                  child: FadeTransition(
                                    opacity: _slotFade,
                                    child: _buildSlotsSection(colors, state, context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildConfirmButton(colors, state, selectedSlot, patientId, context),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppColorSet colors) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: FadeTransition(
        opacity: _headerFade,
        child: ClipRect(
          child: Container(
            color: colors.surface.withValues(alpha: 0.7),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _GlassIconButton(
                      icon: Icons.arrow_forward,
                      onTap: () => Navigator.of(context).pop(),
                      colors: colors,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          AppStrings.bookingTitle,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: colors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection(AppColorSet colors, UserBookingLoaded state) {
    const arabicDays = ['الأحد','الاثنين','الثلاثاء','الأربعاء','الخميس','الجمعة','السبت'];
    const arabicNums = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
    String toArabic(int n) => n.toString().split('').map((c) => arabicNums[int.parse(c)]).join();

    const months = ['يناير','فبراير','مارس','أبريل','مايو','يونيو','يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر'];

    final selected = state.selectedDate;
    final dates = List.generate(7, (i) {
      final d = selected.add(Duration(days: i - 3));
      return (dayName: arabicDays[d.weekday % 7], dayNumber: toArabic(d.day), date: d);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${months[selected.month - 1]}، ${toArabic(selected.year)}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            _GlassIconButton(
              icon: Icons.calendar_month,
              onTap: () async {
                final bloc = context.read<UserBookingBloc>();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selected,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                );
                if (picked != null && mounted) {
                  bloc.add(UserBookingSelectDate(picked));
                }
              },
              colors: colors,
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) => _DateCard(
              dayName: dates[i].dayName,
              dayNumber: dates[i].dayNumber,
              isSelected: dates[i].date.day == selected.day && dates[i].date.month == selected.month,
              onTap: () {
                context.read<UserBookingBloc>().add(UserBookingSelectDate(dates[i].date));
                _restartSlotAnimation();
              },
              colors: colors,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorCard(AppColorSet colors, DoctorEntity doctor) {
    return GlassCard(
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: colors.chipBg,
                child: Icon(Icons.person, color: colors.chipText),
              ),
              Positioned(
                bottom: -4, left: -4,
                child: Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(
                    color: doctor.isAvailable ? colors.secondary : colors.textLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.surface, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.fullName.isNotEmpty ? 'د. ${doctor.fullName}' : '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.specialty,
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.verified, color: colors.primary, size: 24),
        ],
      ),
    );
  }

  Widget _buildSlotsSection(AppColorSet colors, UserBookingLoaded state, BuildContext context) {
    final morning = state.slots.where((s) {
      final hour = int.tryParse((s.time.split(':').firstOrNull ?? '0'));
      return hour != null && hour < 12;
    }).toList();
    final evening = state.slots.where((s) {
      final hour = int.tryParse((s.time.split(':').firstOrNull ?? '0'));
      return hour != null && hour >= 12;
    }).toList();

    return Column(
      children: [
        _buildSlotGrid(colors, 'الفترة الصباحية', Icons.light_mode, morning, state.selectedSlotId, context),
        const SizedBox(height: 32),
        _buildSlotGrid(colors, 'الفترة المسائية', Icons.dark_mode, evening, state.selectedSlotId, context),
      ],
    );
  }

  Widget _buildSlotGrid(AppColorSet colors, String title, IconData icon, List slots, String? selectedId, BuildContext context) {
    if (slots.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: title, icon: icon, colors: colors),
          const SizedBox(height: 16),
          Center(child: CircularProgressIndicator(color: colors.primary)),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: title, icon: icon, colors: colors),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.8,
          ),
          itemCount: slots.length,
          itemBuilder: (context, i) => _SlotCard(
            time: slots[i].time,
            isBooked: !slots[i].isAvailable,
            isSelected: slots[i].id == selectedId,
            onTap: () {
              context.read<UserBookingBloc>().add(UserBookingSelectSlot(slots[i].id));
            },
            colors: colors,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(AppColorSet colors, UserBookingLoaded state, selectedSlot, String patientId, BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              colors.background,
              colors.background.withValues(alpha: 0.0),
            ],
          ),
        ),
        padding: EdgeInsets.fromLTRB(16, 32, 16, MediaQuery.of(context).padding.bottom + 24),
        child: ScaleTransition(
          scale: _confirmScale,
          child: AnimatedOpacity(
            opacity: selectedSlot != null ? 1.0 : 0.5,
            duration: const Duration(milliseconds: 300),
            child: GestureDetector(
              onTapDown: (_) => _confirmBtnController.forward(),
              onTapUp: (_) {
                _confirmBtnController.reverse();
                if (selectedSlot != null) {
                  context.read<UserBookingBloc>().add(UserBookingConfirm(
                    patientId: patientId,
                    patientName: context.read<AuthCubit>().state.userName ?? AppStrings.bookingDefaultPatientName,
                    doctorId: widget.doctorId,
                    doctorEntity: state.doctor,
                    date: state.selectedDate,
                    timeSlot: selectedSlot.time,
                  ));
                }
              },
              onTapCancel: () => _confirmBtnController.reverse(),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: state is UserBookingBooking
                    ? Center(
                        child: SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(
                            color: colors.primaryDark,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'تأكيد الحجز',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: colors.primaryDark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.event_available, color: colors.primaryDark, size: 22),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  final String dayName;
  final String dayNumber;
  final bool isSelected;
  final VoidCallback onTap;
  final AppColorSet colors;

  const _DateCard({
    required this.dayName,
    required this.dayNumber,
    required this.isSelected,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 56,
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryDark : colors.cardBg.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors.primary : colors.divider.withValues(alpha: 0.08),
          ),
          boxShadow: isSelected
              ? [BoxShadow(
                  color: colors.primaryDark.withValues(alpha: 0.2),
                  blurRadius: 12,
                )]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? colors.chipText.withValues(alpha: 0.8)
                    : colors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dayNumber,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isSelected ? colors.chipText : colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlotCard extends StatefulWidget {
  final String time;
  final bool isBooked;
  final bool isSelected;
  final VoidCallback onTap;
  final AppColorSet colors;

  const _SlotCard({
    required this.time,
    required this.isBooked,
    required this.isSelected,
    required this.onTap,
    required this.colors,
  });

  @override
  State<_SlotCard> createState() => _SlotCardState();
}

class _SlotCardState extends State<_SlotCard>
    with SingleTickerProviderStateMixin {

  late AnimationController _tapController;
  late Animation<double> _tapScale;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _tapScale = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _tapController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isBooked ? null : (_) => _tapController.forward(),
      onTapUp: widget.isBooked ? null : (_) {
        _tapController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _tapController.reverse(),
      child: ScaleTransition(
        scale: _tapScale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.colors.primaryDark
                : widget.colors.cardBg.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? widget.colors.primary
                  : widget.colors.divider.withValues(alpha: 0.08),
              width: widget.isSelected ? 1.5 : 1.0,
            ),
            boxShadow: widget.isSelected
                ? [BoxShadow(
                    color: widget.colors.primaryDark.withValues(alpha: 0.3),
                    blurRadius: 12,
                  )]
                : [],
          ),
          child: Opacity(
            opacity: widget.isBooked ? 0.4 : 1.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 18,
                      color: widget.isSelected
                          ? widget.colors.chipText
                          : widget.colors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.time,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: widget.isSelected
                            ? widget.colors.chipText
                            : widget.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
                if (widget.isBooked)
                  Icon(Icons.lock, size: 16, color: widget.colors.textSecondary)
                else if (widget.isSelected)
                  Icon(Icons.check_circle, size: 16, color: widget.colors.chipText)
                else
                  Text(
                    'متاح',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: widget.colors.primary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final AppColorSet colors;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: colors.primary, size: 16),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final AppColorSet colors;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: colors.cardBg.withValues(alpha: 0.5),
          shape: BoxShape.circle,
          border: Border.all(color: colors.divider.withValues(alpha: 0.08)),
        ),
        child: Icon(icon, color: colors.primary, size: 20),
      ),
    );
  }
}
