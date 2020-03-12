part of 'permission_screen_bloc.dart';

@immutable
class PermissionScreenState {
  final PermissionType current;
  final PermissionType next;
  final List<PermissionType> incomplete;

  PermissionScreenState({@required this.current, @required this.next, @required this.incomplete});

  factory PermissionScreenState.init({@required PermissionType current, @required PermissionType next, @required List<PermissionType> incomplete}) {
    return PermissionScreenState(current: current, next: next, incomplete: incomplete);
  }

  PermissionScreenState update({@required current, @required next, @required incomplete}) {
    return PermissionScreenState(
      current: current,
      next: next,
      incomplete: incomplete
    );
  }
}


