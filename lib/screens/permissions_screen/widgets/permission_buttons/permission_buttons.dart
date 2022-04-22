import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/repositories/initial_login_repository.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/test_blocs/is_testing_cubit.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc/permission_buttons_bloc.dart';


class PermissionButtons extends StatelessWidget {
  final PermissionType _permission;

  const PermissionButtons({
    required PermissionType permission,
    Key? key
  })
    : _permission = permission,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionButtonsBloc, bool>(
      builder: (context, enabled) {
        return Row(
          children: [
            SizedBox(width: .1.sw),
            Expanded(
              child: ElevatedButton(
                key: Key("${_permission.toString().replaceAll("PermissionType.", '')}ButtonKey"),
                onPressed: enabled 
                  ? () => _requestPermission(context: context, permission: _permission)
                  : null,
                child: const ButtonText(text: 'Enable')
              )),
            SizedBox(width: .1.sw),
          ]
        );
      }
    );
  }

  void _requestPermission({required BuildContext context, required PermissionType permission}) async {
    BlocProvider.of<PermissionButtonsBloc>(context).add(PermissionButtonsEvent.disable);
    
    if (context.read<IsTestingCubit>().state) {
      _updateIfGranted(context: context, granted: false, type: permission);
      return;
    }
    
    if (permission == PermissionType.bluetooth) {
      _requestBluetooth(context: context, permission: permission);
    } else if (permission == PermissionType.location) {
      _requestLocation(context: context, permission: permission);
    } else if (permission == PermissionType.notification) {
      _requestNotification(context: context, permission: permission);
    } else if (permission == PermissionType.beacon) {
      _requestBeacon(context: context, permission: permission);
    }
  }

  void _requestBluetooth({required BuildContext context, required PermissionType permission}) async {
    BluetoothState currentBleState = await flutterBeacon.bluetoothState;
    InitialLoginRepository initialLoginRepository = RepositoryProvider.of<InitialLoginRepository>(context);
    
    if (currentBleState == BluetoothState.stateUnknown) {
      flutterBeacon.bluetoothStateChanged().listen((BluetoothState state) {
        initialLoginRepository.setIsInitialLogin(isInitial: false).then((_) {
          _updateIfGranted(context: context, granted: state == BluetoothState.stateOn, type: permission);
        });
      });
    } else {
        initialLoginRepository.setIsInitialLogin(isInitial: false).then((_) {
        _updateIfGranted(context: context, granted: currentBleState == BluetoothState.stateOn, type: permission);
      });
    }
  }

  void _requestLocation({required BuildContext context, required PermissionType permission}) async {
    final PermissionStatus status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      BlocProvider.of<GeoLocationBloc>(context).add(GeoLocationReady());
    }
    _updateIfGranted(context: context, granted: status.isGranted, type: permission);
  }

  void _requestNotification({required BuildContext context, required PermissionType permission}) async {
    bool status;
    if (Platform.isIOS) {
      status = await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
    } else {
      status = await Permission.notification.isGranted;
    }

    if (status) {
      OneSignal.shared.setExternalUserId(BlocProvider.of<CustomerBloc>(context).customer!.identifier);
    }
    _updateIfGranted(context: context, granted: status, type: permission);
  }

  void _requestBeacon({required BuildContext context, required PermissionType permission}) async {
    BlocProvider.of<PermissionButtonsBloc>(context).add(PermissionButtonsEvent.enable);
    if (await Permission.locationAlways.isGranted) {
      _updateIfGranted(context: context, granted: true, type: permission);
    } else {
      if (Platform.isIOS) {
        openAppSettings();
      } else {
        if (await Permission.locationAlways.isPermanentlyDenied) {
          openAppSettings();
        } else {
          await Permission.locationAlways.request();
          bool granted = await Permission.locationAlways.isGranted;
          _updateIfGranted(context: context, granted: granted, type: permission);
        }
      }
    }
  }

  void _updateIfGranted({required BuildContext context, required bool granted, required PermissionType type}) {
    BlocProvider.of<PermissionButtonsBloc>(context).add(PermissionButtonsEvent.enable);
    _updatePermissionsBloc(context: context, granted: granted, type: type);
    if (!granted) {
      _showPermissionDeniedAlert(context: context, type: type);
    }
  }

  void _updatePermissionsBloc({required BuildContext context, required bool granted, required PermissionType type}) {
    PermissionsBloc permissionsBloc = BlocProvider.of<PermissionsBloc>(context);
    
    switch (type) {
      case PermissionType.bluetooth:
        permissionsBloc.add(BleStatusChanged(granted: granted));
        break;
      case PermissionType.location:
        permissionsBloc.add(LocationStatusChanged(granted: granted));
        break;
      case PermissionType.notification:
        permissionsBloc.add(NotificationStatusChanged(granted: granted));
        break;
      case PermissionType.beacon:
        permissionsBloc.add(BeaconStatusChanged(granted: granted));
        break;
    }
  }

  void _showPermissionDeniedAlert({required BuildContext context, required PermissionType type}) async {
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
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PlatformText(body),
            SizedBox(height: 10.h),
            PlatformText("* May restart app")
          ],
        ),
        actions: [
          PlatformDialogAction(
            child: PlatformText('Cancel'),
            onPressed: () => Navigator.pop(context)
          ),
          PlatformDialogAction(
            key: const Key("enablePermissionButtonKey"),
            child: PlatformText('Enable'),
            onPressed: () async {
              if (context.read<IsTestingCubit>().state) {
                _updatePermissionsBloc(context: context, granted: true, type: type);
              } else {
                if (Platform.isAndroid) {
                  if (type == PermissionType.location) {
                    openAppSettings();
                  } else if (type == PermissionType.beacon) {
                    await Permission.locationAlways.request().isGranted;
                  }
                } else {
                  openAppSettings();
                }
              }
              return Navigator.pop(context);
            }
          )
        ],
      )
    );
  }
}