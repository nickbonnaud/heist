import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/auth_screen/widgets/background.dart';

import '../helpers/test_title.dart';

class LoginScreenTest {
  final WidgetTester tester;

  const LoginScreenTest({required this.tester});

  Future<void> init() async {
    TestTitle.write(testName: "Login Screen Tests");
    
    expect(find.byKey(Key("loginFormKey")), findsOneWidget);

    expect(find.byKey(Key("loginButtonTextKey")), findsNothing);

    await _enterInvalidEmail();
    await _enterValidEmail();

    await _enterInvalidPassword();
    await _enterValidPassword();

    await _tapSubmitButton();
    await tester.pumpAndSettle();
  }
  
  Future<void> _enterInvalidEmail() async {
    expect(find.byKey(Key("emailFormFieldKey")), findsOneWidget);

    expect(find.text("Invalid Email"), findsNothing);
    await tester.enterText(find.byKey(Key("emailFormFieldKey")), "not @n email!");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text("Invalid Email"), findsOneWidget);
  }

  Future<void> _enterValidEmail() async {
    expect(find.text("Invalid Email"), findsOneWidget);

    await tester.enterText(find.byKey(Key("emailFormFieldKey")), "joe@gmail.com");
    await tester.pump(Duration(milliseconds: 300));

    expect(find.text("Invalid Email"), findsNothing);
  }

  Future<void> _enterInvalidPassword() async {
    expect(find.byKey(Key("passwordFormFieldKey")), findsOneWidget);
    
    expect(find.text("Invalid Password"), findsNothing);
    await tester.enterText(find.byKey(Key("passwordFormFieldKey")), "bad pas");
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text("Invalid Password"), findsOneWidget);
  }

  Future<void> _enterValidPassword() async {
    expect(find.text("Invalid Password"), findsOneWidget);

    await tester.enterText(find.byKey(Key("passwordFormFieldKey")), "jdgDKXV2!^***4652vbFbd42@");
    await tester.pump(Duration(milliseconds: 300));

    expect(find.text("Invalid Password"), findsNothing);
    await tester.tap(find.text("Done"));
    await tester.pump();
  }

  Future<void> _tapSubmitButton() async {
    expect(find.byKey(Key("loginButtonTextKey")), findsNWidgets(2));
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byKey(Key("loginButtonTextKey")).first);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }
}