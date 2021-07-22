import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/screens/tutorial_screen/models/tutorial.dart';
import 'package:meta/meta.dart';
import 'package:heist/extensions/string_extensions.dart';

part 'tutorial_screen_event.dart';
part 'tutorial_screen_state.dart';

enum TutorialCardType {
  faq,
  denyPayment,
  approvePayment,
  withBill,
  atRegister,
}

class TutorialScreenBloc extends Bloc<TutorialScreenEvent, TutorialScreenState> {
  TutorialScreenBloc() : super(TutorialScreenState.initial(tutorialCards: _createCards()));

  List<Tutorial> get tutorialCards => state.tutorialCards;
  
  @override
  Stream<TutorialScreenState> mapEventToState(TutorialScreenEvent event) async* {
    if (event is Next) {
      yield* _mapNextToState();
    } else if (event is Previous) {
      yield* _mapPreviousToState();
    }
  }

  Stream<TutorialScreenState> _mapNextToState() async* {
    yield state.updateNext();
  }

  Stream<TutorialScreenState> _mapPreviousToState() async* {
    yield state.updatePrevious();
  }

  static List<Tutorial> _createCards() {
    return TutorialCardType.values.map((type) => Tutorial(
      type: type,
      key: "${type.toString().replaceAll("TutorialCardType.", "")}Key".capitalizeFirst,
      header: _setHeader(type: type),
      body: _setBody(type: type),
      artboard: _setArtboard(type: type),
      hasInitialAnimation: type == TutorialCardType.approvePayment || type == TutorialCardType.denyPayment,
      dismissed: false
    )).toList();
  }

  static String _setHeader({required TutorialCardType type}) {
    String header;
    switch (type) {
      case TutorialCardType.atRegister:
        header = 'At Register';
        break;
      case TutorialCardType.withBill:
        header = 'Paying Tab/Check';
        break;
      case TutorialCardType.approvePayment:
        header = 'Approve';
        break;
      case TutorialCardType.denyPayment:
        header = 'Deny';
        break;
      case TutorialCardType.faq:
        header = 'FAQ';
        break;
    }

    return header;
  }

  static String _setBody({required TutorialCardType type}) {
    String body;
    switch (type) {
      case TutorialCardType.atRegister:
        body = "Paying at a register is simple! Just tell the cashier you are paying with ${Constants.appName}.\n\n They may ask for your name, but thats it!";
        break;
      case TutorialCardType.withBill:
        body = "Paying at a restaurant or bar is actually easier!\n\n When you are finished with your meal or drinks, just leave!";
        break;
      case TutorialCardType.approvePayment:
        body = "You will receive a notification with your bill. \n\n You can either manually approve the transaction or ${Constants.appName} will automatically pay for you.";
        break;
      case TutorialCardType.denyPayment:
        body = 'If there is something wrong with your bill you can deny it. \n\n You must choose from one of three categores: Wrong Bill, Error in Bill, or Other';
        break;
      case TutorialCardType.faq:
        body =  "Q: What happens if you don't respond to a bill notification?\n\n"
                "A: You will be sent a reminder notification after a period of time, after which if you don't respond to you will automatically charged.\n\n\n"
                "Q: What if you deny a bill using the option 'Wrong Bill', but fail to choose the correct bill?\n\n"
                "A: You will be sent three reminder notifications, each after a period of time you fail to respond. After the third notification, you will be automatically charged the full amount.\n\n\n"
                "Q: Should you tell your server or bartender you are paying with ${Constants.appName}?\n\n"
                "A: It is not required, but for your server or bartenders state of mind we highly recommend it!";
        break;
    }
    return body;
  }

  static String? _setArtboard({required TutorialCardType type}) {
    String? artboardName;
    switch (type) {
      case TutorialCardType.atRegister:
        artboardName = 'at_register';
        break;
      case TutorialCardType.withBill:
        artboardName = 'with_tab';
        break;
      case TutorialCardType.approvePayment:
        artboardName = 'accept';
        break;
      case TutorialCardType.denyPayment:
        artboardName = 'decline';
        break;
      case TutorialCardType.faq:
        artboardName = null;
        break;
    }
    return artboardName;
  }
}
