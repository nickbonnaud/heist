import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/receipt_modal_sheet/receipt_modal_sheet_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/screens/receipt_screen/receipt_screen.dart';
import 'package:heist/themes/global_colors.dart';

class TransactionLogoDetails extends StatelessWidget {
  final double _topMargin;
  final double _leftMargin;
  final double _height;
  final double _borderRadius;
  final TransactionResource _transactionResource;
  final AnimationController _controller;

  TransactionLogoDetails({
    @required double topMargin,
    @required double leftMargin,
    @required double height,
    @required double borderRadius,
    @required TransactionResource transactionResource,
    @required AnimationController controller
  })
    : assert(
      topMargin != null &&
      leftMargin != null &&
      height != null &&
      borderRadius != null &&
      transactionResource != null &&
      controller != null
    ),
      _topMargin = topMargin,
      _leftMargin = leftMargin,
      _height = height,
      _borderRadius = borderRadius,
      _transactionResource = transactionResource,
      _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _topMargin,
      left: _leftMargin,
      height: _height,
      right: 16,
      child: AnimatedOpacity(
        opacity: _controller.status == AnimationStatus.completed ? 1 : 0, 
        duration: Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: () => _viewReceiptModal(context: context),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_borderRadius),
              color: Theme.of(context).colorScheme.scrollBackgroundLight
            ),
            padding: EdgeInsets.only(left: _height).add(EdgeInsets.all(8)),
            child: _buildContent(context: context),
          ),
        ),
      )
    );
  }

  Widget _buildContent({@required BuildContext context}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        PlatformText(
          "Bill at ${_transactionResource.business.profile.name}",
          style: TextStyle(
            fontSize: SizeConfig.getWidth(4) * _controller.value,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.textOnLight
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            PlatformText(
              "Total:",
              style: TextStyle(
                fontSize: SizeConfig.getWidth(4) * _controller.value,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).colorScheme.textOnLightSubdued,
              ),
            ),
            PlatformText(
              Currency.create(cents: _transactionResource.transaction.total),
              style: TextStyle(
                fontSize: SizeConfig.getWidth(4) * _controller.value,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.textOnLight
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _viewReceiptModal({@required BuildContext context}) {
    showPlatformModalSheet(
      context: context,
      builder: (_) => ReceiptScreen(transactionResource: _transactionResource, receiptModalSheetBloc: BlocProvider.of<ReceiptModalSheetBloc>(context))
    );
  }
}