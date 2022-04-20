import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/account_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/resources/helpers/debouncer.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:meta/meta.dart';

part 'setup_tip_card_event.dart';
part 'setup_tip_card_state.dart';

class SetupTipCardBloc extends Bloc<SetupTipCardEvent, SetupTipCardState> {
  final AccountRepository _accountRepository;
  final CustomerBloc _customerBloc;

  final Duration _debounceTime = const Duration(milliseconds: 300);

  SetupTipCardBloc({required AccountRepository accountRepository, required CustomerBloc customerBloc})
    : _accountRepository = accountRepository,
      _customerBloc = customerBloc,
      super(SetupTipCardState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<TipRateChanged>((event, emit) => _mapTipRateChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<QuickTipRateChanged>((event, emit) => _mapQuickTipRateChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<Submitted>((event, emit) async => await _mapSubmittedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapTipRateChangedToState({required TipRateChanged event, required Emitter<SetupTipCardState> emit}) {
    emit(state.update(isTipRateValid: Validators.isValidDefaultTip(tip: event.tipRate)));
  }

  void _mapQuickTipRateChangedToState({required QuickTipRateChanged event, required Emitter<SetupTipCardState> emit}) {
    emit(state.update(isQuickTipRateValid: Validators.isValidQuickTip(tip: event.quickTipRate)));
  }

  Future<void> _mapSubmittedToState({required Submitted event, required Emitter<SetupTipCardState> emit}) async {
    emit(state.update(isSubmitting: true));
    try {
      Customer customer = await _accountRepository.update(accountIdentifier: event.accountIdentifier, tipRate: event.tipRate, quickTipRate: event.quickTipRate);
      _customerBloc.add(CustomerUpdated(customer: customer));
      emit(state.update(isSubmitting: false, isSuccess: true));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error));
    }
  }

  void _mapResetToState({required Emitter<SetupTipCardState> emit}) {
    emit(state.update(isSuccess: false, errorMessage: ""));
  }
}
