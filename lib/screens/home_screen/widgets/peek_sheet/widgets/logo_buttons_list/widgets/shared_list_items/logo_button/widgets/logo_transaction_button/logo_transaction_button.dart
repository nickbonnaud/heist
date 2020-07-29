import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/receipt_modal_sheet/receipt_modal_sheet_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/screens/receipt_screen/receipt_screen.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:transparent_image/transparent_image.dart';

import 'bloc/logo_transaction_button_bloc.dart';

class LogoTransactionButton extends StatefulWidget {
  final TransactionResource _transactionResource;
  final double _logoBorderRadius;
  final double _warningIconSize;

  LogoTransactionButton({
    @required TransactionResource transactionResource,
    @required double logoBorderRadius,
    @required double warningIconSize
  })
    : assert(transactionResource != null && logoBorderRadius != null && warningIconSize != null),
      _transactionResource = transactionResource,
      _logoBorderRadius = logoBorderRadius,
      _warningIconSize = warningIconSize;

  @override
  State<LogoTransactionButton> createState() => _LogoTransactionButtonState();
}

class _LogoTransactionButtonState extends State<LogoTransactionButton> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      lowerBound: 0.0,
      upperBound: 0.3,
    )..addListener(() {
      setState(() {});
    });
    
    if ((widget._transactionResource.issue?.warningsSent ?? 0) != 0 && widget._transactionResource.transaction.status.code >= 500) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _toggleButtonPress(context: context),
      onTapUp: (_) => _toggleButtonPress(context: context),
      onTap: () => _showCurrentTransaction(context: context),
      child: Stack(
        children: <Widget>[
          BlocBuilder<LogoTransactionButtonBloc, LogoTransactionButtonState>(
            builder: (context, state) {
              return Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                elevation: state.pressed ? 0 : 5,
                child: CachedNetworkImage(
                  imageUrl: widget._transactionResource.business.photos.logo.smallUrl,
                  imageBuilder: (context, imageProvider) => Hero(
                    tag: widget._transactionResource.transaction.identifier,
                    child: CircleAvatar(
                      backgroundImage: imageProvider,
                      radius: widget._logoBorderRadius,
                    )
                  ),
                  placeholder: (_,__) => Image.memory(kTransparentImage),
                )
              );
            }
          ),
          if ((widget._transactionResource.issue?.warningsSent ?? 0) != 0 && widget._transactionResource.transaction.status.code >= 500)
            Positioned(
              bottom: 2.0,
              left: 10.0,
              child: _createWarningIcon()
            )
        ],
      ),
    );
  }

  Widget _createWarningIcon() {
    return Transform.scale(
      scale: 1 - _controller.value,
      child: BlocBuilder<LogoTransactionButtonBloc, LogoTransactionButtonState>(
        builder: (context, state) {
          return RawMaterialButton(
            onPressed: () => _showCurrentTransaction(context: context),
            child: Icon(
              Icons.priority_high,
              color: Theme.of(context).colorScheme.background,
              size: widget._warningIconSize,
            ),
            shape: CircleBorder(),
            elevation: state.pressed ? 0 : 5,
            fillColor: widget._transactionResource.issue.warningsSent == 1
              ? Theme.of(context).colorScheme.info
              : widget._transactionResource.issue.warningsSent == 2 
              ? Theme.of(context).colorScheme.warning
              : Theme.of(context).colorScheme.danger,
          );
        }
      )
    );
  }

  void _toggleButtonPress({@required BuildContext context}) {
    BlocProvider.of<LogoTransactionButtonBloc>(context).add(TogglePressed());
  }

  void _showCurrentTransaction({@required BuildContext context}) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => ReceiptScreen(transactionResource: widget._transactionResource, receiptModalSheetBloc: BlocProvider.of<ReceiptModalSheetBloc>(context))
    ));
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}