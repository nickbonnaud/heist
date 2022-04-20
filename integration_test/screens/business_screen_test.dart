import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/business_screen/business_screen.dart';

import '../helpers/test_title.dart';
import 'transaction_picker_screen_test.dart';

class BusinessScreenTest {
  final WidgetTester tester;

  const BusinessScreenTest({required this.tester});

  Future<void> initLogoButtonDismiss({bool isInitial = true}) async {
    if (isInitial) {
      TestTitle.write(testName: "Business Screen Tests");
    }

    expect(find.byType(BusinessScreen), findsOneWidget);

    await _dismissScreenButton();
  }

  Future<void> initLogoButtonNearby() async {
    expect(find.byKey(const Key("bannerKey")), findsOneWidget);
    expect(find.byKey(const Key("logoKey")), findsOneWidget);

    expect(find.byKey(const Key("websiteButtonKey")), findsOneWidget);
    expect(find.byKey(const Key("phoneButtonKey")), findsOneWidget);
    expect(find.byKey(const Key("hoursKey")), findsOneWidget);

    await _scrollDescription();
    
    expect(find.byType(BusinessScreen), findsOneWidget);
    await _dismissButtonSwipe();
  }

  Future<void> initLogoButtonActive() async {
    expect(find.byKey(const Key("bannerKey")), findsOneWidget);
    expect(find.byKey(const Key("logoKey")), findsOneWidget);

    expect(find.byKey(const Key("websiteButtonKey")), findsOneWidget);
    expect(find.byKey(const Key("phoneButtonKey")), findsOneWidget);
    expect(find.byKey(const Key("hoursKey")), findsOneWidget);

    expect(find.byKey(const Key("claimTransactionButtonKey")), findsOneWidget);
    await TransactionPickerScreenTest(tester: tester).initBusinessScreen();

    await _scrollDescription();
    
    expect(find.byType(BusinessScreen), findsOneWidget);
    await _dismissButtonSwipe();
  }

  Future<void> initDetails({bool shouldSwipe = false}) async {
    expect(find.byType(BusinessScreen), findsOneWidget);
    if (shouldSwipe) {
      await _dismissButtonSwipe();
    } else {
      await _dismissScreenButton();
    }
  }

  Future<void> _scrollDescription() async {
    double initialPosition = tester.getCenter(find.byKey(const Key("websiteButtonKey"))).dy;

    await tester.drag(find.byKey(const Key("scrollBodyKey")), const Offset(0, -500));
    await tester.pump();

    double finalPosition = tester.getCenter(find.byKey(const Key("websiteButtonKey"))).dy;
    
    expect(initialPosition != finalPosition, true);
  }
  
  Future<void> _dismissScreenButton() async {
    await tester.tap(find.byKey(const Key("dismissBusinessButtonKey")));
    await tester.pumpAndSettle();

    expect(find.byType(BusinessScreen), findsNothing);
  }

  Future<void> _dismissButtonSwipe() async {
    await tester.fling(find.byKey(const Key("dragBarKey")), const Offset(0, 500), 3000);
    await tester.pumpAndSettle();

    expect(find.byType(BusinessScreen), findsNothing);
  }
}