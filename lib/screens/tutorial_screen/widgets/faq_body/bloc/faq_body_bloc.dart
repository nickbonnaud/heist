import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/screens/tutorial_screen/models/faq.dart';
import 'package:meta/meta.dart';

part 'faq_body_event.dart';
part 'faq_body_state.dart';

final List<String> questions = [
  "What happens if you don't respond to a bill notification?",
  "What if you deny a bill using the option 'Wrong Bill', but fail to choose the correct bill?",
  "Should you tell your server or bartender you are paying with ${Constants.appName}?",
];

final List<String> _answers = [
  "You will be sent a reminder notification after a period of time, after which if you don't respond to you will automatically charged.",
  "You will be sent three reminder notifications, each after a period of time you fail to respond. After the third notification, you will be automatically charged the full amount.",
  "It is not required, but for your server or bartenders state of mind we highly recommend it!",
];

class FaqBodyBloc extends Bloc<FaqBodyEvent, FaqBodyState> {
  FaqBodyBloc()
    : super(FaqBodyState.initial(questions: questions, answers: _answers)) {
      _eventHandler();
  }

  void _eventHandler() {
    on<ToggleAnswerVisibility>((event, emit) => _mapToggleAnswerVisibilityToState(faqToUpdate: event.faq, emit: emit));
  }

  void _mapToggleAnswerVisibilityToState({required Faq faqToUpdate, required Emitter<FaqBodyState> emit}) {
    final List<Faq> updatedFaqs = state.faqs.map((faq){
      return faq == faqToUpdate 
        ? faqToUpdate.update(answerVisible: !faqToUpdate.answerVisible) 
        : faq.answerVisible ? faq.update(answerVisible: false) : faq;
    }).toList();
    emit(FaqBodyState(faqs: updatedFaqs));
  }
}
