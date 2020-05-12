import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/screens/permission_screen/bloc/permission_screen_bloc.dart';

import 'widgets/beacon_body.dart';
import 'widgets/bluetooth_body.dart';
import 'widgets/location_body.dart';
import 'widgets/notification_body.dart';
import 'widgets/success_body.dart';


class PermissionsScreen extends StatefulWidget {

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> with SingleTickerProviderStateMixin {
  bool _isBluetoothEnabled;
  bool _isLocationEnabled;
  bool _isNotificationEnabled;
  bool _isBeaconEnabled;
  
  AnimationController _controller;
  Animation<Offset> _offsetAnimationFirst;
  Animation<Offset> _offsetAnimationSecond;

  bool doAnimate = false;


  @override
  void initState() {
    super.initState();
    _isBluetoothEnabled = BlocProvider.of<PermissionsBloc>(context).isBleEnabled;
    _isLocationEnabled = BlocProvider.of<PermissionsBloc>(context).isLocationEnabled;
    _isNotificationEnabled = BlocProvider.of<PermissionsBloc>(context).isNotificationEnabled;
    _isBeaconEnabled = BlocProvider.of<PermissionsBloc>(context).isBeaconEnabled;

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
    return BlocProvider<PermissionScreenBloc>(
      create: (context) => PermissionScreenBloc(
        isBluetoothEnabled: _isBluetoothEnabled,
        isLocationEnabled: _isLocationEnabled,
        isBeaconEnabled: _isBeaconEnabled,
        isNotificationEnabled: _isNotificationEnabled
      ), 
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
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(18.0),
        child: SingleChildScrollView(child: screen),
      ),
    );
  }
}