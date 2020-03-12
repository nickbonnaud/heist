part of 'permission_screen_bloc.dart';

@immutable
abstract class PermissionScreenEvent {}

class PermissionChanged extends PermissionScreenEvent {
  final PermissionType permissionType;

  PermissionChanged({@required this.permissionType});
}

