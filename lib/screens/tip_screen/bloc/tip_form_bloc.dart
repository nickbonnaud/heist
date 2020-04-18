import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/account.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/account_repository.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'tip_form_event.dart';
part 'tip_form_state.dart';

class TipFormBloc extends Bloc<TipFormEvent, TipFormState> {
  final AccountRepository _accountRepository;
  final CustomerBloc _customerBloc;

  TipFormBloc({@required AccountRepository accountRepository, @required CustomerBloc customerBloc})
    : assert(accountRepository != null && customerBloc != null),
      _accountRepository = accountRepository,
      _customerBloc = customerBloc;
  
  @override
  TipFormState get initialState => TipFormState.initial();

  @override
  Stream<TipFormState> transformEvents(
    Stream<TipFormEvent> events,
    Stream<TipFormState> Function(TipFormEvent event) next
  ) {
    final nonDebounceStream = events.where((event) => event is !TipRateChanged && event is !QuickTipRateChanged);
    final debounceStream = events.where((event) => event is TipRateChanged || event is QuickTipRateChanged)
      .debounceTime(Duration(milliseconds: 300));
    
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }
  
  @override
  Stream<TipFormState> mapEventToState(TipFormEvent event) async* {
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

  Stream<TipFormState> _mapTipRateChangedToState(TipRateChanged event) async* {
    yield state.update(isTipRateValid: Validators.isValidTip(event.tipRate));
  }

  Stream<TipFormState> _mapQuickTipRateChangedToState(QuickTipRateChanged event) async* {
    yield state.update(isQuickTipRateValid: Validators.isValidTip(event.quickTipRate));
  }

  Stream<TipFormState> _mapSubmittedToState(Submitted event) async* {
    yield state.update(isSubmitting: true);
    try {
      Account account = await _accountRepository.update(accountIdentifier: event.customer.account.identifier, tipRate: event.tipRate, quickTipRate: event.quickTipRate);
      _customerBloc.add(UpdateCustomer(customer: event.customer.update(account: account)));
      yield state.update(isSubmitting: false, isSuccess: true);
    } catch (_) {
      yield state.update(isSubmitting: false, isFailure: true);
    }
  }

  Stream<TipFormState> _mapResetToState() async* {
    yield state.update(isSuccess: false, isFailure: false);
  }
}