import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/validators.dart';

part 'search_identifier_modal_event.dart';
part 'search_identifier_modal_state.dart';

class SearchIdentifierModalBloc extends Bloc<SearchIdentifierModalEvent, SearchIdentifierModalState> {
  SearchIdentifierModalBloc()
    : super(SearchIdentifierModalState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<UUIDChanged>((event, emit) => _mapUUIDChangedToState(event: event, emit: emit));
  }

  void _mapUUIDChangedToState({required UUIDChanged event, required Emitter<SearchIdentifierModalState> emit}) {
    emit(state.update(isUUIDValid: Validators.isValidUUID(uuid: event.uuid), uuid: event.uuid));
  }
}
