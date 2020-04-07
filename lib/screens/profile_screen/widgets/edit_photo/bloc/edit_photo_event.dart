part of 'edit_photo_bloc.dart';

abstract class EditPhotoEvent extends Equatable {
  const EditPhotoEvent();

  @override
  List<Object> get props => [];
}

class ChangePhoto extends EditPhotoEvent {
  final Customer customer;
  final File photo;

  ChangePhoto({@required this.customer, @required this.photo});

  @override
  List<Object> get props => [customer, photo];

  @override
  String toString() => 'ChangePhoto { customer: $customer, photo: $photo }';
}

class ResetPhotoForm extends EditPhotoEvent {}