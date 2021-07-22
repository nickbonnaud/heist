import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/tutorial_screen/bloc/tutorial_screen_bloc.dart';
import 'package:heist/screens/tutorial_screen/models/tutorial.dart';

void main() {
  group("Tutorial Tests ", () {

    test("Tutorial can update it's attributes", () {
      var tutorial = Tutorial(type: TutorialCardType.approvePayment, key: "key", header: "header", body: "body", hasInitialAnimation: true, dismissed: true);

      expect(tutorial.dismissed, true);
      tutorial = tutorial.update(dismissed: false);
      expect(tutorial.dismissed, false);
    });
  });
}