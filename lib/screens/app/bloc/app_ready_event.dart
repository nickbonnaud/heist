part of 'app_ready_bloc.dart';

abstract class AppReadyEvent extends Equatable {
  const AppReadyEvent();

  @override
  List<Object> get props => [];
}

class CustomerStatusChanged extends AppReadyEvent {
  final Status customerStatus;

  const CustomerStatusChanged({required this.customerStatus});

  @override
  List<Object> get props => [customerStatus];

  @override
  String toString() => 'CustomerStatusChanged { customerStatus: $customerStatus }';
}

class PermissionChecksComplete extends AppReadyEvent {
  final bool permissionsReady;

  const PermissionChecksComplete({required this.permissionsReady});

  @override
  List<Object> get props => [permissionsReady];

  @override
  String toString() => 'PermissionChecksComplete { permissionsReady: $permissionsReady }';
}

class AuthCheckComplete extends AppReadyEvent {
  final bool isAuthenticated;
  
  const AuthCheckComplete({required this.isAuthenticated});

  @override
  List<Object> get props => [isAuthenticated];

  @override
  String toString() => 'AuthCheckComplete { isAuthenticated: $isAuthenticated }';
}

class DataLoaded extends AppReadyEvent {
  final DataType type;

  const DataLoaded({required this.type});

  @override
  List<Object> get props => [type];

  @override
  String toString() => 'DataLoaded { type: $type }';
}