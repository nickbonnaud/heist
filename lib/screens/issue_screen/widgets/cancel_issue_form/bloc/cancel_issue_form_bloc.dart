import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_issue_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:meta/meta.dart';

part 'cancel_issue_form_event.dart';
part 'cancel_issue_form_state.dart';

class CancelIssueFormBloc extends Bloc<CancelIssueFormEvent, CancelIssueFormState> {
  final TransactionIssueRepository _issueRepository;
  final OpenTransactionsBloc _openTransactionsBloc;

  CancelIssueFormBloc({required TransactionIssueRepository issueRepository, required OpenTransactionsBloc openTransactionsBloc, required TransactionResource transactionResource})
    : _issueRepository = issueRepository,
      _openTransactionsBloc = openTransactionsBloc,
      super(CancelIssueFormState.initial(transactionResource: transactionResource)) {
        _eventHandler();
  }

  void _eventHandler() {
    on<Submitted>((event, emit) => _mapSubmittedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapSubmittedToState({required Submitted event, required Emitter<CancelIssueFormState> emit}) async {
    emit(state.update(isSubmitting: true));
    try {
      TransactionResource transaction = await _issueRepository.cancelIssue(issueId: event.issueIdentifier);
      _openTransactionsBloc.add(UpdateOpenTransaction(transaction: transaction));
      emit(state.update(isSubmitting: false, isSuccess: true, transactionResource: transaction));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error));
    }
  }

  void _mapResetToState({required Emitter<CancelIssueFormState> emit}) async {
    emit(state.update(isSuccess: false, errorMessage: ""));
  }
}
