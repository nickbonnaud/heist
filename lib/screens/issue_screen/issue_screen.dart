import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/global_widgets/overlay_app_bar.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_issue_repository.dart';
import 'package:heist/resources/enums/issue_type.dart';
import 'package:heist/screens/issue_screen/widgets/cancel_issue_form/bloc/cancel_issue_form_bloc.dart';
import 'package:heist/screens/issue_screen/widgets/cancel_issue_form/cancel_issue_form.dart';

import 'bloc/issue_form_bloc.dart';
import 'widgets/issue_form.dart';


class IssueScreen extends StatelessWidget {
  final TransactionIssueRepository _issueRepository;
  final IssueType _type;
  final TransactionResource _transaction;

  IssueScreen({required TransactionIssueRepository issueRepository, required IssueType type, required TransactionResource transaction})
    : _issueRepository = issueRepository,
      _type = type,
      _transaction = transaction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: OverlayAppBar(context: context),
      body: _type != IssueType.cancel
        ? BlocProvider<IssueFormBloc>(
            create: (BuildContext context) => IssueFormBloc(
              issueRepository: _issueRepository,
              openTransactionsBloc: BlocProvider.of<OpenTransactionsBloc>(context),
              transactionResource: _transaction
            ),
            child: IssueForm(type: _type, transaction: _transaction),
          )
        : BlocProvider<CancelIssueFormBloc>(
          create: (BuildContext context) => CancelIssueFormBloc(
            issueRepository: _issueRepository,
            openTransactionsBloc: BlocProvider.of<OpenTransactionsBloc>(context),
            transactionResource: _transaction
          ),
          child: CancelIssueForm(transactionResource: _transaction),
        )
    );
  }
}