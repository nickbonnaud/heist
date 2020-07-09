import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/onboard_screen/bloc/onboard_bloc.dart';
import 'package:heist/screens/permission_screen/permission_screen.dart';
import 'package:heist/screens/profile_setup_screen/profile_setup_screen.dart';
import 'package:heist/screens/tutorial_screen/tutorial_screen.dart';
import 'package:heist/themes/global_colors.dart';

class OnboardBody extends StatelessWidget {
  final bool _customerOnboarded;
  final bool _permissionsReady;

  OnboardBody({@required bool customerOnboarded, @required permissionsReady})
    : assert(customerOnboarded != null && permissionsReady != null),
      _customerOnboarded = customerOnboarded,
      _permissionsReady = permissionsReady;
  
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
                VeryBoldText1(text: "Account Setup", context: context),
                SizedBox(height: SizeConfig.getHeight(5)),
                Stepper(
                  currentStep: currentStep,
                  steps: [
                    Step(
                      title: BoldText1(
                        text: "Onboard", 
                        context: context, 
                        color: currentStep == 0 
                          ? Theme.of(context).colorScheme.textOnLight
                          : Theme.of(context).colorScheme.textOnLightDisabled
                      ), 
                      content: BoldText3(
                        text: "Let's get Started! Don't worry it's only a few steps.",
                        context: context,
                        color: Theme.of(context).colorScheme.textOnLightSubdued
                      ),
                      isActive: currentStep == 0,
                      state: _setCurrentStepState(currentStep: currentStep, stepIndex: 0)
                    ),
                    Step(
                      title: BoldText1(
                        text: "Profile", 
                        context: context, 
                        color: currentStep == 1
                          ? Theme.of(context).colorScheme.textOnLight 
                          : Theme.of(context).colorScheme.textOnLightDisabled
                      ), 
                      content: BoldText3(
                        text: _customerOnboarded 
                          ? "Go to next step." 
                          : "First let's setup your Profile Account!",
                        context: context, 
                        color: Theme.of(context).colorScheme.textOnLightSubdued
                      ),
                      isActive: currentStep == 1,
                      state: _setCurrentStepState(currentStep: currentStep, stepIndex: 1)
                    ),
                    Step(
                      title: BoldText1(
                        text: "Tutorial",
                        context: context, 
                        color: currentStep == 2 
                          ? Theme.of(context).colorScheme.textOnLight 
                          : Theme.of(context).colorScheme.textOnLightDisabled
                      ), 
                      content: BoldText3(
                        text: "Learn how to use ${Constants.appName}!", 
                        context: context, 
                        color: Theme.of(context).colorScheme.textOnLightSubdued
                      ),
                      isActive: currentStep == 2,
                      state: _setCurrentStepState(currentStep: currentStep, stepIndex: 2)
                    ),
                    Step(
                      title: BoldText1(
                        text: "Permissions", 
                        context: context,
                        color: currentStep == 3 
                          ? Theme.of(context).colorScheme.textOnLight
                          : Theme.of(context).colorScheme.textOnLightDisabled
                      ), 
                      content: BoldText3(
                        text: _permissionsReady 
                          ? "Finish"
                          : "Lastly let's configure your permissions!", 
                        context: context, 
                        color: Theme.of(context).colorScheme.textOnLightSubdued
                      ),
                      isActive: currentStep == 3,
                      state: _setCurrentStepState(currentStep: currentStep, stepIndex: 3)
                    ),
                  ],
                  controlsBuilder: (BuildContext context, {VoidCallback onStepContinue,VoidCallback onStepCancel}) {
                      return FlatButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        onPressed: () => _showOnboardScreen(context, currentStep),
                        child: BoldText3(text: _buttonText(currentStep), context: context, color: Theme.of(context).colorScheme.secondary),
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
  
  void _showOnboardScreen(BuildContext context, int currentStep) {
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
        if (!_permissionsReady) _showModal(context: context, screen: PermissionsScreen(permissionsBloc: BlocProvider.of<PermissionsBloc>(context)), lastScreen: true);
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
    }
    return buttonText;
  }

  void _showModal({@required BuildContext context, @required Widget screen, bool lastScreen = false}) {
    showPlatformModalSheet(
      context: context, 
      builder: (_) => screen
    ).then((_) {
      if (!lastScreen) BlocProvider.of<OnboardBloc>(context).add(OnboardEvent.next);
    });
  }
}