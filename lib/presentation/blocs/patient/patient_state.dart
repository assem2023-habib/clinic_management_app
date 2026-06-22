import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/patient_entity.dart';

abstract class PatientState extends Equatable {
  const PatientState();
  @override
  List<Object?> get props => [];
}

class PatientInitial extends PatientState {}

class PatientLoading extends PatientState {}

class PatientLoaded extends PatientState {
  final List<PatientEntity> patients;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;
  const PatientLoaded(this.patients, {this.isLoadingMore = false, this.hasMore = true, this.page = 1});
  PatientLoaded copyWith({List<PatientEntity>? patients, bool? isLoadingMore, bool? hasMore, int? page}) {
    return PatientLoaded(
      patients ?? this.patients,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
  @override
  List<Object?> get props => [patients, isLoadingMore, hasMore, page];
}

class PatientError extends PatientState {
  final String message;
  const PatientError(this.message);
  @override
  List<Object?> get props => [message];
}
