import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/receipt_modal_sheet/receipt_modal_sheet_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/screens/receipt_screen/receipt_screen.dart';
import 'package:heist/themes/global_colors.dart';

class TransactionLogoDetails extends StatelessWidget {
  final double _topMargin;
  final double _leftMargin;
  final double _height;
  final double _borderRadius;
  final TransactionResource _transactionResource;
  final AnimationController _controller;
  final int _index;

  TransactionLogoDetails({
    required double topMargin,
    required double leftMargin,
    required double height,
    required double borderRadius,
    required TransactionResource transactionResource,
    required AnimationController controller,
    required int index
  })
    : _topMargin = topMargin,
      _leftMargin = leftMargin,
      _height = height,
      _borderRadius = borderRadius,
      _transactionResource = transactionResource,
      _controller = controller,
      _index = index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _topMargin,
      left: _leftMargin,
      height: _height,
      right: 16,
      child: _controller.status == AnimationStatus.completed
        ? Details(
          height: _height, 
          borderRadius: _borderRadius, 
          transactionResource: _transactionResource, 
          controller: _controller, 
          index: _index
        )
        : Container()
    );
  }
}

class Details extends StatefulWidget {
  final double _height;
  final double _borderRadius;
  final TransactionResource _transactionResource;
  final AnimationController _controller;
  final int _index;

  Details({
    required double height,
    required double borderRadius,
    required TransactionResource transactionResource,
    required AnimationController controller,
    required int index
  })
    : _height = height,
      _borderRadius = borderRadius,
      _transactionResource = transactionResource,
      _controller = controller,
      _index = index;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> with SingleTickerProviderStateMixin {
  late AnimationController _detailsController;
  bool _isPressed = false;
  static const _curve = Curves.easeIn;
  
  @override
  void initState() {
    super.initState();
    _detailsController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    
    Future.delayed(Duration(milliseconds: 200 * widget._index), () => _detailsController.forward());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _detailsController, curve: _curve),
      builder: (context, child) {
        return Opacity(
          opacity: _detailsController.value,
          child: Padding(
            padding: EdgeInsets.only(right: 4),
            child: GestureDetector(
              onTap: () => _viewReceiptModal(context: context),
              onTapDown: (_) => setState(() => _isPressed = !_isPressed),
              onTapUp: (_) => setState(() => _isPressed = !_isPressed),
              onTapCancel: () => setState(() => _isPressed = !_isPressed),
              child: Material(
                elevation: _isPressed ? 0 : 5,
                borderRadius: BorderRadius.circular(widget._borderRadius),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget._borderRadius),
                    color: Theme.of(context).colorScheme.scrollBackground
                  ),
                  padding: EdgeInsets.only(left: widget._height).add(EdgeInsets.all(8)),
                  child: _buildContent(context: context),
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildContent({required BuildContext context}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        PlatformText(
          "Bill at ${widget._transactionResource.business.profile.name}",
          style: TextStyle(
            fontSize: SizeConfig.getWidth(4) * widget._controller.value,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            PlatformText(
              "Total:",
              style: TextStyle(
                fontSize: SizeConfig.getWidth(4) * widget._controller.value,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).colorScheme.onPrimarySubdued,
              ),
            ),
            PlatformText(
              Currency.create(cents: widget._transactionResource.transaction.total),
              style: TextStyle(
                fontSize: SizeConfig.getWidth(4) * widget._controller.value,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _viewReceiptModal({required BuildContext context}) {
    Navigator.of(context).pushNamed(Routes.receipt, arguments: widget._transactionResource);
  }
}