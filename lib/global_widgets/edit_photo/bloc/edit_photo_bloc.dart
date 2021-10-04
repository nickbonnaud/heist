import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
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
      super(PhotoUnchanged()) { _eventHandler(); }

  void _eventHandler() {
    on<ChangePhoto>((event, emit) => _mapChangePhotoToState(event: event, emit: emit));
    on<ResetPhotoForm>((event, emit) => _mapResetPhotoFormToState(emit: emit));
  }

  void _mapChangePhotoToState({required ChangePhoto event, required Emitter<EditPhotoState> emit}) async {
    emit(Submitting(photo: event.photo));
    try {
      Customer customer = await _photoRepository.upload(photo: event.photo, profileIdentifier: event.profileIdentifier);
      emit(SubmitSuccess(photo: event.photo));
      _customerBloc.add(CustomerUpdated(customer: customer));
    } catch (_) {
      emit(SubmitFailed());
    }
  }

  void _mapResetPhotoFormToState({required Emitter<EditPhotoState> emit}) async {
    emit(PhotoUnchanged());
  }
}
