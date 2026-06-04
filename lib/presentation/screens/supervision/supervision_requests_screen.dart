import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/utils/app_toast.dart';
import 'package:clinic_management_app/domain/entities/supervision_entity.dart';
import 'package:clinic_management_app/domain/entities/supervision_request_entity.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/supervision/supervision_bloc.dart';

class SupervisionRequestsScreen extends StatefulWidget {
  const SupervisionRequestsScreen({super.key});

  @override
  State<SupervisionRequestsScreen> createState() => _SupervisionRequestsScreenState();
}

class _SupervisionRequestsScreenState extends State<SupervisionRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() {
    final authState = context.read<AuthCubit>().state;
    final bloc = context.read<SupervisionBloc>();
    final userId = authState.userId ?? '';

    if (authState.role == UserRole.patient) {
      bloc.add(LoadPatientDoctors(userId));
    } else if (authState.role == UserRole.doctor) {
      bloc.add(LoadDoctorPatients(userId));
    }
  }

  void _loadRequests() {
    final authState = context.read<AuthCubit>().state;
    final bloc = context.read<SupervisionBloc>();
    final userId = authState.userId ?? '';

    if (authState.role == UserRole.patient) {
      bloc.add(LoadPatientRequests(userId));
    } else if (authState.role == UserRole.doctor) {
      bloc.add(LoadDoctorRequests(userId));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final authState = context.watch<AuthCubit>().state;
    final isPatient = authState.role == UserRole.patient;

    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppStrings.supervisionRequests,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            if (index == 0) {
              _loadData();
            } else {
              _loadRequests();
            }
          },
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          tabs: [
            Tab(text: isPatient ? AppStrings.supervisingDoctors : AppStrings.supervisedPatients),
            Tab(text: isPatient ? AppStrings.pendingRequests : AppStrings.incomingRequests),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          isPatient
              ? _PatientDoctorsTab(onRefresh: _loadData)
              : _DoctorPatientsTab(onRefresh: _loadData),
          isPatient
              ? _PatientRequestsTab(onRefresh: _loadRequests)
              : _DoctorRequestsTab(onRefresh: _loadRequests),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Patient: Supervising Doctors Tab
// ─────────────────────────────────────────────
class _PatientDoctorsTab extends StatelessWidget {
  final VoidCallback onRefresh;
  const _PatientDoctorsTab({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocConsumer<SupervisionBloc, SupervisionState>(
      listener: (context, state) {
        if (state is SupervisionOperationSuccess) {
          showAppToast(context, state.message);
          onRefresh();
        } else if (state is SupervisionError) {
          showAppToast(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is SupervisionLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PatientDoctorsLoaded) {
          if (state.doctors.isEmpty) {
            return _EmptyState(
              icon: Icons.medical_services_outlined,
              message: AppStrings.noSupervisingDoctors,
              colors: colors,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => onRefresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.doctors.length,
              itemBuilder: (context, index) {
                final supervision = state.doctors[index];
                return _SupervisionCard(
                  title: supervision.doctorName ?? 'طبيب',
                  subtitle: supervision.notes ?? '',
                  status: supervision.status,
                  statusColor: colors.success,
                  icon: Icons.medical_services_rounded,
                  colors: colors,
                  trailing: _ActionChip(
                    label: AppStrings.removeSupervision,
                    color: colors.error,
                    icon: Icons.link_off_rounded,
                    onPressed: () {
                      final userId = context.read<AuthCubit>().state.userId ?? '';
                      context.read<SupervisionBloc>().add(
                        PatientRemoveDoctor(userId, supervision.doctorId),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ─────────────────────────────────────────────
// Doctor: Supervised Patients Tab
// ─────────────────────────────────────────────
class _DoctorPatientsTab extends StatelessWidget {
  final VoidCallback onRefresh;
  const _DoctorPatientsTab({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocConsumer<SupervisionBloc, SupervisionState>(
      listener: (context, state) {
        if (state is SupervisionOperationSuccess) {
          showAppToast(context, state.message);
          onRefresh();
        } else if (state is SupervisionError) {
          showAppToast(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is SupervisionLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DoctorPatientsLoaded) {
          if (state.patients.isEmpty) {
            return _EmptyState(
              icon: Icons.people_outline_rounded,
              message: AppStrings.noSupervisedPatients,
              colors: colors,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => onRefresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.patients.length,
              itemBuilder: (context, index) {
                final supervision = state.patients[index];
                return _SupervisionCard(
                  title: supervision.patientName ?? 'مريض',
                  subtitle: supervision.notes ?? '',
                  status: supervision.status,
                  statusColor: colors.success,
                  icon: Icons.person_rounded,
                  colors: colors,
                  trailing: _ActionChip(
                    label: AppStrings.removeSupervision,
                    color: colors.error,
                    icon: Icons.link_off_rounded,
                    onPressed: () {
                      final userId = context.read<AuthCubit>().state.userId ?? '';
                      context.read<SupervisionBloc>().add(
                        RemovePatientFromDoctor(userId, supervision.patientId),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ─────────────────────────────────────────────
// Patient: Pending Requests Tab
// ─────────────────────────────────────────────
class _PatientRequestsTab extends StatelessWidget {
  final VoidCallback onRefresh;
  const _PatientRequestsTab({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocConsumer<SupervisionBloc, SupervisionState>(
      listener: (context, state) {
        if (state is SupervisionOperationSuccess) {
          showAppToast(context, state.message);
          onRefresh();
        } else if (state is SupervisionError) {
          showAppToast(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is SupervisionLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PatientRequestsLoaded) {
          if (state.requests.isEmpty) {
            return _EmptyState(
              icon: Icons.hourglass_empty_rounded,
              message: AppStrings.noPendingRequests,
              colors: colors,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => onRefresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.requests.length,
              itemBuilder: (context, index) {
                final request = state.requests[index];
                return _RequestCard(
                  title: request.doctorName ?? 'طبيب',
                  status: request.status,
                  createdAt: request.createdAt,
                  icon: Icons.medical_services_rounded,
                  colors: colors,
                  actions: [
                    if (request.status == 'pending')
                      _ActionChip(
                        label: AppStrings.cancelRequest,
                        color: colors.warning,
                        icon: Icons.cancel_outlined,
                        onPressed: () {
                          context.read<SupervisionBloc>().add(CancelRequest(request.id));
                        },
                      ),
                  ],
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ─────────────────────────────────────────────
// Doctor: Incoming Requests Tab
// ─────────────────────────────────────────────
class _DoctorRequestsTab extends StatelessWidget {
  final VoidCallback onRefresh;
  const _DoctorRequestsTab({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocConsumer<SupervisionBloc, SupervisionState>(
      listener: (context, state) {
        if (state is SupervisionOperationSuccess) {
          showAppToast(context, state.message);
          onRefresh();
        } else if (state is SupervisionError) {
          showAppToast(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is SupervisionLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DoctorRequestsLoaded) {
          if (state.requests.isEmpty) {
            return _EmptyState(
              icon: Icons.inbox_rounded,
              message: AppStrings.noPendingRequests,
              colors: colors,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => onRefresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.requests.length,
              itemBuilder: (context, index) {
                final request = state.requests[index];
                return _RequestCard(
                  title: request.patientName ?? 'مريض',
                  status: request.status,
                  createdAt: request.createdAt,
                  icon: Icons.person_rounded,
                  colors: colors,
                  actions: [
                    if (request.status == 'pending') ...[
                      _ActionChip(
                        label: AppStrings.approveRequest,
                        color: colors.success,
                        icon: Icons.check_circle_outline,
                        onPressed: () {
                          context.read<SupervisionBloc>().add(ApproveRequest(request.id));
                        },
                      ),
                      const SizedBox(width: 8),
                      _ActionChip(
                        label: AppStrings.rejectRequest,
                        color: colors.error,
                        icon: Icons.cancel_outlined,
                        onPressed: () {
                          context.read<SupervisionBloc>().add(RejectRequest(request.id));
                        },
                      ),
                    ],
                  ],
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ─────────────────────────────────────────────
// Shared Widgets
// ─────────────────────────────────────────────

class _SupervisionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;
  final IconData icon;
  final AppColorSet colors;
  final Widget? trailing;

  const _SupervisionCard({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
    required this.icon,
    required this.colors,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colors.primary, colors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status == 'active' ? AppStrings.active : status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            if (trailing != null) ...[
              const SizedBox(height: 12),
              Align(alignment: Alignment.centerLeft, child: trailing!),
            ],
          ],
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final String title;
  final String status;
  final String? createdAt;
  final IconData icon;
  final AppColorSet colors;
  final List<Widget> actions;

  const _RequestCard({
    required this.title,
    required this.status,
    this.createdAt,
    required this.icon,
    required this.colors,
    required this.actions,
  });

  Color _statusColor() {
    switch (status) {
      case 'pending':
        return colors.warning;
      case 'approved':
        return colors.success;
      case 'rejected':
        return colors.error;
      default:
        return colors.textSecondary;
    }
  }

  String _statusLabel() {
    switch (status) {
      case 'pending':
        return AppStrings.pending;
      case 'approved':
        return AppStrings.supervisionRequestApproved;
      case 'rejected':
        return AppStrings.supervisionRequestRejected;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _statusColor().withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: _statusColor(), size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                      if (createdAt != null)
                        Text(
                          createdAt!,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor().withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _statusColor(),
                    ),
                  ),
                ),
              ],
            ),
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(children: actions),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionChip({
    required this.label,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final AppColorSet colors;

  const _EmptyState({
    required this.icon,
    required this.message,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, size: 40, color: colors.primary.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
