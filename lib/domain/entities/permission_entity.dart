import 'package:equatable/equatable.dart';

class PermissionEntity extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? group;
  final String guardName;

  const PermissionEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.group,
    this.guardName = 'api',
  });

  PermissionEntity copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? group,
    String? guardName,
  }) {
    return PermissionEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      group: group ?? this.group,
      guardName: guardName ?? this.guardName,
    );
  }

  @override
  List<Object?> get props => [id, name, slug, description, group, guardName];
}
