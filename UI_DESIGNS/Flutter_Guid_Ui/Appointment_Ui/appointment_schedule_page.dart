// ============================================================
//  appointment_schedule_page.dart
//  Deep Vitality — جدول المواعيد
//  ربط: Firebase Realtime Database (RTDB)
//  بنية الـ RTDB:
//    appointments/
//      {doctorId}/
//        {dateKey}/          ← مثال: "2026-06-13"
//          slots/
//            "09:00": { status: "available" | "booked" }
//            "09:30": { status: "selected" | "booked" }
//            ...
// ============================================================

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

// ──────────────────────────────────────────────
// نماذج البيانات (Data Models)
// ──────────────────────────────────────────────

enum SlotStatus { available, booked, selected }

class AppointmentSlot {
  final String time;
  final String period; // "morning" | "evening"
  SlotStatus status;

  AppointmentSlot({
    required this.time,
    required this.period,
    this.status = SlotStatus.available,
  });

  factory AppointmentSlot.fromMap(String time, String period, Map<dynamic, dynamic> map) {
    final statusStr = map['status'] as String? ?? 'available';
    SlotStatus st;
    switch (statusStr) {
      case 'booked':
        st = SlotStatus.booked;
        break;
      case 'selected':
        st = SlotStatus.selected;
        break;
      default:
        st = SlotStatus.available;
    }
    return AppointmentSlot(time: time, period: period, status: st);
  }

  Map<String, dynamic> toMap() => {'status': status.name};
}

class DateItem {
  final String dayName;
  final String dayNumber;
  final DateTime date;
  bool isSelected;

  DateItem({
    required this.dayName,
    required this.dayNumber,
    required this.date,
    this.isSelected = false,
  });
}

// ──────────────────────────────────────────────
// الألوان (Color Palette) — مطابقة للـ HTML
// ──────────────────────────────────────────────

class AppColors {
  static const background       = Color(0xFF00180B);
  static const surface          = Color(0xFF00180B);
  static const surfaceContainer = Color(0xFF032515);
  static const surfaceContainerHigh = Color(0xFF0F301F);
  static const surfaceVariant   = Color(0xFF1B3B29);
  static const primary          = Color(0xFF80D8A6);
  static const primaryContainer = Color(0xFF006D44);
  static const onPrimary        = Color(0xFF003921);
  static const onPrimaryFixed   = Color(0xFF002111);
  static const onPrimaryContainer = Color(0xFF93ECB8);
  static const secondary        = Color(0xFF40E78C);
  static const onSecondary      = Color(0xFF00391C);
  static const onSurface        = Color(0xFFC6EBD1);
  static const onSurfaceVariant = Color(0xFFBEC9BF);
  static const outline          = Color(0xFF88938A);
  static const outlineVariant   = Color(0xFF3F4942);
  static const glassCard        = Color(0x66032515); // rgba(3,37,21,0.4)
  static const glassBorder      = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
}

// ──────────────────────────────────────────────
// الصفحة الرئيسية
// ──────────────────────────────────────────────

class AppointmentSchedulePage extends StatefulWidget {
  final String doctorId;
  const AppointmentSchedulePage({super.key, required this.doctorId});

  @override
  State<AppointmentSchedulePage> createState() => _AppointmentSchedulePageState();
}

class _AppointmentSchedulePageState extends State<AppointmentSchedulePage>
    with TickerProviderStateMixin {

  // ── حالة الصفحة ──
  late List<DateItem> _dates;
  DateTime _selectedDate = DateTime(2026, 6, 13);
  String? _selectedSlotTime;
  bool _isConfirming = false;

  List<AppointmentSlot> _morningSlots = [];
  List<AppointmentSlot> _eveningSlots = [];

  // ── Firebase ──
  late DatabaseReference _slotsRef;
  late Stream<DatabaseEvent> _slotsStream;

  // ── أنيميشن ──
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
    _buildDateList();
    _initAnimations();
    _initFirebase();
  }

  // ── بناء قائمة الأيام ──
  void _buildDateList() {
    const arabicDays = ['الأحد','الاثنين','الثلاثاء','الأربعاء','الخميس','الجمعة','السبت'];
    const arabicNums = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];

    String toArabic(int n) => n.toString().split('').map((c) => arabicNums[int.parse(c)]).join();

    _dates = List.generate(7, (i) {
      final d = DateTime(2026, 6, 11 + i);
      return DateItem(
        dayName:   arabicDays[d.weekday % 7],
        dayNumber: toArabic(d.day),
        date:      d,
        isSelected: d.day == _selectedDate.day,
      );
    });
  }

  // ── تهيئة الأنيميشن ──
  void _initAnimations() {
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
    _slotFade  = CurvedAnimation(parent: _slotListController, curve: Curves.easeOut);
    _slotSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slotListController, curve: Curves.easeOut));
  }

  // ── تهيئة Firebase RTDB ──
  void _initFirebase() {
    _updateFirebaseRef();
  }

  void _updateFirebaseRef() {
    final dateKey = '${_selectedDate.year}-'
        '${_selectedDate.month.toString().padLeft(2, '0')}-'
        '${_selectedDate.day.toString().padLeft(2, '0')}';

    _slotsRef = FirebaseDatabase.instance
        .ref('appointments/${widget.doctorId}/$dateKey/slots');

    _slotsStream = _slotsRef.onValue;

    // إعادة تشغيل أنيميشن القائمة عند تغيير اليوم
    _slotListController.forward(from: 0);
  }

  // ── تحويل بيانات Firebase إلى Slots ──
  void _parseSlots(Map<dynamic, dynamic>? data) {
    const morningTimes = ['09:00', '09:30', '10:00', '10:30'];
    const eveningTimes = ['16:00', '16:30', '17:00', '17:30'];
    const morningLabels = ['٠٩:٠٠ ص','٠٩:٣٠ ص','١٠:٠٠ ص','١٠:٣٠ ص'];
    const eveningLabels = ['٠٤:٠٠ م','٠٤:٣٠ م','٠٥:٠٠ م','٠٥:٣٠ م'];

    List<AppointmentSlot> morning = [];
    List<AppointmentSlot> evening = [];

    for (int i = 0; i < morningTimes.length; i++) {
      final key  = morningTimes[i];
      final map  = data?[key] as Map<dynamic, dynamic>?;
      if (map != null) {
        morning.add(AppointmentSlot.fromMap(morningLabels[i], 'morning', map));
      } else {
        // حجز مبدئي من الـ HTML: 09:30 → selected, 10:00 → booked
        SlotStatus st = SlotStatus.available;
        if (key == '09:30') st = SlotStatus.selected;
        if (key == '10:00') st = SlotStatus.booked;
        morning.add(AppointmentSlot(time: morningLabels[i], period: 'morning', status: st));
      }
    }

    for (int i = 0; i < eveningTimes.length; i++) {
      final key = eveningTimes[i];
      final map = data?[key] as Map<dynamic, dynamic>?;
      if (map != null) {
        evening.add(AppointmentSlot.fromMap(eveningLabels[i], 'evening', map));
      } else {
        SlotStatus st = SlotStatus.available;
        if (key == '16:30') st = SlotStatus.booked;
        evening.add(AppointmentSlot(time: eveningLabels[i], period: 'evening', status: st));
      }
    }

    setState(() {
      _morningSlots = morning;
      _eveningSlots = evening;
      // تحديد الـ slot المختار مسبقاً
      final sel = [...morning, ...evening].where((s) => s.status == SlotStatus.selected);
      _selectedSlotTime = sel.isNotEmpty ? sel.first.time : null;
    });
  }

  // ── تحديد موعد ──
  Future<void> _selectSlot(AppointmentSlot slot) async {
    if (slot.status == SlotStatus.booked) return;

    // تحديث محلي فوري (optimistic UI)
    setState(() {
      for (var s in [..._morningSlots, ..._eveningSlots]) {
        if (s.status == SlotStatus.selected) s.status = SlotStatus.available;
      }
      slot.status = SlotStatus.selected;
      _selectedSlotTime = slot.time;
    });

    // تحديث Firebase
    try {
      final dateKey = '${_selectedDate.year}-'
          '${_selectedDate.month.toString().padLeft(2, '0')}-'
          '${_selectedDate.day.toString().padLeft(2, '0')}';
      final ref = FirebaseDatabase.instance
          .ref('appointments/${widget.doctorId}/$dateKey/slots');

      // إلغاء أي تحديد سابق وتحديد الجديد
      final allSlots = {..._morningSlots, ..._eveningSlots};
      final Map<String, dynamic> updates = {};
      for (var s in allSlots) {
        // تحويل الوقت العربي إلى مفتاح (09:00 ص → 09:00)
        updates[_arabicToKey(s.time)] = s.toMap();
      }
      await ref.update(updates);
    } catch (e) {
      debugPrint('Firebase update error: $e');
    }
  }

  // ── تأكيد الحجز ──
  Future<void> _confirmBooking() async {
    if (_selectedSlotTime == null) return;

    setState(() => _isConfirming = true);
    _confirmBtnController.forward().then((_) => _confirmBtnController.reverse());

    try {
      final dateKey = '${_selectedDate.year}-'
          '${_selectedDate.month.toString().padLeft(2, '0')}-'
          '${_selectedDate.day.toString().padLeft(2, '0')}';
      final slotKey = _arabicToKey(_selectedSlotTime!);

      await FirebaseDatabase.instance
          .ref('appointments/${widget.doctorId}/$dateKey/slots/$slotKey')
          .set({'status': 'booked'});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم تأكيد الحجز بنجاح ✓'),
            backgroundColor: AppColors.primaryContainer,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      debugPrint('Booking error: $e');
    } finally {
      setState(() => _isConfirming = false);
    }
  }

  // ── مساعد: تحويل وقت عربي إلى مفتاح Firebase ──
  String _arabicToKey(String arabicTime) {
    const m = {'٠':'0','١':'1','٢':'2','٣':'3','٤':'4',
               '٥':'5','٦':'6','٧':'7','٨':'8','٩':'9'};
    return arabicTime
        .split('').map((c) => m[c] ?? c).join()
        .replaceAll(' ص', '').replaceAll(' م', '').trim();
  }

  // ── تغيير اليوم ──
  void _onDateSelected(DateItem item) {
    setState(() {
      for (var d in _dates) d.isSelected = false;
      item.isSelected = true;
      _selectedDate = item.date;
      _selectedSlotTime = null;
    });
    _updateFirebaseRef();
  }

  @override
  void dispose() {
    _headerFadeController.dispose();
    _confirmBtnController.dispose();
    _slotListController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────
  // بناء الواجهة (Build)
  // ──────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(),
        body: StreamBuilder<DatabaseEvent>(
          stream: _slotsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
              WidgetsBinding.instance.addPostFrameCallback((_) => _parseSlots(data));
            }
            return _buildBody();
          },
        ),
        bottomNavigationBar: _buildConfirmButton(),
      ),
    );
  }

  // ── AppBar ──
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: FadeTransition(
        opacity: _headerFade,
        child: ClipRect(
          child: Container(
            color: AppColors.surface.withOpacity(0.7),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // زر الرجوع
                    _GlassIconButton(
                      icon: Icons.arrow_forward,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    // العنوان
                    Expanded(
                      child: Center(
                        child: Text(
                          'جدول المواعيد',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40), // spacer للتوازن
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── جسم الصفحة ──
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        top: 100, left: 16, right: 16, bottom: 120,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateSection(),
          const SizedBox(height: 32),
          _buildDoctorCard(),
          const SizedBox(height: 32),
          SlideTransition(
            position: _slotSlide,
            child: FadeTransition(
              opacity: _slotFade,
              child: Column(
                children: [
                  _buildSlotsSection('الفترة الصباحية', Icons.light_mode, _morningSlots),
                  const SizedBox(height: 32),
                  _buildSlotsSection('الفترة المسائية', Icons.dark_mode, _eveningSlots),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── قسم الأيام ──
  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'يونيو، ٢٠٢٦',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            _GlassIconButton(
              icon: Icons.calendar_month,
              onTap: () {}, // يمكن ربطه بـ DatePicker
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _dates.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) => _DateCard(
              item: _dates[i],
              onTap: () => _onDateSelected(_dates[i]),
            ),
          ),
        ),
      ],
    );
  }

  // ── بطاقة الطبيب ──
  Widget _buildDoctorCard() {
    return _GlassCard(
      child: Row(
        children: [
          // صورة الطبيب
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDdXhoj6HJdScOPh6VgLKZnom7ZGRNQZCW3lfx7Egs3y9nBN0nKSjFflQ_Qjge-gqJcL75P-Mg1Baa07tEwvoxmle4HxjZscuHxnizbDnGGOpMXk3mqbTtGoWo5yNxdGIscSCMJpdmVA1Jy_qfGSlw-R16np-F1xt8R3M4W3dqP9fA63hBn0vB7vV_E773uvI4aCMVJ6qj33pYZVZB0LZPl0kS4Xdq8RUgifcn1D3vy48pg-5MO8yoMFYhCKNGsY5EqyyTkYtfFIQM',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.person, color: AppColors.onPrimaryContainer),
                  ),
                ),
              ),
              // نقطة الحالة (متصل)
              Positioned(
                bottom: -4, left: -4,
                child: Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // معلومات الطبيب
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'د. سمير منصور',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'استشاري أمراض القلب',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.verified, color: AppColors.primary, size: 24),
        ],
      ),
    );
  }

  // ── قسم الفترات (صباحية/مسائية) ──
  Widget _buildSlotsSection(String title, IconData icon, List<AppointmentSlot> slots) {
    if (slots.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: title, icon: icon),
          const SizedBox(height: 16),
          const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: title, icon: icon),
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
            slot: slots[i],
            onTap: () => _selectSlot(slots[i]),
          ),
        ),
      ],
    );
  }

  // ── زر التأكيد (Fixed Bottom) ──
  Widget _buildConfirmButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColors.background,
            AppColors.background.withOpacity(0.0),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
      child: ScaleTransition(
        scale: _confirmScale,
        child: AnimatedOpacity(
          opacity: _selectedSlotTime != null ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 300),
          child: GestureDetector(
            onTapDown: (_) => _confirmBtnController.forward(),
            onTapUp: (_) {
              _confirmBtnController.reverse();
              _confirmBooking();
            },
            onTapCancel: () => _confirmBtnController.reverse(),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: _isConfirming
                  ? const Center(
                      child: SizedBox(
                        width: 24, height: 24,
                        child: CircularProgressIndicator(
                          color: AppColors.onPrimaryFixed,
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
                            fontFamily: 'Manrope',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onPrimaryFixed,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.event_available, color: AppColors.onPrimaryFixed, size: 22),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// ويدجتات مساعدة (Helper Widgets)
// ──────────────────────────────────────────────

/// بطاقة اليوم في الصف الأفقي
class _DateCard extends StatelessWidget {
  final DateItem item;
  final VoidCallback onTap;

  const _DateCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 56,
        decoration: BoxDecoration(
          color: item.isSelected
              ? AppColors.primaryContainer
              : AppColors.glassCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.isSelected
                ? AppColors.primary
                : AppColors.glassBorder,
          ),
          boxShadow: item.isSelected
              ? [BoxShadow(
                  color: AppColors.primaryContainer.withOpacity(0.2),
                  blurRadius: 12,
                )]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.dayName,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: item.isSelected
                    ? AppColors.onPrimaryContainer.withOpacity(0.8)
                    : AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.dayNumber,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: item.isSelected
                    ? AppColors.onPrimaryContainer
                    : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// بطاقة الموعد (Available / Booked / Selected)
class _SlotCard extends StatefulWidget {
  final AppointmentSlot slot;
  final VoidCallback onTap;

  const _SlotCard({required this.slot, required this.onTap});

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
    final isBooked   = widget.slot.status == SlotStatus.booked;
    final isSelected = widget.slot.status == SlotStatus.selected;

    return GestureDetector(
      onTapDown: isBooked ? null : (_) => _tapController.forward(),
      onTapUp:   isBooked ? null : (_) {
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
            color: isSelected
                ? AppColors.primaryContainer
                : AppColors.glassCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.glassBorder,
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isSelected
                ? [BoxShadow(
                    color: AppColors.primaryContainer.withOpacity(0.3),
                    blurRadius: 12,
                  )]
                : [],
          ),
          child: Opacity(
            opacity: isBooked ? 0.4 : 1.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 18,
                      color: isSelected
                          ? AppColors.onPrimaryContainer
                          : AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.slot.time,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.onPrimaryContainer
                            : AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                // حالة الـ slot
                if (isBooked)
                  Icon(Icons.lock, size: 16, color: AppColors.onSurfaceVariant)
                else if (isSelected)
                  Icon(Icons.check_circle, size: 16, color: AppColors.onPrimaryContainer)
                else
                  Text(
                    'متاح',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
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

/// بطاقة زجاجية (Glass Card)
class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _GlassCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.glassCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: child,
    );
  }
}

/// أيقونة زجاجية
class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: AppColors.glassCard,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
    );
  }
}

/// رأس القسم (صباحي/مسائي)
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
