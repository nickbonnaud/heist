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

class PermissionChecksComplete extends BootEvent {}

class DataLoaded extends BootEvent {
  final DataType type;

  const DataLoaded({@required this.type});

  @override
  List<Object> get props => [type];

  @override
  String toString() => 'DataLoaded { type: $type }';
}