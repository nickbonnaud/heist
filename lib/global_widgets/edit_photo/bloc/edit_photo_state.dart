part of 'edit_photo_bloc.dart';

abstract class EditPhotoState extends Equatable {
  const EditPhotoState();

  @override
  List<Object> get props => [];
}

class PhotoUnchanged extends EditPhotoState {}

class Submitting extends EditPhotoState {
  final XFile photo;

  const Submitting({required this.photo});

  @override
  List<Object> get props => [photo];

  @override
  String toString() => 'Submitting { photo: $photo }';
}

class SubmitSuccess extends EditPhotoState {
  final XFile photo;

  const SubmitSuccess({required this.photo});

  @override
  List<Object> get props => [photo];

  @override
  String toString() => 'SubmitSuccess { photo: $photo }';
}

class SubmitFailed extends EditPhotoState {}
