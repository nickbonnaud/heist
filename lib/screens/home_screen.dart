import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/repositories/on_board_repository.dart';
import 'package:heist/screens/permission_screen/permission_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _isInitialLogin().then((bool isInitial) {
      if (isInitial || isInitial == null) {
        _showPermissionsModal(context: context, bluetoothEnabled: false, locationEnabled: false, notificationEnabled: false, beaconEnabled: false);
      } else {
        _checkPermissionsModal().then((List results) {
          bool bluetoothEnabled = results[0] == BluetoothState.stateOn;
          bool locationEnabled = results[1] == PermissionStatus.granted;
          bool notificationEnabled = results[2] == PermissionStatus.granted;
          bool beaconEnabled = results[3] == PermissionStatus.granted;
          if (!bluetoothEnabled || !locationEnabled || !notificationEnabled || !beaconEnabled) {
            _showPermissionsModal(context: context, bluetoothEnabled: bluetoothEnabled, locationEnabled: locationEnabled, notificationEnabled: notificationEnabled, beaconEnabled: beaconEnabled);
          }
        });
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: PlatformText('Something')
      ),
    );
  }

  void _showPermissionsModal({
    @required BuildContext context,
    @required bool bluetoothEnabled,
    @required bool locationEnabled,
    @required bool notificationEnabled,
    @required bool beaconEnabled
  }) {
    showPlatformModalSheet(
      context: context,
      builder: (_) => PlatformWidget(
        android: (_) => PermissionsScreen(
          isBluetoothEnabled: bluetoothEnabled,
          isLocationEnabled: locationEnabled,
          isNotificationEnabled: notificationEnabled,
          isBeaconEnabled: beaconEnabled,
        ),
        ios: (_) => PermissionsScreen(
          isBluetoothEnabled: bluetoothEnabled,
          isLocationEnabled: locationEnabled,
          isNotificationEnabled: notificationEnabled,
          isBeaconEnabled: beaconEnabled,
        )
      )
    ); 
  }
  
  Future<List> _checkPermissionsModal() async {
    return Future.wait([
      flutterBeacon.bluetoothState,
      PermissionHandler().checkPermissionStatus(PermissionGroup.location),
      PermissionHandler().checkPermissionStatus(PermissionGroup.notification),
      PermissionHandler().checkPermissionStatus(PermissionGroup.locationAlways),
    ]);
  }

  Future<bool> _isInitialLogin() async {
    return OnBoardRepository().isInitialLogin();
  }
}