import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/receipt_modal_sheet/receipt_modal_sheet_bloc.dart';
import 'package:heist/global_widgets/cached_avatar_hero.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/receipt_screen/receipt_screen.dart';
import 'package:heist/themes/global_colors.dart';

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
        leading: CachedAvatarHero(
          url: _transactionResource.business.photos.logo.smallUrl,
          radius: 6,
          tag: _transactionResource.transaction.identifier
        ),
        title: BoldText4(
          text: _transactionResource.business.profile.name, 
          context: context,
        ),
        subtitle: Text2(
          text: 'Total: ${Currency.create(cents: _transactionResource.transaction.total)}', 
          context: context, 
          color: Theme.of(context).colorScheme.textOnLightSubdued
        ),
        trailing: Text2(
          text: _transactionResource.transaction.billUpdatedAt, 
          context: context, 
          color: Theme.of(context).colorScheme.textOnLightSubdued
        ),
        onTap: () => showFullTransaction(context),
      )
    );
  }

  void showFullTransaction(BuildContext context) {
    BlocProvider.of<DefaultAppBarBloc>(context).add(Rotate());
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => ReceiptScreen(transactionResource: _transactionResource, receiptModalSheetBloc: BlocProvider.of<ReceiptModalSheetBloc>(context))
    )).then((_) {
      BlocProvider.of<DefaultAppBarBloc>(context).add(Reset());
    });
  }
}