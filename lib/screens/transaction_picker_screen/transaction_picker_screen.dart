import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/screens/transaction_picker_screen/widgets/info_button.dart';
import 'package:heist/themes/global_colors.dart';

import 'bloc/transaction_picker_screen_bloc.dart';
import 'widgets/transaction_picker_body.dart';

class TransactionPickerScreen extends StatelessWidget {
  final Business _business;
  final bool _fromSettings;

  const TransactionPickerScreen({
    required Business business,
    required bool fromSettings,
    Key? key
  })
    : _business = business,
      _fromSettings = fromSettings,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BottomModalAppBar(
        backgroundColor: Theme.of(context).colorScheme.topAppBar,
        trailingWidget: const InfoButton()
      ),
      body: BlocProvider<TransactionPickerScreenBloc>(
        create: (BuildContext context) => TransactionPickerScreenBloc(
          transactionRepository: RepositoryProvider.of<TransactionRepository>(context),
          activeLocationBloc: BlocProvider.of<ActiveLocationBloc>(context),
          openTransactionsBloc: BlocProvider.of<OpenTransactionsBloc>(context)
        )
          ..add(Fetch(businessIdentifier: _business.identifier)),
        child: TransactionPickerBody(businessIdentifier: _business.identifier, fromSettings: _fromSettings,),
      ),
    );
  }
}