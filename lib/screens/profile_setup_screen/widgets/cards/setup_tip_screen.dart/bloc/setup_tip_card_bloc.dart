import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/account_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'setup_tip_card_event.dart';
part 'setup_tip_card_state.dart';

class SetupTipCardBloc extends Bloc<SetupTipCardEvent, SetupTipCardState> {
  final AccountRepository _accountRepository;
  final CustomerBloc _customerBloc;

  SetupTipCardBloc({required AccountRepository accountRepository, required CustomerBloc customerBloc})
    : _accountRepository = accountRepository,
      _customerBloc = customerBloc,
      super(SetupTipCardState.initial());

  @override
  Stream<Transition<SetupTipCardEvent, SetupTipCardState>> transformEvents(Stream<SetupTipCardEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => event is !TipRateChanged && event is !QuickTipRateChanged);
    final debounceStream = events.where((event) => event is TipRateChanged || event is QuickTipRateChanged)
      .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<SetupTipCardState> mapEventToState(SetupTipCardEvent event) async* {
    if (event is TipRateChanged) {
      yield* _mapTipRateChangedToState(event);
    } else if (event is QuickTipRateChanged) {
      yield* _mapQuickTipRateChangedToState(event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<SetupTipCardState> _mapTipRateChangedToState(TipRateChanged event) async* {
    yield state.update(isTipRateValid: Validators.isValidDefaultTip(tip: event.tipRate));
  }

  Stream<SetupTipCardState> _mapQuickTipRateChangedToState(QuickTipRateChanged event) async* {
    yield state.update(isQuickTipRateValid: Validators.isValidQuickTip(tip: event.quickTipRate));
  }

  Stream<SetupTipCardState> _mapSubmittedToState(Submitted event) async* {
    yield state.update(isSubmitting: true);
    try {
      Customer customer = await _accountRepository.update(accountIdentifier: event.accountIdentifier, tipRate: event.tipRate, quickTipRate: event.quickTipRate);
      _customerBloc.add(CustomerUpdated(customer: customer));
      yield state.update(isSubmitting: false, isSuccess: true);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, errorMessage: exception.error);
    }
  }

  Stream<SetupTipCardState> _mapResetToState() async* {
    yield state.update(isSuccess: false, errorMessage: "");
  }
}
