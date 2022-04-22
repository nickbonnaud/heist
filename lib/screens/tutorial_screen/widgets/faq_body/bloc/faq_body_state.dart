part of 'faq_body_bloc.dart';

@immutable
class FaqBodyState extends Equatable {
  final List<Faq> faqs;

  const FaqBodyState({required this.faqs});

  factory FaqBodyState.initial({required List<String> questions, required List<String> answers}) {
    return FaqBodyState(
      faqs: questions.asMap().map((index, question) => MapEntry(index, Faq(question: question, answer: answers[index], answerVisible: false))).values.toList()
    ); 
  }

  @override
  List<Object> get props => [faqs];

  @override
  String toString() => "FaqBodyState { faqs: $faqs }";
}