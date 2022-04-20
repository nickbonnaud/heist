import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/tutorial_screen/models/faq.dart';

void main() {
  group("Faq Tests", () {

    test("Faq can update it's attributes", () {
      var faq = const Faq(question: "question", answer: "answer", answerVisible: false);

      expect(faq.answerVisible, false);
      faq = faq.update(answerVisible: true);
      expect(faq.answerVisible, true);
    });
  });
}