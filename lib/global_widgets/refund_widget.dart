import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/cached_avatar_hero.dart';
import 'package:heist/models/transaction/refund_resource.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/resources/helpers/date_formatter.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'default_app_bar/bloc/default_app_bar_bloc.dart';

class RefundWidget extends StatelessWidget {
  final RefundResource _refundResource;
  final Key _key;

  const RefundWidget({required RefundResource refundResource, required Key key})
    : _refundResource = refundResource,
      _key = key;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: _key,
      child: ListTile(
        leading: CachedAvatarHero(
          url: _refundResource.business.photos.logo.smallUrl, 
          radius: 35.sp, 
          tag: _refundResource.transaction.identifier
        ),
        title: Text(
          _refundResource.business.profile.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp
          ),
        ),
        subtitle: Text(
          'Refund: ${Currency.create(cents: _refundResource.refund.total)}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimarySubdued,
            fontSize: 16.sp
          ),
        ),
        trailing: Text(
          DateFormatter.toStandardDate(date: _refundResource.refund.createdAt),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimarySubdued,
            fontSize: 16.sp
          ),
        ),
        onTap: () => _showFullTransaction(context: context),
      ),
    );
  }

  void _showFullTransaction({required BuildContext context}) {
    final TransactionResource transactionResource = TransactionResource(
      transaction: _refundResource.transaction,
      business: _refundResource.business,
      refunds: [_refundResource.refund].toList(),
      issue: _refundResource.issue,
    );

    BlocProvider.of<DefaultAppBarBloc>(context).add(Rotate());
    
    Navigator.of(context).pushNamed(Routes.receipt, arguments: transactionResource).then((_) {
      BlocProvider.of<DefaultAppBarBloc>(context).add(Reset());
    });
  }
}