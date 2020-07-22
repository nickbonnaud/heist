import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/receipt_modal_sheet/receipt_modal_sheet_bloc.dart';
import 'package:heist/models/transaction/refund_resource.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/receipt_screen/receipt_screen.dart';
import 'package:heist/themes/global_colors.dart';

import 'default_app_bar/bloc/default_app_bar_bloc.dart';

class RefundWidget extends StatelessWidget {
  final RefundResource _refundResource;

  const RefundWidget({Key key, @required RefundResource refundResource})
    : assert(refundResource != null),
      _refundResource = refundResource,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Hero(
          tag: _refundResource.transaction.identifier,
          child: CircleAvatar(
            backgroundImage: NetworkImage(_refundResource.business.photos.logo.smallUrl),
            radius: SizeConfig.getWidth(6),
          )
        ),
        title: BoldText4(
          text: _refundResource.business.profile.name,
          context: context
        ),
        subtitle: Text2(
          text: 'Refund: ${Currency.create(cents: _refundResource.refund.total)}',
          context: context,
          color: Theme.of(context).colorScheme.textOnLightSubdued
        ),
        trailing: Text2(
          text: _refundResource.refund.createdAt,
          context: context,
          color: Theme.of(context).colorScheme.textOnLightSubdued
        ),
        onTap: () => showFullTransaction(context),
      ),
    );
  }

  void showFullTransaction(BuildContext context) {
    TransactionResource transactionResource = TransactionResource(
      transaction: _refundResource.transaction,
      business: _refundResource.business,
      refunds: [_refundResource.refund].toList(),
      issue: _refundResource.issue,
      error: null
    );
    BlocProvider.of<DefaultAppBarBloc>(context).add(Rotate());
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => ReceiptScreen(transactionResource: transactionResource, receiptModalSheetBloc: BlocProvider.of<ReceiptModalSheetBloc>(context))
    )).then((_) {
      BlocProvider.of<DefaultAppBarBloc>(context).add(Reset());
    });
  }
}