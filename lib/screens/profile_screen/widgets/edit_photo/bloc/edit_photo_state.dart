part of 'edit_photo_bloc.dart';

abstract class EditPhotoState extends Equatable {
  const EditPhotoState();

  @override
  List<Object> get props => [];
}

class EditPhotoInit extends EditPhotoState {}

class PhotoUnchanged extends EditPhotoState {
  final Customer customer;

  PhotoUnchanged({@required this.customer});

  @override
  List<Object> get props => [customer];

  @override
  String toString() => 'PhotoUnchanged { customer: $customer }';
}

class Submitting extends EditPhotoState {
  final File photo;

  Submitting({@required this.photo});

  @override
  List<Object> get props => [photo];

  @override
  String toString() => 'Submitting { photo: $photo }';
}

class SubmitSuccess extends EditPhotoState {
  final File photo;

  SubmitSuccess({@required this.photo});

  @override
  List<Object> get props => [photo];

  @override
  String toString() => 'SubmitSuccess { photo: $photo }';
}

class SubmitFailed extends EditPhotoState {
  final Customer customer;

  SubmitFailed({@required this.customer});

  @override
  List<Object> get props => [customer];

  @override
  String toString() => 'SubmitFailed { customer: $customer }';
}
