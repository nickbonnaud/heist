import 'dart:async';

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
      super(CancelIssueFormState.initial(transactionResource: transactionResource));

  @override
  Stream<CancelIssueFormState> mapEventToState(CancelIssueFormEvent event) async* {
    if (event is Submitted) {
      yield* _mapSubmittedToState(event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<CancelIssueFormState> _mapSubmittedToState(Submitted event) async* {
    yield state.update(isSubmitting: true);
    try {
      TransactionResource transaction = await _issueRepository.cancelIssue(issueId: event.issueIdentifier);
      _openTransactionsBloc.add(UpdateOpenTransaction(transaction: transaction));
      yield state.update(isSubmitting: false, isSuccess: true, transactionResource: transaction);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, errorMessage: exception.error);
    }
  }

  Stream<CancelIssueFormState> _mapResetToState() async* {
    yield state.update(isSuccess: false, errorMessage: "");
  }
}
