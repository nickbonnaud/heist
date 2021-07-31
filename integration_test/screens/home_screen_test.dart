import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/business_screen/business_screen.dart';
import 'package:heist/screens/receipt_screen/widgets/receipt_screen_body.dart';

import '../helpers/test_title.dart';
import 'business_screen_test.dart';
import 'receipt_screen_test.dart';

class HomeScreenTest {
  final WidgetTester tester;

  const HomeScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Home Screen Tests");

    expect(find.byKey(Key("homeScreenKey")), findsOneWidget);

    await _pressLogos();
    
    await _horizontalScrollPeekSheet();

    await _togglePeekSheet();

    await _pressDetails();
  }

  Future<void> _pressLogos() async {
    await _tapNearbyBusinessLogo();

    await _tapActiveLocationLogo();
    
    await _tapOpenTransactionsLogo();
  }
  
  Future<void> _pressDetails() async {
    await _flingPeekSheet();
    
    await _tapOpenTransactionDetails();

    await _tapActiveLocationDetails();

    await _tapNearbyLocationDetails();

    await _verticalScrollPeekSheet();

    await _flingPeekSheet(isExpanded: true);
  }
  
  Future<void> _tapOpenTransactionsLogo() async {
    expect(find.byKey(Key("openLogoButtonKey-0")), findsOneWidget);

    await tester.tap(find.byKey(Key("openLogoButtonKey-0")));
    await tester.pumpAndSettle();

    await ReceiptScreenTest(tester: tester).initLogo();
  }

  Future<void> _tapNearbyBusinessLogo() async {
    BusinessScreenTest businessScreenTest = BusinessScreenTest(tester: tester);
    
    expect(find.byKey(Key("nearbyLogoButtonKey-0")), findsOneWidget);

    await tester.tap(find.byKey(Key("nearbyLogoButtonKey-0")));
    await tester.pumpAndSettle();

    await businessScreenTest.initLogoButtonDismiss();

    await tester.tap(find.byKey(Key("nearbyLogoButtonKey-0")));
    await tester.pumpAndSettle();

    await businessScreenTest.initLogoButton();
  }

  Future<void> _tapActiveLocationLogo() async {
    BusinessScreenTest businessScreenTest = BusinessScreenTest(tester: tester);
    
    await tester.tap(find.byKey(Key("activeLogoButtonKey-0")));
    await tester.pumpAndSettle();

    await businessScreenTest.initLogoButtonDismiss(isInitial: false);

    await tester.tap(find.byKey(Key("activeLogoButtonKey-0")));
    await tester.pumpAndSettle();

    await businessScreenTest.initLogoButton();
  }

  Future<void> _horizontalScrollPeekSheet() async {
    double inititalPosition = tester.getCenter(find.byKey(Key("openLogoButtonKey-0"))).dx;
    
    await tester.drag(find.byKey(Key('nearbyLogoButtonKey-0')), Offset(500, 0));
    await tester.pump();

    double finalPosition = tester.getCenter(find.byKey(Key("openLogoButtonKey-0"))).dx;
    expect(inititalPosition != finalPosition, true);
  }

  Future<void> _togglePeekSheet() async {
    double inititalPosition = tester.getCenter(find.byIcon(Icons.arrow_upward)).dy;

    await tester.tap(find.byIcon(Icons.arrow_upward), warnIfMissed: false);
    await tester.pumpAndSettle();

    double topPosition = tester.getCenter(find.byIcon(Icons.arrow_upward)).dy;
    expect(inititalPosition != topPosition, true);

    await tester.tap(find.byIcon(Icons.arrow_upward), warnIfMissed: false);
    await tester.pumpAndSettle();

    double finalPosition = tester.getCenter(find.byIcon(Icons.arrow_upward)).dy;
    expect(inititalPosition == finalPosition, true);
  }

  Future<void> _flingPeekSheet({bool isExpanded: false}) async {
    if (isExpanded) {
      await tester.fling(find.byKey(Key("dragAreaKey")), Offset(0, 1000), 3000);
      await tester.pumpAndSettle();
    } else {
      await tester.fling(find.byKey(Key("dragAreaKey")).last, Offset(0, -1000), 3000);
      await tester.pumpAndSettle();
    }
  }

  Future<void> _tapOpenTransactionDetails() async {
    expect(find.byType(ReceiptScreenBody), findsNothing);
    
    await tester.tap(find.byKey(Key("openDetailsKey-0")));
    await tester.pumpAndSettle();

    await ReceiptScreenTest(tester: tester).initDetails();
  }

  Future<void> _tapActiveLocationDetails() async {
    expect(find.byType(BusinessScreen), findsNothing);

    await tester.tap(find.byKey(Key("activeDetailsKey-0")));
    await tester.pumpAndSettle();

    await BusinessScreenTest(tester: tester).initDetails();
  }

  Future<void> _tapNearbyLocationDetails() async {
     expect(find.byType(BusinessScreen), findsNothing);

    await tester.tap(find.byKey(Key("nearbyDetailsKey-0")));
    await tester.pumpAndSettle();

    await BusinessScreenTest(tester: tester).initDetails(shouldSwipe: true);
  }

  Future<void> _verticalScrollPeekSheet() async {
    double inititalPosition = tester.getCenter(find.byKey(Key("openLogoButtonKey-0"))).dy;
    
    await tester.fling(find.byKey(Key('activeDetailsKey-0')), Offset(0, -500), 200);
    await tester.pump();

    double finalPosition = tester.getCenter(find.byKey(Key("openLogoButtonKey-0"))).dy;
    expect(inititalPosition != finalPosition, true);
  }
}