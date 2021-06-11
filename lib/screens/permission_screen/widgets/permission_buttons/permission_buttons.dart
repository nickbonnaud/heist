import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
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
  final InitialLoginRepository _initialLoginRepository;
  final GeoLocationBloc _geoLocationBloc;
  final PermissionsBloc _permissionsBloc;
  final String _customerIdentifier;

  PermissionButtons({
    required PermissionType permission,
    required InitialLoginRepository initialLoginRepository,
    required GeoLocationBloc geoLocationBloc,
    required PermissionsBloc permissionsBloc,
    required String customerIdentifier
  })
    : _permission = permission,
      _initialLoginRepository = initialLoginRepository,
      _geoLocationBloc = geoLocationBloc,
      _customerIdentifier = customerIdentifier,
      _permissionsBloc = permissionsBloc;

  @override
  State<PermissionButtons> createState() => _PermissionButtonsState();
}

class _PermissionButtonsState extends State<PermissionButtons> {
  late StreamSubscription<BluetoothState> _bleStatusWatcher;
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionButtonsBloc, bool>(
      builder: (context, enabled) {
        return Row(
          children: [
            SizedBox(width: SizeConfig.getWidth(20)),
            Expanded(child: ElevatedButton(
                onPressed: enabled 
                  ? () => _requestPermission(widget._permission)
                  : null,
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
    _bleStatusWatcher.cancel();
    super.dispose();
  }

  void _requestPermission(PermissionType permission) async {
    BlocProvider.of<PermissionButtonsBloc>(context).add(PermissionButtonsEvent.disable);
    if (permission == PermissionType.bluetooth) {
      BluetoothState currentBleState = await flutterBeacon.bluetoothState;
      if (currentBleState == BluetoothState.stateUnknown) {
        flutterBeacon.bluetoothStateChanged().listen((BluetoothState state) {
          widget._initialLoginRepository.setIsInitialLogin(isInitial: false).then((_) {
            _updateIfGranted(granted: state == BluetoothState.stateOn, type: permission);
          });
        });
      } else {
         widget._initialLoginRepository.setIsInitialLogin(isInitial: false).then((_) {
          _updateIfGranted(granted: currentBleState == BluetoothState.stateOn, type: permission);
        });
      }
    } else if (permission == PermissionType.location) {
      final PermissionStatus status = await Permission.locationWhenInUse.request();
      if (status.isGranted) {
        widget._geoLocationBloc.add(GeoLocationReady());
      }
      _updateIfGranted(granted: status.isGranted, type: permission);
    } else if (permission == PermissionType.notification) {
      bool status = await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
      if (status) {
        OneSignal.shared.setExternalUserId(widget._customerIdentifier);
      }
      _updateIfGranted(granted: status, type: permission);
    } else if (permission == PermissionType.beacon) {
     BlocProvider.of<PermissionButtonsBloc>(context).add(PermissionButtonsEvent.enable);
      if (await Permission.locationAlways.isGranted) {
        _updateIfGranted(granted: true, type: permission);
      } else {
        openAppSettings();
      }
    }
  }

  void _updateIfGranted({required bool granted, required PermissionType type}) {
    BlocProvider.of<PermissionButtonsBloc>(context).add(PermissionButtonsEvent.enable);
    _updatePermissionsBloc(granted, type);
    if (!granted) {
      _showPermissionDeniedAlert(type);
    }
  }

  void _updatePermissionsBloc(bool granted, PermissionType type) {
    switch (type) {
      case PermissionType.bluetooth:
        widget._permissionsBloc.add(BleStatusChanged(granted: granted));
        break;
      case PermissionType.location:
        widget._permissionsBloc.add(LocationStatusChanged(granted: granted));
        break;
      case PermissionType.notification:
        widget._permissionsBloc.add(NotificationStatusChanged(granted: granted));
        break;
      case PermissionType.beacon:
        widget._permissionsBloc.add(BeaconStatusChanged(granted: granted));
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
              openAppSettings();
              return Navigator.pop(context);
            }
          )
        ],
      )
    );
  }
}