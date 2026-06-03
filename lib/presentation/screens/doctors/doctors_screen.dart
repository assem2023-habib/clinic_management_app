import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/utils/app_toast.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_event.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_state.dart';
import 'package:clinic_management_app/presentation/widgets/app_drawer.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_form_dialog.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_glass_card.dart';
import 'package:clinic_management_app/presentation/widgets/particle_background.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  bool _isSearchFocused = false;
  String _selectedCategory = 'all';
  int _bottomNavIndex = 0;

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  final List<Map<String, String>> _categories = [
    {'key': 'all', 'label': 'الكل'},
    {'key': 'قلب', 'label': 'القلب'},
    {'key': 'أعصاب', 'label': 'الأعصاب'},
    {'key': 'عيون', 'label': 'العيون'},
    {'key': 'أسنان', 'label': 'الأسنان'},
  ];

  void _openSheet(AppColorSet colors, DoctorEntity doctor) {

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _buildBottomSheet(colors, doctor),
    );
  }

  Widget _buildBottomSheet(AppColorSet colors, DoctorEntity doctor) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B3B29),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF88938A).withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF006D44), Color(0xFF40E78C)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الخيارات المتاحة لـ',
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'د. ${doctor.name}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _sheetOption(
            colors,
            icon: Icons.visibility_rounded,
            label: 'عرض الملف',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.doctorProfile, arguments: doctor.id);
            },
          ),
          _sheetOption(
            colors,
            icon: Icons.edit_rounded,
            label: 'تعديل البيانات',
            onTap: () {
              Navigator.pop(context);
              _showDoctorForm(context, doctor: doctor);
            },
          ),
          _sheetOption(
            colors,
            icon: Icons.delete_rounded,
            label: 'حذف',
            isDanger: true,
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmDialog(colors, doctor);
            },
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF002111),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'إلغاء',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sheetOption(
    AppColorSet colors, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Icon(icon, size: 22, color: isDanger ? colors.error : colors.textPrimary),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDanger ? colors.error : colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(AppColorSet colors, DoctorEntity doctor) {
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF1B3B29),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: colors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: colors.error.withValues(alpha: 0.2)),
                    ),
                    child: Icon(Icons.delete_forever_rounded, size: 30, color: colors.error),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'تأكيد الحذف',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'هل أنت متأكد من حذف ملف\nد. ${doctor.name}؟\nلا يمكن التراجع عن هذا الإجراء.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.65,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F301F),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                'إلغاء',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(ctx);
                            context.read<DoctorBloc>().add(DoctorDelete(doctor.id));
                            showAppToast(context, '🗑 تم حذف د. ${doctor.name}');
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: colors.error.withValues(alpha: 0.13),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: colors.error.withValues(alpha: 0.28)),
                            ),
                            child: Center(
                              child: Text(
                                'حذف',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: colors.error,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDoctorForm(BuildContext context, {DoctorEntity? doctor}) {
    showDialog(
      context: context,
      builder: (_) => DoctorFormDialog(doctor: doctor),
    );
  }
}

class _CentralPulsePainter extends CustomPainter {
  final double progress;
  _CentralPulsePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = progress * size.longestSide * 1.5;
    final opacity = (1.0 - progress) * 0.1;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = const Color(0xFF40E78C).withValues(alpha: opacity);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}

class GlassSkeletonList extends StatelessWidget {
  const GlassSkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 3,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          height: 280,
          decoration: BoxDecoration(
            color: const Color(0xFF012B17).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SkeletonContainer(width: 80, height: 80, borderRadius: 14),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonContainer(width: 60, height: 14),
                          const SizedBox(height: 8),
                          SkeletonContainer(width: 140, height: 18),
                          const SizedBox(height: 6),
                          SkeletonContainer(width: 100, height: 14),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SkeletonContainer(width: 180, height: 14),
                const SizedBox(height: 8),
                SkeletonContainer(width: double.infinity, height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SkeletonContainer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  const SkeletonContainer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF0F301F),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
