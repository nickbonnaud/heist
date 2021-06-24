import 'package:equatable/equatable.dart';

class Faq extends Equatable {
  final String question;
  final String answer;
  final bool answerVisible;

  Faq({required this.question, required this.answer, required this.answerVisible});

  Faq update({required bool answerVisible}) {
    return Faq(
      question: this.question,
      answer: this.answer,
      answerVisible: answerVisible
    );
  }

  @override
  List<Object> get props => [question, answer, answerVisible];

  @override
  String toString() => 'Faq { question: $question, answer: $answer, answerVisible: $answerVisible }';
}