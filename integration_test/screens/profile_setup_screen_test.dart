import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

import '../helpers/test_title.dart';

class ProfileSetupScreenTest {
  final WidgetTester tester;

  const ProfileSetupScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Profile Setup Screen Tests");

    expect(find.byKey(const Key("profileSetupScreenKey")), findsOneWidget);

    await _fillOutNameForm();

    await _addPhoto();

    await _fillOutTipRateForm();

    await _addPaymentMethod();
  }

  
  Future<void> _fillOutNameForm() async {
    await _enterErrorName();
    await _submitFirstLastNameFail();
    
    await _addFirstAndLastName();
    await _submitFirstLastNameSuccess();
    await _dismissNameSnackbar();
  }

  Future<void> _enterErrorName() async {
    await tester.enterText(find.byKey(const Key("firstNameFieldKey")), "error");
    await tester.pump(const Duration(milliseconds: 300));

    await tester.enterText(find.byKey(const Key("lastNameFieldKey")), faker.person.lastName());
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pumpAndSettle();
  }

  Future<void> _submitFirstLastNameFail() async {
    expect(find.byKey(const Key("nameSnackbarKey")), findsNothing);
    
    await tester.tap(find.byKey(const Key("submitNameButtonKey")));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key("nameSnackbarKey")), findsOneWidget);
    await tester.fling(find.byKey(const Key("nameSnackbarKey")), const Offset(0, 500), 500);
    await tester.pump();
  }
  
  Future<void> _addFirstAndLastName() async {
    expect(find.text("Invalid first name"), findsNothing);

    await tester.tap(find.byKey(const Key("firstNameFieldKey")));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key("firstNameFieldKey")), "1");
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text("Invalid first name"), findsOneWidget);

    await tester.enterText(find.byKey(const Key("firstNameFieldKey")), faker.person.firstName());
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text("Invalid first name"), findsNothing);

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key("lastNameFieldKey")));
    await tester.pumpAndSettle();
    
    expect(find.text("Invalid last name"), findsNothing);
    await tester.enterText(find.byKey(const Key("lastNameFieldKey")), "a");
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text("Invalid last name"), findsOneWidget);

    await tester.enterText(find.byKey(const Key("lastNameFieldKey")), faker.person.lastName());
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text("Invalid last name"), findsNothing);

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pumpAndSettle();
  }

  Future<void> _submitFirstLastNameSuccess() async {
    await tester.tap(find.byKey(const Key("submitNameButtonKey")));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
  }

  Future<void> _dismissNameSnackbar() async {
    await tester.fling(find.byKey(const Key("nameSnackbarKey")), const Offset(0, 500), 500);
    await tester.pumpAndSettle();
  }

  Future<void> _addPhoto() async {
    await tester.tap(find.byKey(const Key("addPhotoButtonKey")));
    await tester.pumpAndSettle();

    await tester.fling(find.byKey(const Key("editPhotoSnackbarKey")), const Offset(0, 500), 500);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key("submitPhotoButtonKey")));
    await tester.pumpAndSettle();
  }

  Future<void> _fillOutTipRateForm() async {
    await _addTipError();
    await _submitTipRatesFail();
    
    await _addTipRates();
    await _submitTipRatesSuccess();
    await _dismissTipsSnackbar();
  }

  Future<void> _addTipError() async {
    await tester.enterText(find.byKey(const Key("defaultTipRateFieldKey")), "17");
    await tester.pump(const Duration(milliseconds: 300));

    await tester.enterText(find.byKey(const Key("quickTipRateFieldKey")), "17");
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pumpAndSettle();
  }

  Future<void> _submitTipRatesFail() async {
    expect(find.byKey(const Key("tipsSnackBarKey")), findsNothing);

    await tester.tap(find.byKey(const Key("submitTipRatesButtonKey")));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key("tipsSnackBarKey")), findsOneWidget);

    await tester.fling(find.byKey(const Key("tipsSnackBarKey")), const Offset(0, 500), 500);
    await tester.pump();
  }
  
  Future<void> _addTipRates() async {
    expect(find.text('Must be between 0 and 30'), findsNothing);
    await tester.enterText(find.byKey(const Key("defaultTipRateFieldKey")), "");
    await tester.pump(const Duration(milliseconds: 300));
    await tester.enterText(find.byKey(const Key("defaultTipRateFieldKey")), "50");
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Must be between 0 and 30'), findsOneWidget);

    await tester.enterText(find.byKey(const Key("defaultTipRateFieldKey")), "");
    await tester.pump(const Duration(milliseconds: 300));
    await tester.enterText(find.byKey(const Key("defaultTipRateFieldKey")), "15");
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Must be between 0 and 30'), findsNothing);

    expect(find.text('Must be between 0 and 20'), findsNothing);
    await tester.enterText(find.byKey(const Key("quickTipRateFieldKey")), "");
    await tester.pump(const Duration(milliseconds: 300));
    await tester.enterText(find.byKey(const Key("quickTipRateFieldKey")), "40");
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Must be between 0 and 20'), findsOneWidget);

    await tester.enterText(find.byKey(const Key("quickTipRateFieldKey")), "");
    await tester.pump(const Duration(milliseconds: 300));
    await tester.enterText(find.byKey(const Key("quickTipRateFieldKey")), "7");
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Must be between 0 and 20'), findsNothing);

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pumpAndSettle();
  }

  Future<void> _submitTipRatesSuccess() async {
    await tester.tap(find.byKey(const Key("submitTipRatesButtonKey")));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
  }

  Future<void> _dismissTipsSnackbar() async {
    await tester.fling(find.byKey(const Key("tipsSnackBarKey")), const Offset(0, 500), 500);
    await tester.pumpAndSettle();
  }

  Future<void> _addPaymentMethod() async {
    await tester.tap(find.byKey(const Key("addPaymentButtonKey")));
    await tester.pump();

    await tester.tap(find.byKey(const Key("submitPaymentMethdKey")));
    await tester.pumpAndSettle();
  }
}