import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/onboard_screen/bloc/onboard_bloc.dart';
import 'package:heist/screens/permission_screen/permission_screen.dart';
import 'package:heist/screens/profile_setup_screen/profile_setup_screen.dart';
import 'package:heist/screens/tutorial_screen/tutorial_screen.dart';
import 'package:vibrate/vibrate.dart';

class OnboardBody extends StatelessWidget {
  final int totalSteps = 3;

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
                      state: currentStep == 0 ? StepState.editing : currentStep > 0 ? StepState.complete : StepState.indexed
                    ),
                    Step(
                      title: BoldText(text: "Profile", size: SizeConfig.getWidth(8), color: currentStep == 1 ? Colors.black : Colors.black26), 
                      content: BoldText(text: "First let's setup your Profile Account!", size: SizeConfig.getWidth(6), color: Colors.black54),
                      isActive: currentStep == 1,
                      state: currentStep == 0 ? StepState.editing : currentStep > 1 ? StepState.complete : StepState.indexed
                    ),
                    Step(
                      title: BoldText(text: "Tutorial", size: SizeConfig.getWidth(8), color: currentStep == 2 ? Colors.black : Colors.black26), 
                      content: BoldText(text: "Next let's learn how to use ${Constants.appName}!", size: SizeConfig.getWidth(6), color: Colors.black54),
                      isActive: currentStep == 2,
                      state: currentStep == 0 ? StepState.editing : currentStep > 2 ? StepState.complete : StepState.indexed
                    ),
                    Step(
                      title: BoldText(text: "Permissions", size: SizeConfig.getWidth(8), color: currentStep == 3 ? Colors.black : Colors.black26), 
                      content: BoldText(text: "Lastly let's configure your permissions!", size: SizeConfig.getWidth(6), color: Colors.black54),
                      isActive: currentStep == 3,
                      state: currentStep == 0 ? StepState.editing : currentStep > 3 ? StepState.complete : StepState.indexed
                    )
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

  void _showOnboardScreen(BuildContext context, int currentStep) {
    switch (currentStep) {
      case 0:
        BlocProvider.of<OnboardBloc>(context).add(OnboardEvent.next);
        break;
      case 1:
        showModal(context, ProfileSetupScreen(), false);
        break;
      case 2:
        showModal(context, TutorialScreen(), false);
        break;
      case 3:
        showModal(context, PermissionsScreen(), true);
        break;
    }
  }

  String _buttonText(int currentStep) {
    switch (currentStep) {
      case 0:
        return "Start";
        break;
      case 1:
        return "Setup Account";
        break;
      case 2:
        return "View Tutorial";
        break;
      case 3:
        return "Set Permissions";
        break;
    }
  }

  void showModal(BuildContext context, Widget screen, bool lastScreen) {
    showPlatformModalSheet(
      context: context, 
      builder: (_) => screen
    ).then((value) {
      if (!lastScreen) {
        BlocProvider.of<OnboardBloc>(context).add(OnboardEvent.next); 
      } else {
        _showSnackbar(context);
      }
    });
  }

  void _showSnackbar(BuildContext context) async {
    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.feedback(FeedbackType.success);
    }

    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: BoldText(text: "Account Setup Complete!", size: SizeConfig.getWidth(6), color: Colors.white)
              ),
              PlatformWidget(
                android: (_) => Icon(Icons.check_circle_outline),
                ios: (_) => Icon(
                  IconData(
                    0xF3FE,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage
                  ),
                  color: Colors.white,
                ),
              )
            ],
          ),
          backgroundColor: Colors.green,
        )
      ).closed.then((_) => {
        Navigator.of(context).pop()
      });
  }
}