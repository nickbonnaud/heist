import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';

class IntroScreen extends StatefulWidget {
  final AnimationController _controller;

  IntroScreen({@required AnimationController controller})
    : assert(controller != null),
      _controller = controller;

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  ProfileSetupScreenBloc _profileSetupScreenBloc;

  @override
  void initState() {
    super.initState();
    _profileSetupScreenBloc = BlocProvider.of<ProfileSetupScreenBloc>(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, bottom: 16, right: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: SizeConfig.getHeight(15)),
              VeryBoldText3(
                text: "Let's setup your Profile!",
                context: context,
                color: Colors.black
              ),
              SizedBox(height: SizeConfig.getHeight(3)),
              Image.asset(
                "assets/slide_3.png",
                fit: BoxFit.contain,
                height: 350,
              ),
              SizedBox(height: SizeConfig.getHeight(3)),
              BoldText4(text: "Don't worry it's only a few steps...", context: context)
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: BlocBuilder<ProfileSetupScreenBloc, ProfileSetupScreenState>(
                  builder: (context, state) {
                    return RaisedButton(
                      color: Colors.green,
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () => _nextButtonPressed(context, state),
                      child: BoldText3(text: 'Next', context: context, color: Colors.white)
                    );
                  }
                ) 
              )
            ],
          )
        ],
      ),
    );    
  }

  @override
  void dispose() {
    widget._controller.removeStatusListener(_animationListener);
    super.dispose();
  }

  void _nextButtonPressed(BuildContext context, ProfileSetupScreenState state) {
    widget._controller.addStatusListener(_animationListener);
    widget._controller.forward();
  }

  void _animationListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _profileSetupScreenBloc.add(SectionCompleted(section: Section.intro));
    }
  }
}