import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_issue_repository.dart';
import 'package:heist/resources/enums/issue_type.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/resources/helpers/debouncer.dart';
import 'package:meta/meta.dart';

part 'issue_form_event.dart';
part 'issue_form_state.dart';


class IssueFormBloc extends Bloc<IssueFormEvent, IssueFormState> {
  final TransactionIssueRepository _issueRepository;
  final OpenTransactionsBloc _openTransactionsBloc;

  IssueFormBloc({
    required TransactionIssueRepository issueRepository,
    required OpenTransactionsBloc openTransactionsBloc,
    required TransactionResource transactionResource,
    required IssueType issueType
  })
    : _issueRepository = issueRepository,
      _openTransactionsBloc = openTransactionsBloc,
      super(IssueFormState.initial(transactionResource: transactionResource, issueType: issueType)) { _eventHandler(); }

  void _eventHandler() {
    on<MessageChanged>((event, emit) => _mapMessageChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: const Duration(milliseconds: 300)));
    on<Submitted>((event, emit) async => await _mapSubmittedToState(emit: emit));
    on<Updated>((event, emit) async => await _mapUpdatedToState(emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapMessageChangedToState({required MessageChanged event, required Emitter<IssueFormState> emit}) {
    emit(state.update(message: event.message, isMessageValid: event.message.length >=5));
  }

  Future<void> _mapSubmittedToState({required Emitter<IssueFormState> emit}) async {
    emit(state.update(isSubmitting: true));

    try {
      TransactionResource transaction = await _issueRepository.reportIssue(
        type: state.issueType,
        transactionId: state.transactionResource.transaction.identifier,
        message: state.message
      );

      _openTransactionsBloc.add(UpdateOpenTransaction(transaction: transaction));
      emit(state.update(isSubmitting: false, isSuccess: true, transactionResource: transaction));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error));
    }
  }

  Future<void> _mapUpdatedToState({required Emitter<IssueFormState> emit}) async {
    emit(state.update(isSubmitting: true));

    try {
      TransactionResource transaction= await _issueRepository.changeIssue(
        type: state.issueType,
        issueId: state.transactionResource.issue!.identifier,
        message: state.message
      );

      _openTransactionsBloc.add(UpdateOpenTransaction(transaction: transaction));
      emit(state.update(isSubmitting: false, isSuccess: true, transactionResource: transaction));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error));
    }
  }

  void _mapResetToState({required Emitter<IssueFormState> emit}) {
    emit(state.update(isSuccess: false, errorMessage: ""));
  }
}
