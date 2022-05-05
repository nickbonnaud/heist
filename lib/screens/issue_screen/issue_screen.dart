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
  final IssueType _type;
  final TransactionResource _transaction;

  const IssueScreen({required IssueType type, required TransactionResource transaction, Key? key})
    : _type = type,
      _transaction = transaction,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const OverlayAppBar(),
      body: _type != IssueType.cancel
        ? BlocProvider<IssueFormBloc>(
            create: (BuildContext context) => IssueFormBloc(
              issueRepository: RepositoryProvider.of<TransactionIssueRepository>(context),
              openTransactionsBloc: BlocProvider.of<OpenTransactionsBloc>(context),
              transactionResource: _transaction,
              issueType: _type
            ),
            child: const IssueForm(),
          )
        : BlocProvider<CancelIssueFormBloc>(
          create: (BuildContext context) => CancelIssueFormBloc(
            issueRepository: RepositoryProvider.of<TransactionIssueRepository>(context),
            openTransactionsBloc: BlocProvider.of<OpenTransactionsBloc>(context),
            transactionResource: _transaction
          ),
          child: CancelIssueForm(transactionResource: _transaction),
        )
    );
  }
}