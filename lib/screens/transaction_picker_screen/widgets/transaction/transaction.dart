import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/global_widgets/dots.dart';
import 'package:heist/models/transaction/purchased_item.dart';
import 'package:heist/models/unassigned_transaction/unassigned_transaction_resource.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/receipt_screen/widgets/purchased_item_widget.dart';
import 'package:heist/screens/transaction_picker_screen/bloc/transaction_picker_screen_bloc.dart';
import 'package:heist/screens/transaction_picker_screen/helpers/picker_transformer.dart';
import 'package:heist/screens/transaction_picker_screen/widgets/transaction/bloc/transaction_bloc.dart';
import 'package:intl/intl.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:vibrate/vibrate.dart';

class Transaction extends StatefulWidget {
  final List<UnassignedTransactionResource> _transactions;

  Transaction({@required List<UnassignedTransactionResource> transactions})
    : assert(transactions != null),
      _transactions = transactions;

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
          if (currentState.claimFailure) {
            _showSnackbar(context, 'Failed to claim. Please try again.', currentState);
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
              purchasedItem: PurchasedItem(name: "Purchased", subName: null, price: 199, quantity: 1, total: 199)
            ),
            Divider(),
            PurchasedItemWidget(
              purchasedItem: PurchasedItem(name: "Item", subName: null, price: 500, quantity: 2, total: 1000)
            ),
            Divider(),
            PurchasedItemWidget(
              purchasedItem: PurchasedItem(name: "Another Item", subName: null, price: 1000, quantity: 3, total: 3000)
            ),
            Divider(),
            // unique item
            ListTile(),
            //
            Divider(),
            SizedBox(height:SizeConfig.getHeight(3)),
            _createFooterRow("Subtotal", 4199),
            SizedBox(height:SizeConfig.getHeight(1)),
            _createFooterRow("Tax", 525),
            SizedBox(height:SizeConfig.getHeight(3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                BoldText(text: "Total", size: SizeConfig.getWidth(7), color: Colors.black),
                BoldText(text: Currency.create(cents: 4724), size: SizeConfig.getWidth(7), color: Colors.black),
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
        _underlayController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
        BlocProvider.of<TransactionBloc>(context).add(PickerChanged(transactionResource: widget._transactions[index]));
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
                CircleAvatar(
                  backgroundImage: NetworkImage(widget._transactions[0].business.photos.logo.smallUrl),
                  radius: SizeConfig.getWidth(7),
                ),
                SizedBox(width: SizeConfig.getWidth(2)),
                Expanded(
                  child: BoldText(
                    text: widget._transactions[0].business.profile.name,
                    size: SizeConfig.getWidth(7),
                    color: Colors.black
                  )
                ),
                BlocBuilder<TransactionBloc, String>(
                  builder: (context, date) {
                    if (date.length != 0) {
                      return NormalText(
                        text: "Billed at: ${_formatTime(date)}",
                        size: SizeConfig.getWidth(4), 
                        color: Colors.black54,
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
                  child: RaisedButton(
                    color: Colors.blue,
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () => _claimButtonPressed(context, index),
                    child: BlocBuilder<TransactionPickerScreenBloc, TransactionPickerScreenState>(
                      builder: (context, state) {
                        return _createButtonText(state);
                      }
                    ) 
                  )
                )
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _createButtonText(TransactionPickerScreenState state) {
    final currentState = state;
    if (currentState is TransactionsLoaded) {
      if (currentState.claiming) {
        return TyperAnimatedTextKit(
          speed: Duration(milliseconds: 250),
          text: ['Claiming...'],
          textStyle: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: SizeConfig.getWidth(6),
              fontWeight: FontWeight.w700
            ),
            color: Colors.white
          ),
        );
      } else {
        return BoldText(text: 'Claim', size: SizeConfig.getWidth(6), color: Colors.white);
      }
    }
    return BoldText(text: 'Claim', size: SizeConfig.getWidth(6), color: Colors.white);
  }

  void _claimButtonPressed(BuildContext context, int index) {
    _showConfirmDialog(context, index);
  }
  
  String _formatTime(String date) {
    return DateFormat('jm').format(DateTime.parse(date));
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
      PurchasedItem item = purchasedItems.firstWhere((PurchasedItem item) {
        return item.subName == null;
      });

      if (item == null) {
        item = purchasedItems[0];
      }

      return PurchasedItem(name: item.name, subName: "Bill same as another.\nCheck 'Billed at' time.", price: item.price, quantity: item.quantity, total: item.total);
    });

    return PurchasedItemWidget(
      purchasedItem: PurchasedItem(name: uniqueItem.name, subName: uniqueItem.subName, price: uniqueItem.price, quantity: uniqueItem.quantity, total: uniqueItem.total)
    );
  }

  Widget _createFooterRow(String title, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        NormalText(
          text: title, 
          size: SizeConfig.getWidth(5), 
          color: Colors.black
        ),
        NormalText(
          text: Currency.create(cents: value), 
          size: SizeConfig.getWidth(5), 
          color: Colors.black
        )
      ],
    );
  }

  void _showSnackbar(BuildContext context, String message, TransactionsLoaded state) async {
    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.feedback(state.claimSuccess ? FeedbackType.success : FeedbackType.error);
    }

    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: BoldText(text: message, size: SizeConfig.getWidth(6), color: Colors.white)
              ),
              PlatformWidget(
                android: (_) => Icon(state.claimSuccess ? Icons.check_circle_outline : Icons.error),
                ios: (_) => Icon(
                  IconData(
                    state.claimSuccess ? 0xF3FE : 0xF35B,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage
                  ),
                  color: Colors.white,
                ),
              )
            ],
          ),
          backgroundColor: state.claimSuccess ? Colors.green : Colors.red,
        )
      ).closed.then((_) => {
        if (state.claimFailure) {
          BlocProvider.of<TransactionPickerScreenBloc>(context).add(Reset())
        }
      });
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
      ?  BlocProvider.of<TransactionPickerScreenBloc>(context).add(Claim(transactionResource: widget._transactions[index]))
      : null);
  }
}