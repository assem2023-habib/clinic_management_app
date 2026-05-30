import 'package:equatable/equatable.dart';

class UsersStats extends Equatable {
  final int total;
  final int doctors;
  final int patients;
  final int receptionists;
  final int admins;
  final int active;
  final int inactive;
  final int newToday;
  final int newThisWeek;
  final int newThisMonth;

  const UsersStats({
    required this.total,
    required this.doctors,
    required this.patients,
    required this.receptionists,
    required this.admins,
    required this.active,
    required this.inactive,
    required this.newToday,
    required this.newThisWeek,
    required this.newThisMonth,
  });

  @override
  List<Object?> get props => [total, doctors, patients, receptionists, admins, active, inactive, newToday, newThisWeek, newThisMonth];
}

class AppointmentsStats extends Equatable {
  final int? total;
  final int? today;
  final int? todayTotal;
  final int? thisWeek;
  final int? thisMonth;
  final int? upcoming;
  final Map<String, int> byStatus;

  const AppointmentsStats({
    this.total,
    this.today,
    this.todayTotal,
    this.thisWeek,
    this.thisMonth,
    this.upcoming,
    this.byStatus = const {},
  });

  @override
  List<Object?> get props => [total, today, todayTotal, thisWeek, thisMonth, upcoming, byStatus];
}

class PatientsStats extends Equatable {
  final int total;
  final int? newThisMonth;
  final int? registeredToday;

  const PatientsStats({required this.total, this.newThisMonth, this.registeredToday});

  @override
  List<Object?> get props => [total, newThisMonth, registeredToday];
}

class DoctorsStats extends Equatable {
  final int total;
  const DoctorsStats({required this.total});
  @override
  List<Object?> get props => [total];
}

class SpecializationCount extends Equatable {
  final String name;
  final int doctorsCount;
  const SpecializationCount({required this.name, required this.doctorsCount});
  @override
  List<Object?> get props => [name, doctorsCount];
}

class SpecializationsStats extends Equatable {
  final int total;
  final List<SpecializationCount> top;
  const SpecializationsStats({required this.total, this.top = const []});
  @override
  List<Object?> get props => [total, top];
}

class RatingsStats extends Equatable {
  final double average;
  final int total;
  const RatingsStats({required this.average, required this.total});
  @override
  List<Object?> get props => [average, total];
}

class DashboardData extends Equatable {
  final UsersStats? users;
  final AppointmentsStats appointments;
  final PatientsStats? patients;
  final DoctorsStats? doctors;
  final int? totalMedicalRecords;
  final int? totalPrescriptions;
  final SpecializationsStats? specializations;
  final RatingsStats? ratings;

  const DashboardData({
    this.users,
    this.appointments = const AppointmentsStats(),
    this.patients,
    this.doctors,
    this.totalMedicalRecords,
    this.totalPrescriptions,
    this.specializations,
    this.ratings,
  });

  @override
  List<Object?> get props => [users, appointments, patients, doctors, totalMedicalRecords, totalPrescriptions, specializations, ratings];
}
