import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/tutorial_screen/models/faq.dart';
import 'package:heist/screens/tutorial_screen/widgets/faq_body/bloc/faq_body_bloc.dart';

void main() {
  group("FAQ Body Bloc Tests", () {
    late FaqBodyBloc faqBodyBloc;
    late FaqBodyState _baseState;

    setUp(() {
      faqBodyBloc = FaqBodyBloc();
      _baseState = faqBodyBloc.state;
    });

    tearDown(() {
      faqBodyBloc.close();
    });

    test("Initial state of FaqBodyBloc is FaqBodyState.initial", () {
      expect(faqBodyBloc.state, _baseState);
    });

    test("FaqBodyBloc creates FAQs", () {
      expect(faqBodyBloc.state.faqs.isNotEmpty, true);
    });

    blocTest<FaqBodyBloc, FaqBodyState>(
      "FaqBodyBloc ToggleAnswerVisibility can show faq answer",
      build: () {
        expect(faqBodyBloc.state.faqs.any((faq) => faq.answerVisible), false);
        return faqBodyBloc;
      },
      act: (bloc) => bloc.add(ToggleAnswerVisibility(faq: faqBodyBloc.state.faqs[1])),
      expect: () {
        Faq updatedFaq = _baseState.faqs[1].update(answerVisible: true);
        _baseState.faqs[1] = updatedFaq;
        return [_baseState];
      },
      verify: (_) {
        expect(faqBodyBloc.state.faqs.any((faq) => faq.answerVisible), true);
      }
    );

    blocTest<FaqBodyBloc, FaqBodyState>(
      "FaqBodyBloc ToggleAnswerVisibility can hide faq answer",
      build: () => faqBodyBloc,
      seed: () {
        Faq updatedFaq = _baseState.faqs[1].update(answerVisible: true);
        _baseState.faqs[2] = updatedFaq;
        return _baseState;
      },
      act: (bloc) => bloc.add(ToggleAnswerVisibility(faq: faqBodyBloc.state.faqs[2])),
      expect: () {
        Faq updatedFaq = _baseState.faqs[2].update(answerVisible: false);
        _baseState.faqs[2] = updatedFaq;
        return [_baseState];
      },
      verify: (_) {
        expect(faqBodyBloc.state.faqs.any((faq) => faq.answerVisible), false);
      }
    );
  });
}