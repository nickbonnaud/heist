import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/screens/home_screen/blocs/side_drawer_bloc/side_drawer_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/drag_button.dart';
import 'widgets/logo_buttons_list/bloc/logo_buttons_list_bloc.dart';
import 'widgets/logo_buttons_list/logo_buttons_list.dart';
import 'widgets/peek_header.dart';

class PeekSheet extends StatefulWidget {

  const PeekSheet({Key? key})
    : super(key: key);
  
  @override
  State<PeekSheet> createState() => _PeekSheetState();
}

class _PeekSheetState extends State<PeekSheet> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  double get _maxHeight => MediaQuery.of(context).size.height;
  double get _topMargin => lerp(min: 20.h, max: 20.h + MediaQuery.of(context).padding.top);
  double get _headerFontSize => lerp(min: 24.sp, max: 30.sp);
  double get _buttonSize => lerp(min: 32.sp, max: 42.sp);
  double get _pullLineHeight => lerp(min: 8.h, max: 40.h);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500)
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        BlocProvider.of<SideDrawerBloc>(context).add(const ButtonVisibilityChanged(isVisible: false));
      } else if (status == AnimationStatus.dismissed) {
        BlocProvider.of<SideDrawerBloc>(context).add(const ButtonVisibilityChanged(isVisible: true));
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller, 
      builder: (context, child) {
        return Positioned(
          height: lerp(min: 140.h, max: _maxHeight),
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3), 
                  spreadRadius: 4.0,
                  blurRadius: 5,
                  offset: Offset(0, -5.h)
                )
              ]
            ),
            child: BlocProvider<LogoButtonsListBloc>(
              create: (_) => LogoButtonsListBloc(
                openTransactionsBloc: BlocProvider.of<OpenTransactionsBloc>(context),
                activeLocationBloc: BlocProvider.of<ActiveLocationBloc>(context),
                nearbyBusinessesBloc: BlocProvider.of<NearbyBusinessesBloc>(context),
                numberOpenTransactions: BlocProvider.of<OpenTransactionsBloc>(context).openTransactions.length,
                numberActiveLocations: BlocProvider.of<ActiveLocationBloc>(context).state.activeLocations.length,
                numberNearbyLocations: BlocProvider.of<NearbyBusinessesBloc>(context).state.businesses.length
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: _pullLineHeight,
                    left: 35.w,
                    right: 35.w,
                    child: Container(
                      height: 4.h,
                      color: Theme.of(context).colorScheme.draggableBar,
                    )
                  ),
                  PeekHeader(fontSize: _headerFontSize, topMargin: _topMargin, buttonSize: _buttonSize, controller: _controller),
                  DragButton(size: _buttonSize, topMargin: _topMargin, controller: _controller, toggle: _toggle),
                  Positioned(
                    top: _topMargin + _headerFontSize,
                    child: SizedBox(
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
                      key: const Key("dragAreaKey"),
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta != null) {
      _controller.value -= details.primaryDelta! / _maxHeight;
    }
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
  
  double lerp({required double min, required double max}) {
    return lerpDouble(min, max, _controller.value)!;
  }

  void _toggle() {
    final bool isOpen = _controller.status == AnimationStatus.completed;
    isOpen ? _controller.reverse() : _controller.forward();
  }
}