import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsChecker {

  const PermissionsChecker();
  
  Future<bool> bleEnabled() async {
    // TODO //
    // return await Permission.bluetooth.status.isGranted,
    return await flutterBeacon.bluetoothState  == BluetoothState.stateOn;
  }

  Future<bool> locationEnabled() async {
    return await Permission.location.status.isGranted;
  }

  Future<bool> notificationEnabled() async {
    return await Permission.notification.status.isGranted;
  }

  Future<bool> beaconEnabled() async {
    return await Permission.locationAlways.status.isGranted;
  }
}