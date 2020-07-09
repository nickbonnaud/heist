import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/screens/transaction_picker_screen/widgets/info_button.dart';
import 'package:heist/themes/global_colors.dart';

import 'bloc/transaction_picker_screen_bloc.dart';
import 'widgets/transaction_picker_body.dart';

class TransactionPickerScreen extends StatelessWidget {
  final TransactionRepository _transactionRepository = TransactionRepository();
  final Business _business;

  TransactionPickerScreen({@required Business business})
    : assert(business != null),
      _business = business;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BottomModalAppBar(backgroundColor: Theme.of(context).colorScheme.topAppBarLight, trailingWidget: InfoButton()),
      body: BlocProvider<TransactionPickerScreenBloc>(
        create: (BuildContext context) => TransactionPickerScreenBloc(transactionRepository: _transactionRepository)
          ..add(Fetch(businessIdentifier: _business.identifier)),
        child: TransactionPickerBody(),
      ),
    );
  }
}