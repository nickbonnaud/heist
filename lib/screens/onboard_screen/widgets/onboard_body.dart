import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/models/status.dart';
import 'package:heist/resources/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/screens/onboard_screen/bloc/onboard_bloc.dart';
import 'package:heist/themes/global_colors.dart';

class OnboardBody extends StatefulWidget {
  final PermissionsBloc _permissionsBloc;
  final Status _customerStatus;

  const OnboardBody({
    required PermissionsBloc permissionsBloc,
    required Status customerStatus,
    Key? key
  })
    : _permissionsBloc = permissionsBloc,
      _customerStatus = customerStatus,
      super(key: key);

  @override
  State<OnboardBody> createState() => _OnboardBodyState();
}

class _OnboardBodyState extends State<OnboardBody> with SingleTickerProviderStateMixin {
  late bool _customerOnboarded;
  late bool _permissionsReady;
  
  late AnimationController _animationController;
  late Animation<Offset> _onboardTitleAnimation;
  late Animation<Offset> _profileTitleAnimation;
  late Animation<Offset> _tutorialTitleAnimation;
  late Animation<Offset> _permissionsTitleAnimation;
  late Animation<Offset> _onboardBodyAnimation;
  late Animation<Offset> _finishTitleAnimation;
  late Animation<Offset> _buttonAnimation;

  @override
  void initState() {
    _customerOnboarded = widget._customerStatus.code > 103;
    _permissionsReady = widget._permissionsBloc.allPermissionsValid;

    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _onboardTitleAnimation = Tween<Offset>(
      begin: Offset(0, 50.h), 
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _animationController, 
      curve: const Interval(0.0, 0.90, curve: ElasticOutCurve(0.8))
    ));

    _profileTitleAnimation = Tween<Offset>(
      begin: Offset(0, 100.h),
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _animationController, 
      curve: const Interval(.2, 1.0, curve: ElasticOutCurve(0.8))
    ));

    _tutorialTitleAnimation = Tween<Offset>(
      begin: Offset(0, 100.h),
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _animationController, 
      curve: const Interval(0.1, 0.99, curve: ElasticOutCurve(0.8))
    ));

    _permissionsTitleAnimation = Tween<Offset>(
      begin: Offset(0, 100.h),
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _animationController, 
      curve: const Interval(0.0, 0.8, curve: ElasticOutCurve(0.8))
    ));

    _onboardBodyAnimation = Tween<Offset>(
      begin: Offset(50.w, 0), 
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _animationController, 
      curve: Curves.linear
    ));

    _finishTitleAnimation = Tween<Offset>(
      begin: Offset(0, 100.h),
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 0.9, curve: ElasticOutCurve(0.8))
    ));

    _buttonAnimation = Tween<Offset>(
      begin: Offset(-50.w, 0.0), 
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
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: BlocBuilder<OnboardBloc, int>(
        builder: (context, currentStep) {
          return _body(currentStep: currentStep);
        }
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _body({required int currentStep}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "Account Setup",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 40.sp
          ),
        ),
        Stepper(
          key: const Key("onboardStepperKey"),
          currentStep: currentStep,
          steps: [
            Step(
              title: _createTitle(title: "Onboard", currentStep: currentStep, animation: _onboardTitleAnimation), 
              content: AnimatedBuilder(
                animation: _animationController,
                builder: (BuildContext context, Widget? child) {
                  return SlideTransition(
                    position: _onboardBodyAnimation,
                    child: _stepText(text: "Let's get Started! Don't worry it's only a few steps.")
                  );
                }
              ),
              isActive: currentStep == 0,
              state: _setCurrentStepState(currentStep: currentStep, stepIndex: 0)
            ),
            Step(
              title: _createTitle(title: "Profile", currentStep: currentStep, animation: _profileTitleAnimation), 
              content: _stepText(
                text: _customerOnboarded 
                  ? "Go to next step." 
                  : "First let's setup your Profile Account!"
              ),
              isActive: currentStep == 1,
              state: _setCurrentStepState(currentStep: currentStep, stepIndex: 1)
            ),
            Step(
              title: _createTitle(title: "Tutorial", currentStep: currentStep, animation: _tutorialTitleAnimation), 
              content: _stepText(text: "Learn how to use ${Constants.appName}!"),
              isActive: currentStep == 2,
              state: _setCurrentStepState(currentStep: currentStep, stepIndex: 2)
            ),
            Step(
              title: _createTitle(title: "Permissions", currentStep: currentStep, animation: _permissionsTitleAnimation), 
              content: _stepText(
                text: _permissionsReady 
                  ? "Next Step"
                  : "Lastly let's configure your permissions!"
              ),
              isActive: currentStep == 3,
              state: _setCurrentStepState(currentStep: currentStep, stepIndex: 3)
            ),
            Step(
              title: _createTitle(title: "Finished!", currentStep: currentStep, animation: _finishTitleAnimation),
              content: _stepText(text: "Onboarding Complete!"),
              isActive: currentStep == 4,
              state: _setCurrentStepState(currentStep: currentStep, stepIndex: 4)
            )
          ],
          controlsBuilder: (context, details) {
              return AnimatedBuilder(
                animation: _animationController, 
                builder: (BuildContext context, Widget? child) {
                  return SlideTransition(
                    position: _buttonAnimation,
                    child: TextButton(
                      key: const Key("stepperButtonKey"),
                      onPressed: () => _buttonPressed(context, currentStep),
                      child: Text(
                        _buttonText(currentStep: currentStep),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.sp,
                          color: Theme.of(context).colorScheme.callToAction
                        ),
                      )
                    ),
                  );
                }
              );
            }
        )
      ],
    );
  }

  AnimatedBuilder _createTitle({required String title, required int currentStep, required Animation<Offset> animation}) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return SlideTransition(
          position: animation,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35.sp,
              color: currentStep == 0 
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onPrimaryDisabled
            ),
          )
        );
      }
    );
  }

  Widget _stepText({required String text}) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25.sp,
        color: Theme.of(context).colorScheme.onPrimarySubdued
      ),
    );
  }
  
  StepState _setCurrentStepState({required int currentStep, required int stepIndex}) {
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
    } else {
      return StepState.indexed;
    }
  }
  
  void _buttonPressed(BuildContext context, int currentStep) {
    switch (currentStep) {
      case 0:
        BlocProvider.of<OnboardBloc>(context).add(OnboardEvent.next);
        break;
      case 1:
        _customerOnboarded
          ? BlocProvider.of<OnboardBloc>(context).add(OnboardEvent.next)
          : _goToScreen(route: Routes.onboardProfile);
        break;
      case 2:
        _goToScreen(route: Routes.tutorial);
        break;
      case 3:
        !_permissionsReady
          ? _goToScreen(route: Routes.onboardPermissions)
          : BlocProvider.of<OnboardBloc>(context).add(OnboardEvent.next);
        break;
      case 4:
        _navigateToNextScreen();
        break;
    }
  }
  
  String _buttonText({required int currentStep}) {
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
        break;
      default:
        buttonText = "";
    }
    return buttonText;
  }

  void _goToScreen({required String route}) {
    Navigator.of(context).pushNamed(route)
      .then((_) => BlocProvider.of<OnboardBloc>(context).add(OnboardEvent.next));
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }
}