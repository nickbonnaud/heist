import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/cached_avatar_hero.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/resources/helpers/date_formatter.dart';
import 'package:heist/routing/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/themes/global_colors.dart';

import 'default_app_bar/bloc/default_app_bar_bloc.dart';

class TransactionWidget extends StatelessWidget {
  final TransactionResource _transactionResource;

  const TransactionWidget({required TransactionResource transactionResource, required Key key})
    : _transactionResource = transactionResource,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CachedAvatarHero(
          url: _transactionResource.business.photos.logo.smallUrl,
          radius: 35.sp,
          tag: _transactionResource.transaction.identifier
        ),
        title: Text(
          _transactionResource.business.profile.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp
          ),
        ),
        subtitle: Text(
          'Total: ${Currency.create(cents: _transactionResource.transaction.total)}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimarySubdued,
            fontSize: 16.sp
          ),
        ),
        trailing: Text(
          DateFormatter.toStandardDate(date: _transactionResource.transaction.billUpdatedAt),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimarySubdued,
            fontSize: 16.sp
          ),
        ),
        onTap: () => _showFullTransaction(context: context),
      )
    );
  }

  void _showFullTransaction({required BuildContext context}) {
    BlocProvider.of<DefaultAppBarBloc>(context).add(Rotate());

    Navigator.of(context).pushNamed(Routes.receipt, arguments: _transactionResource).then((_) {
      BlocProvider.of<DefaultAppBarBloc>(context).add(Reset());
    });
  }
}