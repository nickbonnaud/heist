part of 'edit_photo_bloc.dart';

abstract class EditPhotoEvent extends Equatable {
  const EditPhotoEvent();

  @override
  List<Object> get props => [];
}

class ChangePhoto extends EditPhotoEvent {
  final Profile profile;
  final PickedFile photo;

  ChangePhoto({required this.profile, required this.photo});

  @override
  List<Object> get props => [profile, photo];

  @override
  String toString() => 'ChangePhoto { profile: $profile, photo: $photo }';
}

class ResetPhotoForm extends EditPhotoEvent {}