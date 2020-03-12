import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/screens/permission_screen/bloc/permission_screen_bloc.dart';
import 'package:heist/screens/permission_screen/bluetooth_body.dart';

import 'beacon_body.dart';
import 'location_body.dart';
import 'notification_body.dart';
import 'success_body.dart';

class PermissionsScreen extends StatefulWidget {
  final bool _isBluetoothEnabled;
  final bool _isLocationEnabled;
  final bool _isNotificationEnabled;
  final bool _isBeaconEnabled;

  const PermissionsScreen({
    Key key,
    @required isBluetoothEnabled,
    @required isLocationEnabled,
    @required isNotificationEnabled,
    @required isBeaconEnabled,
    }) :  _isBluetoothEnabled = isBluetoothEnabled,
          _isLocationEnabled = isLocationEnabled,
          _isNotificationEnabled = isNotificationEnabled,
          _isBeaconEnabled = isBeaconEnabled,
          super(key: key);

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimationFirst;
  Animation<Offset> _offsetAnimationSecond;

  bool doAnimate = false;
  

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500)
    )..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.forward) {
        setState(() {
          doAnimate = true;
        });
      } else if (status == AnimationStatus.completed) {
        setState(() {
          doAnimate = false;
        });
        _controller.reset();
      }
    });

    _offsetAnimationFirst = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -1.5)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn
    ));

    _offsetAnimationSecond = Tween<Offset>(
      begin: Offset(0.0, 1.5),
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PermissionScreenBloc>(
          create: (context) => PermissionScreenBloc(
            isBluetoothEnabled: widget._isBluetoothEnabled,
            isLocationEnabled: widget._isLocationEnabled,
            isBeaconEnabled: widget._isBeaconEnabled,
            isNotificationEnabled: widget._isNotificationEnabled
          )
        ),
        BlocProvider<PermissionsBloc>(
          create: (context) => PermissionsBloc()..add(AppReady())
        )
      ],
      child: BlocListener<PermissionScreenBloc, PermissionScreenState>(
        listener: (context, state) {
          if (state.incomplete.length == 0) {
            Future.delayed(Duration(seconds: 2), () => Navigator.of(context).pop());
          }
        },

        child: Scaffold(
          backgroundColor: Colors.white,
          body: _constructBody(_controller)
        )
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _constructBody(AnimationController controller) {
    return BlocBuilder<PermissionScreenBloc, PermissionScreenState>(
      builder: (context, state) {
        return AnimatedCrossFade(
          firstChild: SlideTransition(
            position: _offsetAnimationFirst,
            child: _setBodyScreen(state.current, controller)
          ),
          secondChild: SlideTransition(
            position: _offsetAnimationSecond,
            child: _setBodyScreen(state.next, controller)
          ),
          crossFadeState: (!doAnimate) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(seconds: 1)
        );
      }
    );
  }

  Widget _setBodyScreen(PermissionType type, AnimationController controller) {
    Widget screen;
    switch (type) {
      case PermissionType.bluetooth:
        screen = BluetoothBody(controller: controller);
        break;
      case PermissionType.location:
        screen = LocationBody(controller: controller);
        break;
      case PermissionType.notification:
        screen = NotificationBody(controller: controller);
        break;
      case PermissionType.beacon:
        screen = BeaconBody(controller: controller);
        break;
      default:
        screen = SuccessBody();
    }
    return screen;
  }
}