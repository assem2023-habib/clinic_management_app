import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';
import 'package:clinic_management_app/presentation/blocs/doctor_profile/doctor_profile_event.dart';
import 'package:clinic_management_app/presentation/blocs/doctor_profile/doctor_profile_state.dart';

class DoctorProfileBloc extends Bloc<DoctorProfileEvent, DoctorProfileState> {
  final DoctorRepository repository;

  DoctorProfileBloc(this.repository) : super(DoctorProfileInitial()) {
    on<LoadDoctorProfile>(_onLoadProfile);
    on<ToggleSlotAvailability>(_onToggleSlot);
    on<SubmitReview>(_onSubmitReview);
  }

  Future<void> _onLoadProfile(LoadDoctorProfile event, Emitter<DoctorProfileState> emit) async {
    emit(DoctorProfileLoading());
    try {
      final profile = await repository.getDoctorProfile(event.doctorId);
      emit(DoctorProfileLoaded(profile));
    } catch (e) {
      emit(DoctorProfileError(e.toString()));
    }
  }

  Future<void> _onToggleSlot(ToggleSlotAvailability event, Emitter<DoctorProfileState> emit) async {
    try {
      await repository.toggleSlotAvailability(event.slotId);
      final current = state;
      if (current is DoctorProfileLoaded) {
        final profile = await repository.getDoctorProfile(current.profile.doctor.id);
        emit(DoctorProfileLoaded(profile));
      }
    } catch (e) {
      emit(DoctorProfileError(e.toString()));
    }
  }

  Future<void> _onSubmitReview(SubmitReview event, Emitter<DoctorProfileState> emit) async {
    try {
      await repository.addReview(event.doctorId, event.review);
      final profile = await repository.getDoctorProfile(event.doctorId);
      emit(DoctorProfileLoaded(profile));
    } catch (e) {
      emit(DoctorProfileError(e.toString()));
    }
  }
}
