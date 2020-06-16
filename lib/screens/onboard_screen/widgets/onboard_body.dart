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
                BoldText.veryBold(text: "Account Setup", size: SizeConfig.getWidth(9), color: Colors.black),
                SizedBox(height: SizeConfig.getHeight(5)),
                Stepper(
                  currentStep: currentStep,
                  steps: [
                    Step(
                      title: BoldText(text: "Onboard", size: SizeConfig.getWidth(8), color: currentStep == 0 ? Colors.black : Colors.black26), 
                      content: BoldText(text: "Let's get Started! Don't worry it's only a few steps.", size: SizeConfig.getWidth(6), color: Colors.black54),
                      isActive: currentStep == 0,
                      state: _setCurrentStepState(currentStep: currentStep, stepIndex: 0)
                    ),
                    Step(
                      title: BoldText(text: _customerOnboarded ? "Profile Completed" : "Profile", size: SizeConfig.getWidth(8), color: currentStep == 1 ? Colors.black : Colors.black26), 
                      content: BoldText(text: _customerOnboarded ? "Go to next step." : "First let's setup your Profile Account!", size: SizeConfig.getWidth(6), color: Colors.black54),
                      isActive: currentStep == 1,
                      state: _setCurrentStepState(currentStep: currentStep, stepIndex: 1)
                    ),
                    Step(
                      title: BoldText(text: "Tutorial", size: SizeConfig.getWidth(8), color: currentStep == 2 ? Colors.black : Colors.black26), 
                      content: BoldText(text: "Learn how to use ${Constants.appName}!", size: SizeConfig.getWidth(6), color: Colors.black54),
                      isActive: currentStep == 2,
                      state: _setCurrentStepState(currentStep: currentStep, stepIndex: 2)
                    ),
                    Step(
                      title: BoldText(text: _permissionsReady ? "Permissions Complete" : "Permissions", size: SizeConfig.getWidth(8), color: currentStep == 3 ? Colors.black : Colors.black26), 
                      content: BoldText(text: _permissionsReady ? "Finish" : "Lastly let's configure your permissions!", size: SizeConfig.getWidth(6), color: Colors.black54),
                      isActive: currentStep == 3,
                      state: _setCurrentStepState(currentStep: currentStep, stepIndex: 3)
                    ),
                  ],
                  controlsBuilder: (
                    BuildContext context,
                    {VoidCallback onStepContinue, 
                    VoidCallback onStepCancel}) {
                      return PlatformButton(
                        child: BoldText(text: _buttonText(currentStep), size: SizeConfig.getWidth(6), color: Colors.blue),
                        onPressed: () => _showOnboardScreen(context, currentStep),
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