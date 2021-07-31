import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/screens/home_screen/blocs/side_drawer_bloc/side_drawer_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import 'widgets/drawer_body.dart';

class SideDrawer extends StatefulWidget {
  final Widget _homeScreen;

  SideDrawer({required Widget homeScreen})
    : _homeScreen = homeScreen;

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> with SingleTickerProviderStateMixin {
  static const String HERO_KEY = 'MENU_KEY';
  static const double _minScale = 0.86;
  static const double _drawerWidth = 0.66;
  static const double _shadowOffset = 16.0;
  static const double _borderRadius = 32.0;
  
  late Animation<double> _animation, _scaleAnimation;
  late Animation<BorderRadius> _radiusAnimation;
  late AnimationController _animationController;

  _open(BuildContext context) {
    _animationController.forward();
    BlocProvider.of<SideDrawerBloc>(context).add(DrawerStatusChanged(menuOpen: true));
  }

  _close(BuildContext context) {
    _animationController.reverse();
    BlocProvider.of<SideDrawerBloc>(context).add(DrawerStatusChanged(menuOpen: false));
  }

  _onMenuPressed(BuildContext context, SideDrawerState state) {
    state.menuOpened ? _close(context) : _open(context);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && !BlocProvider.of<SideDrawerBloc>(context).state.menuOpened) {
          BlocProvider.of<SideDrawerBloc>(context).add(DrawerStatusChanged(menuOpen: true));
        } else if (status == AnimationStatus.dismissed && BlocProvider.of<SideDrawerBloc>(context).state.menuOpened) {
          BlocProvider.of<SideDrawerBloc>(context).add(DrawerStatusChanged(menuOpen: false));
        }
      });

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _radiusAnimation = BorderRadiusTween(begin: BorderRadius.circular(0.0), end: BorderRadius.circular(_borderRadius))
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.ease));

    _scaleAnimation = Tween<double>(begin: 1.0, end: _minScale).animate(_animationController);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SideDrawerBloc, SideDrawerState>(
      builder: (context, state) {
        return Scaffold(
          body: GestureDetector(
            onHorizontalDragUpdate: BlocProvider.of<SideDrawerBloc>(context).state.menuOpened
              ? _handleDragUpdate
              : null,
            onHorizontalDragEnd: BlocProvider.of<SideDrawerBloc>(context).state.menuOpened
              ? _handleDragEnd
              : null,
            child: _buildBody(state: state)
          ),
          floatingActionButton: state.buttonVisible ? Padding(
            padding: EdgeInsets.only(top: 25, left: 10),
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.callToAction,
              heroTag: HERO_KEY,
              child: Icon(Icons.menu),
              onPressed: () => _onMenuPressed(context, state),
            ),
          ) : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        );
      }
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta != null) {
      _animationController.value += details.primaryDelta! / MediaQuery.of(context).size.width;
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_animationController.isAnimating ||
        _animationController.status == AnimationStatus.completed) return;
    
    final double flingVelocity =
      details.velocity.pixelsPerSecond.dy / MediaQuery.of(context).size.width;
    if (flingVelocity < 0.0)
      _animationController.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _animationController.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _animationController.fling(
        velocity: _animationController.value < 0.5 ? -2.0 : 2.0);
  }

  Widget _buildBody({required SideDrawerState state}) {
    return Stack(
      children: <Widget>[
        DrawerBody(),
        Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.translate(
            offset: Offset((MediaQuery.of(context).size.width * _drawerWidth) * _animation.value, 0.0),
            child: AbsorbPointer(
              absorbing: state.menuOpened,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: _animation.value * _shadowOffset),
                    child: Material(
                      borderRadius: _radiusAnimation.value,
                      elevation: _animationController.value * 10,
                      child: ClipRRect(
                        borderRadius: _radiusAnimation.value,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).colorScheme.background,
                          child: widget._homeScreen,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}