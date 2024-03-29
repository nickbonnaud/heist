import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/profile_screen/profile_screen.dart';
import 'dart:io';

import '../helpers/test_title.dart';

class ProfileScreenTest {
  final WidgetTester tester;

  const ProfileScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Profile Screen Tests");

    expect(find.byType(ProfileScreen), findsOneWidget);

    await _changeFirstNameError();

    await _changeLastNameError();

    await _submitError();

    await _changePhoto();

    await _changeFirstName();

    await _changeLastName();

    await _submitSuccess();

    await _navigateBack();

    await _cancelButton();
  }

  Future<void> _changeFirstNameError() async {
    expect(find.text('Invalid First Name'), findsNothing);

    
    await tester.tap(find.byKey(const Key("firstNameFieldKey")));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key("firstNameFieldKey")), "e");
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Invalid First Name'), findsOneWidget);

    await tester.enterText(find.byKey(const Key("firstNameFieldKey")), "error");
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Invalid First Name'), findsNothing);

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pumpAndSettle();
  }

  Future<void> _changeLastNameError() async {
  expect(find.text('Invalid Last Name'), findsNothing);

    await tester.tap(find.byKey(const Key("lastNameFieldKey")));
    await tester.pumpAndSettle();
    
    await tester.enterText(find.byKey(const Key("lastNameFieldKey")), "a");
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Invalid Last Name'), findsOneWidget);

    await tester.enterText(find.byKey(const Key("lastNameFieldKey")), "error");
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Invalid Last Name'), findsNothing);

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pumpAndSettle();
  }

  Future<void> _submitError() async {
    expect(find.byKey(const Key("profileFormSnackbarKey")), findsNothing);
    
    await tester.tap(find.byKey(const Key("submitButtonKey")));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key("profileFormSnackbarKey")), findsOneWidget);

    await tester.fling(find.byKey(const Key("profileFormSnackbarKey")), const Offset(0, 500), 500);
    await tester.pump();
  }

    Future<void> _changePhoto() async {
    await tester.tap(find.byKey(const Key("addPhotoButtonKey")));
    await tester.pumpAndSettle();

    await tester.fling(find.byKey(const Key("editPhotoSnackbarKey")), const Offset(0, 500), 500);
    await tester.pumpAndSettle();
  }

  Future<void> _changeFirstName() async {
    await tester.tap(find.byKey(const Key("firstNameFieldKey")));
    await tester.pumpAndSettle();
    
    await tester.enterText(find.byKey(const Key("firstNameFieldKey")), "first");
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pumpAndSettle();
  }

  Future<void> _changeLastName() async {
    await tester.tap(find.byKey(const Key("lastNameFieldKey")));
    await tester.pumpAndSettle();
    
    await tester.enterText(find.byKey(const Key("lastNameFieldKey")), "last");
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pumpAndSettle();
  }

  Future<void> _submitSuccess() async {
    expect(find.byKey(const Key("profileFormSnackbarKey")), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    
    await tester.tap(find.byKey(const Key("submitButtonKey")));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byKey(const Key("profileFormSnackbarKey")), findsOneWidget);

    await tester.fling(find.byKey(const Key("profileFormSnackbarKey")), const Offset(0, 500), 500);
    await tester.pumpAndSettle();
  }

  Future<void> _navigateBack() async {
    await tester.tap(find.byKey(const Key("profileTileKey")));
    await tester.pumpAndSettle();
  }

  Future<void> _cancelButton() async {
    expect(find.byType(ProfileScreen), findsOneWidget);
    await tester.tap(find.byKey(const Key("cancelButtonKey")));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileScreen), findsNothing);
  }
}