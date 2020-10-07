import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/global_widgets/ios_date_picker/bloc/ios_date_picker_bloc.dart';
import 'package:heist/global_widgets/ios_date_picker/ios_date_picker.dart';
import 'package:heist/global_widgets/material_date_picker/bloc/material_date_picker_bloc.dart';
import 'package:heist/global_widgets/material_date_picker/material_date_picker.dart';
import 'package:heist/global_widgets/search_business_name_modal.dart';
import 'package:heist/global_widgets/search_identifier_modal.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/date_range.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/screens/historic_transactions_screen/bloc/historic_transactions_bloc.dart';

import 'bloc/filter_button_bloc.dart';

enum Option {
  all,
  businessName,
  date,
  transactionId
}

class FilterButton extends StatefulWidget {
  final Color _startColor;
  final Color _endColor;

  FilterButton({@required Color startColor, @required Color endColor})
    : assert(startColor != null && endColor != null),
      _startColor = startColor,
      _endColor = endColor;

  @override
  State<FilterButton> createState() => _FilterButtonState();
}
class _FilterButtonState extends State<FilterButton> with SingleTickerProviderStateMixin {
  final double _expandedSize = SizeConfig.getWidth(60);
  final double _hiddenSize = SizeConfig.getWidth(1);
  AnimationController _controller;
  Animation<Color> _colorAnimation;

  
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
          builder: (BuildContext context, Widget child) {
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
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
                _buildBaseButton(),
              ],
            );
          }
        ),
      )
    );
  }
  
  Widget _buildOption({@required Option option, @required Widget icon, @required double angle}) {
    if (_controller.isDismissed) {
      return Container();
    }
    
    double iconSize = 0.0;
    if (_controller.value > 0.8) {
      iconSize = SizeConfig.getWidth(8) * (_controller.value - 0.8) * 5;
    }

    return Transform.rotate(
      angle: angle,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 8.0),
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

  double _setAngle({@required int index}) {
    final double topPoint = 2 * math.pi * 1.2;
    final double buttonPoint =  2 * math.pi * .68;

    double length = (topPoint - buttonPoint) / Option.values.length;
    return topPoint - (length * index);
  }
  
  void _onSelection({@required Option option}) {
    BlocProvider.of<FilterButtonBloc>(context).add(Toggle());
    switch (option) {
      case Option.date:
        _searchByDate(context);
        break;
      case Option.businessName:
        _searchByName(context);
        break;
      case Option.transactionId:
        _searchByTransactionId(context);
        break;
      case Option.all:
        _fetchAllTransactions(context);
        break;
    }
  }

  void _searchByDate(BuildContext context) async {
    DateRange range;
    if (Platform.isIOS) {
      range = await showPlatformModalSheet(
        context: context,
        builder: (_) => BlocProvider<IosDatePickerBloc>(
          create: (BuildContext context) => IosDatePickerBloc(),
          child: IosDatePicker(),
        )
      );
    } else {
      range = await showPlatformModalSheet(
        context: context,
        builder: (_) => BlocProvider<MaterialDatePickerBloc>(
          create: (BuildContext context) => MaterialDatePickerBloc(),
          child: MaterialDatePicker(),
        )
      );
    }
    if (range != null && range.startDate != null && range.endDate != null) {
      BlocProvider.of<HistoricTransactionsBloc>(context).add(FetchTransactionsByDateRange(dateRange: range, reset: true));
    }
  }

  void _searchByName(BuildContext context) async {
    Business business = await showPlatformModalSheet(
      context: context,
      builder: (_) => SearchBusinessNameModal()
    );
    if (business != null) {
      BlocProvider.of<HistoricTransactionsBloc>(context).add(FetchTransactionsByBusiness(identifier: business.identifier, reset: true));
    }
  }

  void _searchByTransactionId(BuildContext context) async {
    String identifier = await showPlatformModalSheet(
      context: context,
      builder: (_) => SearchIdentifierModal(hintText: "Transaction ID")
    );
    if (identifier != null) {
      BlocProvider.of<HistoricTransactionsBloc>(context).add(FetchTransactionByIdentifier(identifier: identifier, reset: true));
    }
  }

  void _fetchAllTransactions(BuildContext context) {
    BlocProvider.of<HistoricTransactionsBloc>(context).add(FetchHistoricTransactions(reset: true));
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
          onPressed: () => BlocProvider.of<FilterButtonBloc>(context).add(Toggle()),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(1.0, scaleFactor),
            child: Icon(
              state.isActive ? Icons.close : Icons.filter_list,
              size: SizeConfig.getWidth(10),
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          backgroundColor: _colorAnimation.value,
        );
      }
    );
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