import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/entities/user_entity.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/repositories/user_repository.dart';

abstract class UserEvent {}

class LoadUsers extends UserEvent {
  final String? role;
  final String? search;
  final String? gender;
  final bool? isActive;
  LoadUsers({this.role, this.search, this.gender, this.isActive});
}

class LoadUserById extends UserEvent {
  final String id;
  LoadUserById(this.id);
}

class UpdateUser extends UserEvent {
  final String id;
  final Map<String, dynamic> data;
  UpdateUser(this.id, this.data);
}

class ToggleUserActive extends UserEvent {
  final String id;
  ToggleUserActive(this.id);
}

class DeleteUser extends UserEvent {
  final String id;
  DeleteUser(this.id);
}

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<UserEntity> users;
  UsersLoaded(this.users);
}

class UserLoaded extends UserState {
  final UserEntity user;
  UserLoaded(this.user);
}

class UserOperationSuccess extends UserState {
  final String message;
  UserOperationSuccess(this.message);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc(this.repository) : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<LoadUserById>(_onLoadUserById);
    on<UpdateUser>(_onUpdateUser);
    on<ToggleUserActive>(_onToggleActive);
    on<DeleteUser>(_onDeleteUser);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await repository.getAllUsers(role: event.role, search: event.search, gender: event.gender, isActive: event.isActive);
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onLoadUserById(LoadUserById event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await repository.getUserById(event.id);
      if (user != null) { emit(UserLoaded(user)); } else { emit(UserError(AppStrings.opUserNotFound)); }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    try {
      await repository.updateUser(event.id, event.data);
      emit(UserOperationSuccess(AppStrings.opUserUpdated));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onToggleActive(ToggleUserActive event, Emitter<UserState> emit) async {
    try {
      final isActive = await repository.toggleActive(event.id);
      emit(UserOperationSuccess(isActive ? AppStrings.opUserActivated : AppStrings.opUserDeactivated));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    try {
      await repository.deleteUser(event.id);
      emit(UserOperationSuccess(AppStrings.opUserDeleted));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
