import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/boot/boot_bloc.dart';
import 'package:heist/global_widgets/route_builders/slide_up_route.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/layout_screen/layout_screen.dart';
import 'package:heist/screens/onboard_screen/bloc/onboard_bloc.dart';
import 'package:heist/screens/permission_screen/permission_screen.dart';
import 'package:heist/screens/profile_setup_screen/profile_setup_screen.dart';
import 'package:heist/screens/tutorial_screen/tutorial_screen.dart';
import 'package:heist/themes/global_colors.dart';

class OnboardBody extends StatefulWidget {

  @override
  State<OnboardBody> createState() => _OnboardBodyState();
}

class _OnboardBodyState extends State<OnboardBody> with SingleTickerProviderStateMixin {
  bool _customerOnboarded;
  bool _permissionsReady;
  
  AnimationController _animationController;
  Animation<Offset> _onboardTitleAnimation;
  Animation<Offset> _profileTitleAnimation;
  Animation<Offset> _tutorialTitleAnimation;
  Animation<Offset> _permissionsTitleAnimation;
  Animation<Offset> _onboardBodyAnimation;
  Animation<Offset> _finishTitleAnimation;
  Animation<Offset> _buttonAnimation;

  @override
  void initState() {
    _customerOnboarded = BlocProvider.of<BootBloc>(context).isCustomerOnboarded;
    _permissionsReady = BlocProvider.of<BootBloc>(context).arePermissionsReady;

    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _onboardTitleAnimation = Tween<Offset>(
      begin: Offset(0, 50), 
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _animationController, 
      curve: Interval(0.0, 0.90, curve: ElasticOutCurve(0.8))
    ));

    _profileTitleAnimation = Tween<Offset>(
      begin: Offset(0, 100),
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _animationController, 
      curve: Interval(.2, 1.0, curve: ElasticOutCurve(0.8))
    ));

    _tutorialTitleAnimation = Tween<Offset>(
      begin: Offset(0, 100),
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _animationController, 
      curve: Interval(0.1, 0.99, curve: ElasticOutCurve(0.8))
    ));

    _permissionsTitleAnimation = Tween<Offset>(
      begin: Offset(0, 100),
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _animationController, 
      curve: Interval(0.0, 0.8, curve: ElasticOutCurve(0.8))
    ));

    _onboardBodyAnimation = Tween<Offset>(
      begin: Offset(50, 0), 
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _animationController, 
      curve: Curves.linear
    ));

    _finishTitleAnimation = Tween<Offset>(
      begin: Offset(0, 100),
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.3, 0.9, curve: ElasticOutCurve(0.8))
    ));

    _buttonAnimation = Tween<Offset>(
      begin: Offset(-50.0, 0.0), 
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _animationController, 
      curve: Curves.decelerate
    ));
    
    _animationController.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Center(
        child: BlocBuilder<OnboardBloc, int>(
          builder: (context, currentStep) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedOpacity(
                  opacity: _animationController.value, 
                  duration: Duration(milliseconds: 300),
                  child: VeryBoldText1(text: "Account Setup", context: context),
                ),
                SizedBox(height: SizeConfig.getHeight(5)),
                Stepper(
                  currentStep: currentStep,
                  steps: [
                    Step(
                      title: _createTitle(title: "Onboard", currentStep: currentStep, animation: _onboardTitleAnimation), 
                      content: AnimatedBuilder(
                        animation: _animationController,
                        builder: (BuildContext context, Widget child) {
                          return SlideTransition(
                            position: _onboardBodyAnimation,
                            child: BoldText3(
                              text: "Let's get Started! Don't worry it's only a few steps.",
                              context: context,
                              color: Theme.of(context).colorScheme.onPrimarySubdued
                            )
                          );
                        }
                      ),
                      isActive: currentStep == 0,
                      state: _setCurrentStepState(currentStep: currentStep, stepIndex: 0)
                    ),
                    Step(
                      title: _createTitle(title: "Profile", currentStep: currentStep, animation: _profileTitleAnimation), 
                      content: BoldText3(
                        text: _customerOnboarded 
                          ? "Go to next step." 
                          : "First let's setup your Profile Account!",
                        context: context, 
                        color: Theme.of(context).colorScheme.onPrimarySubdued
                      ),
                      isActive: currentStep == 1,
                      state: _setCurrentStepState(currentStep: currentStep, stepIndex: 1)
                    ),
                    Step(
                      title: _createTitle(title: "Tutorial", currentStep: currentStep, animation: _tutorialTitleAnimation), 
                      content: BoldText3(
                        text: "Learn how to use ${Constants.appName}!", 
                        context: context, 
                        color: Theme.of(context).colorScheme.onPrimarySubdued
                      ),
                      isActive: currentStep == 2,
                      state: _setCurrentStepState(currentStep: currentStep, stepIndex: 2)
                    ),
                    Step(
                      title: _createTitle(title: "Permissions", currentStep: currentStep, animation: _permissionsTitleAnimation), 
                      content: BoldText3(
                        text: _permissionsReady 
                          ? "Next Step"
                          : "Lastly let's configure your permissions!", 
                        context: context, 
                        color: Theme.of(context).colorScheme.onPrimarySubdued
                      ),
                      isActive: currentStep == 3,
                      state: _setCurrentStepState(currentStep: currentStep, stepIndex: 3)
                    ),
                    Step(
                      title: _createTitle(title: "Finished!", currentStep: currentStep, animation: _finishTitleAnimation),
                      content: BoldText3(text: "Onboarding Complete!", context: context, color: Theme.of(context).colorScheme.onPrimarySubdued),
                      isActive: currentStep == 4,
                      state: _setCurrentStepState(currentStep: currentStep, stepIndex: 4)
                    )
                  ],
                  controlsBuilder: (BuildContext context, {VoidCallback onStepContinue,VoidCallback onStepCancel}) {
                      return AnimatedBuilder(
                        animation: _animationController, 
                        builder: (BuildContext context, Widget child) {
                          return SlideTransition(
                            position: _buttonAnimation,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              onPressed: () => _buttonPressed(context, currentStep),
                              child: BoldText3(text: _buttonText(currentStep), context: context, color: Theme.of(context).colorScheme.callToAction),
                            ),
                          );
                        }
                      );
                    }
                )
              ],
            );
          }
        ),
      )  
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  AnimatedBuilder _createTitle({@required String title, @required int currentStep, @required Animation animation}) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget child) {
        return SlideTransition(
          position: animation,
          child: BoldText1(
            text: title, 
            context: context, 
            color: currentStep == 0 
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onPrimaryDisabled
          )
        );
      }
    );
  }
  
  StepState _setCurrentStepState({@required int currentStep, @required int stepIndex}) {
    if (stepIndex == 1 && _customerOnboarded) {
      return StepState.complete;
    }

    if (stepIndex == 3 && _permissionsReady) {
      return StepState.complete;
    }

    if (currentStep > stepIndex) {
      return StepState.complete;
    } else if (currentStep == stepIndex) {
      return StepState.editing;
    } else return StepState.indexed;
  }
  
  void _buttonPressed(BuildContext context, int currentStep) {
    switch (currentStep) {
      case 0:
        BlocProvider.of<OnboardBloc>(context).add(OnboardEvent.next);
        break;
      case 1:
        _customerOnboarded
          ? BlocProvider.of<OnboardBloc>(context).add(OnboardEvent.next)
          : _showModal(context: context, screen: ProfileSetupScreen());
        break;
      case 2:
        _showModal(context: context, screen: TutorialScreen());
        break;
      case 3:
        if (!_permissionsReady) _showModal(context: context, screen: PermissionsScreen());
        break;
      case 4:
        _navigateToNextScreen();
        break;
    }
  }

  String _buttonText(int currentStep) {
    String buttonText;
    switch (currentStep) {
      case 0:
        buttonText = "Start";
        break;
      case 1:
        buttonText = _customerOnboarded ? "Next Step" : "Setup Account";
        break;
      case 2:
        buttonText = "View Tutorial";
        break;
      case 3:
        buttonText = _permissionsReady ? "Finish" : "Set Permissions";
        break;
      case 4:
        buttonText = "Finish";
    }
    return buttonText;
  }

  void _showModal({@required BuildContext context, @required Widget screen}) {
    showPlatformModalSheet(
      context: context, 
      builder: (_) => screen
    ).then((_) {
      BlocProvider.of<OnboardBloc>(context).add(OnboardEvent.next);
    });
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      SlideUpRoute(screen: LayoutScreen())
    );
  }
}