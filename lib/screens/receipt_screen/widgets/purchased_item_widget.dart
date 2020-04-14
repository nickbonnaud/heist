import 'package:flutter/material.dart';
import 'package:heist/models/transaction/purchased_item.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';

class PurchasedItemWidget extends StatelessWidget {
  final PurchasedItem _purchasedItem;

  const PurchasedItemWidget({@required PurchasedItem purchasedItem})
    : assert(purchasedItem != null),
      _purchasedItem = purchasedItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: BoldText(
        text: _purchasedItem.quantity.toString(), 
        size: SizeConfig.getWidth(5), 
        color: Colors.black
      ),
      title: BoldText(
        text: _purchasedItem.name, 
        size: SizeConfig.getWidth(5), 
        color: Colors.black
      ),
      subtitle: _purchasedItem.subName != null
        ? BoldText(
          text: _purchasedItem.subName, 
          size: SizeConfig.getWidth(4), 
          color: Colors.black54
        )
        : null,
      trailing: BoldText(
        text: Currency.create(cents: _purchasedItem.total) , 
        size: SizeConfig.getWidth(5), 
        color: Colors.black
      ),
    );
  }
}