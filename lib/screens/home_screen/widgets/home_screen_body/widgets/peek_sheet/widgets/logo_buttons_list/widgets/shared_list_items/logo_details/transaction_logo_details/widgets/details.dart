import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/currency.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final String _keyValue;
  final double _height;
  final double _borderRadius;
  final TransactionResource _transactionResource;
  final AnimationController _controller;
  final int _index;

  Details({
    required String keyValue,
    required double height,
    required double borderRadius,
    required TransactionResource transactionResource,
    required AnimationController controller,
    required int index
  })
    : _keyValue = keyValue,
      _height = height,
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
              key: Key(widget._keyValue),
              onTap: () => _viewReceiptModal(),
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
                  child: _buildContent(),
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildContent() {
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

  void _viewReceiptModal() {
    Navigator.of(context).pushNamed(Routes.receipt, arguments: widget._transactionResource);
  }
}