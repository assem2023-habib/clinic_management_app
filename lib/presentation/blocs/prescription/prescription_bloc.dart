import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/entities/medicine_entity.dart';
import 'package:clinic_management_app/domain/entities/prescription_entity.dart';
import 'package:clinic_management_app/domain/entities/prescription_item_entity.dart';
import 'package:clinic_management_app/domain/repositories/prescription_repository.dart';

abstract class PrescriptionEvent {}

class LoadMedicines extends PrescriptionEvent {
  final String? search;
  final String? manufacturer;
  LoadMedicines({this.search, this.manufacturer});
}

class LoadMedicineById extends PrescriptionEvent {
  final String id;
  LoadMedicineById(this.id);
}

class CreateMedicine extends PrescriptionEvent {
  final MedicineEntity medicine;
  CreateMedicine(this.medicine);
}

class UpdateMedicine extends PrescriptionEvent {
  final MedicineEntity medicine;
  UpdateMedicine(this.medicine);
}

class DeleteMedicine extends PrescriptionEvent {
  final String id;
  DeleteMedicine(this.id);
}

class LoadPrescriptions extends PrescriptionEvent {
  final String medicalRecordId;
  LoadPrescriptions(this.medicalRecordId);
}

class LoadPrescriptionById extends PrescriptionEvent {
  final String id;
  LoadPrescriptionById(this.id);
}

class CreatePrescription extends PrescriptionEvent {
  final String medicalRecordId;
  final PrescriptionEntity prescription;
  CreatePrescription(this.medicalRecordId, this.prescription);
}

class UpdatePrescription extends PrescriptionEvent {
  final PrescriptionEntity prescription;
  UpdatePrescription(this.prescription);
}

class DeletePrescription extends PrescriptionEvent {
  final String id;
  DeletePrescription(this.id);
}

class LoadPrescriptionItems extends PrescriptionEvent {
  final String prescriptionId;
  LoadPrescriptionItems(this.prescriptionId);
}

class CreatePrescriptionItem extends PrescriptionEvent {
  final String prescriptionId;
  final PrescriptionItemEntity item;
  CreatePrescriptionItem(this.prescriptionId, this.item);
}

class UpdatePrescriptionItem extends PrescriptionEvent {
  final PrescriptionItemEntity item;
  UpdatePrescriptionItem(this.item);
}

class DeletePrescriptionItem extends PrescriptionEvent {
  final String id;
  DeletePrescriptionItem(this.id);
}

abstract class PrescriptionState {}

class PrescriptionInitial extends PrescriptionState {}

class PrescriptionLoading extends PrescriptionState {}

class MedicinesLoaded extends PrescriptionState {
  final List<MedicineEntity> medicines;
  MedicinesLoaded(this.medicines);
}

class MedicineLoaded extends PrescriptionState {
  final MedicineEntity medicine;
  MedicineLoaded(this.medicine);
}

class PrescriptionsListLoaded extends PrescriptionState {
  final List<PrescriptionEntity> prescriptions;
  PrescriptionsListLoaded(this.prescriptions);
}

class PrescriptionDetailLoaded extends PrescriptionState {
  final PrescriptionEntity prescription;
  PrescriptionDetailLoaded(this.prescription);
}

class PrescriptionItemsLoaded extends PrescriptionState {
  final List<PrescriptionItemEntity> items;
  PrescriptionItemsLoaded(this.items);
}

class PrescriptionOperationSuccess extends PrescriptionState {
  final String message;
  PrescriptionOperationSuccess(this.message);
}

class PrescriptionError extends PrescriptionState {
  final String message;
  PrescriptionError(this.message);
}

class PrescriptionBloc extends Bloc<PrescriptionEvent, PrescriptionState> {
  final PrescriptionRepository repository;

  PrescriptionBloc(this.repository) : super(PrescriptionInitial()) {
    on<LoadMedicines>(_onLoadMedicines);
    on<LoadMedicineById>(_onLoadMedicineById);
    on<CreateMedicine>(_onCreateMedicine);
    on<UpdateMedicine>(_onUpdateMedicine);
    on<DeleteMedicine>(_onDeleteMedicine);
    on<LoadPrescriptions>(_onLoadPrescriptions);
    on<LoadPrescriptionById>(_onLoadPrescriptionById);
    on<CreatePrescription>(_onCreatePrescription);
    on<UpdatePrescription>(_onUpdatePrescription);
    on<DeletePrescription>(_onDeletePrescription);
    on<LoadPrescriptionItems>(_onLoadPrescriptionItems);
    on<CreatePrescriptionItem>(_onCreatePrescriptionItem);
    on<UpdatePrescriptionItem>(_onUpdatePrescriptionItem);
    on<DeletePrescriptionItem>(_onDeletePrescriptionItem);
  }

  Future<void> _onLoadMedicines(LoadMedicines event, Emitter<PrescriptionState> emit) async {
    emit(PrescriptionLoading());
    try {
      final medicines = await repository.getAllMedicines(search: event.search, manufacturer: event.manufacturer);
      emit(MedicinesLoaded(medicines));
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }

  Future<void> _onLoadMedicineById(LoadMedicineById event, Emitter<PrescriptionState> emit) async {
    emit(PrescriptionLoading());
    try {
      final medicine = await repository.getMedicineById(event.id);
      if (medicine != null) {
        emit(MedicineLoaded(medicine));
      } else {
        emit(PrescriptionError('Medicine not found'));
      }
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }

  Future<void> _onCreateMedicine(CreateMedicine event, Emitter<PrescriptionState> emit) async {
    try {
      await repository.createMedicine(event.medicine);
      final medicines = await repository.getAllMedicines();
      emit(MedicinesLoaded(medicines));
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }

  Future<void> _onUpdateMedicine(UpdateMedicine event, Emitter<PrescriptionState> emit) async {
    try {
      await repository.updateMedicine(event.medicine);
      final medicines = await repository.getAllMedicines();
      emit(MedicinesLoaded(medicines));
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }

  Future<void> _onDeleteMedicine(DeleteMedicine event, Emitter<PrescriptionState> emit) async {
    try {
      await repository.deleteMedicine(event.id);
      final medicines = await repository.getAllMedicines();
      emit(MedicinesLoaded(medicines));
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }

  Future<void> _onLoadPrescriptions(LoadPrescriptions event, Emitter<PrescriptionState> emit) async {
    emit(PrescriptionLoading());
    try {
      final prescriptions = await repository.getPrescriptions(event.medicalRecordId);
      emit(PrescriptionsListLoaded(prescriptions));
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }

  Future<void> _onLoadPrescriptionById(LoadPrescriptionById event, Emitter<PrescriptionState> emit) async {
    emit(PrescriptionLoading());
    try {
      final prescription = await repository.getPrescriptionById(event.id);
      if (prescription != null) {
        emit(PrescriptionDetailLoaded(prescription));
      } else {
        emit(PrescriptionError('Prescription not found'));
      }
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }

  Future<void> _onCreatePrescription(CreatePrescription event, Emitter<PrescriptionState> emit) async {
    try {
      await repository.createPrescription(event.medicalRecordId, event.prescription);
      final prescriptions = await repository.getPrescriptions(event.medicalRecordId);
      emit(PrescriptionsListLoaded(prescriptions));
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }

  Future<void> _onUpdatePrescription(UpdatePrescription event, Emitter<PrescriptionState> emit) async {
    try {
      await repository.updatePrescription(event.prescription);
      emit(PrescriptionOperationSuccess('Prescription updated'));
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }

  Future<void> _onDeletePrescription(DeletePrescription event, Emitter<PrescriptionState> emit) async {
    try {
      await repository.deletePrescription(event.id);
      emit(PrescriptionOperationSuccess('Prescription deleted'));
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }

  Future<void> _onLoadPrescriptionItems(LoadPrescriptionItems event, Emitter<PrescriptionState> emit) async {
    emit(PrescriptionLoading());
    try {
      final items = await repository.getPrescriptionItems(event.prescriptionId);
      emit(PrescriptionItemsLoaded(items));
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }

  Future<void> _onCreatePrescriptionItem(CreatePrescriptionItem event, Emitter<PrescriptionState> emit) async {
    try {
      await repository.createPrescriptionItem(event.prescriptionId, event.item);
      final items = await repository.getPrescriptionItems(event.prescriptionId);
      emit(PrescriptionItemsLoaded(items));
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }

  Future<void> _onUpdatePrescriptionItem(UpdatePrescriptionItem event, Emitter<PrescriptionState> emit) async {
    try {
      await repository.updatePrescriptionItem(event.item);
      emit(PrescriptionOperationSuccess('Item updated'));
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }

  Future<void> _onDeletePrescriptionItem(DeletePrescriptionItem event, Emitter<PrescriptionState> emit) async {
    try {
      await repository.deletePrescriptionItem(event.id);
      emit(PrescriptionOperationSuccess('Item deleted'));
    } catch (e) {
      emit(PrescriptionError(e.toString()));
    }
  }
}
