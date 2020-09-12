import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/repositories/initial_login_repository.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'bloc/permission_buttons_bloc.dart';


class PermissionButtons extends StatefulWidget {
  final PermissionType _permission;

  PermissionButtons({@required PermissionType permission})
    : assert(permission != null),
      _permission = permission;

  @override
  State<PermissionButtons> createState() => _PermissionButtonsState();
}

class _PermissionButtonsState extends State<PermissionButtons> {
  StreamSubscription<BluetoothState> _bleStatusWatcher;
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionButtonsBloc, bool>(
      builder: (context, enabled) {
        return Row(
          children: [
            SizedBox(width: SizeConfig.getWidth(20)),
            Expanded(child: RaisedButton(
                onPressed: enabled 
                  ? () => _requestPermission(widget._permission)
                  : null,
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                child: BoldText3(text: 'Enable', context: context, color: Theme.of(context).colorScheme.onSecondary)
              )),
            SizedBox(width: SizeConfig.getWidth(20)),
          ]
        );
      }
    );
  }

  @override
  void dispose() {
    _bleStatusWatcher?.cancel();
    super.dispose();
  }

  void _requestPermission(PermissionType permission) async {
    BlocProvider.of<PermissionButtonsBloc>(context).add(PermissionButtonsEvent.disable);
    if (permission == PermissionType.bluetooth) {
      BluetoothState currentBleState = await flutterBeacon.bluetoothState;
      if (currentBleState == BluetoothState.stateUnknown) {
        flutterBeacon.bluetoothStateChanged().listen((BluetoothState state) {
          InitialLoginRepository().setIsInitialLogin(false).then((_) {
            _updateIfGranted(granted: state == BluetoothState.stateOn, type: permission);
          });
        });
      } else {
        InitialLoginRepository().setIsInitialLogin(false).then((_) {
          _updateIfGranted(granted: currentBleState == BluetoothState.stateOn, type: permission);
        });
      }
    } else if (permission == PermissionType.location) {
      final Map<PermissionGroup, PermissionStatus> status = await PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse]);
      if (status[PermissionGroup.locationWhenInUse] == PermissionStatus.granted) {
        BlocProvider.of<GeoLocationBloc>(context).add(GeoLocationReady());
      }
      _updateIfGranted(granted: status[PermissionGroup.locationWhenInUse] == PermissionStatus.granted, type: permission);
    } else if (permission == PermissionType.notification) {
      bool status = await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
      if (status) {
        OneSignal.shared.setExternalUserId(BlocProvider.of<AuthenticationBloc>(context).customer.identifier);
      }
      _updateIfGranted(granted: status, type: permission);
    } else if (permission == PermissionType.beacon) {
      BlocProvider.of<PermissionButtonsBloc>(context).add(PermissionButtonsEvent.enable);
      PermissionStatus status = await PermissionHandler().checkPermissionStatus(PermissionGroup.locationAlways);
      if (status == PermissionStatus.granted) {
        _updateIfGranted(granted: true, type: permission);
      } else {
        _openAppSettings();
      }
    }
  }

  void _updateIfGranted({@required bool granted, @required PermissionType type}) {
    BlocProvider.of<PermissionButtonsBloc>(context).add(PermissionButtonsEvent.enable);
    _updatePermissionsBloc(granted, type);
    if (!granted) {
      _showPermissionDeniedAlert(type);
    }
  }

  void _updatePermissionsBloc(bool granted, PermissionType type) {
    switch (type) {
      case PermissionType.bluetooth:
        BlocProvider.of<PermissionsBloc>(context).add(BleStatusChanged(granted: granted));
        break;
      case PermissionType.location:
        BlocProvider.of<PermissionsBloc>(context).add(LocationStatusChanged(granted: granted));
        break;
      case PermissionType.notification:
        BlocProvider.of<PermissionsBloc>(context).add(NotificationStatusChanged(granted: granted));
        break;
      case PermissionType.beacon:
        BlocProvider.of<PermissionsBloc>(context).add(BeaconStatusChanged(granted: granted));
        break;
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
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(height: SizeConfig.getHeight(1)),
            PlatformText(body),
            SizedBox(height: SizeConfig.getHeight(2)),
            PlatformText("* May restart app")
          ],
        ),
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
}