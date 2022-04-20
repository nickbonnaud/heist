import 'package:flutter/material.dart';
import 'package:heist/models/transaction/purchased_item.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PurchasedItemWidget extends StatelessWidget {
  final PurchasedItem _purchasedItem;
  final int _index;

  const PurchasedItemWidget({required PurchasedItem purchasedItem, required int index, Key? key})
    : _purchasedItem = purchasedItem,
      _index = index,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key('purchasedItemKey-$_index'),
      leading: Text(
        _purchasedItem.quantity.toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.sp
        ),
      ),
      title: Text(
        _purchasedItem.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.sp
        ),
      ),
      subtitle: _purchasedItem.subName != null
        ? Text(
            _purchasedItem.subName!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: Theme.of(context).colorScheme.onPrimarySubdued
            ),
          )
        : null,
      trailing: Text(
        Currency.create(cents: _purchasedItem.total),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.sp
        ),
      )
    );
  }
}