import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/repositories/onboard_repository.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/screens/permission_screen/bloc/permission_screen_bloc.dart';
import 'package:permission_handler/permission_handler.dart';


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
              _requestPermission(widget._permission, widget._controller, context);
            } 
          ),
          android: (_) => RaisedButton(
            onPressed: () {
              _requestPermission(widget._permission, widget._controller, context);
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

  void _requestPermission(PermissionType permission, AnimationController controller, BuildContext context) async {
    if (permission == PermissionType.bluetooth) {
      BluetoothState currentBleState = await flutterBeacon.bluetoothState;
      if (currentBleState == BluetoothState.stateUnknown) {
        flutterBeacon.bluetoothStateChanged().listen((BluetoothState state) {
          OnboardRepository().setIsInitialLogin(false).then((_) {
            _updateIfGranted(currentBleState == BluetoothState.stateOn, permission);
          });
        });
      } else {
        OnboardRepository().setIsInitialLogin(false).then((_) {
          _updateIfGranted(currentBleState == BluetoothState.stateOn, permission);
        });
      }
    } else if (permission == PermissionType.location) {
      final Map<PermissionGroup, PermissionStatus> status = await PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse]);
      if (status[PermissionGroup.locationWhenInUse] == PermissionStatus.granted) {
        BlocProvider.of<GeoLocationBloc>(context).add(GeoLocationReady());
      }
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
        title = 'Please enable Bluetooth';
        body = '${Constants.appName} requires Bluetooth to work properly';
        break;
      case PermissionType.location:
        title = 'Please Enable Location Services';
        body = '${Constants.appName} must use location services to work properly.';
        break;
      case PermissionType.notification:
        title = 'Please enable Notifications';
        body = '${Constants.appName} must use notifications to work properly.';
        break;
      case PermissionType.beacon:
        title = 'Please set to Always';
        body = "${Constants.appName} requires Location to be set to 'Always' to work properly";
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