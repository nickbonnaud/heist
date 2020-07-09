import 'package:flutter/material.dart';
import 'package:heist/models/transaction/purchased_item.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/themes/global_colors.dart';

class PurchasedItemWidget extends StatelessWidget {
  final PurchasedItem _purchasedItem;

  const PurchasedItemWidget({@required PurchasedItem purchasedItem})
    : assert(purchasedItem != null),
      _purchasedItem = purchasedItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: BoldText4(
        text: _purchasedItem.quantity.toString(), 
        context: context,
      ),
      title: BoldText4(
        text: _purchasedItem.name, 
        context: context,
      ),
      subtitle: _purchasedItem.subName != null
        ? BoldText5(
          text: _purchasedItem.subName, 
          context: context, 
          color: Theme.of(context).colorScheme.textOnLightSubdued
        )
        : null,
      trailing: BoldText4(
        text: Currency.create(cents: _purchasedItem.total) , 
        context: context
      ),
    );
  }
}