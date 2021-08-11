import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/profile_screen/profile_screen.dart';

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

  Future<void> _changePhoto() async {
    await tester.tap(find.byKey(Key("addPhotoButtonKey")));
    await tester.pumpAndSettle();

    await tester.fling(find.byKey(Key("editPhotoSnackbarKey")), Offset(0, 500), 500);
    await tester.pumpAndSettle();
  }

  Future<void> _changeFirstNameError() async {
    expect(find.text('Invalid First Name'), findsNothing);

    await tester.enterText(find.byKey(Key("firstNameFieldKey")), "e");
    await tester.pump(Duration(milliseconds: 300));

    expect(find.text('Invalid First Name'), findsOneWidget);

    await tester.enterText(find.byKey(Key("firstNameFieldKey")), "error");
    await tester.pump(Duration(milliseconds: 300));

    expect(find.text('Invalid First Name'), findsNothing);
  }

  Future<void> _changeLastNameError() async {
    expect(find.text('Invalid Last Name'), findsNothing);

    await tester.enterText(find.byKey(Key("lastNameFieldKey")), "a");
    await tester.pump(Duration(milliseconds: 300));

    expect(find.text('Invalid Last Name'), findsOneWidget);

    await tester.enterText(find.byKey(Key("lastNameFieldKey")), "error");
    await tester.pump(Duration(milliseconds: 300));

    expect(find.text('Invalid Last Name'), findsNothing);
  }

  Future<void> _submitError() async {
    expect(find.byKey(Key("profileFormSnackbarKey")), findsNothing);
    
    await tester.tap(find.text("Done"));
    await tester.pump();
    
    await tester.tap(find.byKey(Key("submitButtonKey")));
    await tester.pumpAndSettle();
    expect(find.byKey(Key("profileFormSnackbarKey")), findsOneWidget);

    await tester.fling(find.byKey(Key("profileFormSnackbarKey")), Offset(0, 500), 500);
    await tester.pump();
  }

  Future<void> _changeFirstName() async {
    await tester.enterText(find.byKey(Key("firstNameFieldKey")), "first");
    await tester.pump(Duration(milliseconds: 300));
  }

  Future<void> _changeLastName() async {
    await tester.enterText(find.byKey(Key("lastNameFieldKey")), "last");
    await tester.pump(Duration(milliseconds: 300));
  }

  Future<void> _submitSuccess() async {
    expect(find.byKey(Key("profileFormSnackbarKey")), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    
    await tester.tap(find.text("Done"));
    await tester.pump();
    
    await tester.tap(find.byKey(Key("submitButtonKey")));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byKey(Key("profileFormSnackbarKey")), findsOneWidget);

    await tester.fling(find.byKey(Key("profileFormSnackbarKey")), Offset(0, 500), 500);
    await tester.pumpAndSettle();
  }

  Future<void> _navigateBack() async {
    await tester.tap(find.byKey(Key("profileTileKey")));
    await tester.pumpAndSettle();
  }

  Future<void> _cancelButton() async {
    expect(find.byType(ProfileScreen), findsOneWidget);
    await tester.tap(find.byKey(Key("cancelButtonKey")));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileScreen), findsNothing);
  }
}