import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/tutorial_screen/tutorial_screen.dart';
import 'package:heist/screens/tutorial_screen/widgets/tutorial_cards.dart';

import '../helpers/test_title.dart';

class TutorialScreenTest {
  final WidgetTester tester;

  const TutorialScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Tutorial Screen Tests");

    expect(find.byType(TutorialCards), findsOneWidget);

    await _goToWithBillCard();
    await _goToApprovePaymentCard();
    await _goToDenyPaymentCard();
    await _goToFaqCard();

    await _tapOnFaqs();

    await _closeTutorial();
  }

  Future<void> initFromDrawer() async {
    TestTitle.write(testName: "Tutorial Screen From Drawer Tests");

    expect(find.byType(TutorialScreen), findsNothing);
    await tester.tap(find.byKey(const Key("tutorialDrawerItemKey")));
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(TutorialScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.clear).last);
    await tester.pumpAndSettle();

    expect(find.byType(TutorialScreen), findsNothing);
  }

  Future<void> initLogin() async {
    await tester.tap(find.byIcon(Icons.clear).last);
    await tester.pumpAndSettle();
  }

  Future<void> _goToWithBillCard() async {
    expect(find.byKey(const Key("cardAtRegisterKey")), findsOneWidget);
    await tester.tap(find.byKey(const Key("nextButtonAtRegisterKey")));
    await tester.pump(const Duration(milliseconds: 500));
  }

  Future<void> _goToApprovePaymentCard() async {
    expect(find.byKey(const Key("cardWithBillKey")), findsOneWidget);
    await tester.tap(find.byKey(const Key("nextButtonWithBillKey")));
    await tester.pump(const Duration(milliseconds: 500));
  }
  
  Future<void> _goToDenyPaymentCard() async {
    expect(find.byKey(const Key("cardApprovePaymentKey")), findsOneWidget);
    await tester.tap(find.byKey(const Key("nextButtonApprovePaymentKey")));
    await tester.pump(const Duration(milliseconds: 500));
  }

  Future<void> _goToFaqCard() async {
    expect(find.byKey(const Key("cardDenyPaymentKey")), findsOneWidget);
    await tester.pump();
    await tester.tap(find.byKey(const Key("nextButtonDenyPaymentKey")));
    await tester.pump(const Duration(milliseconds: 500));
  }

  Future<void> _tapOnFaqs() async {
    expect(find.byKey(const Key("cardFaqKey")), findsOneWidget);

    expect(find.byKey(const Key("faqAnswerKey-0")), findsNothing);

    await tester.tap(find.byKey(const Key("faqQuestionKey-0")));
    await tester.pump();
    expect(find.byKey(const Key("faqAnswerKey-0")), findsOneWidget);

    await tester.tap(find.byKey(const Key("faqAnswerKey-0")));
    await tester.pump();
    expect(find.byKey(const Key("faqAnswerKey-0")), findsNothing);
  }

  Future<void> _closeTutorial() async {
    await tester.tap(find.byKey(const Key("nextButtonFaqKey")));
    await tester.pumpAndSettle();
  }
}