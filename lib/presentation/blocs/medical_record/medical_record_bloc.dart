import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/repositories/medical_record_repository.dart';
import 'package:clinic_management_app/domain/entities/medical_record_entity.dart';

class MedicalRecordBloc extends Bloc<MedicalRecordEvent, MedicalRecordState> {
  final MedicalRecordRepository repository;

  MedicalRecordBloc(this.repository) : super(MedicalRecordInitial()) {
    on<MedicalRecordLoadAll>(_onLoadAll);
    on<MedicalRecordLoadMore>(_onLoadMore);
  }

  Future<void> _onLoadAll(MedicalRecordLoadAll event, Emitter<MedicalRecordState> emit) async {
    emit(MedicalRecordLoading());
    try {
      final records = await repository.getAllRecords(page: event.page, limit: event.limit);
      final hasMore = records.length >= event.limit;
      emit(MedicalRecordLoaded(records, hasMore: hasMore, page: event.page));
    } catch (e) {
      emit(MedicalRecordError(e.toString()));
    }
  }

  Future<void> _onLoadMore(MedicalRecordLoadMore event, Emitter<MedicalRecordState> emit) async {
    if (state is! MedicalRecordLoaded || (state as MedicalRecordLoaded).isLoadingMore) return;
    final current = state as MedicalRecordLoaded;
    emit(current.copyWith(isLoadingMore: true));
    try {
      final newRecords = await repository.getAllRecords(page: event.page, limit: event.limit);
      final all = [...current.records, ...newRecords];
      final hasMore = newRecords.length >= event.limit;
      emit(MedicalRecordLoaded(all, hasMore: hasMore, page: event.page));
    } catch (e) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }
}

abstract class MedicalRecordEvent {
  const MedicalRecordEvent();
}

class MedicalRecordLoadAll extends MedicalRecordEvent {
  final int page;
  final int limit;
  const MedicalRecordLoadAll({this.page = 1, this.limit = 20});
}

class MedicalRecordLoadMore extends MedicalRecordEvent {
  final int page;
  final int limit;
  const MedicalRecordLoadMore({this.page = 1, this.limit = 20});
}

abstract class MedicalRecordState {
  const MedicalRecordState();
}

class MedicalRecordInitial extends MedicalRecordState {
  const MedicalRecordInitial();
}

class MedicalRecordLoading extends MedicalRecordState {
  const MedicalRecordLoading();
}

class MedicalRecordLoaded extends MedicalRecordState {
  final List<MedicalRecordEntity> records;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;
  const MedicalRecordLoaded(this.records, {this.isLoadingMore = false, this.hasMore = true, this.page = 1});
  MedicalRecordLoaded copyWith({List<MedicalRecordEntity>? records, bool? isLoadingMore, bool? hasMore, int? page}) {
    return MedicalRecordLoaded(
      records ?? this.records,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}

class MedicalRecordError extends MedicalRecordState {
  final String message;
  const MedicalRecordError(this.message);
}
