import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/screens/tutorial_screen/bloc/tutorial_screen_bloc.dart';
import 'package:heist/screens/tutorial_screen/models/tutorial.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'faq_body/bloc/faq_body_bloc.dart';
import 'faq_body/faq_body.dart';


class TutorialCard extends StatefulWidget {
  final Tutorial _tutorialCard;

  const TutorialCard({required Tutorial tutorialCard, Key? key})
    : _tutorialCard = tutorialCard,
      super(key: key);
      
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
          duration: const Duration(milliseconds: 500),
          top: state.tutorialCards.firstWhere((card) => card.type == widget._tutorialCard.type).dismissed
            ? MediaQuery.of(context).size.height
            : state.tutorialCards.indexOf(widget._tutorialCard) * 15.h,
          bottom: state.tutorialCards.firstWhere((card) => card.type == widget._tutorialCard.type).dismissed
            ? -MediaQuery.of(context).size.height
            : 0,
          child: Container(
            key: Key("card${widget._tutorialCard.key}"),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3), 
                  spreadRadius: 1.0,
                  blurRadius: 5,
                  offset: Offset(0, -5.h)
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
      return Stack(
        children: [
          Positioned(
            top: 0,
            child: SizedBox(
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
            )
          ),
          Positioned(
            bottom: 0,
            child: Container(
              color: Theme.of(context).colorScheme.background,
              width: MediaQuery.of(context).size.width,
              child: _getBody(context: context, state: state)
            )
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
      padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 20.h),
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
                    padding: EdgeInsets.only(left: 8.w),
                    child: Text(
                      widget._tutorialCard.header,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 35.sp,
                      ),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: IconButton(
                      key: Key("exitButton${widget._tutorialCard.key}"),
                      icon: Icon(
                        Icons.clear, 
                        color: Theme.of(context).colorScheme.callToAction,
                        size: 35.sp,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  )
                ],
              ),
              SizedBox(height: 30.h),
              widget._tutorialCard.type != TutorialCardType.faq
                ? Text(
                    widget._tutorialCard.body,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimarySubdued,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold
                    ),
                  )
                : BlocProvider<FaqBodyBloc>(
                    create: (_) => FaqBodyBloc(),
                    child: const FaqBody(),
                  ),
            ],
          ),
          SizedBox(height: 30.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  key: Key("previousButton${widget._tutorialCard.key}"),
                  onPressed: state.currentIndex != state.tutorialCards.length - 1
                    ? () => BlocProvider.of<TutorialScreenBloc>(context).add(Previous())
                    : null,
                  child: ButtonText(
                    text: 'Previous',
                    color: state.currentIndex != state.tutorialCards.length - 1
                      ? Theme.of(context).colorScheme.callToAction
                      : Theme.of(context).colorScheme.callToActionDisabled,
                  )
                )
              ) ,
              SizedBox(width: 15.w),
              Expanded(
                child: ElevatedButton(
                  key: Key("nextButton${widget._tutorialCard.key}"),
                  onPressed: state.currentIndex != 0
                    ? () => BlocProvider.of<TutorialScreenBloc>(context).add(Next())
                    : () => Navigator.of(context).pop(),
                  child: ButtonText(
                    text: state.currentIndex != 0
                      ? 'Next'
                      : 'Close',
                  )
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