part of 'cancel_issue_form_bloc.dart';


abstract class CancelIssueFormEvent extends Equatable {
  const CancelIssueFormEvent();

  @override
  List<Object> get props => [];
}

class Submitted extends CancelIssueFormEvent {
  final String issueIdentifier;

  const Submitted({@required this.issueIdentifier});

  @override
  List<Object> get props => [issueIdentifier];

  @override
  String toString() => 'Submitted { issueIdentifier: $issueIdentifier }';
}

class Reset extends CancelIssueFormEvent {}
