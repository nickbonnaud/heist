import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/models/transaction/refund_resource.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/receipt_screen/receipt_screen.dart';

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
        leading: CircleAvatar(
          backgroundImage: NetworkImage(_refundResource.business.photos.logo.smallUrl),
          radius: SizeConfig.getWidth(6),
        ),
        title: BoldText(
          text: _refundResource.business.profile.name,
          size: SizeConfig.getWidth(5),
          color: Colors.black
        ),
        subtitle: NormalText(
          text: 'Refund: ${Currency.create(cents: _refundResource.refund.total)}', 
          size: SizeConfig.getWidth(5),
          color: Colors.black54
        ),
        trailing: NormalText(
          text: _refundResource.refund.createdAt,
          size: SizeConfig.getWidth(5),
          color: Colors.black54
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
    showPlatformModalSheet(
      context: context,
      builder: (_) => ReceiptScreen(transactionResource: transactionResource)
    ).then((_) {
      BlocProvider.of<DefaultAppBarBloc>(context).add(Reset());
    });
  }
}