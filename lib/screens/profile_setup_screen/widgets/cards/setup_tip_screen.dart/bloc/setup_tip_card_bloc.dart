import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/account_repository.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'setup_tip_card_event.dart';
part 'setup_tip_card_state.dart';

class SetupTipCardBloc extends Bloc<SetupTipCardEvent, SetupTipScreenState> {
  final AccountRepository _accountRepository;
  final AuthenticationBloc _authenticationBloc;

  SetupTipCardBloc({@required AccountRepository accountRepository, @required AuthenticationBloc authenticationBloc})
    : assert(accountRepository != null && authenticationBloc != null),
      _accountRepository = accountRepository,
      _authenticationBloc = authenticationBloc,
      super(SetupTipScreenState.initial());

  @override
  Stream<Transition<SetupTipCardEvent, SetupTipScreenState>> transformEvents(Stream<SetupTipCardEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => event is !TipRateChanged && event is !QuickTipRateChanged);
    final debounceStream = events.where((event) => event is TipRateChanged || event is QuickTipRateChanged)
      .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<SetupTipScreenState> mapEventToState(SetupTipCardEvent event) async* {
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

  Stream<SetupTipScreenState> _mapTipRateChangedToState(TipRateChanged event) async* {
    yield state.update(isTipRateValid: Validators.isValidTip(event.tipRate));
  }

  Stream<SetupTipScreenState> _mapQuickTipRateChangedToState(QuickTipRateChanged event) async* {
    yield state.update(isQuickTipRateValid: Validators.isValidTip(event.quickTipRate));
  }

  Stream<SetupTipScreenState> _mapSubmittedToState(Submitted event) async* {
    yield state.update(isSubmitting: true);
    try {
      Customer customer = await _accountRepository.update(accountIdentifier: event.customer.account.identifier, tipRate: event.tipRate, quickTipRate: event.quickTipRate);
      _authenticationBloc.add(CustomerUpdated(customer: customer));
      yield state.update(isSubmitting: false, isSuccess: true);
    } catch (_) {
      yield state.update(isSubmitting: false, isFailure: true);
    }
  }

  Stream<SetupTipScreenState> _mapResetToState() async* {
    yield state.update(isSuccess: false, isFailure: false);
  }
}