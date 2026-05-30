import 'package:clinic_management_app/domain/entities/dashboard_data.dart';

UsersStats _usersStats(Map<String, dynamic>? m) => UsersStats(
  total: (m?['total'] as num?)?.toInt() ?? 0,
  doctors: (m?['doctors'] as num?)?.toInt() ?? 0,
  patients: (m?['patients'] as num?)?.toInt() ?? 0,
  receptionists: (m?['receptionists'] as num?)?.toInt() ?? 0,
  admins: (m?['admins'] as num?)?.toInt() ?? 0,
  active: (m?['active'] as num?)?.toInt() ?? 0,
  inactive: (m?['inactive'] as num?)?.toInt() ?? 0,
  newToday: (m?['new_today'] as num?)?.toInt() ?? 0,
  newThisWeek: (m?['new_this_week'] as num?)?.toInt() ?? 0,
  newThisMonth: (m?['new_this_month'] as num?)?.toInt() ?? 0,
);

AppointmentsStats _appointmentsStats(Map<String, dynamic>? m) {
  final byStatusRaw = m?['by_status'] as Map<String, dynamic>?;
  final byStatus = <String, int>{};
  if (byStatusRaw != null) {
    for (final e in byStatusRaw.entries) {
      byStatus[e.key] = (e.value as num?)?.toInt() ?? 0;
    }
  }
  return AppointmentsStats(
    total: (m?['total'] as num?)?.toInt(),
    today: (m?['today'] as num?)?.toInt(),
    todayTotal: (m?['today_total'] as num?)?.toInt(),
    thisWeek: (m?['this_week'] as num?)?.toInt(),
    thisMonth: (m?['this_month'] as num?)?.toInt(),
    upcoming: (m?['upcoming'] as num?)?.toInt(),
    byStatus: byStatus,
  );
}

PatientsStats _patientsStats(Map<String, dynamic>? m) => PatientsStats(
  total: (m?['total'] as num?)?.toInt() ?? 0,
  newThisMonth: (m?['new_this_month'] as num?)?.toInt(),
  registeredToday: (m?['registered_today'] as num?)?.toInt(),
);

DoctorsStats _doctorsStats(Map<String, dynamic>? m) => DoctorsStats(
  total: (m?['total'] as num?)?.toInt() ?? 0,
);

SpecializationsStats _specializationsStats(Map<String, dynamic>? m) {
  final topRaw = (m?['top'] as List<dynamic>?)?.cast<Map<String, dynamic>>();
  return SpecializationsStats(
    total: (m?['total'] as num?)?.toInt() ?? 0,
    top: topRaw?.map((e) => SpecializationCount(
      name: e['name'] as String? ?? '',
      doctorsCount: (e['doctors_count'] as num?)?.toInt() ?? 0,
    )).toList() ?? [],
  );
}

RatingsStats _ratingsStats(Map<String, dynamic>? m) => RatingsStats(
  average: (m?['average'] as num?)?.toDouble() ?? 0.0,
  total: (m?['total'] as num?)?.toInt() ?? 0,
);

class DashboardModel {
  static DashboardData fromMap(Map<String, dynamic> map) {
    final data = map['data'] as Map<String, dynamic>? ?? map;
    return DashboardData(
      users: data['users'] != null ? _usersStats(data['users'] as Map<String, dynamic>) : null,
      appointments: _appointmentsStats(data['appointments'] as Map<String, dynamic>?),
      patients: data['patients'] != null ? _patientsStats(data['patients'] as Map<String, dynamic>) : null,
      doctors: data['doctors'] != null ? _doctorsStats(data['doctors'] as Map<String, dynamic>) : null,
      totalMedicalRecords: (data['medical_records'] is Map) ? (data['medical_records'] as Map)['total'] as int? : null,
      totalPrescriptions: (data['prescriptions'] is Map) ? (data['prescriptions'] as Map)['total'] as int? : null,
      specializations: data['specializations'] != null ? _specializationsStats(data['specializations'] as Map<String, dynamic>) : null,
      ratings: data['ratings'] != null ? _ratingsStats(data['ratings'] as Map<String, dynamic>) : null,
    );
  }
}
