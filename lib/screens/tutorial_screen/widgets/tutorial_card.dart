import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/tutorial_screen/bloc/tutorial_screen_bloc.dart';
import 'package:heist/screens/tutorial_screen/models/tutorial.dart';
import 'package:heist/themes/global_colors.dart';

import 'faq_body/bloc/faq_body_bloc.dart';
import 'faq_body/faq_body.dart';


class TutorialCard extends StatefulWidget {
  final Tutorial _tutorialCard;

  TutorialCard({required Tutorial tutorialCard})
    : _tutorialCard = tutorialCard;
      
  @override
  State<TutorialCard> createState() => _TutorialCardState();
}

class _TutorialCardState extends State<TutorialCard> {
  final FlareControls _controls = FlareControls();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TutorialScreenBloc, TutorialScreenState>(
      builder: (context, state) {
        return AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          top: state.tutorialCards.firstWhere((card) => card.type == widget._tutorialCard.type).dismissed
            ? MediaQuery.of(context).size.height
            : state.tutorialCards.indexOf(widget._tutorialCard) * 10.0,
          bottom: state.tutorialCards.firstWhere((card) => card.type == widget._tutorialCard.type).dismissed
            ? - MediaQuery.of(context).size.height
            : 0,
          child: Container(
            key: Key("card${widget._tutorialCard.key}"),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3), 
                  spreadRadius: 1.0,
                  blurRadius: 5,
                  offset: Offset(0, -5)
                )
              ]
            ),
            child: _getScaffold(context: context, state: state),
          ), 
        );
      }
    );
  }

  Widget _getScaffold({required BuildContext context, required TutorialScreenState state}) {
    if (widget._tutorialCard.type != TutorialCardType.faq) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: FlareActor(
              'assets/tutorial.flr',
              animation: 'main',
              artboard: widget._tutorialCard.artboard,
              isPaused: _isPaused(state: state),
              controller: _controls,
              callback: (_) => _controls.play('repeat'),
            )
          ),
          Expanded(
            child: _getBody(context: context, state: state)
          )
        ],
      );
    }

    return SafeArea(
      bottom: false,
      maintainBottomViewPadding: true,
      child: _getBody(context: context, state: state)
    ); 
  }

  Widget _getBody({required BuildContext context, required TutorialScreenState state}) {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: SizeConfig.getWidth(2)), 
                    child: VeryBoldText2(text: widget._tutorialCard.header, context: context)
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: SizeConfig.getHeight(1)),
                    child: PlatformIconButton(
                      key: Key("exitButton${widget._tutorialCard.key}"),
                      icon: Icon(
                        Icons.clear, 
                        color: Theme.of(context).colorScheme.callToAction,
                        size: SizeConfig.getWidth(6),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  )
                ],
              ),
              SizedBox(height: SizeConfig.getHeight(4)),
              widget._tutorialCard.type != TutorialCardType.faq
                ? PlatformText(
                  widget._tutorialCard.body,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimarySubdued,
                    fontSize: SizeConfig.getWidth(6),
                    fontWeight: FontWeight.bold
                  ),
                )
                : BlocProvider<FaqBodyBloc>(
                  create: (_) => FaqBodyBloc(),
                  child: FaqBody(),
                  ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  key: Key("previousButton${widget._tutorialCard.key}"),
                  onPressed: state.currentIndex != state.tutorialCards.length - 1
                    ? () => BlocProvider.of<TutorialScreenBloc>(context).add(Previous())
                    : null,
                  child: BoldText3(
                    text: 'Previous', 
                    context: context, 
                    color: state.currentIndex != state.tutorialCards.length - 1 ? Theme.of(context).colorScheme.callToAction : Theme.of(context).colorScheme.callToActionDisabled,
                  ),
                )
              ) ,
              SizedBox(width: SizeConfig.getWidth(4)),
              Expanded(
                child: ElevatedButton(
                  key: Key("nextButton${widget._tutorialCard.key}"),
                  onPressed: state.currentIndex != 0
                    ? () => BlocProvider.of<TutorialScreenBloc>(context).add(Next())
                    : () => Navigator.of(context).pop(),
                  child: BoldText3(
                    text: state.currentIndex != 0
                      ? 'Next'
                      : 'Close', 
                    context: context, 
                    color: Theme.of(context).colorScheme.onSecondary
                  ),
                )
              )
            ],
          )
        ],
      ),
    );
  }

  bool _isPaused({required TutorialScreenState state}) {
    return state.tutorialCards.indexOf(widget._tutorialCard) != state.currentIndex;
  }
}