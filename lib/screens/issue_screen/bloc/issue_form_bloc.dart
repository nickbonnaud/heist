import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_issue_repository.dart';
import 'package:heist/resources/enums/issue_type.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'issue_form_event.dart';
part 'issue_form_state.dart';


class IssueFormBloc extends Bloc<IssueFormEvent, IssueFormState> {
  final TransactionIssueRepository _issueRepository;
  final OpenTransactionsBloc _openTransactionsBloc;

  IssueFormBloc({required TransactionIssueRepository issueRepository, required OpenTransactionsBloc openTransactionsBloc, required TransactionResource transactionResource})
    : _issueRepository = issueRepository,
      _openTransactionsBloc = openTransactionsBloc,
      super(IssueFormState.initial(transactionResource: transactionResource));

  @override
  Stream<Transition<IssueFormEvent, IssueFormState>> transformEvents(Stream<IssueFormEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => event is !MessageChanged);
    final debounceStream = events.where((event) => event is MessageChanged)
      .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<IssueFormState> mapEventToState(IssueFormEvent event) async* {
    if (event is MessageChanged) {
      yield* _mapMessageChangedToState(event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<IssueFormState> _mapMessageChangedToState(MessageChanged event) async* {
    yield state.update(isMessageValid: event.message.length >=5);
  }

  Stream<IssueFormState> _mapSubmittedToState(Submitted event) async* {
    yield state.update(isSubmitting: true);
    try {
      TransactionResource transaction = await _issueRepository.reportIssue(type: event.type, transactionId: event.transaction.transaction.identifier, message: event.message);
      _openTransactionsBloc.add(UpdateOpenTransaction(transaction: transaction));
      yield state.update(isSubmitting: false, isSuccess: true, transactionResource: transaction);
    } catch (_) {
      yield state.update(isSubmitting: false, isFailure: true);
    }
  }

  Stream<IssueFormState> _mapResetToState() async* {
    yield state.update(isSuccess: false, isFailure: false);
  }
}
