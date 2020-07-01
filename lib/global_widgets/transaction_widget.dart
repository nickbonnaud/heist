import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/bloc/receipt_modal_sheet_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/receipt_screen/receipt_screen.dart';

import 'default_app_bar/bloc/default_app_bar_bloc.dart';

class TransactionWidget extends StatelessWidget {
  final TransactionResource _transactionResource;

  const TransactionWidget({Key key, @required TransactionResource transactionResource})
    : assert(transactionResource != null),
      _transactionResource = transactionResource,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(_transactionResource.business.photos.logo.smallUrl),
          radius: SizeConfig.getWidth(6),
        ),
        title: BoldText(
          text: _transactionResource.business.profile.name, 
          size: SizeConfig.getWidth(5), 
          color: Colors.black
        ),
        subtitle: NormalText(
          text: 'Total: ${Currency.create(cents: _transactionResource.transaction.total)}', 
          size: SizeConfig.getWidth(5), 
          color: Colors.black54
        ),
        trailing: NormalText(
          text: _transactionResource.transaction.billUpdatedAt, 
          size: SizeConfig.getWidth(5), 
          color: Colors.black54
        ),
        onTap: () => showFullTransaction(context),
      )
    );
  }

  void showFullTransaction(BuildContext context) {
    BlocProvider.of<DefaultAppBarBloc>(context).add(Rotate());
    showPlatformModalSheet(
      context: context, 
      builder: (_) => ReceiptScreen(transactionResource: _transactionResource, receiptModalSheetBloc: BlocProvider.of<ReceiptModalSheetBloc>(context))
    ).then((_) {
      BlocProvider.of<DefaultAppBarBloc>(context).add(Reset());
    });
  }
}