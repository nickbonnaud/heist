import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_title.dart';

class PermissionsScreenTest {
  final WidgetTester tester;

  const PermissionsScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Permissions Screen Tests");

    expect(find.byKey(Key("permissionsScreenKey")), findsOneWidget);

    await _tapEnableBluetoothButton();
    await _tapEnableNotificationsButton();
    await _tapEnableLocationButton();
    await _tapEnableBeaconButton();
  }

  Future<void> _tapEnableBluetoothButton() async {
    await tester.tap(find.byKey(Key("bluetoothButtonKey")));
    await tester.pump(Duration(milliseconds: 500));

    expect(find.byKey(Key("enablePermissionButtonKey")), findsOneWidget);
    await tester.tap(find.byKey(Key("enablePermissionButtonKey")));
    await tester.pump(Duration(seconds: 3));
  }

  Future<void> _tapEnableNotificationsButton() async {
    await tester.tap(find.byKey(Key("notificationButtonKey")));
    await tester.pump();

    expect(find.byKey(Key("enablePermissionButtonKey")), findsOneWidget);
    await tester.tap(find.byKey(Key("enablePermissionButtonKey")));
    await tester.pump(Duration(seconds: 3));
  }

  Future<void> _tapEnableLocationButton() async {
    await tester.tap(find.byKey(Key("locationButtonKey")));
    await tester.pump();

    expect(find.byKey(Key("enablePermissionButtonKey")), findsOneWidget);
    await tester.tap(find.byKey(Key("enablePermissionButtonKey")));
    await tester.pump(Duration(seconds: 3));
  }

  Future<void> _tapEnableBeaconButton() async {
    await tester.tap(find.byKey(Key("beaconButtonKey")));
    await tester.pump();

    expect(find.byKey(Key("enablePermissionButtonKey")), findsOneWidget);
    await tester.tap(find.byKey(Key("enablePermissionButtonKey")));
    await tester.pumpAndSettle();
  }
}