import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/repositories/on_board_repository.dart';
import 'package:heist/resources/constants.dart';
import 'package:permission_handler/permission_handler.dart';

import 'bloc/permission_screen_bloc.dart';

class PermissionButtons extends StatefulWidget {
  final PermissionType _permission;
  final AnimationController _controller;
  

  PermissionButtons({@required permission, @required controller})
    : assert(permission != null),
      _permission = permission,
      _controller = controller;

  @override
  State<PermissionButtons> createState() => _PermissionButtonsState();
}

class _PermissionButtonsState extends State<PermissionButtons> {
  PermissionScreenBloc _permissionScreenBloc;

  StreamSubscription<BluetoothState> _bleStatusWatcher;
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionScreenBloc, PermissionScreenState>(
      builder: (context, state) {
        _permissionScreenBloc = BlocProvider.of<PermissionScreenBloc>(context);
        return PlatformWidget(
          ios: (_) => CupertinoButton.filled(
            child: PlatformText('Enable'), 
            onPressed: () {
              _requestPermission(widget._permission, widget._controller);
            } 
          ),
          android: (_) => RaisedButton(
            onPressed: () {
              _requestPermission(widget._permission, widget._controller);
            },
            child: PlatformText('Enable', style: TextStyle(color: Colors.white),),
            color: Theme.of(context).primaryColor,
          ),
        );
      }
    );
  }

  @override
  void dispose() {
    _bleStatusWatcher?.cancel();
    super.dispose();
  }

  void _requestPermission(PermissionType permission, AnimationController controller) async {
    if (permission == PermissionType.bluetooth) {
      BluetoothState currentBleState = await flutterBeacon.bluetoothState;
      if (currentBleState == BluetoothState.stateUnknown) {
        flutterBeacon.bluetoothStateChanged().listen((BluetoothState state) {
          _updateIfGranted(currentBleState == BluetoothState.stateOn, permission);
          OnBoardRepository().setIsInitialLogin(false);
        });
      } else {
        _updateIfGranted(currentBleState == BluetoothState.stateOn, permission);
      }
    } else if (permission == PermissionType.location) {
      final Map<PermissionGroup, PermissionStatus> status = await PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse]);
      _updateIfGranted(status[PermissionGroup.locationWhenInUse] == PermissionStatus.granted, permission);
    } else if (permission == PermissionType.notification) {
      FutureOr<bool> status = await FirebaseMessaging().requestNotificationPermissions();
      _updateIfGranted(status, permission);
    } else if (permission == PermissionType.beacon) {
      PermissionStatus status = await PermissionHandler().checkPermissionStatus(PermissionGroup.locationAlways);
      if (status == PermissionStatus.granted) {
        _updateIfGranted(true, permission);
      } else {
        _openAppSettings();
      }
    }
  }

  void _updateIfGranted(bool granted, PermissionType type) {
    if (granted) {
      widget._controller..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _updateBloc(widget._permission);
        }
      });
      widget._controller.forward();
    } else {
      _showPermissionDeniedAlert(type);
    }
  }

  void _showPermissionDeniedAlert(PermissionType type) {
    String title;
    String body;
    switch (type) {
      case PermissionType.bluetooth:
        title = 'Bluetooth Required!';
        body = '${Constants.appName} requires Bluetooth to work properly';
        break;
      case PermissionType.location:
        title = 'Location Services Required!';
        body = '${Constants.appName} must use location services to work properly.';
        break;
      case PermissionType.notification:
        title = 'Notifications Required!';
        body = '${Constants.appName} must use notifications to work properly.';
        break;
      case PermissionType.beacon:
        title = 'Beacon Type Always Required!';
        body = '${Constants.appName} requires Location Always to work properly';
        break;
    }
    
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: PlatformText(title),
        content: PlatformText(body),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText('Cancel'),
            onPressed: () => Navigator.pop(context)
          ),
          PlatformDialogAction(
            child: PlatformText('Enable'),
            onPressed: () {
              _openAppSettings();
              return Navigator.pop(context);
            }
          )
        ],
      )
    );
  }

  void _openAppSettings() async {
    await PermissionHandler().openAppSettings();
  }

  void _updateBloc(PermissionType permission) {
    _permissionScreenBloc.add(PermissionChanged(permissionType: permission));
  }
}