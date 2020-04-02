part of 'edit_photo_bloc.dart';

abstract class EditPhotoEvent extends Equatable {
  const EditPhotoEvent();
}

class EditPhotoBlocInit extends EditPhotoEvent {
  final Customer customer;

  EditPhotoBlocInit({@required this.customer});

  @override
  List<Object> get props => [customer];

  @override
  String toString() => 'ChangePhoto { customer: $customer }';
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