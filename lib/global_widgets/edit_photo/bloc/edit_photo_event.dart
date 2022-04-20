part of 'edit_photo_bloc.dart';

abstract class EditPhotoEvent extends Equatable {
  const EditPhotoEvent();

  @override
  List<Object> get props => [];
}

class ChangePhoto extends EditPhotoEvent {
  final String profileIdentifier;
  final XFile photo;

  const ChangePhoto({required this.profileIdentifier, required this.photo});

  @override
  List<Object> get props => [profileIdentifier, photo];

  @override
  String toString() => 'ChangePhoto { profileIdentifier: $profileIdentifier, photo: $photo }';
}

class ResetPhotoForm extends EditPhotoEvent {}