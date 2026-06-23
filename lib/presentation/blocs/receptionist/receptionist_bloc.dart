import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/receptionist_entity.dart';
import 'package:clinic_management_app/domain/repositories/receptionist_repository.dart';

abstract class ReceptionistEvent {}

class LoadReceptionists extends ReceptionistEvent {
  final String? search;
  final String? gender;
  final bool? isActive;
  LoadReceptionists({this.search, this.gender, this.isActive});
}

class LoadReceptionistById extends ReceptionistEvent {
  final String id;
  LoadReceptionistById(this.id);
}

class CreateReceptionistEvent extends ReceptionistEvent {
  final ReceptionistEntity receptionist;
  CreateReceptionistEvent(this.receptionist);
}

class UpdateReceptionistEvent extends ReceptionistEvent {
  final ReceptionistEntity receptionist;
  UpdateReceptionistEvent(this.receptionist);
}

class DeleteReceptionistEvent extends ReceptionistEvent {
  final String id;
  DeleteReceptionistEvent(this.id);
}

class ActivateReceptionistAccount extends ReceptionistEvent {
  final String id;
  ActivateReceptionistAccount(this.id);
}

abstract class ReceptionistState {}

class ReceptionistInitial extends ReceptionistState {}

class ReceptionistLoading extends ReceptionistState {}

class ReceptionistsLoaded extends ReceptionistState {
  final List<ReceptionistEntity> receptionists;
  ReceptionistsLoaded(this.receptionists);
}

class ReceptionistLoaded extends ReceptionistState {
  final ReceptionistEntity receptionist;
  ReceptionistLoaded(this.receptionist);
}

class ReceptionistOperationSuccess extends ReceptionistState {
  final String message;
  ReceptionistOperationSuccess(this.message);
}

class ReceptionistError extends ReceptionistState {
  final String message;
  ReceptionistError(this.message);
}

class ReceptionistBloc extends Bloc<ReceptionistEvent, ReceptionistState> {
  final ReceptionistRepository repository;

  ReceptionistBloc(this.repository) : super(ReceptionistInitial()) {
    on<LoadReceptionists>(_onLoadAll);
    on<LoadReceptionistById>(_onLoadById);
    on<CreateReceptionistEvent>(_onCreate);
    on<UpdateReceptionistEvent>(_onUpdate);
    on<DeleteReceptionistEvent>(_onDelete);
    on<ActivateReceptionistAccount>(_onActivate);
  }

  Future<void> _onLoadAll(LoadReceptionists event, Emitter<ReceptionistState> emit) async {
    emit(ReceptionistLoading());
    try {
      final list = await repository.getAllReceptionists(search: event.search, gender: event.gender, isActive: event.isActive);
      emit(ReceptionistsLoaded(list));
    } catch (e) {
      emit(ReceptionistError(e.toString()));
    }
  }

  Future<void> _onLoadById(LoadReceptionistById event, Emitter<ReceptionistState> emit) async {
    emit(ReceptionistLoading());
    try {
      final r = await repository.getReceptionistById(event.id);
      if (r != null) { emit(ReceptionistLoaded(r)); } else { emit(ReceptionistError(AppStrings.opNotFound)); }
    } catch (e) {
      emit(ReceptionistError(e.toString()));
    }
  }

  Future<void> _onCreate(CreateReceptionistEvent event, Emitter<ReceptionistState> emit) async {
    try {
      await repository.createReceptionist(event.receptionist);
      final list = await repository.getAllReceptionists();
      emit(ReceptionistsLoaded(list));
    } catch (e) {
      emit(ReceptionistError(e.toString()));
    }
  }

  Future<void> _onUpdate(UpdateReceptionistEvent event, Emitter<ReceptionistState> emit) async {
    try {
      await repository.updateReceptionist(event.receptionist);
      emit(ReceptionistOperationSuccess(AppStrings.opUpdated));
    } catch (e) {
      emit(ReceptionistError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteReceptionistEvent event, Emitter<ReceptionistState> emit) async {
    try {
      await repository.deleteReceptionist(event.id);
      final list = await repository.getAllReceptionists();
      emit(ReceptionistsLoaded(list));
    } catch (e) {
      emit(ReceptionistError(e.toString()));
    }
  }

  Future<void> _onActivate(ActivateReceptionistAccount event, Emitter<ReceptionistState> emit) async {
    try {
      final active = await repository.activateAccount(event.id);
      emit(ReceptionistOperationSuccess(active ? AppStrings.opActivated : AppStrings.opDeactivated));
    } catch (e) {
      emit(ReceptionistError(e.toString()));
    }
  }
}
