import 'dart:ui';

import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/global_widgets/cached_avatar.dart';
import 'package:heist/global_widgets/dots.dart';
import 'package:heist/models/transaction/purchased_item.dart';
import 'package:heist/models/unassigned_transaction/unassigned_transaction_resource.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/resources/helpers/date_formatter.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/receipt_screen/widgets/purchased_item_widget.dart';
import 'package:heist/screens/transaction_picker_screen/bloc/transaction_picker_screen_bloc.dart';
import 'package:heist/screens/transaction_picker_screen/helpers/picker_transformer.dart';
import 'package:heist/screens/transaction_picker_screen/widgets/transaction/bloc/transaction_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:collection/collection.dart';

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
    return BlocListener<TransactionPickerScreenBloc, TransactionPickerScreenState>(
      listener: (context, state) {
        final currentState = state;
        if (currentState is TransactionsLoaded) {
          if (currentState.errorMessage.isNotEmpty) {
            _showSnackbar(context, currentState.errorMessage, currentState);
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.only(left: 16, bottom: 16, right: 16),
        child: _underlayWidget(),
      )
    );
  }

  @override
  void dispose() {
    _underlayController.dispose();
    super.dispose();
  }

  Widget _underlayWidget() {
    return Stack(
      children: <Widget>[
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
          child: _overlayWidget(context)
        ),
      ],
    );
  }

  Widget _underlayBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(height: SizeConfig.getHeight(7)),
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
            SizedBox(height:SizeConfig.getHeight(3)),
            _createFooterRow(context: context, title: "Subtotal", value: 4199),
            SizedBox(height:SizeConfig.getHeight(1)),
            _createFooterRow(context: context, title: "Tax", value: 525),
            SizedBox(height:SizeConfig.getHeight(3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                BoldText2(text: "Total", context: context),
                BoldText2(text: Currency.create(cents: 4724), context: context),
              ],
            )
          ],
        ),
        Row()
      ],
    );
  }

  Widget _overlayWidget(BuildContext context) {
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
          backgroundColor: Colors.transparent,
          body: _overlayBody(index)
        );
      },
    );
  }

  Widget _overlayBody(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: <Widget>[
                CachedAvatar(
                  url: widget._transactions[0].business.photos.logo.smallUrl,
                  radius: 7
                ),
                SizedBox(width: SizeConfig.getWidth(2)),
                Expanded(
                  child: BoldText2(
                    text: widget._transactions[0].business.profile.name,
                    context: context,
                  )
                ),
                BlocBuilder<TransactionBloc, DateTime?>(
                  builder: (context, date) {
                    if (date != null) {
                      return Text3(
                        text: "Billed at: ${DateFormatter.toStringDateTime(date: date)}",
                        context: context, 
                        color: Theme.of(context).colorScheme.onPrimarySubdued,
                      );
                    }
                    return Container();
                  }
                )
              ],
            ),
            SizedBox(height: SizeConfig.getHeight(27)),
            _uniquePurchase(widget._transactions[index])
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Dots(slideIndex: index, numberOfDots: widget._transactions.length),
            Row(
              children: <Widget>[
                Expanded(
                  child: BlocBuilder<TransactionPickerScreenBloc, TransactionPickerScreenState>(
                    builder: (context, state) {
                      final TransactionPickerScreenState currentState = state;
                      return ElevatedButton(
                        onPressed: currentState is TransactionsLoaded && currentState.claiming
                          ? null
                          : () => _claimButtonPressed(context, index),
                        child: _buttonChild(context: context, state: state)
                      );
                    }
                  ) 
                )
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _buttonChild({required BuildContext context, required TransactionPickerScreenState state}) {
    final currentState = state;
    if (currentState is TransactionsLoaded) {
      if (currentState.claiming) {
        SizedBox(height: SizeConfig.getWidth(5), width: SizeConfig.getWidth(5), child: CircularProgressIndicator());
      } else {
        return BoldText3(text: 'Claim', context: context, color: Theme.of(context).colorScheme.onSecondary);
      }
    }
    return BoldText3(text: 'Claim', context: context, color: Theme.of(context).colorScheme.onSecondary);
  }

  void _claimButtonPressed(BuildContext context, int index) {
    _showConfirmDialog(context, index);
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

      return PurchasedItem(name: item.name, subName: "Bill same as another.\nCheck 'Billed at' time.", price: item.price, quantity: item.quantity, total: item.total);
    });

    return PurchasedItemWidget(
      purchasedItem: PurchasedItem(name: uniqueItem.name, subName: uniqueItem.subName, price: uniqueItem.price, quantity: uniqueItem.quantity, total: uniqueItem.total),
      index: 3,
    );
  }

  Widget _createFooterRow({required BuildContext context, required String title, required int value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text2(
          text: title, 
          context: context, 
          color: Theme.of(context).colorScheme.onPrimary
        ),
        Text2(
          text: Currency.create(cents: value), 
          context: context, 
          color: Theme.of(context).colorScheme.onPrimary
        )
      ],
    );
  }

  void _showSnackbar(BuildContext context, String message, TransactionsLoaded state) async {
    state.claimSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: BoldText4(text: message, context: context, color: Theme.of(context).colorScheme.onSecondary)
          ),
        ],
      ),
      backgroundColor: state.claimSuccess 
        ? Theme.of(context).colorScheme.iconPrimary
        : Theme.of(context).colorScheme.error,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar)
      .closed.then((_) => {
        if (state.errorMessage.isNotEmpty) {
          BlocProvider.of<TransactionPickerScreenBloc>(context).add(Reset())
        }
      }
    );
  }

  void _showConfirmDialog(BuildContext context, int index) {
    showPlatformDialog(
      context: context, 
      builder: (_) => PlatformAlertDialog(
        title: PlatformText("Are you Sure?"),
        content: PlatformText("Claiming a transaction is final. Please be sure this transaction is yours."),
        actions: <Widget>[
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
      ?  BlocProvider.of<TransactionPickerScreenBloc>(context).add(Claim(transactionIdentifier: widget._transactions[index].transaction.identifier))
      : null);
  }
}