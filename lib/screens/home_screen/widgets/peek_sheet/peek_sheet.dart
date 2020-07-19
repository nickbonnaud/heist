import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/screens/layout_screen/bloc/side_menu_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import 'widgets/drag_button.dart';
import 'widgets/logo_buttons_list/bloc/logo_buttons_list_bloc.dart';
import 'widgets/logo_buttons_list/logo_buttons_list.dart';
import 'widgets/peek_header.dart';

class PeekSheet extends StatefulWidget {

  @override
  State<PeekSheet> createState() => _PeekSheetState();
}

class _PeekSheetState extends State<PeekSheet> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  double get _maxHeight => MediaQuery.of(context).size.height;
  double get _topMargin => lerp(min: 20, max: 20 + MediaQuery.of(context).padding.top);
  double get _headerFontSize => lerp(min: SizeConfig.getWidth(5), max: SizeConfig.getWidth(8));
  double get _buttonSize => lerp(min: SizeConfig.getWidth(7), max: SizeConfig.getWidth(10));
  double get _pullLineHeight => lerp(min: SizeConfig.getHeight(1), max: SizeConfig.getHeight(5));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500)
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        BlocProvider.of<SideMenuBloc>(context).add(ToggleButtonVisibility(isVisible: false));
      } else if (status == AnimationStatus.dismissed) {
        BlocProvider.of<SideMenuBloc>(context).add(ToggleButtonVisibility(isVisible: true));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller, 
      builder: (context, child) {
        return Positioned(
          height: lerp(min: SizeConfig.getHeight(17), max: _maxHeight),
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32))
            ),
            child: BlocProvider<LogoButtonsListBloc>(
              create: (_) => LogoButtonsListBloc(
                openTransactionsBloc: BlocProvider.of<OpenTransactionsBloc>(context),
                activeLocationBloc: BlocProvider.of<ActiveLocationBloc>(context),
                nearbByusinessesBloc: BlocProvider.of<NearbyBusinessesBloc>(context),
                numberOpenTransactions: BlocProvider.of<OpenTransactionsBloc>(context).openTransactions.length,
                numberActiveLocations: BlocProvider.of<ActiveLocationBloc>(context).locations.length,
                numberNearbyLocations: BlocProvider.of<NearbyBusinessesBloc>(context).businesses.length
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: _pullLineHeight,
                    left: SizeConfig.getWidth(10),
                    right: SizeConfig.getWidth(10),
                    child: Container(
                      height: 4,
                      color: Theme.of(context).colorScheme.draggableBar,
                    )
                  ),
                  PeekHeader(fontSize: _headerFontSize, topMargin: _topMargin, buttonSize: _buttonSize, controller: _controller),
                  DragButton(size: _buttonSize, topMargin: _topMargin, controller: _controller, toggle: _toggle),
                  Positioned(
                    top: _topMargin + _headerFontSize,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: LogoButtonsList(
                        controller: _controller,
                        topMargin: _topMargin,
                      ),
                    )
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _toggle,
                      onVerticalDragUpdate: _handleDragUpdate,
                      onVerticalDragEnd: _handleDragEnd,
                      child: Container(
                        height: _topMargin +_headerFontSize + _buttonSize,
                        color: Colors.transparent,
                      ),
                    )
                  ),
                ],
              ),
            )
          )
        );
      }
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value -= details.primaryDelta / _maxHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating || _controller.status == AnimationStatus.completed) return;

    final double flingVelocity = details.velocity.pixelsPerSecond.dy / _maxHeight;
    if (flingVelocity < 0.0) {
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    } else if (flingVelocity > 0.0) {
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    } else {
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
    }
  }
  
  double lerp({@required double min, @required double max}) {
    return lerpDouble(min, max, _controller.value);
  }

  void _toggle() {
    final bool isOpen = _controller.status == AnimationStatus.completed;
    isOpen ? _controller.reverse() : _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}