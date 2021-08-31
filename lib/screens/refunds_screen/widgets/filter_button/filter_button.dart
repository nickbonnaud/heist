
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/screens/refunds_screen/bloc/refunds_screen_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc/filter_button_bloc.dart';

enum Option {
  all,
  date,
  refundId,
  businessName,
  transactionId,
}

class FilterButton extends StatefulWidget {
  final Color _startColor;
  final Color _endColor;

  FilterButton({required Color startColor, required Color endColor})
    : _startColor = startColor,
      _endColor = endColor;

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> with SingleTickerProviderStateMixin {
  final double _expandedSize = 225.w;
  final double _hiddenSize = 1.w;
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200)
    );
    _colorAnimation = ColorTween(
      begin: widget._startColor,
      end: widget._endColor,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FilterButtonBloc, FilterButtonState>(
      listener: (context, state) {
        state.isActive ? _open() : _close();
      },
      child: SizedBox(
        width: _expandedSize,
        height: _expandedSize,
        child: AnimatedBuilder(
          animation: _controller, 
          builder: (BuildContext context, Widget? child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                _buildExpandedBackground(),
                _buildOption(
                  option: Option.all, 
                  icon: Icon(
                    Icons.refresh, 
                    color: Theme.of(context).colorScheme.onSecondary,
                  ), 
                  angle: _setAngle(index: 1)
                ),
                _buildOption(
                  option: Option.businessName, 
                  icon: Icon(
                    Icons.business, 
                    color: Theme.of(context).colorScheme.onSecondary,
                  ), 
                  angle: _setAngle(index: 2)
                ),
                _buildOption(
                  option: Option.date, 
                  icon: Icon(
                    Icons.event, 
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  angle: _setAngle(index: 3)
                ),
                _buildOption(
                  option: Option.transactionId,
                  icon: Icon(
                    Icons.receipt, 
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  angle: _setAngle(index: 4)
                ),
                _buildOption(
                  option: Option.refundId, 
                  icon: Icon(
                    Icons.receipt_long,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ), 
                  angle: _setAngle(index: 5)
                ),
                _buildBaseButton(),
              ],
            );
          }
        ),
      ),
    );
  }

  Widget _buildOption({required Option option, required Widget icon, required double angle}) {
    if (_controller.isDismissed) {
      return Container();
    }
    
    double iconSize = 0.0;
    if (_controller.value > 0.8) {
      iconSize = 30.w * (_controller.value - 0.8) * 5;
    }

    return Transform.rotate(
      angle: angle,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: IconButton(
            onPressed: () => _onSelection(option: option),
            icon: Transform.rotate(
              angle: -angle,
              child: icon,
            ),
            iconSize: iconSize,
            alignment: Alignment.center,
            padding: EdgeInsets.all(0.0),
          ),
        ),
      ),
    );
  }
  
  double _setAngle({required int index}) {
    final double topPoint = 2 * math.pi * 1.2;
    final double buttonPoint =  2 * math.pi * .68;

    double length = (topPoint - buttonPoint) / Option.values.length;
    return topPoint - (length * index);
  }
  
  Widget _buildExpandedBackground() {
    double size = _hiddenSize + (_expandedSize - _hiddenSize) * _controller.value;
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle, 
        color: _controller.value > 0.01 ? Theme.of(context).colorScheme.secondary : Colors.transparent,
      )
    );
  }

  Widget _buildBaseButton() {
    double scaleFactor = 2 * (_controller.value - 0.5).abs();
    return BlocBuilder<FilterButtonBloc, FilterButtonState>(
      builder: (context, state) {
        return FloatingActionButton(
          key: Key("refundsFilterButtonKey"),
          onPressed: () => BlocProvider.of<FilterButtonBloc>(context).add(Toggle()),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(1.0, scaleFactor),
            child: Icon(
              state.isActive ? Icons.close : Icons.filter_list,
              size: 40.w,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          backgroundColor: _colorAnimation.value,
        );
      }
    );
  }

  void _onSelection({required Option option}) {
    BlocProvider.of<FilterButtonBloc>(context).add(Toggle());
    switch (option) {
      case Option.all:
        _fetchAllRefunds();
        break;
      case Option.date:
        _searchByDate();
        break;
      case Option.refundId:
        _searchByRefundId();
        break;
      case Option.businessName:
        _searchByName();
        break;
      case Option.transactionId:
        _searchByTransactionId();
        break;
    }
  }

  void _fetchAllRefunds() {
    BlocProvider.of<RefundsScreenBloc>(context).add(FetchAllRefunds(reset: true));
  }

  void _searchByDate() async {
    DateTimeRange? range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      helpText: "Please select date range",
      confirmText: "SET",
      saveText: "SUBMIT",
      currentDate: DateTime.now()
    );

    if (range != null) {
      BlocProvider.of<RefundsScreenBloc>(context).add(FetchRefundsByDateRange(dateRange: range, reset: true));
    }
  }

  void _searchByRefundId() async {
    Navigator.of(context).pushNamed(Routes.refundsIdentifier)
      .then((identifier) {
        if (identifier != null) {
          identifier = identifier as String;
          BlocProvider.of<RefundsScreenBloc>(context).add(FetchRefundByIdentifier(identifier: identifier, reset: true));
        }
      });
  }

  void _searchByName() async {
    Navigator.of(context).pushNamed(Routes.refundsBusinessName)
      .then((business) {
        if (business !=  null) {
          business = business as Business;
          BlocProvider.of<RefundsScreenBloc>(context).add(FetchRefundByBusiness(identifier: business.identifier, reset: true));
        }
      });
  }

  void _searchByTransactionId() async {
    Navigator.of(context).pushNamed(Routes.refundsTransactionIdentifier)
      .then((identifier) {
        if (identifier != null) {
          identifier = identifier as String;
          BlocProvider.of<RefundsScreenBloc>(context).add(FetchRefundByTransaction(identifier: identifier, reset: true));
        }
      });
  }

  void _open() {
    if (_controller.isDismissed) {
      _controller.forward();
    }
  }

  void _close() {
    if (_controller.isCompleted) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}