import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/business_screen/business_screen.dart';

import '../helpers/test_title.dart';

class BusinessScreenTest {
  final WidgetTester tester;

  const BusinessScreenTest({required this.tester});

  Future<void> initLogoButtonDismiss({bool isInitial: true}) async {
    if (isInitial) {
      TestTitle.write(testName: "Business Screen Tests");
    }

    expect(find.byType(BusinessScreen), findsOneWidget);

    await _dismissScreenButton();
  }

  Future<void> initLogoButton() async {
    expect(find.byKey(Key("bannerKey")), findsOneWidget);
    expect(find.byKey(Key("logoKey")), findsOneWidget);

    expect(find.byKey(Key("websiteButtonKey")), findsOneWidget);
    expect(find.byKey(Key("phoneButtonKey")), findsOneWidget);
    expect(find.byKey(Key("hoursKey")), findsOneWidget);

    await _scrollDescription();
    
    expect(find.byType(BusinessScreen), findsOneWidget);
    await _dismissButtonSwipe();
  }

  Future<void> initDetails({bool shouldSwipe: false}) async {
    expect(find.byType(BusinessScreen), findsOneWidget);
    if (shouldSwipe) {
      await _dismissButtonSwipe();
    } else {
      await _dismissScreenButton();
    }
  }

  Future<void> _scrollDescription() async {
    double initialPosition = tester.getCenter(find.byKey(Key("websiteButtonKey"))).dy;

    await tester.drag(find.byKey(Key("scrollBodyKey")), Offset(0, -500));
    await tester.pump();

    double finalPosition = tester.getCenter(find.byKey(Key("websiteButtonKey"))).dy;
    
    expect(initialPosition != finalPosition, true);
  }
  
  Future<void> _dismissScreenButton() async {
    await tester.tap(find.byKey(Key("dismissBusinessButtonKey")));
    await tester.pumpAndSettle();

    expect(find.byType(BusinessScreen), findsNothing);
  }

  Future<void> _dismissButtonSwipe() async {
    await tester.fling(find.byKey(Key("dragBarKey")), Offset(0, 500), 3000);
    await tester.pumpAndSettle();

    expect(find.byType(BusinessScreen), findsNothing);
  }
}