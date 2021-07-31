import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

  Future<void> _goToWithBillCard() async {
    expect(find.byKey(Key("cardAtRegisterKey")), findsOneWidget);
    await tester.tap(find.byKey(Key("nextButtonAtRegisterKey")));
    await tester.pump(Duration(milliseconds: 500));
  }

  Future<void> _goToApprovePaymentCard() async {
    expect(find.byKey(Key("cardWithBillKey")), findsOneWidget);
    await tester.tap(find.byKey(Key("nextButtonWithBillKey")));
    await tester.pump(Duration(milliseconds: 500));
  }
  
  Future<void> _goToDenyPaymentCard() async {
    expect(find.byKey(Key("cardApprovePaymentKey")), findsOneWidget);
    await tester.tap(find.byKey(Key("nextButtonApprovePaymentKey")));
    await tester.pump(Duration(milliseconds: 500));
  }

  Future<void> _goToFaqCard() async {
    expect(find.byKey(Key("cardDenyPaymentKey")), findsOneWidget);
    await tester.pump();
    await tester.tap(find.byKey(Key("nextButtonDenyPaymentKey")));
    await tester.pump(Duration(milliseconds: 500));
  }

  Future<void> _tapOnFaqs() async {
    expect(find.byKey(Key("cardFaqKey")), findsOneWidget);

    expect(find.byKey(Key("faqAnswerKey-0")), findsNothing);

    await tester.tap(find.byKey(Key("faqQuestionKey-0")));
    await tester.pump();
    expect(find.byKey(Key("faqAnswerKey-0")), findsOneWidget);

    await tester.tap(find.byKey(Key("faqAnswerKey-0")));
    await tester.pump();
    expect(find.byKey(Key("faqAnswerKey-0")), findsNothing);
  }

  Future<void> _closeTutorial() async {
    await tester.tap(find.byKey(Key("nextButtonFaqKey")));
    await tester.pumpAndSettle();
  }
}