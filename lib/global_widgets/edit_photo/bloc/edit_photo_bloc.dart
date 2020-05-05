import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/customer/photos.dart';
import 'package:heist/models/customer/profile.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:meta/meta.dart';

part 'edit_photo_event.dart';
part 'edit_photo_state.dart';

class EditPhotoBloc extends Bloc<EditPhotoEvent, EditPhotoState> {
  final ProfileRepository _profileRepository;
  final CustomerBloc _customerBloc;

  EditPhotoBloc({@required ProfileRepository profileRepository, @required CustomerBloc customerBloc})
    : assert(profileRepository != null, customerBloc != null),
      _profileRepository = profileRepository,
      _customerBloc = customerBloc;
  
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
      Photos photos = await _profileRepository.uploadPhoto(photo: event.photo, profileIdentifier: event.customer.profile.identifier);
      Profile profile = event.customer.profile.update(photos: photos);
      Customer customer = event.customer.update(profile: profile);
      yield SubmitSuccess(photo: event.photo);
      _customerBloc.add(UpdateCustomer(customer: customer));
    } catch (_) {
      yield SubmitFailed();
    }
  }
}
