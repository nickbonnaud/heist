import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/cached_avatar_hero.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/resources/helpers/date_formatter.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/themes/global_colors.dart';

import 'default_app_bar/bloc/default_app_bar_bloc.dart';

class TransactionWidget extends StatelessWidget {
  final TransactionResource _transactionResource;

  const TransactionWidget({required TransactionResource transactionResource, Key? key})
    : _transactionResource = transactionResource,
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
          color: Theme.of(context).colorScheme.onPrimarySubdued
        ),
        trailing: Text2(
          text: DateFormatter.toStandardDate(date: _transactionResource.transaction.billUpdatedAt), 
          context: context, 
          color: Theme.of(context).colorScheme.onPrimarySubdued
        ),
        onTap: () => showFullTransaction(context),
      )
    );
  }

  void showFullTransaction(BuildContext context) {
    BlocProvider.of<DefaultAppBarBloc>(context).add(Rotate());

    Navigator.of(context).pushNamed(Routes.receipt, arguments: _transactionResource).then((_) {
      BlocProvider.of<DefaultAppBarBloc>(context).add(Reset());
    });
  }
}