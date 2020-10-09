part of 'boot_bloc.dart';

abstract class BootEvent extends Equatable {
  const BootEvent();

  @override
  List<Object> get props => [];
}

class CustomerStatusChanged extends BootEvent {
  final Status customerStatus;

  const CustomerStatusChanged({@required this.customerStatus});

  @override
  List<Object> get props => [customerStatus];

  @override
  String toString() => 'CustomerStatusChanged { customerStatus: $customerStatus }';
}

class PermissionChecksComplete extends BootEvent {
  final bool permissionsReady;

  const PermissionChecksComplete({@required this.permissionsReady});

  @override
  List<Object> get props => [permissionsReady];

  @override
  String toString() => 'PermissionChecksComplete { permissionsReady: $permissionsReady }';
}

class AuthCheckComplete extends BootEvent {
  final bool isAuthenticated;
  
  const AuthCheckComplete({@required this.isAuthenticated});

  @override
  List<Object> get props => [isAuthenticated];

  @override
  String toString() => 'AuthCheckComplete { isAuthenticated: $isAuthenticated }';
}

class DataLoaded extends BootEvent {
  final DataType type;

  const DataLoaded({@required this.type});

  @override
  List<Object> get props => [type];

  @override
  String toString() => 'DataLoaded { type: $type }';
}