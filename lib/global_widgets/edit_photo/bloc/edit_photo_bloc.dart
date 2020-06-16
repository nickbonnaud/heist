import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:meta/meta.dart';

part 'edit_photo_event.dart';
part 'edit_photo_state.dart';

class EditPhotoBloc extends Bloc<EditPhotoEvent, EditPhotoState> {
  final ProfileRepository _profileRepository;
  final AuthenticationBloc _authenticationBloc;

  EditPhotoBloc({@required ProfileRepository profileRepository, @required AuthenticationBloc authenticationBloc})
    : assert(profileRepository != null, authenticationBloc != null),
      _profileRepository = profileRepository,
      _authenticationBloc = authenticationBloc;
  
  @override
  EditPhotoState get initialState => PhotoUnchanged();

  @override
  Stream<EditPhotoState> mapEventToState(EditPhotoEvent event) async* {
    if (event is ChangePhoto) {
      yield* _mapChangePhotoToState(event);
    } else if (event is ResetPhotoForm) {
      yield PhotoUnchanged();
    }
  }

  Stream<EditPhotoState> _mapChangePhotoToState(ChangePhoto event) async* {
    yield Submitting(photo: event.photo);
    try {
      Customer customer = await _profileRepository.uploadPhoto(photo: event.photo, profileIdentifier: event.customer.profile.identifier);
      yield SubmitSuccess(photo: event.photo);
      _authenticationBloc.add(CustomerUpdated(customer: customer));
    } catch (_) {
      yield SubmitFailed();
    }
  }
}
