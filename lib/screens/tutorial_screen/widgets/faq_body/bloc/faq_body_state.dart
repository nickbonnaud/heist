part of 'faq_body_bloc.dart';

@immutable
class FaqBodyState {
  final List<Faq> faqs;

  FaqBodyState({@required this.faqs});

  factory FaqBodyState.initial({@required List<String> questions, @required List<String> answers}) {
    return FaqBodyState(
      faqs: questions.asMap().map((index, question) => MapEntry(index, Faq(question: question, answer: answers[index], answerVisible: false)) ).values.toList()
    ); 
  }
}