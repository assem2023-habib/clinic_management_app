import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/domain/entities/role_entity.dart';
import 'package:clinic_management_app/domain/entities/permission_entity.dart';
import 'package:clinic_management_app/domain/repositories/rbac_repository.dart';

abstract class RbacEvent {}

class LoadRoles extends RbacEvent {
  final String? search;
  LoadRoles({this.search});
}

class LoadRoleById extends RbacEvent {
  final String id;
  LoadRoleById(this.id);
}

class CreateRoleEvent extends RbacEvent {
  final RoleEntity role;
  CreateRoleEvent(this.role);
}

class UpdateRoleEvent extends RbacEvent {
  final RoleEntity role;
  UpdateRoleEvent(this.role);
}

class DeleteRoleEvent extends RbacEvent {
  final String id;
  DeleteRoleEvent(this.id);
}

class SyncPermissions extends RbacEvent {
  final String roleId;
  final List<String> permissionSlugs;
  SyncPermissions(this.roleId, this.permissionSlugs);
}

class LoadPermissions extends RbacEvent {
  final String? group;
  final String? search;
  LoadPermissions({this.group, this.search});
}

class LoadPermissionById extends RbacEvent {
  final String id;
  LoadPermissionById(this.id);
}

class CreatePermissionEvent extends RbacEvent {
  final PermissionEntity permission;
  CreatePermissionEvent(this.permission);
}

class UpdatePermissionEvent extends RbacEvent {
  final PermissionEntity permission;
  UpdatePermissionEvent(this.permission);
}

class DeletePermissionEvent extends RbacEvent {
  final String id;
  DeletePermissionEvent(this.id);
}

class LoadUserRoles extends RbacEvent {
  final String userId;
  LoadUserRoles(this.userId);
}

class SyncUserRoles extends RbacEvent {
  final String userId;
  final List<String> roleSlugs;
  SyncUserRoles(this.userId, this.roleSlugs);
}

abstract class RbacState {}

class RbacInitial extends RbacState {}

class RbacLoading extends RbacState {}

class RolesLoaded extends RbacState {
  final List<RoleEntity> roles;
  RolesLoaded(this.roles);
}

class RoleLoaded extends RbacState {
  final RoleEntity role;
  RoleLoaded(this.role);
}

class PermissionsLoaded extends RbacState {
  final List<PermissionEntity> permissions;
  PermissionsLoaded(this.permissions);
}

class PermissionLoaded extends RbacState {
  final PermissionEntity permission;
  PermissionLoaded(this.permission);
}

class UserRolesLoaded extends RbacState {
  final List<RoleEntity> roles;
  UserRolesLoaded(this.roles);
}

class RbacOperationSuccess extends RbacState {
  final String message;
  RbacOperationSuccess(this.message);
}

class RbacError extends RbacState {
  final String message;
  RbacError(this.message);
}

class RbacBloc extends Bloc<RbacEvent, RbacState> {
  final RbacRepository repository;

  RbacBloc(this.repository) : super(RbacInitial()) {
    on<LoadRoles>(_onLoadRoles);
    on<LoadRoleById>(_onLoadRoleById);
    on<CreateRoleEvent>(_onCreateRole);
    on<UpdateRoleEvent>(_onUpdateRole);
    on<DeleteRoleEvent>(_onDeleteRole);
    on<SyncPermissions>(_onSyncPermissions);
    on<LoadPermissions>(_onLoadPermissions);
    on<LoadPermissionById>(_onLoadPermissionById);
    on<CreatePermissionEvent>(_onCreatePermission);
    on<UpdatePermissionEvent>(_onUpdatePermission);
    on<DeletePermissionEvent>(_onDeletePermission);
    on<LoadUserRoles>(_onLoadUserRoles);
    on<SyncUserRoles>(_onSyncUserRoles);
  }

  Future<void> _onLoadRoles(LoadRoles event, Emitter<RbacState> emit) async {
    emit(RbacLoading());
    try {
      final roles = await repository.getRoles(search: event.search);
      emit(RolesLoaded(roles));
    } catch (e) {
      emit(RbacError(e.toString()));
    }
  }

  Future<void> _onLoadRoleById(LoadRoleById event, Emitter<RbacState> emit) async {
    emit(RbacLoading());
    try {
      final role = await repository.getRoleById(event.id);
      if (role != null) { emit(RoleLoaded(role)); } else { emit(RbacError('Role not found')); }
    } catch (e) {
      emit(RbacError(e.toString()));
    }
  }

  Future<void> _onCreateRole(CreateRoleEvent event, Emitter<RbacState> emit) async {
    try {
      await repository.createRole(event.role);
      final roles = await repository.getRoles();
      emit(RolesLoaded(roles));
    } catch (e) {
      emit(RbacError(e.toString()));
    }
  }

  Future<void> _onUpdateRole(UpdateRoleEvent event, Emitter<RbacState> emit) async {
    try {
      await repository.updateRole(event.role);
      emit(RbacOperationSuccess('Role updated'));
    } catch (e) {
      emit(RbacError(e.toString()));
    }
  }

  Future<void> _onDeleteRole(DeleteRoleEvent event, Emitter<RbacState> emit) async {
    try {
      await repository.deleteRole(event.id);
      final roles = await repository.getRoles();
      emit(RolesLoaded(roles));
    } catch (e) {
      emit(RbacError(e.toString()));
    }
  }

  Future<void> _onSyncPermissions(SyncPermissions event, Emitter<RbacState> emit) async {
    emit(RbacLoading());
    try {
      final role = await repository.syncPermissions(event.roleId, event.permissionSlugs);
      emit(RoleLoaded(role));
    } catch (e) {
      emit(RbacError(e.toString()));
    }
  }

  Future<void> _onLoadPermissions(LoadPermissions event, Emitter<RbacState> emit) async {
    emit(RbacLoading());
    try {
      final permissions = await repository.getPermissions(group: event.group, search: event.search);
      emit(PermissionsLoaded(permissions));
    } catch (e) {
      emit(RbacError(e.toString()));
    }
  }

  Future<void> _onLoadPermissionById(LoadPermissionById event, Emitter<RbacState> emit) async {
    emit(RbacLoading());
    try {
      final permission = await repository.getPermissionById(event.id);
      if (permission != null) { emit(PermissionLoaded(permission)); } else { emit(RbacError('Permission not found')); }
    } catch (e) {
      emit(RbacError(e.toString()));
    }
  }

  Future<void> _onCreatePermission(CreatePermissionEvent event, Emitter<RbacState> emit) async {
    try {
      await repository.createPermission(event.permission);
      final permissions = await repository.getPermissions();
      emit(PermissionsLoaded(permissions));
    } catch (e) {
      emit(RbacError(e.toString()));
    }
  }

  Future<void> _onUpdatePermission(UpdatePermissionEvent event, Emitter<RbacState> emit) async {
    try {
      await repository.updatePermission(event.permission);
      emit(RbacOperationSuccess('Permission updated'));
    } catch (e) {
      emit(RbacError(e.toString()));
    }
  }

  Future<void> _onDeletePermission(DeletePermissionEvent event, Emitter<RbacState> emit) async {
    try {
      await repository.deletePermission(event.id);
      final permissions = await repository.getPermissions();
      emit(PermissionsLoaded(permissions));
    } catch (e) {
      emit(RbacError(e.toString()));
    }
  }

  Future<void> _onLoadUserRoles(LoadUserRoles event, Emitter<RbacState> emit) async {
    emit(RbacLoading());
    try {
      final roles = await repository.getUserRoles(event.userId);
      emit(UserRolesLoaded(roles));
    } catch (e) {
      emit(RbacError(e.toString()));
    }
  }

  Future<void> _onSyncUserRoles(SyncUserRoles event, Emitter<RbacState> emit) async {
    emit(RbacLoading());
    try {
      final roles = await repository.syncUserRoles(event.userId, event.roleSlugs);
      emit(UserRolesLoaded(roles));
    } catch (e) {
      emit(RbacError(e.toString()));
    }
  }
}
