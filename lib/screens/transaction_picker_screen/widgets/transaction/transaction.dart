import 'dart:ui';

import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/global_widgets/cached_avatar.dart';
import 'package:heist/global_widgets/dots.dart';
import 'package:heist/models/transaction/purchased_item.dart';
import 'package:heist/models/unassigned_transaction/unassigned_transaction_resource.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/resources/helpers/date_formatter.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/screens/receipt_screen/widgets/widgets/purchased_item_widget.dart';
import 'package:heist/screens/transaction_picker_screen/bloc/transaction_picker_screen_bloc.dart';
import 'package:heist/screens/transaction_picker_screen/helpers/picker_transformer.dart';
import 'package:heist/screens/transaction_picker_screen/widgets/transaction/bloc/transaction_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:collection/collection.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Transaction extends StatefulWidget {
  final List<UnassignedTransactionResource> _transactions;

  Transaction({required List<UnassignedTransactionResource> transactions})
    : _transactions = transactions;

  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  final TransformerPageController _underlayController = TransformerPageController();
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, bottom: 16.h, right: 16.w),
      child: _underlayWidget(),
    );
  }

  @override
  void dispose() {
    _underlayController.dispose();
    super.dispose();
  }

  Widget _underlayWidget() {
    return Stack(
      children: [
        TransformerPageView(
          pageController: _underlayController,
          transformer: PickerTransformer(),
          itemCount: widget._transactions.length,
          itemBuilder: (BuildContext context, int index) {
            return _underlayBody();
          },
        ),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 8.0,
            sigmaY: 8.0
          ),
          child: _overlayWidget()
        ),
      ],
    );
  }

  Widget _underlayBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: 140.h),
            PurchasedItemWidget(
              purchasedItem: PurchasedItem(name: "Purchased", subName: null, price: 199, quantity: 1, total: 199),
              index: 0,
            ),
            Divider(),
            PurchasedItemWidget(
              purchasedItem: PurchasedItem(name: "Item", subName: null, price: 500, quantity: 2, total: 1000),
              index: 1,
            ),
            Divider(),
            PurchasedItemWidget(
              purchasedItem: PurchasedItem(name: "Another Item", subName: null, price: 1000, quantity: 3, total: 3000),
              index: 2,
            ),
            Divider(),
            // where unique item is overlayed
            ListTile(),
            //
            Divider(),
            SizedBox(height: 30.h),
            _createFooterRow(title: "Subtotal", value: 4199),
            SizedBox(height: 10.h),
            _createFooterRow(title: "Tax", value: 525),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28.sp,
                  ),
                ),
                Text(
                  Currency.create(cents: 4724),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28.sp,
                  ),
                ),
              ],
            )
          ],
        ),
        Row()
      ],
    );
  }

  Widget _overlayWidget() {
    return TransformerPageView(
      transformer: PickerTransformer(),
      itemCount: widget._transactions.length,
      onPageChanged: (index) {
        if (index != null) {
          _underlayController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
          BlocProvider.of<TransactionBloc>(context).add(PickerChanged(transactionUpdatedAt: widget._transactions[index].transaction.updatedDate));
        }
      },
      itemBuilder: (BuildContext context, int index) {
        return Scaffold(
          key: Key("overlayBodyKey-$index"),
          backgroundColor: Colors.transparent,
          body: _overlayBody(index: index)
        );
      },
    );
  }

  Widget _overlayBody({required int index}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                CachedAvatar(
                  url: widget._transactions[0].business.photos.logo.smallUrl,
                  radius: 50.w
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        widget._transactions[0].business.profile.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.sp
                        ),
                      ),
                      BlocBuilder<TransactionBloc, DateTime?>(
                        builder: (context, date) {
                          if (date == null) return Container();

                          return Text(
                            "Billed: ${DateFormatter.toStringTime(date: date)}",
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Theme.of(context).colorScheme.onPrimarySubdued,
                            ),
                          );
                        }
                      )
                    ],
                  )
                ),
              ],
            ),
            SizedBox(height: 255.h),
            _uniquePurchase(widget._transactions[index])
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Dots(slideIndex: index, numberOfDots: widget._transactions.length),
            SizedBox(height: 10.h),
            Row(
              children: [
                SizedBox(width: .1.sw),
                Expanded(
                  child: BlocBuilder<TransactionPickerScreenBloc, TransactionPickerScreenState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        key: Key("claimSubmitButtonKey"),
                        onPressed: state.claiming
                          ? null
                          : () => _claimButtonPressed(state: state, index: index),
                        child: _buttonChild(state: state)
                      );
                    }
                  ) 
                ),
                SizedBox(width: .1.sw)
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _buttonChild({required TransactionPickerScreenState state}) {
    if (state.claiming) {
      return SizedBox(height: 25.w, width: 25.w, child: CircularProgressIndicator());
    }
    
    return ButtonText(text: 'Claim');
  }

  void _claimButtonPressed({required int index, required TransactionPickerScreenState state}) {
    _showConfirmDialog(state: state, index: index);
  }
  
  Widget _uniquePurchase(UnassignedTransactionResource transaction) {
    List<PurchasedItem> purchasedItems  = transaction.transaction.purchasedItems;
    
    PurchasedItem uniqueItem = purchasedItems.firstWhere((PurchasedItem item) {
      return !widget._transactions.where((UnassignedTransactionResource resource) {
        return transaction.transaction.identifier != resource.transaction.identifier;
      }).map((UnassignedTransactionResource transactionResource) {
        return transactionResource.transaction.purchasedItems;
      }).toList().expand((i) => i).toList().contains(item);
    }, orElse: () {
      PurchasedItem? item = purchasedItems.firstWhereOrNull((PurchasedItem item) {
        return item.subName == null;
      });

      if (item == null) {
        item = purchasedItems[0];
      }

      return PurchasedItem(name: item.name, subName: "Bill same as another.\nCheck 'Billed' time.", price: item.price, quantity: item.quantity, total: item.total);
    });

    return PurchasedItemWidget(
      purchasedItem: PurchasedItem(name: uniqueItem.name, subName: uniqueItem.subName, price: uniqueItem.price, quantity: uniqueItem.quantity, total: uniqueItem.total),
      index: 0,
    );
  }

  Widget _createFooterRow({required String title, required int value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
          ),
        ),
        Text(
          Currency.create(cents: value),
          style: TextStyle(
            fontSize: 18.sp,
          ),
        )
      ],
    );
  }

  void _showConfirmDialog({required TransactionPickerScreenState state, required int index}) {
    showPlatformDialog(
      context: context, 
      builder: (_) => PlatformAlertDialog(
        key: Key("confirmClaimDialogKey"),
        title: PlatformText("Are you Sure?"),
        content: PlatformText("Claiming a transaction is final. Please be sure this transaction is yours."),
        actions: [
          PlatformDialogAction(
            child: PlatformText('Cancel'), 
            onPressed: () => Navigator.of(context).pop(false)
          ),
          PlatformDialogAction(
            child: PlatformText('Confirm'), 
            onPressed: () => Navigator.of(context).pop(true)
          ),
        ],
      )
    ).then((confirmed) => confirmed
      ? BlocProvider.of<TransactionPickerScreenBloc>(context).add(Claim(unassignedTransaction: widget._transactions[index]))
      : null
    );
  }
}