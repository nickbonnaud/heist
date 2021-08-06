import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/customer/profile.dart';
import 'package:heist/repositories/photo_repository.dart';
import 'package:image_picker/image_picker.dart';

part 'edit_photo_event.dart';
part 'edit_photo_state.dart';

class EditPhotoBloc extends Bloc<EditPhotoEvent, EditPhotoState> {
  final PhotoRepository _photoRepository;
  final CustomerBloc _customerBloc;

  EditPhotoBloc({required PhotoRepository photoRepository, required CustomerBloc customerBloc})
    : _photoRepository = photoRepository,
      _customerBloc = customerBloc,
      super(PhotoUnchanged());

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
      Customer customer = await _photoRepository.upload(photo: event.photo, profileIdentifier: event.profileIdentifier);
      yield SubmitSuccess(photo: event.photo);
      _customerBloc.add(CustomerUpdated(customer: customer));
    } catch (_) {
      yield SubmitFailed();
    }
  }
}
