import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_title.dart';

class ProfileSetupScreenTest {
  final WidgetTester tester;

  const ProfileSetupScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Profile Setup Screen Tests");

    expect(find.byKey(Key("profileSetupScreenKey")), findsOneWidget);

    await _fillOutNameForm();

    await _addPhoto();

    await _fillOutTipRateForm();

    await _addPaymentMethod();
  }

  
  Future<void> _fillOutNameForm() async {
    await _addFirstAndLastName();
    await _submitFirstLastName();
    await _dismissNameSnackbar();
  }

  Future<void> _addFirstAndLastName() async {
    expect(find.text("Invalid first name"), findsNothing);
    await tester.enterText(find.byKey(Key("firstNameFieldKey")), "1");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text("Invalid first name"), findsOneWidget);

    await tester.enterText(find.byKey(Key("firstNameFieldKey")), faker.person.firstName());
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text("Invalid first name"), findsNothing);

    expect(find.text("Invalid last name"), findsNothing);
    await tester.enterText(find.byKey(Key("lastNameFieldKey")), "a");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text("Invalid last name"), findsOneWidget);

    await tester.enterText(find.byKey(Key("lastNameFieldKey")), faker.person.lastName());
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text("Invalid last name"), findsNothing);

    await tester.tap(find.text("Done"));
    await tester.pumpAndSettle();
  }

  Future<void> _submitFirstLastName() async {
    await tester.tap(find.byKey(Key("submitNameButtonKey")));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
  }

  Future<void> _dismissNameSnackbar() async {
    await tester.fling(find.byKey(Key("nameSnackbarKey")), Offset(0, 500), 500);
    await tester.pumpAndSettle();
  }

  Future<void> _addPhoto() async {
    await tester.tap(find.byKey(Key("addPhotoButtonKey")));
    await tester.pumpAndSettle();

    await tester.fling(find.byKey(Key("editPhotoSnackbarKey")), Offset(0, 500), 500);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("submitPhotoButtonKey")));
    await tester.pumpAndSettle();
  }

  Future<void> _fillOutTipRateForm() async {
    await _addTipRates();
    await _submitTipRates();
    await _dismissTipsSnackbar();
  }

  Future<void> _addTipRates() async {
    expect(find.text('Must be between 0 and 30'), findsNothing);
    await tester.enterText(find.byKey(Key("defaultTipRateFieldKey")), "");
    await tester.pump(Duration(milliseconds: 300));
    await tester.enterText(find.byKey(Key("defaultTipRateFieldKey")), "50");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('Must be between 0 and 30'), findsOneWidget);

    await tester.enterText(find.byKey(Key("defaultTipRateFieldKey")), "");
    await tester.pump(Duration(milliseconds: 300));
    await tester.enterText(find.byKey(Key("defaultTipRateFieldKey")), "15");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('Must be between 0 and 30'), findsNothing);

    expect(find.text('Must be between 0 and 20'), findsNothing);
    await tester.enterText(find.byKey(Key("quickTipRateFieldKey")), "");
    await tester.pump(Duration(milliseconds: 300));
    await tester.enterText(find.byKey(Key("quickTipRateFieldKey")), "40");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('Must be between 0 and 20'), findsOneWidget);

    await tester.enterText(find.byKey(Key("quickTipRateFieldKey")), "");
    await tester.pump(Duration(milliseconds: 300));
    await tester.enterText(find.byKey(Key("quickTipRateFieldKey")), "7");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('Must be between 0 and 20'), findsNothing);

    await tester.tap(find.text("Done"));
    await tester.pumpAndSettle();
  }

  Future<void> _submitTipRates() async {
    await tester.tap(find.byKey(Key("submitTipRatesButtonKey")));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
  }

  Future<void> _dismissTipsSnackbar() async {
    await tester.fling(find.byKey(Key("tipsSnackBarKey")), Offset(0, 500), 500);
    await tester.pumpAndSettle();
  }

  Future<void> _addPaymentMethod() async {
    await tester.tap(find.byKey(Key("addPaymentButtonKey")));
    await tester.pump();

    await tester.tap(find.byKey(Key("submitPaymentMethdKey")));
    await tester.pumpAndSettle();
  }
}