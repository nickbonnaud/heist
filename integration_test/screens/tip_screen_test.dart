import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/tip_screen/tip_screen.dart';
import 'dart:io';

import '../helpers/test_title.dart';

class TipScreenTest {
  final WidgetTester tester;

  const TipScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Tip Screen Tests");

    expect(find.byType(TipScreen), findsOneWidget);

    await _changeDefaultTipError();

    await _changeQuickTipError();

    await _submitError();

    await _changeDefaultTipSuccess();

    await _changeQuickTipSuccess();

    await _submitSuccess();

    await _navigateBack();

    await _cancelButton();
  }

  Future<void> _changeDefaultTipError() async {
    expect(find.text('Must be between 0 and 30'), findsNothing);

    await tester.enterText(find.byKey(const Key("defaultTipFieldKey")), "2t");
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Must be between 0 and 30'), findsOneWidget);

    await tester.enterText(find.byKey(const Key("defaultTipFieldKey")), "17");
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Must be between 0 and 30'), findsNothing);
  }

  Future<void> _changeQuickTipError() async {
    expect(find.text('Must be between 0 and 20'), findsNothing);

    await tester.enterText(find.byKey(const Key("quickTipFieldKey")), "1^");
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Must be between 0 and 20'), findsOneWidget);

    await tester.enterText(find.byKey(const Key("quickTipFieldKey")), "17");
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Must be between 0 and 20'), findsNothing);

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pump();
  }

  Future<void> _submitError() async {
    expect(find.byKey(const Key("tipFormSnackbarKey")), findsNothing);

    await tester.tap(find.byKey(const Key("submitButtonKey")));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key("tipFormSnackbarKey")), findsOneWidget);

    await tester.fling(find.byKey(const Key("tipFormSnackbarKey")), const Offset(0, 500), 500);
    await tester.pump();
  }

  Future<void> _changeDefaultTipSuccess() async {
    await tester.enterText(find.byKey(const Key("defaultTipFieldKey")), "22");
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> _changeQuickTipSuccess() async {
    await tester.enterText(find.byKey(const Key("quickTipFieldKey")), "6");
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text(Platform.isIOS ? 'Done' : 'DONE'));
    await tester.pump();
  }

  Future<void> _submitSuccess() async {
    expect(find.byKey(const Key("tipFormSnackbarKey")), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byKey(const Key("submitButtonKey")));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byKey(const Key("tipFormSnackbarKey")), findsOneWidget);

    await tester.fling(find.byKey(const Key("tipFormSnackbarKey")), const Offset(0, 500), 500);
    await tester.pump();
  }

  Future<void> _navigateBack() async {
    await tester.tap(find.byKey(const Key("tipTileKey")));
    await tester.pumpAndSettle();
  }

  Future<void> _cancelButton() async {
    expect(find.byType(TipScreen), findsOneWidget);
    await tester.tap(find.byKey(const Key("cancelButtonKey")));
    await tester.pumpAndSettle();
    expect(find.byType(TipScreen), findsNothing);
  }
}